package OScriptVM

InterpretResult :: distinct enum u8 
{ 
	INTERPRET_OK, 
	INTERPRET_COMPILE_OK,
	INTERPRET_COMPILE_ERROR, 
	INTERPRET_RUNTIME_ERROR 
}

CallFrame 	:: struct 
{
	function   : 	^Function,
	ip         : 	^Uint,
	slots      : 	[]Value,
	globals	   :    ^Table,
	context_ID :    ImportID 
}


GlobalFrame :: struct { current  : ^Table }


VM :: struct {
	
	frames 			  : [MAX_FRAMES]CallFrame,
	frame_count 	  : Int,

	global_frame      : [MAX_GLOBAL_FRAME]GlobalFrame,
	global_frame_count: Int,

	stack 			  : [MAX_STACK]Value,
	tos		  		  : Int,

	globals			  :  Table, 
	treturn           :  Value,  

	inter_strings     : TableString,
	inter_hash        : TableHash,

	// GC
	bytes_allocated   : Uint,
	next_gc           : Uint,
	min_heap_size     : Uint,
	objects	   		  : ^Object,
	gc_trigger		  : bool,	
	
	gray_stack		  : [dynamic]^Object,
	gray_stack_Len    : Int,
	gray_stack_count  : Int,

	call_state        : CallState 

}

init_vm :: proc() 
{ 
	runtime_init()
	create_vm()
	init_gc_config()
}


setup   :: proc( mainID : FunctionID ) -> InterpretResult
{

	if !is_valid_functionID_functionBD(mainID) do return .INTERPRET_COMPILE_ERROR
	
	variant_register()
	register_olib()          // Nota(jstn): depois, pos o algumas operações podem ser subscrita
	register_call_data()   	 //
	

	// prepara o programa para ser rodado
	call_script_function(mainID)
	return .INTERPRET_COMPILE_OK
}

interpret :: #force_inline proc() -> InterpretResult {
	allow_gc_trigger()
	return run()
}



@(private,optimization_mode="favor_size")
run :: proc() -> InterpretResult
{
	frame := get_current_frame()

	for 
	{
		instruction := #force_inline read_instruction()

		#partial switch instruction
		{
			case .OP_CONSTANT: 
				peek_cptr()^ = read_constant_ptr()^
				push_empty()

			case .OP_TRUE    : 
				BOOL_VAL_PTR(peek_cptr(),true)
				push_empty()

			case .OP_FALSE   : 
				BOOL_VAL_PTR(peek_cptr(),false)
				push_empty()

			case .OP_NIL     :
				NIL_VAL_PTR(peek_cptr())
				push_empty()

			case .OP_POP	 : pop_offset(1)

			case .OP_OPERATOR_UNARY: 


				op    := read_instruction()
				a     := pop_ptr()
				r     := peek_cptr()
				error : bool

				op_function := #force_inline get_operator_evaluator_unary(op,a.type)
							   
				if op_function == nil {
					runtime_error("invalid operand of type '",GET_TYPE_NAME(a),"' for unary operator '",get_operator_name(op),"'.")
					return .INTERPRET_RUNTIME_ERROR
				}

				#force_inline op_function(a,nil,r,&error,get_obj_error())
				if error { runtime_error(get_error_msg()); return .INTERPRET_RUNTIME_ERROR }								
				
				push_empty()
				
			case .OP_OPERATOR:

				op    :=  read_instruction()
				b     :=  pop_ptr() 
				a     :=  pop_ptr()
				r     :=  peek_cptr()

				error : bool

				op_function := #force_inline get_operator_evaluator(op,a.type,b.type)

				if op_function == nil {
					runtime_error("invalid operands '",GET_TYPE_NAME(a),"' and '",GET_TYPE_NAME(b),"' in operator '",get_operator_name(op),"'.")
					return .INTERPRET_RUNTIME_ERROR
				}

				#force_inline op_function(a,b,r,&error,get_obj_error())
				if error { runtime_error(get_error_msg()); return .INTERPRET_RUNTIME_ERROR }				
				
				push_empty()

			case .OP_PRINT: 

				argc  := read_byte()
				args  := peek_slice(argc)
						 pop_offset(argc)

				printer(args)

			case .OP_SUB_SP: pop_offset(read_byte())

			case  .OP_CONSTRUCT:

				op    := read_instruction()
				argc  := read_byte()
				args  := peek_slice(argc)
						 pop_offset(argc)

				r     := peek_cptr()
				error : bool

				construct_function := #force_inline get_construct_evaluator(op)
				if construct_function == nil { runtime_error("invalid  '",get_operator_name(op),"'","constructor."); return .INTERPRET_RUNTIME_ERROR }

				#force_inline construct_function(args,argc,r,&error,get_obj_error())
				if error { runtime_error(get_error_msg()); return .INTERPRET_RUNTIME_ERROR}
				
				push_empty()
				#force_inline trigger_gc()

			case .OP_DEFINE_GLOBAL: 

				sym_indx := read_byte()
				hash     := get_symbol_hash_BD(sym_indx)
			
				if !table_set_hash(frame.globals,hash,peek_ptr(0)^) {
					when OSCRIPT_ALLOW_RUNTIME_WARNINGS do runtime_error("there is already a variable declared '",get_symbol_str_BD(sym_indx),"' in this scope.")
					return .INTERPRET_RUNTIME_ERROR
				}

				pop_offset(1)


			case .OP_GET_GLOBAL:

				sym_indx := read_byte()
				hash     := get_symbol_hash_BD(sym_indx)

				value_p  := peek_cptr()

				if !table_get_hash(frame.globals,hash,value_p) {
					when OSCRIPT_ALLOW_RUNTIME_WARNINGS do runtime_error("identifier '",get_symbol_str_BD(sym_indx),"' not declared in the current scope.")
					return .INTERPRET_RUNTIME_ERROR
				}

				push_empty()

			case .OP_SET_GLOBAL:

				@static cannot := ValueBitSet{.OBJ_FUNCTION,.OBJ_CLASS,.OBJ_PACKAGE}

				sym_indx       := read_byte()
				hash           := get_symbol_hash_BD(sym_indx)
				cannot_assign  : bool

				if table_pset_hash(frame.globals,hash,peek_ptr(0),&cannot_assign,&cannot) {
					when OSCRIPT_ALLOW_RUNTIME_WARNINGS do runtime_error("undefined variable '",get_symbol_str_BD(sym_indx),"' in this scope.")
					return .INTERPRET_RUNTIME_ERROR
				}
				else if cannot_assign {
					when OSCRIPT_ALLOW_RUNTIME_WARNINGS do runtime_error("illegal assignment '",get_symbol_str_BD(sym_indx),"' in this scope.")
					return .INTERPRET_RUNTIME_ERROR
				}


			case .OP_GET_LOCAL: push_ptr(&frame.slots[read_byte()])

			case .OP_SET_LOCAL: frame.slots[read_byte()] = peek_ptr(0)^

			case .OP_JUMP_IF_FALSE: 
				jmp_address := read_byte()
				if #force_inline falsey(peek_ptr(0)) do frame.ip = &frame.function.chunk.code[jmp_address]
			
			case .OP_JUMP_IF_TRUE: 
				jmp_address := read_byte()
				if ! #force_inline falsey(peek_ptr(0)) do frame.ip = &frame.function.chunk.code[jmp_address]

			case .OP_JUMP: frame.ip = &frame.function.chunk.code[read_byte()]

			case .OP_MATCH: #force_inline match()

			// case .OP_ASSERT:

			// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if !IS_VAL_STRING_PTR(peek_ptr(0)) {
			// 		when OSCRIPT_ALLOW_RUNTIME_WARNINGS do runtime_error("expected a string for assert error message, got '",TYPE_TO_STRING(.OBJ_STRING),"'.")
			// 		return .INTERPRET_RUNTIME_ERROR
			// 	}	

			// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if falsey(peek_ptr(1)) {
			// 		when OSCRIPT_ALLOW_RUNTIME_WARNINGS do runtime_error("assertion failed: ",VAL_STRING_DATA_PTR(peek_ptr(0)))
			// 		return .INTERPRET_RUNTIME_ERROR
			// 	}

			// 	pop_offset(2)

			case .OP_CALL:

				argc   		 := read_byte()
				callee_value := pop_ptr()
				has_error    : bool

				callee := #force_inline get_call_type_ptr(callee_value) 
				if callee == nil { runtime_error("invalid call of type '",GET_TYPE_NAME(callee_value),"'."); return .INTERPRET_RUNTIME_ERROR }

				#force_inline callee(callee_value,argc,0,&has_error)
				if has_error do return .INTERPRET_RUNTIME_ERROR

				frame = get_current_frame()
				#force_inline trigger_gc()

			case .OP_CALL1:

				has_error : bool
				method    := pop_ptr()
				callee    := #force_inline  get_call_type_ptr(method) 
	
				#force_inline callee(method,0,1,&has_error)
				if has_error do return .INTERPRET_RUNTIME_ERROR

				frame = get_current_frame()

			case .OP_PRENEW: if !preinstatiate() do return .INTERPRET_RUNTIME_ERROR
				
				frame = get_current_frame()
				#force_inline trigger_gc()


			case .OP_NEW:
				argc      := read_byte()
				if ! #force_inline instatiate_class(argc) do return .INTERPRET_RUNTIME_ERROR
				
				frame = get_current_frame()
				#force_inline trigger_gc()

			case .OP_GET_PROPERTY:

				op            :=  read_instruction()
				property      :=  read_symid_vptr()
				obj           :=  pop_ptr() 
				r             :=  peek_cptr()
				error         : bool

				op_function := #force_inline get_operator_evaluator(op,obj.type,property.type)

				if op_function == nil { 
					sym_indx := AS_SYMID_PTR(property)
					runtime_error("cannot find property '",get_symbol_str_BD(sym_indx),"' on base of '",GET_TYPE_NAME(obj),"'.")
					return .INTERPRET_RUNTIME_ERROR
				}
		
				#force_inline op_function(obj,property,r,&error,get_obj_error())
				if error { runtime_error(get_error_msg()); return .INTERPRET_RUNTIME_ERROR }	

				push_empty()

			case .OP_CHANGE_GLOBAL: if !change_global(peek_ptr(0)) do return .INTERPRET_RUNTIME_ERROR
				// frame = get_current_frame()

			case .OP_GLOBAL_RETURN:	    previous_global_frame() 


			case .OP_SET_PROPERTY:

				op       :=  read_instruction()
				property :=  read_symid_vptr()	
				obj      :=  peek_ptr(0) 
				r        :=  peek_ptr(1)
				error    :   bool

				               
				op_function := #force_inline get_operator_evaluator(op,obj.type,property.type)
				
				if op_function == nil 
				{
					sym_indx := AS_SYMID_PTR(property)
					runtime_error("cannot find property '",get_symbol_str_BD(sym_indx),"' on base of '",GET_TYPE_NAME(obj),"'.")
					return .INTERPRET_RUNTIME_ERROR
				}
				
				#force_inline op_function(obj,property,r,&error,get_obj_error())
				if error     { runtime_error(get_error_msg()); return .INTERPRET_RUNTIME_ERROR }	

				

			case .OP_SET_INDEXING:

				op      := read_instruction()
				obj  	:= pop_ptr()
				indx 	:= pop_ptr()
				assign  := peek_ptr(0)

				error   : bool

				op_function := #force_inline get_operator_evaluator(op,obj.type,indx.type)
				if op_function == nil {
					runtime_error("cannot set index of type '",GET_TYPE_NAME(indx),"' on base of '",GET_TYPE_NAME(obj),"'.")
					return .INTERPRET_RUNTIME_ERROR
				}
				
				#force_inline op_function(obj,indx,assign,&error,get_obj_error())
				if error { runtime_error(get_error_msg()); return .INTERPRET_RUNTIME_ERROR }

			case .OP_INVOKE:

				argc   		:= read_byte()
				has_error	: bool

				handle := #force_inline get_handle_ptr(peek_ptr(0))
				if handle == nil { runtime_error("invalid call method of type '",GET_TYPE_NAME(peek_ptr(0)),"'."); return .INTERPRET_RUNTIME_ERROR }

				#force_inline handle(argc,&has_error)
				if has_error do return .INTERPRET_RUNTIME_ERROR

				frame = #force_inline get_current_frame()
				#force_inline trigger_gc()

			// case .OP_SUPER_INVOKE:

			// 	argc   		:= read_byte()
			// 	has_error	: bool

			// 	callee_from := #force_inline get_method_special(peek_ptr(argc))
			// 	               #force_inline callee_from(argc,&has_error)

			// 	if has_error do return .INTERPRET_RUNTIME_ERROR
			// 	frame = #force_inline get_current_frame()


			case .OP_STORE_RETURN: current_vm.treturn = pop_ptr()^
			case .OP_LOAD_RETURN : peek_cptr()^       = current_vm.treturn; push_empty()


			case .OP_RETURN:

				r_result    := pop_ptr()
				previous_frame()

				if end_frame() 	{
					when OSCRIPT_REPORT_TOS { println("\ntos -> ",get_vm().tos); return .INTERPRET_OK }
					else do return .INTERPRET_OK 
				}

				peek_cptr()^ = r_result^
				push_empty()

				frame = get_current_frame() //actualiza o frame corrente

			case : runtime_error("'",instruction,"' invalid instruction."); return .INTERPRET_RUNTIME_ERROR
			
		}



	}



	return .INTERPRET_OK
}

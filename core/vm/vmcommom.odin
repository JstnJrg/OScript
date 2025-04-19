#+ private
package OScriptVM


/* Nota(jstn): lé as informações que estão contidos no pool code da chunk
   pode ser qualquer informação, essa função é critica, deixe tal como está
   , ou saiba o que estas fazendo */
@(optimization_mode = "favor_size")
read_instruction :: #force_inline proc "contextless" () -> Opcode {
	frame_p := #force_inline get_current_frame()
	byte_data := frame_p.ip^
	frame_p.ip = ptr_offset(frame_p.ip,1)
	return Opcode(byte_data)
}

// /* Nota(jstn): preenche o opcode na chunk que deve ser chamado */
// @(optimization_mode = "favor_size")
// set_instruction :: #force_inline proc(op: Opcode) {
// 	frame_p 		:= get_current_frame()
// 	frame_p.ip^  = Uint(op)
// }

/* Nota(jstn): preenche o opcode na chunk que deve ser chamado */
@(optimization_mode = "favor_size")
set_instruction :: #force_inline proc "contextless" (op: Opcode, offset : Int) {
	frame_p 		    := #force_inline get_current_frame()
	frame_p.ip       = ptr_offset(frame_p.ip,offset) 
	frame_p.ip^      = Uint(op)
}


/* Nota(jstn): lé as informações que estão contidos no pool code da chunk
   pode ser qualquer informação, essa função é critica, deixe tal como está
   , ou saiba o que estas fazendo */
@(optimization_mode = "favor_size")
read_byte :: #force_inline proc "contextless" () -> Uint {
	frame_p   := #force_inline get_current_frame()
	byte_data := frame_p.ip^
	frame_p.ip = ptr_offset(frame_p.ip,1)
	return byte_data
}


/* Nota(jstn): lé as informações que estão contidos no pool code da chunk
   pode ser qualquer informação, essa função é critica, deixe tal como está
   , ou saiba o que estas fazendo */
@(optimization_mode = "favor_size")
read_gs_indx :: #force_inline proc "contextless" () -> Uint { return read_byte() }

/* Nota(jstn): lé as informações que estão contidos no pool code da chunk
   pode ser qualquer informação, essa função é critica, deixe tal como está
   , ou saiba o que estas fazendo */
@(optimization_mode = "favor_size")
read_constant :: #force_inline proc "contextless" () -> Value {
	return get_current_frame().function.chunk.constants[read_byte()]
}

/* Nota(jstn): lé as informações que estão contidos no pool code da chunk
   pode ser qualquer informação, essa função é critica, deixe tal como está
   , ou saiba o que estas fazendo */
@(optimization_mode = "favor_size")
read_constant_ptr :: #force_inline proc "contextless" () -> ^Value {
	return &get_current_frame().function.chunk.constants[read_byte()]
}


/* Nota(jstn): lé as informações que estão contidos no pool code da chunk
   pode ser qualquer informação, essa função é critica, deixe tal como está
   , ou saiba o que estas fazendo */
@(optimization_mode = "favor_size")
read_string :: #force_inline proc () -> ^ObjectString {
	return VAL_AS_OBJ_STRING(get_current_frame().function.chunk.constants[read_byte()])
}

@(optimization_mode = "favor_size")
read_string_vptr :: #force_inline proc "contextless" () -> ^Value {
	return &get_current_frame().function.chunk.constants[read_byte()]
}

read_symid_vptr :: #force_inline proc "contextless" () -> ^Value {
	return &get_current_frame().function.chunk.constants[read_byte()]
}

/* Nota(jstn): lé as informações que estão contidos no pool code da chunk
   pode ser qualquer informação, essa função é critica, deixe tal como está
   , ou saiba o que estas fazendo */
@(optimization_mode = "favor_size")
push :: #force_inline proc (value: Value) {
	if current_vm.tos >=  MAX_STACK do panic("stack overflow")
	current_vm.stack[current_vm.tos] = value
	current_vm.tos += 1
}

/* Nota(jstn): lé as informações que estão contidos no pool code da chunk
   pode ser qualquer informação, essa função é critica, deixe tal como está
   , ou saiba o que estas fazendo */
@(optimization_mode = "favor_size")
push_ptr :: #force_inline proc(value: ^Value) {
	if current_vm.tos >=  MAX_STACK do panic("stack overflow")
	current_vm.stack[current_vm.tos] = value^
	current_vm.tos += 1
}


/* Nota(jstn): lé as informações que estão contidos no pool code da chunk
   pode ser qualquer informação, essa função é critica, deixe tal como está
   , ou saiba o que estas fazendo */
@(optimization_mode = "favor_size")
push_empty :: #force_inline proc() {
	if current_vm.tos >=  MAX_STACK do panic("stack overflow")
	current_vm.tos += 1
}


/* Nota(jstn): lé as informações que estão contidos no pool code da chunk
   pode ser qualquer informação, essa função é critica, deixe tal como está
   , ou saiba o que estas fazendo */
@(optimization_mode = "favor_size")
pop :: #force_inline proc() -> Value {
	current_vm.tos -= 1
	if current_vm.tos < 0 do panic("stack underflow")
	return current_vm.stack[current_vm.tos]
}

/* Nota(jstn): lé as informações que estão contidos no pool code da chunk
   pode ser qualquer informação, essa função é critica, deixe tal como está
   , ou saiba o que estas fazendo */
@(optimization_mode = "favor_size")
pop_ptr :: #force_inline proc() -> ^Value {
	current_vm.tos -= 1
	if current_vm.tos < 0 do panic("stack underflow")
	return &current_vm.stack[current_vm.tos]
}


/* Nota(jstn): desloca o tos com base em um offset, presumo que é seguro */
@(optimization_mode = "favor_size")
pop_offset :: #force_inline proc "contextless" (#any_int offset: Int) { current_vm.tos -= offset }




/* Nota(jstn): lé as informações que estão contidos no pool code da chunk
   pode ser qualquer informação, essa função é critica, deixe tal como está
   , ou saiba o que estas fazendo */
@(optimization_mode = "favor_size")
peek :: #force_inline proc "contextless" (#any_int distance : Int) -> Value { 
	return current_vm.stack[current_vm.tos-1-distance] 
}

/* Nota(jstn): lé as informações que estão contidos no pool code da chunk
   pode ser qualquer informação, essa função é critica, deixe tal como está
   , ou saiba o que estas fazendo */
@(optimization_mode = "favor_size")
peek_ptr :: #force_inline proc "contextless" (#any_int distance : Int) -> ^Value { 
	return &current_vm.stack[current_vm.tos-1-distance] 
}

/* Nota(jstn): lé as informações que estão contidos no pool code da chunk
   pode ser qualquer informação, essa função é critica, deixe tal como está
   , ou saiba o que estas fazendo */
@(optimization_mode = "favor_size")
peek_cptr :: #force_inline proc "contextless" () -> ^Value { 
	return &current_vm.stack[current_vm.tos] 
}

/* Nota(jstn): lé as informações que estão contidos no pool code da chunk
   pode ser qualquer informação, essa função é critica, deixe tal como está
   , ou saiba o que estas fazendo */
@(optimization_mode = "favor_size")
peek_slice :: #force_inline proc "contextless" (#any_int distance : Int) -> []Value { 
	return current_vm.stack[current_vm.tos-distance:][:distance] 
}

// @(optimization_mode = "favor_size")
peek_slice_from :: #force_inline proc "contextless" (#any_int distance : Int) -> []Value { 
	return current_vm.stack[current_vm.tos-distance:][:distance+1] 
}


/* Nota(jstn): lé as informações que estão contidos no pool code da chunk
   pode ser qualquer informação, essa função é critica, deixe tal como está
   , ou saiba o que estas fazendo */
@(optimization_mode = "favor_size")
peek_type :: #force_inline proc "contextless" (#any_int distance : Int) -> ValueType { 
	return current_vm.stack[current_vm.tos-1-distance].type 
}


peek_string :: #force_inline proc( #any_int distance : Int) -> ^ObjectString { 
	return VAL_AS_OBJ_STRING(peek(distance))
}


pop_string :: #force_inline proc() -> ^ObjectString { 
	return VAL_AS_OBJ_STRING(pop())
}


jump      :: #force_inline proc "contextless" ( #any_int address: Uint) {
	frame   := get_current_frame()
	frame.ip = &frame.function.chunk.code[address]
}


/* Nota(jstn): devolve o frame actual apontado por frame_count, deixe tal como está
   , ou saiba o que estas fazendo */
@(optimization_mode = "favor_size")
get_current_frame :: #force_inline proc "contextless" () -> ^CallFrame {
	return &current_vm.frames[current_vm.frame_count-1]
}

/* Nota(jstn): actualiza o ponteiro do frame para proxima posicao livre, deixe tal como está
   , ou saiba o que estas fazendo */
@(optimization_mode = "favor_size")
next_frame :: #force_inline proc "contextless" () { current_vm.frame_count += 1 }

/* Nota(jstn): actualiza o ponteiro do frame para posicao previa livre, deixe tal como está
   , ou saiba o que estas fazendo */
@(optimization_mode = "favor_size")
previous_frame :: #force_inline proc "contextless" () { current_vm.frame_count -= 1 }

@(optimization_mode = "favor_size")
end_frame :: #force_inline proc "contextless" () -> bool { return current_vm.frame_count == 0 }


/* Nota(jstn): lé as informações que estão contidos no pool code da chunk
   pode ser qualquer informação, essa função é critica, deixe tal como está
   , ou saiba o que estas fazendo */
runtime_error :: proc(args: ..any) {

	frame_p		 := get_current_frame()

	instruction  := ptr_sub(frame_p.ip,&frame_p.function.chunk.code[0])
	localization := frame_p.function.chunk.localization[instruction-1]

	print("\n",localization.file," Error (",localization.line,",",localization.column,") ---> ",)
	print(..args)
	print('\n')
}


runtime_error_no_ctx :: proc(args: ..any) {
	print("\nError  ---> ",)
	print(..args)
	print('\n')
}


runtime_warnings :: proc(args: ..any) {

	frame_p	:= get_current_frame()

	instruction  := ptr_sub(frame_p.ip,&frame_p.function.chunk.code[0])
	localization := frame_p.function.chunk.localization[instruction-1]

	print("\n",localization.file," Error (",localization.line,",",localization.column,") ---> ",)
	print(..args)
}

/* Nota(jstn): em caso de stack overflow, mostra as funções que estavam em execução */
trace_stack :: proc(args: ..any)
{

	vm_p 		:= get_vm()
	print(..args)

	// printa as funcoes que estavam em execucao
	for i in 0..=vm_p.frame_count-1
	{
		
		frame_p  := &vm_p.frames[i]
		function := frame_p.function

		instruction  := ptr_sub(frame_p.ip,&frame_p.function.chunk.code[0])
		localization := frame_p.function.chunk.localization[instruction-1]
		
		// a funcao script nao é designada
		finfo  := &function.info
		print("\n(",localization.line,",",localization.column,") ---> frame ",i," [Function] ",finfo.name)
		
	}
}


// Nota(jstn): prepara a função script para ser executada
call_script_function :: proc(script_functionID: FunctionID) {

	call_functionID(script_functionID,0,true)

	// Nota(jstn): actualiza para o frame actaul
	frame          := get_current_frame()
	frame.globals   = &get_vm().globals
}




/* Nota(jstn): devolve o frame actual apontado por frame_count, deixe tal como está
   , ou saiba o que estas fazendo */
@(optimization_mode = "favor_size")
set_current_global_frame :: #force_inline proc "contextless" (table : ^Table) {
	current_vm.global_frame[current_vm.global_frame_count-1].current = table
}


/* Nota(jstn): devolve o frame actual apontado por frame_count, deixe tal como está
   , ou saiba o que estas fazendo */
@(optimization_mode = "favor_size")
get_current_global_frame :: #force_inline proc "contextless" () -> ^GlobalFrame {
	return &current_vm.global_frame[current_vm.global_frame_count-1]
}

/* Nota(jstn): actualiza o ponteiro do frame para proxima posicao livre, deixe tal como está
   , ou saiba o que estas fazendo */
@(optimization_mode = "favor_size")
next_global_frame :: #force_inline proc() -> (sucess: bool)  { 
	
	current_vm.global_frame_count += 1
	
	if current_vm.global_frame_count > MAX_GLOBAL_FRAME 
	{
		runtime_error("GLOBAL FRAME STACK OVERFLOW.")
		sucess = false
		return
	}

	sucess = true
	return
}

/* Nota(jstn): actualiza o ponteiro do frame para posicao previa livre, deixe tal como está
   , ou saiba o que estas fazendo */

@(optimization_mode = "favor_size")
previous_global_frame :: #force_inline proc "contextless" () { 
	frame        	:= get_current_frame()
	global_frame 	:= get_current_global_frame()
	frame.globals   = global_frame.current
	current_vm.global_frame_count -= 1   
}

/* Nota(jstn): actualiza o ponteiro do frame para posicao previa livre, deixe tal como está
   , ou saiba o que estas fazendo */

// @(optimization_mode = "favor_size")
// change_to_current_global_frame :: #force_inline proc() { 
// 	global_frame      := get_current_global_frame()
// 	current_vm.globals = global_frame.current
// }



// /* Nota(jstn): função que actualiza o ponteiro do frame da tabela de global, util para import's, classes etc.*/
@(optimization_mode = "favor_size")
change_global :: #force_inline proc (value_p: ^Value) -> (sucess:bool) {

	#partial switch value_p.type
	{
		// case .OBJ_CLASS_INSTANCE:

		// 	if !next_global_frame() do return false // 0 -> 1
			
		// 	instance := VAL_AS_OBJ_CLASS_INSTANCE_PTR(value_p)
		// 	frame    := get_current_frame()

		// 	set_current_global_frame(frame.globals) // 0
		// 	frame.globals = &instance.fields

		// 	sucess = true
		// 	return

		case .OBJ_PACKAGE:

			if !next_global_frame() do return false // 0 -> 1
			
			import_id      := AS_IMPORT_BD_ID_PTR(value_p)
			import_globals := get_import_context_importID(import_id)
			frame          := get_current_frame()
			
			set_current_global_frame(frame.globals) // Nota(jstn): salva esse contexto
			frame.globals = import_globals

			sucess = true
			return
	}


 return

}



match :: #force_inline proc ()
{
	ncases          := read_byte()
	condition_value := pop_ptr()

	addresses        := peek_slice(ncases); pop_offset(ncases)
	cases            := peek_slice(ncases); pop_offset(ncases)

	@static r : Value
	error     : bool

	for &case_value,indx in cases
	{
		 op_function :=  #force_inline get_operator_evaluator(.OP_EQUAL,condition_value.type,case_value.type)
		if op_function == nil do continue

		#force_inline op_function(condition_value,&case_value,&r,&error,get_obj_error())
		if AS_BOOL_PTR(&r) { jump(AS_INT_PTR(&addresses[indx])+1); return }
	} 
	
}



preinstatiate    :: #force_inline proc() -> (sucess: bool) {

	obj := pop_ptr()

	#partial switch obj.type {

		case .OBJ_CLASS:
	     
	     klass_instance := CREATE_OBJ_CLASS_INSTANCE(AS_CLASS_BD_ID_PTR(obj))
	     class_id       := klass_instance.klass_ID
	     r              := peek_cptr()

	     OBJECT_VAL_PTR(r,klass_instance,.OBJ_CLASS_INSTANCE)
	     push_empty()

	     @static method : Value
	     has_error      : bool

	     initialize_instance_property_classBD(class_id,&klass_instance.fields)
	     sucess = true

	     sucess = get_private_method_classBD(class_id,".__CLASS__.",&method)

	     // Nota(jstn): caso não tenha, então foi declarada ao nivel do Odinlang
	     if !sucess do return true

	     // Nota(jstn): não precisamos verificar se é nil ou não, toda class
	     // deveria ter, é o que pensamos (classes declaradas ao nivel do oscript)
		  callee := #force_inline  get_call_type_ptr(&method) 
				       #force_inline callee(&method,0,1,&has_error)

		  sucess = !has_error 
	     return

	    case .OBJ_PACKAGE:
	    	

	}


	runtime_error("only classes are instantiable.")
	return
}


instatiate_class :: #force_inline proc(#any_int argc: Int) -> bool
{

	klass_instance := VAL_AS_OBJ_CLASS_INSTANCE_PTR(peek_ptr(0))

	// chama o metodo de inicialização ao criar a instancia
	init_name           :: "init"
	@static inicializer : Value
	has_not_error       : bool

	//  uma vez que é uma expressão, então ao final, a VM vai emitr uma pop instrunção, então para
	// evitarmos muitos objectos na STACK, vamos substituir a class pela sua instancia 
	if get_method_classBD(klass_instance.klass_ID,init_name,&inicializer) {
		callee := #force_inline get_call_type_ptr(&inicializer) 
		          #force_inline callee(&inicializer,argc,1,&has_not_error)
		return !has_not_error
	}

	if argc != 0 { runtime_error("expected 0 arguments, but got",argc); return false }
	return true
}


trigger_gc :: #force_inline proc() { if current_vm.gc_trigger do if current_vm.bytes_allocated > current_vm.next_gc do #force_inline collect_garbage() }
#+private

package OScriptVM

import ast "oscript:ast"


@(private="file") current_codegen : ^CodeGen

CodeGen   :: struct { clabel_data: ^LabelData } 

LabelData :: struct 
{
	table      : LabelTable,
	enclosing  : ^LabelData
}

Label   :: struct {
	type    : enum u8 {BREAK,CONTINUE},
	address : int
}

LabelTable       :: [dynamic]Label


create_codegen   :: proc() { cg := new(CodeGen,compile_default_allocator());oscript_assert_mode(cg != nil ); assert(cg != nil, "CodeGen is nullptr."); current_codegen = cg }
destroy_codegen  :: proc() { current_codegen = nil }

begin_labeldata  :: proc() {
	
	if current_codegen.clabel_data == nil {
		 current_codegen.clabel_data       = new(LabelData,compile_default_allocator())
		 current_codegen.clabel_data.table = make(LabelTable,compile_default_allocator())
		 return
	}

	enclosing 							   					 := current_codegen.clabel_data
	current_codegen.clabel_data 					= new(LabelData,compile_default_allocator())
	current_codegen.clabel_data.table     = make(LabelTable,compile_default_allocator())
	current_codegen.clabel_data.enclosing = enclosing
}

end_labeldata   :: proc() { current_codegen.clabel_data = current_codegen.clabel_data.enclosing }

get_labeldata_table :: proc() -> ^LabelTable { return &current_codegen.clabel_data.table }

register_break     :: proc(address: int ) { append(&current_codegen.clabel_data.table,Label{.BREAK,address})}
register_continue  :: proc(address: int ) { append(&current_codegen.clabel_data.table,Label{.CONTINUE,address})}

is_break_l      :: proc(l: ^Label) -> bool { return l.type == .BREAK    }
is_continue_l   :: proc(l: ^Label) -> bool { return l.type == .CONTINUE }










codegen_generate ::  proc(node: ^Node) { generate(node) }

generate_default_return :: proc()      { 
  loc  := peek_clocalization() 
  node := create_return_node(create_literal_node(.OP_NIL,loc),0,loc)
  codegen_generate(node)
}

generate_package_return :: proc() {
  loc  := peek_clocalization() 
  // node := create_return_node(create_literal_node(.OP_NIL,loc),0,loc)
  // codegen_generate(node)
  emit_instruction(.OP_RETURN,loc)
}


@(private="file")
generate :: proc(node: ^Node) {

	#partial switch node.type
	{

		case .EXPRESSION:
			expr_node := (^ast.ExprNode)(node)
			loc       := expr_node.loc

			generate(expr_node.expr)
			emit_instruction(.OP_POP,loc)

		case .STATEMENT:
			stmt_node := (^ast.StmtNode)(node)
			generate(stmt_node.stmt)



		case .LITERAL  :
			literal_node := (^ast.LiteralNode)(node)
			op           := literal_node.op
			loc          := literal_node.loc

			emit_instruction(op,loc)

		case .INT: 
			int_node := (^ast.IntNode)(node)
			loc      := int_node.loc
			emit_constant_load_instruction(INT_VAL(int_node.number),loc)

		case .FLOAT: 
			float_node := (^ast.FloatNode)(node)
			loc        := float_node.loc
			emit_constant_load_instruction(FLOAT_VAL(float_node.number),loc)
		
		case .STRING:
			string_node := (^ast.StringNode)(node)
			str         := string_node.str
			loc         := string_node.loc

			obj_str     := CREATE_OBJ_STRING(&str,vm_get_internal_strings(),string_node.len)
			emit_constant_load_instruction(OBJECT_VAL(obj_str,.OBJ_STRING),loc)

		case .VECTOR:

			container := (^ast.ContainerNode)(node)
			args      := &container.elements
			argc      := len(args)
			loc       := container.loc

			for coord in args do generate(coord)

			//Nota(jstn): TODO: suportar Vec3
			oscript_assert_mode(argc == 2)
			assert(argc == 2,"invalid Vector2 construct, the argcount must be 2.")

			emit_instruction(.OP_CONSTRUCT,loc)
			emit_instruction(.OP_CONSTRUCT_VECTOR2,loc) 
			emit_slot_index(argc,loc)

		case .ARRAY:

			container := (^ast.ContainerNode)(node)
			args      := &container.elements
			argc      := len(args)
			loc       := container.loc

			for coord in args do generate(coord)

			emit_instruction(.OP_CONSTRUCT,loc)
			emit_instruction(.OP_CONSTRUCT_ARRAY,loc)
			emit_slot_index(argc,loc)

		case .TRANSFORM:

			container := (^ast.ContainerNode)(node)
			args      := &container.elements
			argc      := len(args)
			loc       := container.loc

			for axis in args do generate(axis)

			//Nota(jstn): TODO: suporte para Transform3
			oscript_assert_mode(argc == 3)
			assert(argc == 3,"invalid Transform2D construct, the argcount must be 3.")

			emit_instruction(.OP_CONSTRUCT,loc)
			emit_instruction(.OP_CONSTRUCT_TRANSFORM2,loc) 
			emit_slot_index(argc,loc)

		case .COLOR:

			container := (^ast.ContainerNode)(node)
			args      := &container.elements
			argc      := len(args)
			loc       := container.loc

			for channel in args do generate(channel)

			oscript_assert_mode(argc == 4)
			assert(argc == 4,"invalid Color construct, the argcount must be 4.")

			emit_instruction(.OP_CONSTRUCT,loc)
			emit_instruction(.OP_CONSTRUCT_COLOR,loc) 
			emit_slot_index(argc,loc)

		case .RECT:

			container := (^ast.ContainerNode)(node)
			args      := &container.elements
			argc      := len(args)
			loc       := container.loc

			for channel in args do generate(channel)

			oscript_assert_mode(argc == 2)
			assert(argc == 2,"invalid Rect construct, the argcount must be 2.")

			emit_instruction(.OP_CONSTRUCT,loc)
			emit_instruction(.OP_CONSTRUCT_RECT2,loc) 
			emit_slot_index(argc,loc)



		case .UNARY:
			unary_node := (^ast.UnaryNode)(node)
			op         := unary_node.op
			loc        := unary_node.loc

			generate(unary_node.rhs)
			emit_instruction_and_slot_index(.OP_OPERATOR_UNARY,op,loc)

		case .BINARY:
			binary_node := (^ast.BinaryNode)(node)
			op         := binary_node.op
			loc        := binary_node.loc

			generate(binary_node.lhs)
			generate(binary_node.rhs)
			emit_instruction_and_slot_index(.OP_OPERATOR,op,loc)

		case .TERNARY:
			ternary_node := (^ast.TernaryNode)(node) 
			rhs          := ternary_node.rhs
			lhs          := ternary_node.lhs
			condition    := ternary_node.condition
			loc          := ternary_node.loc

			generate(condition)
			false_jmp_address := emit_jump_and_get_address(.OP_JUMP_IF_FALSE,loc) 

			emit_instruction(.OP_POP,loc)
			generate(lhs)

			jmp_address      := emit_jump_and_get_address(.OP_JUMP,loc)

			fill_label_jump_placehold(false_jmp_address,get_current_address())
			emit_instruction(.OP_POP,loc)
			generate(rhs)

			fill_label_jump_placehold(jmp_address,get_current_address())

		case .LOGICAL:
			logical_node := (^ast.LogicalNode)(node)
			op           := logical_node.op
			loc          := logical_node.loc

			#partial switch op
			{
				case .OP_AND:
				 
				 generate(logical_node.lhs)
				 emit_instruction_and_slot_index(.OP_OPERATOR_UNARY,op,loc)

				 false_jmp_address := emit_jump_and_get_address(.OP_JUMP_IF_FALSE,loc)
				 emit_instruction(.OP_POP,loc)
				 
				 generate(logical_node.rhs)
				 emit_instruction_and_slot_index(.OP_OPERATOR_UNARY,op,loc)

				 fill_label_jump_placehold(false_jmp_address,get_current_address())

				case .OP_OR:
				 
				 generate(logical_node.lhs)
				 emit_instruction_and_slot_index(.OP_OPERATOR_UNARY,op,loc)

				 true_jmp_address := emit_jump_and_get_address(.OP_JUMP_IF_TRUE,loc)
				 emit_instruction(.OP_POP,loc)
				 
				 generate(logical_node.rhs)
				 emit_instruction_and_slot_index(.OP_OPERATOR_UNARY,op,loc)
				 
				 fill_label_jump_placehold(true_jmp_address,get_current_address())
			}


		case .NAMEDVAR:
			named_node := (^ast.NamedNode)(node)
			name       := named_node.name
			is_local   := named_node.is_local
			local_indx := named_node.local_indx
			loc        := named_node.loc

			if is_local do emit_instruction_and_slot_index(.OP_GET_LOCAL,local_indx,loc)
			else 
			{
				var_indx := register_symbol_BD(name)
				emit_instruction_and_slot_index(.OP_GET_GLOBAL,var_indx,loc)
			}


		case .ASSIGNMENT:
		 	assignment_node := (^ast.AssignmentNode)(node)
		 	name            := assignment_node.name
		 	expr            := assignment_node.expr
		 	is_local        := assignment_node.is_local
		 	local_indx      := assignment_node.local_indx
		 	loc             := assignment_node.loc

		 	if is_local {
		 		generate(expr)
		 		emit_instruction_and_slot_index(.OP_SET_LOCAL,local_indx,loc)
		 	}
		 	else {
				generate(expr)
				var_indx := register_symbol_BD(name)
				emit_instruction_and_slot_index(.OP_SET_GLOBAL,var_indx,loc)
		 	}


    case .CALL:
    	call_node := (^ast.CallNode)(node)
    	callee    := call_node.callee
    	args      := &(^ast.ContainerNode)(call_node.args).elements
    	argc      := call_node.argc
    	loc       := call_node.loc

    	for arg in args do generate(arg)
    	generate(callee)
    	emit_instruction_and_slot_index(.OP_CALL,argc,loc)

			case .NEW:
				new_node := (^ast.NewNode)(node)
				name     := new_node.class
				args     := &(^ast.ContainerNode)(new_node.args).elements
				argc     := new_node.argc
				loc      := new_node.loc

				for arg in args do generate(arg)
				
				generate(name)
				emit_instruction(.OP_PRENEW,loc)

				emit_instruction_and_slot_index(.OP_NEW,argc,loc)


		case .SET_PROPERTY:
			set_property_node := (^ast.SetPropertyNode)(node)
			named             := set_property_node.lhs
			expr              := set_property_node.expr
			property          := set_property_node.property
			op                := set_property_node.op
			loc               := set_property_node.loc

			generate(expr)
			generate(named)
			
			emit_instruction(.OP_SET_PROPERTY,loc)
			
			sym_id  := register_symbol_BD(property)
			symindx := add_value_in_chunk_and_get_indx(SYMID_VAL(sym_id))

			emit_slot_index(op,loc)
			emit_slot_index(symindx,loc)

			generate_set_property(named)
			// emit_instruction(.OP_POP,loc)
			
		case .GET_PROPERTY:
			get_property_node := (^ast.GetPropertyNode)(node)
			named             := get_property_node.lhs
			property          := get_property_node.property
			op                := get_property_node.op
			loc               := get_property_node.loc

			generate(named)
	
			emit_instruction(.OP_GET_PROPERTY,loc)

			sym_id   := register_symbol_BD(property)
			symindx  := add_value_in_chunk_and_get_indx(SYMID_VAL(sym_id))

			emit_slot_index(op,loc)
			emit_slot_index(symindx,loc)



		case .CALL_METHOD:

			call_method := (^ast.CallMethodNode)(node)
			named       := call_method.lhs
			method      := call_method.method
			args        := &(^ast.ContainerNode)(call_method.args).elements
			argc        := call_method.argc
			loc         := call_method.loc

			for arg in args do generate(arg)
			generate(named)

			// sym_id  := register_symbol_BD(property)
			// symindx := add_value_in_chunk_and_get_indx(SYMID_VAL(sym_id))
			// emit_slot_index(symindx,loc)

			// method_indx  := add_variable_name_in_chunk_and_get_indx_s(&method)
			sym_id  := register_symbol_BD(method)
			emit_instruction(.OP_INVOKE,loc)
			emit_slot_index(argc,loc)
			emit_slot_index(sym_id,loc)
			// emit_slot_index(method_indx,loc)



		case .OBJECTOPERATOR: //=============================================================================================

			object_operator := (^ast.ObjectOperatorNode)(node)
			lhs             := object_operator.lhs
			index           := object_operator.index
			rhs             := object_operator.rhs
			is_set          := object_operator.is_set
			loc             := object_operator.loc

			if is_set 
			{
				generate(rhs)
				generate(index)
				generate(lhs)

				emit_instruction(.OP_SET_INDEXING,loc)
				emit_instruction(.OP_SET_INDEXING,loc)

			}
			else 
			{
				generate(lhs)
				generate(index)

				emit_instruction(.OP_OPERATOR,loc)
				emit_instruction(.OP_GET_INDEXING,loc)
			}




		// STMT
		case .PRINT:

			print_node := (^ast.PrintNode)(node)
			args       := &print_node.container.elements
			loc        := print_node.loc
			argc       := len(args)

			for _node in args do generate(_node)
			emit_instruction_and_slot_index(.OP_PRINT,argc,loc)



		case .SETVAR:

			set_node := (^ast.DefineNode)(node)
			expr     := set_node.expr
			name     := set_node.name
			is_local := set_node.is_local
			loc      := set_node.loc

			if is_local do generate(expr)
			else 
			{
				var_indx := register_symbol_BD(name)
				generate(expr)
				emit_instruction_and_slot_index(.OP_DEFINE_GLOBAL,var_indx,loc)
			}



		case .BLOCK:

			block_node  := (^ast.Block)(node)
			body        := block_node.body
			args        := body.elements
			local_count := block_node.local_count
			loc         := block_node.loc

			for _node in args do generate(_node)

			// println(" local ----> ",local_count)

			// Nota(jstn):uma otimização
			if local_count > 0 do emit_instruction_and_slot_index(.OP_SUB_SP,local_count,loc)


		case .IF:

			if_node     := (^ast.IfNode)(node)
			condition   := if_node.condition
			body        := if_node.body
			elif        := if_node.elif
			has_elif    := if_node.has_elif
			loc         := if_node.loc

			generate(condition)
			false_jmp_address := emit_jump_and_get_address(.OP_JUMP_IF_FALSE,loc)

			emit_instruction(.OP_POP,loc)
			generate(body)

			true_jmp_address := emit_jump_and_get_address(.OP_JUMP,loc) 

			fill_label_jump_placehold(false_jmp_address,get_current_address())
			emit_instruction(.OP_POP,loc)

			if has_elif do generate(elif)

			fill_label_jump_placehold(true_jmp_address,get_current_address())


	  case .WHILE:

	  	while_node  := (^ast.WhileNode)(node)
	  	condition   := while_node.condition
	  	body        := while_node.body
	  	loc         := while_node.loc

	  	jmp_to_address := emit_jump_and_get_address(.OP_JUMP,loc)
	  	block_address  := get_current_address()
	  	
	  	emit_instruction(.OP_POP,loc)

	  	begin_labeldata() //label data
	  	generate(body)
	  	

	  	fill_label_jump_placehold(jmp_to_address,get_current_address())
	  	continue_address    := get_current_address()
	  	
	  	generate(condition)
	  	
	  	true_jmp_address := emit_jump_and_get_address(.OP_JUMP_IF_TRUE,loc)
	  	fill_label_jump_placehold(true_jmp_address,block_address)

	  	emit_instruction(.OP_POP,loc)

	  	break_address  := get_current_address()

	  	// Nota(jstn): preenche os dados do label
	  	for &ld in get_labeldata_table() {
	  		 if       is_break_l(&ld)    do fill_label_jump_placehold(ld.address,break_address) 
	  		 else if  is_continue_l(&ld) do fill_label_jump_placehold(ld.address,continue_address)
	  	}

	  	end_labeldata() //label data


	  case .FOR:

	  	for_node  := (^ast.ForNode)(node)
	  	start     := for_node.start
	  	condition := for_node.condition
	  	increment := for_node.increment

	  	body      := for_node.body
	  	ibody     := for_node.ibody
	  	loc       := for_node.loc

	  	generate(start)

	  	jmp_to_address := emit_jump_and_get_address(.OP_JUMP,loc)
	  	block_address  := get_current_address()


	  	emit_instruction(.OP_POP,loc)

	  	begin_labeldata() //label data
	  	generate(body)

	  	continue_address := get_current_address()

	  	generate(increment)
	  	emit_instruction(.OP_POP,loc)

	  	fill_label_jump_placehold(jmp_to_address,get_current_address())	  	
	  	generate(condition)


	  	true_jmp_address := emit_jump_and_get_address(.OP_JUMP_IF_TRUE,loc)
	  	fill_label_jump_placehold(true_jmp_address,block_address)

	  	generate(ibody)

	  	break_address    := get_current_address()
	  	emit_instruction(.OP_POP,loc)
	  	
	  	// Nota(jstn): preenche os dados do label
	  	for &ld in get_labeldata_table() {

	  		 if       is_break_l(&ld)    do fill_label_jump_placehold(ld.address,break_address) 
	  		 else if  is_continue_l(&ld) do fill_label_jump_placehold(ld.address,continue_address)
	  	}

	  	end_labeldata() //label data


	  case .MATCH:
	  	
	  	match_node   := (^ast.MatchNode)(node)
	  	mcondition   := match_node.condition
	  	condictions  := &(^ast.ContainerNode)(match_node.conditions).elements
	  	cases        := &(^ast.ContainerNode)(match_node.cases).elements
	  	
	  	has_default  := match_node.has_default
	  	loc          := match_node.loc

	  	default_body : ^Node

	  	if has_default do  default_body,_ = pop_safe(cases)

	  	lcondition  := len(condictions)
	  	lcases      := len(cases)

	  	CaseLabel   :: struct { start: int, end: int }
	  	laddress    := create_temp_dynamic(CaseLabel)

	  	oscript_assert_mode(lcondition == lcases)
	  	assert( lcondition == lcases,"something went wrong in match case.")


	  	if lcases > 0 
	  	{

	  		// match initial (1)
	  	 	initial_jump := emit_jump_and_get_address(.OP_JUMP,loc)
	  	

	  		for _case in cases { 
	  			cl      : CaseLabel
	  			cl.start = get_current_address(); generate(_case); cl.end = emit_jump_and_get_address(.OP_JUMP,loc)
	  			append(&laddress,cl)
	  		}

	  		// (2)
	  		fill_label_jump_placehold(initial_jump,get_current_address())
	  		
	  		for _cond  in condictions do generate(_cond)
	  		for &cl    in laddress    do emit_constant_load_instruction(INT_VAL(cl.start),loc)

	  		// (3)
	  		generate(mcondition)
	  		emit_instruction_and_slot_index(.OP_MATCH,lcases,loc)



	  		// Nota(jstn): default
	  		if has_default       do generate(default_body)

	  		// end
	  		for &cl in laddress  do fill_label_jump_placehold(cl.end,get_current_address())
	  		
	  		}

	  case .BREAK:

	  	break_node  := (^ast.BreakNode)(node)
	  	local_count := break_node.local_count
	  	loc         := break_node.loc


	  	// Nota(jstn): uma otimização
	  	if local_count >  0 do emit_instruction_and_slot_index(.OP_SUB_SP,local_count,loc)
	  	break_address := emit_jump_and_get_address(.OP_JUMP,loc)
	  	register_break(break_address)

	  case .CONTINUE:

	  	continue_node  := (^ast.ContinueNode)(node)
	  	local_count := continue_node.local_count
	  	loc         := continue_node.loc

	  	// Nota(jstn): uma otimização
	  	if local_count >  0 do emit_instruction_and_slot_index(.OP_SUB_SP,local_count,loc)
	  	continue_address := emit_jump_and_get_address(.OP_JUMP,loc)
	  	register_continue(continue_address)


	  case .FUNCTION:

	  	function_node := (^FunctionNode)(node)
	  	name          := function_node.name
	  	pbody         := function_node.pbody
	  	body          := function_node.body
	  	arity         := function_node.arity
	  	loc           := function_node.loc

	  	function_id     := create_function_functionBD(name,arity,0,get_current_importID())
	  	function_chunk  := get_function_chunk_functionBD(function_id)

	  	enclosing_chunk := get_current_chunk()
			set_current_chunk(function_chunk)

			generate(body)
			generate(pbody)
			generate_default_return()

			set_current_chunk(enclosing_chunk)
			emit_constant_load_instruction(FUNCTION_BD_ID_VAL(function_id,.OBJ_FUNCTION),loc)

			// func_indx := add_variable_name_in_chunk_and_get_indx_s(&name)
			sym_indx := register_symbol_BD(name)
			emit_instruction_and_slot_index(.OP_DEFINE_GLOBAL,sym_indx,loc)


			case .CLASS:
				
				class_node := (^ClassNode)(node)
				name       := class_node.name
				loc        := class_node.loc

				class_data := class_node.class_data
				fields     := &(^ast.ContainerNode)(class_node.fields_nodes).elements
				methods    := &(^ast.ContainerNode)(class_node.methods_nodes).elements

				has_super  := class_node.has_super
				super_name := class_node.extends

				// Nota(jstn): herança
				super_id := ClassID(-1)

				if has_super { 
					if id ,found  := get_class_name_classBD_by_string(super_name); found do super_id = id
					else { error2(loc,"could not find base class '",super_name,"'.");    return }
				}

				// Nota(jstn): registra a class
				class_id := register_class_classBD(name,super_id)


				for property in class_data.fields 
				{
					register_class_property_classBD(class_id,property)
					if has_super && super_has_property_classBD(class_id,property) { error2(loc,"the '",property,"' property already exists in super class '",super_name,"'."); return }

					register_class_property_set_classBD(class_id,property,get_default_set_classBD(.OBJ_CLASS_INSTANCE))
					register_class_property_get_classBD(class_id,property,get_default_get_classBD(.OBJ_CLASS_INSTANCE))
				}

				// Nota(jstn): vamos executar o corpo da class
				//  afim de que avaliar as expressoes nelas contidas
				// então, precisamos definir o default arity para 1 afim de 
				// tem um permenor, a instancia está acima dos argumentos
				// capturar a instancia. seu slot é 0.
				___CLASS___     :: ".__CLASS__."

		  	function_id     := create_function_functionBD(___CLASS___,0,1,get_current_importID())
		  	function_chunk  := get_function_chunk_functionBD(function_id)

		  	enclosing_chunk := get_current_chunk()
				set_current_chunk(function_chunk)

					// Nota(jstn): carrega a função class caso possua uma class super
					// todas as classes possuem
				if has_super 
				{
						method : Value
						get_private_method_classBD(super_id,".__CLASS__.",&method)
						emit_constant_load_instruction(method,loc)
						emit_instruction(.OP_CALL1,loc)
				}

				for f in fields { generate(f); emit_instruction(.OP_POP,loc) }

				//Nota(jstn): precisamos retornar, então, vamos retornar a instancia, ela já está na stack
				emit_instruction(.OP_RETURN,loc)
				register_class_private_method_classBD(class_id,___CLASS___,FUNCTION_BD_ID_VAL(function_id,.OBJ_FUNCTION))

					
				set_current_chunk(enclosing_chunk)
			 // Nota(jstn): vamos  registrar os metodos

				for m in methods
				{
			  	method_node   := (^FunctionNode)(m)
			  	name          := method_node.name
			  	pbody         := method_node.pbody
			  	body          := method_node.body
			  	arity         := method_node.arity
			  	loc           := method_node.loc

			  	method_id     := create_function_functionBD(name,arity,1,get_current_importID())
			  	method_chunk  := get_function_chunk_functionBD(method_id)

			  	enclosing_chunk := get_current_chunk()
					set_current_chunk(method_chunk)

					generate(body)
					generate(pbody)
					generate_default_return()

					set_current_chunk(enclosing_chunk)
					register_class_method_classBD(class_id,name,FUNCTION_BD_ID_VAL(method_id,.OBJ_FUNCTION))
				}


				// Nota(jstn): declara na tabela de global actual
				// class_name_indx := add_variable_name_in_chunk_and_get_indx_s(&name)
				sym_indx := register_symbol_BD(name)
				emit_constant_load_instruction(CLASS_BD_ID_VAL(class_id,.OBJ_CLASS),loc)
				emit_instruction_and_slot_index(.OP_DEFINE_GLOBAL,sym_indx,loc)


		case .IMPORT:

			import_node := (^ast.ImportNode)(node)
			import_name := import_node.name
			importc     := (^ast.ContainerNode)(import_node.container)
			is_native   := import_node.is_native
			is_duplicate:= import_node.is_duplicate
			hash        := import_node.hash
			body        := importc.elements
			loc         := import_node.loc

			// Nota(jstn): caso seja nativo
			if is_native  {

				id := get_native_import_by_name_importID(import_name,OMODULES)

				oscript_assert_mode(id >= 0)
				assert(id >= 0,"illegal import, is not defined as native.")

	      // import_name_indx := add_variable_name_in_chunk_and_get_indx_s(&import_name)
	      symindx := register_symbol_BD(import_name)
				emit_constant_load_instruction(IMPORT_BD_ID_VAL(id,.OBJ_NATIVE_CLASS),loc)
				emit_instruction_and_slot_index(.OP_DEFINE_GLOBAL,symindx,loc)
			}
			else if is_duplicate 
			{
				// Nota(jstn): é um bug, se o hash for 0, pois 0 é dado somente para import nativos

				oscript_assert_mode(hash > 0)
				assert(hash > 0, "something went wrong to handle reimported package." )
				id := get_import_by_hash_importID(hash)

	      // import_name_indx := add_variable_name_in_chunk_and_get_indx_s(&import_name)
	      symindx := register_symbol_BD(import_name)
				emit_constant_load_instruction(IMPORT_BD_ID_VAL(id,.OBJ_NATIVE_CLASS),loc)
				emit_instruction_and_slot_index(.OP_DEFINE_GLOBAL,symindx,loc)

			}
			else //Nota(jstn): pacotes não nativo
			{

				// Nota(jstn): obtem o ID fruto do registro
				iID              := register_import_importID(import_name,hash)

				// Nota(jstn): declara primeiro o Modulo, caso seu escopo estiver criando objectos, é
				// necessario que seja alcançavel.
	      // import_name_indx := add_variable_name_in_chunk_and_get_indx_s(&import_name)
	      symindx := register_symbol_BD(import_name)
				emit_constant_load_instruction(IMPORT_BD_ID_VAL(iID,.OBJ_PACKAGE),loc)
				emit_instruction_and_slot_index(.OP_DEFINE_GLOBAL,symindx,loc)

				// Nota(jstn): 
				emit_instruction_and_slot_index(.OP_GET_GLOBAL,symindx,loc)
				emit_instruction(.OP_CHANGE_GLOBAL,loc)


				// Nota(jstn): recupera o actual ID 
				enclosing_import := get_current_importID()
				set_current_importID(iID)


				//Nota(jstn): registra tudo
				for _node in body do generate(_node)


				// Nota(jstn): muda o contexto
				set_current_importID(enclosing_import)


				emit_instruction(.OP_GLOBAL_RETURN,loc)
				emit_instruction(.OP_POP,loc)

			}


		case .RETURN:
			return_node := (^ast.ReturnNode)(node)
			expr        := return_node.expr
			local_count := return_node.local_count
			loc         := return_node.loc

			generate(return_node.expr)
			emit_instruction(.OP_STORE_RETURN,loc)
			
			// Nota(jstn): uma otimização
			if local_count > 0 do emit_instruction_and_slot_index(.OP_SUB_SP,local_count,loc)

			emit_instruction(.OP_LOAD_RETURN,loc)
			emit_instruction(.OP_RETURN,loc)

		case : unreachable_ast(node)
		
	}

}


// Nota(jstn): Para quebrar o bug, uma vez que o _mem é copiado, e não é passado a referencia
// então, subistitui onde quer que a variavel está guardada, eu sei que é uma pessima abordagem
// mas é o que eu pensei até aqui.

// STACK : obj, value -> pop: obj, exp: pop value
// deixamos o obj na pilha, pois precisamos transforma-lo num bool
// caso use o buffer, salta para atribuição, caso não, não atribui

// @(private="file")
generate_set_property :: proc(node: ^Node)
{

	#partial switch node.type
	{
		case .NAMEDVAR:
				
				named_node := (^ast.NamedNode)(node)
				name       := named_node.name
				is_local   := named_node.is_local
				local_indx := named_node.local_indx
				loc        := named_node.loc

				if is_local
				{
					// Nota(jstn): caso use o buffer, não pula
					not_use_buffer := emit_jump_and_get_address(.OP_JUMP_IF_TRUE,loc)

					// Nota(jstn): remove o obj transformado em true/false
					emit_instruction(.OP_POP,loc)

					// Nota(jstn): o que vai ser guardado já está na pilha
					emit_instruction_and_slot_index(.OP_SET_LOCAL,local_indx,loc)
					use_buffer := emit_jump_and_get_address(.OP_JUMP,loc)

					fill_label_jump_placehold(not_use_buffer,get_current_address())
					emit_instruction(.OP_POP,loc)

					fill_label_jump_placehold(use_buffer,get_current_address())
				}
				else 
				{	
					sym_id   := register_symbol_BD(name)

					// Nota(jstn): caso use o buffer, não pula
					not_use_buffer := emit_jump_and_get_address(.OP_JUMP_IF_TRUE,loc)

					// Nota(jstn): remove o obj transformado em true/false
					emit_instruction(.OP_POP,loc)

					// Nota(jstn): o que vai ser guardado já está na pilha
					emit_instruction_and_slot_index(.OP_SET_GLOBAL,sym_id,loc)
					use_buffer := emit_jump_and_get_address(.OP_JUMP,loc)

					fill_label_jump_placehold(not_use_buffer,get_current_address())
					emit_instruction(.OP_POP,loc)

					fill_label_jump_placehold(use_buffer,get_current_address())
				}
	

		case .GET_PROPERTY:

			get_property_node := (^ast.GetPropertyNode)(node)
			named             := get_property_node.lhs
			property          := get_property_node.property
			op                := get_property_node.op
			loc               := get_property_node.loc

			// generate(expr)
			// generate(named)
			
			// emit_instruction(.OP_SET_PROPERTY,loc)
			
			// sym_id  := register_symbol_BD(property)
			// symindx := add_value_in_chunk_and_get_indx(SYMID_VAL(sym_id))

			// emit_slot_index(op,loc)
			// emit_slot_index(symindx,loc)


			// Nota(jstn): o que vai ser guardado já está na pilha
			// Nota(jstn): caso use o buffer, não pula
			not_use_buffer := emit_jump_and_get_address(.OP_JUMP_IF_TRUE,loc)

			// Nota(jstn): remove o obj transformado em true/false
			emit_instruction(.OP_POP,loc)

			generate(named)
			emit_instruction(.OP_SET_PROPERTY,loc)

			sym_id  := register_symbol_BD(property)
			symindx := add_value_in_chunk_and_get_indx(SYMID_VAL(sym_id))

			emit_instruction(.OP_SET_PROPERTY,loc)
			emit_slot_index(symindx,loc)

			emit_instruction(.OP_POP,loc)

			use_buffer := emit_jump_and_get_address(.OP_JUMP,loc)

			fill_label_jump_placehold(not_use_buffer,get_current_address())
			emit_instruction(.OP_POP,loc)

			fill_label_jump_placehold(use_buffer,get_current_address())


		case .OBJECTOPERATOR:

			object_operator := (^ast.ObjectOperatorNode)(node)
			lhs             := object_operator.lhs
			index           := object_operator.index
			rhs             := object_operator.rhs
			is_set          := object_operator.is_set
			loc             := object_operator.loc

			// Nota(jstn): o que vai ser guardado já está na pilha
			// Nota(jstn): caso use o buffer, não pula
			not_use_buffer := emit_jump_and_get_address(.OP_JUMP_IF_TRUE,loc)

			// Nota(jstn): remove o obj transformado em true/false
			emit_instruction(.OP_POP,loc)

			generate(index)
			generate(lhs)
			emit_instruction(.OP_SET_INDEXING,loc)
			emit_instruction(.OP_SET_INDEXING,loc)

			use_buffer := emit_jump_and_get_address(.OP_JUMP,loc)

			fill_label_jump_placehold(not_use_buffer,get_current_address())
			emit_instruction(.OP_POP,loc)

			fill_label_jump_placehold(use_buffer,get_current_address())


		case :
			println(node, "set property not handled. it's a compiler bug. please report")
			unreachable_ast(node)


	}

}

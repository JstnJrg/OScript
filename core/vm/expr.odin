#+private

package OScriptVM

member :: proc(lhs: ^Node, bp: BindPower) -> ^Node {

	loc := peek_clocalization(); advance()

	// Nota(jstn): 'new'
	if at(.New)
	{	
		advance()
		expect(.Open_Paren,"expected '(' after 'new'.")
		argc,argcontainer := argument_list(bp)
		expect(.Close_Paren,"expected ')' after arguments.")

		return create_new_node(lhs,argcontainer,argc,loc)
	}

	expect(.Identifier,"expect property name after '.'.")
	if has_error() do return create_bad_node(peek_p(),loc)
	tk_property := peek_p()

	// Nota(jstn): set,get,invoke
	if at(.Equal)      { advance(); rhs := expression(.DEFAULT); return create_set_property_node(lhs,rhs,tk_property.text,.OP_SET_PROPERTY,loc) }
	if at(.Open_Paren) { advance(); argc,container := argument_list(bp); expect(.Close_Paren,"expected '(' after arguments."); return create_call_method_node(lhs,container,tk_property.text,argc,loc)}

	if ok, op := assignmetopcode(peek_ctype()); ok {
		advance()
		rhs := expression(.DEFAULT); 
		bin_node  := create_binary_node(create_get_property_node(lhs,tk_property.text,.OP_GET_PROPERTY,loc),rhs,op,loc)
		return create_set_property_node(lhs,bin_node,tk_property.text,.OP_SET_PROPERTY,loc)
	} 



	return create_get_property_node(lhs,tk_property.text,.OP_GET_PROPERTY,loc)
}


call        :: proc(lhs: ^Node, bp: BindPower) -> ^Node {

	loc := peek_clocalization(); advance()
	result : ^Node

	if !ast_is_identifier(lhs) { error("expected a indetifier for call expression."); return create_bad_node(peek_c(),loc) }
	if is_class() && call_method(lhs,&result,bp,loc) do return result


	argc,argcontainer := argument_list(bp)
	expect(.Close_Paren,"expected ')' after arguments.")

	return create_call_node(lhs,argcontainer,argc,loc)
}


call_method :: proc(lhs: ^Node ,result: ^^Node,bp: BindPower ,loc : Localization) -> bool {

	named 		:= ast_as_namednode(lhs)
	name  		:= named.name
	method_name := synthetic_token(name)

	if has, _ := class_check_redeclaration_method(&method_name); !has do return false

	argc,container := argument_list(bp); 
	expect(.Close_Paren,"expected ')' after arguments."); 


	// Nota(jstn): presumimos que estamos dentro de uma class
	slot    := -1
	tk_self := synthetic_token("self")

	scope_get_var_index(tk_self,&slot)
	result^ = create_call_method_node(create_named_node("",true,slot,loc),container,name,argc,loc)
	return true
}



argument_list :: proc(bp: BindPower) -> (int,^Node) {

	container        := create_container_node()
	args             := &container.elements
	argc             : int

	for !is_eof() && !has_error() && !at(.Close_Paren)
	{
		    skip() // Nota(jstn): remove paragrafos caso haja
	  defer skip()

	  append(args,expression(.DEFAULT))
	  skip_comma()
	  argc += 1

	  if argc > MAX_ARGUMENTS do error("can't have more than ",MAX_ARGUMENTS," arguments.")

	}

	return argc,container
}




assignment2 :: proc(lhs: ^Node, bp: BindPower) -> ^Node {

	p   := peek_p()
	loc := peek_clocalization(); advance()
	opt := peek_ptype()


	// Nota(jstn): só recebe membro aqui quando se está dentro de uma class (presumo eu)
	if ast_is_get_property(lhs) {
		
		get_pnode := ast_as_getpropertynode(lhs)
		tk_self   := synthetic_token("self")

		property  := get_pnode.property
		slot      := -1

		scope_get_var_index(tk_self,&slot)
	    _, opcode := assignmetopcode(opt)
		rhs       := expression(bp)

		bin_node  := create_binary_node(lhs,rhs,opcode,loc)
		return create_set_property_node(create_named_node("",true,slot,loc),bin_node,property,.OP_SET_PROPERTY,loc)
	} 
	
	if !ast_is_identifier(lhs) { error("invalid assignment. expected a identifier as target in assignment."); return create_bad_node(p,loc)}


	_,opcode    := assignmetopcode(opt)
	rhs         := expression(bp)
	binary_node := create_binary_node(lhs,rhs,opcode,loc)
	namednode   := ast_as_namednode(lhs)

	return create_assignment(namednode.name,binary_node,namednode.is_local,namednode.local_indx,loc)
}

assignment :: proc(lhs: ^Node, bp: BindPower) -> ^Node {

	p   := peek_p()
	loc := peek_clocalization(); advance()

	if !ast_is_identifier(lhs) { 
		error("invalid assignment. expected a identifier as target in assignment.")
		return create_bad_node(p,loc)
	}

	rhs       := expression(bp)
	namednode := ast_as_namednode(lhs)

	return create_assignment(namednode.name,rhs,namednode.is_local,namednode.local_indx,loc)
}


ternary  :: proc(lhs: ^Node, bp: BindPower) -> ^Node
{
	#partial switch peek_ctype()
	{
		case .If:

			loc := peek_clocalization(); advance()
			condition := expression(bp) 

			expect(.Else,"expected 'else' after  condition.")
			rhs := expression(bp)

			return create_ternary_node(lhs,condition,rhs,loc)

		case : unreachable(); return nil
	}
} 


binary   :: proc(lhs: ^Node, bp: BindPower) -> ^Node {

	t   := peek_c()
	loc := peek_clocalization(); advance()

	#partial switch t.type 
	{
		case .Sub: 
			rhs := expression(bp)
			return create_binary_node(lhs,rhs,.OP_SUB,loc)

		case .Add: 
			rhs := expression(bp)
			return create_binary_node(lhs,rhs,.OP_ADD,loc)

		case .Mult: 
			rhs := expression(bp)
			return create_binary_node(lhs,rhs,.OP_MULT,loc)

		case .Mult_Mult: 
			rhs := expression(bp)
			return create_binary_node(lhs,rhs,.OP_MULT_MULT,loc)
		
		case .Quo: 
			rhs := expression(bp)
			return create_binary_node(lhs,rhs,.OP_DIV,loc)
		
		case .Mod: 
			rhs := expression(bp)
			return create_binary_node(lhs,rhs,.OP_MOD,loc)

		case .And_Bit: 
			rhs := expression(bp)
			return create_binary_node(lhs,rhs,.OP_BIT_AND,loc)

		case .Xor_Bit: 
			rhs := expression(bp)
			return create_binary_node(lhs,rhs,.OP_BIT_XOR,loc)

		case .Or_Bit: 
			rhs := expression(bp)
			return create_binary_node(lhs,rhs,.OP_BIT_OR,loc)
		
		case .Shift_L_Bit: 
			rhs := expression(bp)
			return create_binary_node(lhs,rhs,.OP_SHIFT_LEFT,loc)

		case .Shift_R_Bit: 
			rhs := expression(bp)
			return create_binary_node(lhs,rhs,.OP_SHIFT_RIGHT,loc)

		case .Equal_Eq: 
			rhs := expression(bp)
			return create_binary_node(lhs,rhs,.OP_EQUAL,loc)

		case .Less: 
			rhs := expression(bp)
			return create_binary_node(lhs,rhs,.OP_LESS,loc)

		case .Greater: 
			rhs := expression(bp)
			return create_binary_node(lhs,rhs,.OP_GREATER,loc)

		case .Not_Eq: 
			rhs := expression(bp)
			return create_binary_node(lhs,rhs,.OP_NOT_EQUAL,loc)

		case .Less_Eq: 
			rhs := expression(bp)
			return create_binary_node(lhs,rhs,.OP_LESS_EQUAL,loc)

		case .Greater_Eq: 
			rhs := expression(bp)
			return create_binary_node(lhs,rhs,.OP_GREATER_EQUAL,loc)

		case .And: 
			rhs := expression(bp)
			return create_logical_node(lhs,rhs,.OP_AND,loc)

		case .Or: 
			rhs := expression(bp)
			return create_logical_node(lhs,rhs,.OP_OR,loc)

		case : unreachable(); return nil
	}
}


group  :: proc(bp: BindPower) -> ^Node {
	advance()
	node := expression(.DEFAULT)
	expect(.Close_Paren,"expected closing ')' after grouping expression.")
	return node
}


unary   :: proc(bp: BindPower) -> ^Node {

	t   := peek_c()
	loc := peek_clocalization(); advance()

	#partial switch t.type 
	{
		case .Sub: 
			rhs := expression(bp)
			return create_unary_node(rhs,.OP_NEGATE,loc)

		case .Add: 
			rhs := expression(bp)
			return rhs

		case .Not: 
			rhs := expression(bp)
			return create_unary_node(rhs,.OP_NOT,loc)

		case .Not_Bit: 
			rhs := expression(bp)
			return create_unary_node(rhs,.OP_BIT_NEGATE,loc)

		case : unreachable(); return nil
	}
}


primary :: proc(bp: BindPower) -> ^Node
{

	t   := peek_c()
	loc := peek_clocalization(); advance()

	#partial switch t.type
	{

		case .True : return create_literal_node(.OP_TRUE,loc)
		case .False: return create_literal_node(.OP_FALSE,loc)
		case .Null : return create_literal_node(.OP_NIL,loc)

		case .Int  : return create_int_node(atoi(t.text),loc)
		case .Float: return create_float_node(Float(atof(t.text)),loc)


		case .String: return create_string_node(t.text,loc)
	
		case : unreachable(); return nil
	}

}


identifier :: proc(bp: BindPower) -> ^Node {


	t       := peek_c()
	loc     := peek_clocalization(); advance()
	local_r : ^Node
	has_var : bool


	// if  is_class()        && identifier_class(&local_r,t,loc) do return local_r
	if !is_global_scope() && identifier_local(&local_r,t,loc) do return local_r 

	// verifica se existe uma declaração global, caso seja  uma  variavel global
	if  has, _loc :=  global_check_redeclaration_var(t); has    do has_var = has

	if !has_var do error("identifier '",t.text,"' not declared in the current scope")
	return create_named_node(t.text,false,-1,loc)
}

identifier_local :: proc(result : ^^Node , t : Token, loc : Localization) -> bool {

	slot    := -1
	// verifica se existe uma declaração global, caso seja  uma  variavel global
	if has, _loc :=  scope_get_var_index(t,&slot); !has do return false

	result^ = create_named_node(t.text,true,slot,loc)
	return true
}


identifier_class :: proc(result: ^^Node, t:Token, loc : Localization) -> bool 
{
	// Nota(jstn): se estivermos numa class, então o mais provavel é que 
	// é uma propriedade da instancia. Temos dois cenarios possiveis

	// 1 - ou estamos dentro do corpo da class (slot 0)
	// 2 - ou estamos em um em um metodo (com slot de qualquer indx)
	// if is_class() 
	
	// TODO: invoção de metdos sem especificação do self, só depois
	#partial switch get_current_type()
	{

		case .TYPE_METHOD,.TYPE_INITIALIZER :

			t := t
			// // Nota(jstn): caso seja um metodo o call vai tratar dele, por issom
			// // vamos retorna-lo

			if has,_  := class_check_redeclaration_method(&t); has && at(.Open_Paren) {
				result^ = create_named_node(t.text,true,-1,loc)
				return true
			}

			// Nota(jstn): field 
			println(class_check_redeclaration_field(&t))

			if has, _ := class_check_redeclaration_field(&t); !has do return false

			slot    := -1
			tk_self := synthetic_token("self")

			scope_get_var_index(tk_self,&slot)
			result^ = create_get_property_node(create_named_node(tk_self.text,true,slot,loc) ,t.text,.OP_GET_PROPERTY,loc)
			return true	

		// Nota(jstn): corpo da class. 
		// segue a logica do prenew, aqui a instancia é slot 0
		case .TYPE_SCRIPT:
			result^ = create_get_property_node(create_named_node("",true,0,loc) ,t.text,.OP_GET_PROPERTY,loc)
			return true
	}
	return false
}
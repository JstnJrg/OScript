#+private

package OScriptVM


vector :: proc(bp: BindPower) -> ^Node {

	loc := peek_clocalization(); type := peek_ctype(); advance()

	container := create_container_generic_node(.VECTOR,loc)
	args      := &container.elements
	argc      := 0


	expect(.Open_Paren,"expected '(' after Vector2.")

	for !is_eof() && !has_error() && !at(.Close_Paren) && argc < 3
	{
		append(args,expression(bp))
		skip_comma()
		argc += 1
	}

	expect(.Close_Paren,"expected ')' after Vector2 arguments.")
	if argc > 2 || argc < 2 do error("illegal Vector expression.")

	return container
}


rect2 :: proc(bp: BindPower) -> ^Node {

	loc := peek_clocalization(); type := peek_ctype(); advance()

	container := create_container_generic_node(.RECT,loc)
	args      := &container.elements
	argc      := 0


	expect(.Open_Paren,"expected '(' after Rect2.")

	for !is_eof() && !has_error() && !at(.Close_Paren) && argc < 3
	{
		append(args,expression(bp))
		skip_comma()
		argc += 1
	}

	expect(.Close_Paren,"expected ')' after Rect2 arguments.")
	if argc > 2 || argc < 2 do error("illegal Rect2 expression.")

	return container
}


array :: proc(bp: BindPower) -> ^Node {

	loc := peek_clocalization(); advance()

	container := create_container_generic_node(.ARRAY,loc)
	args      := &container.elements
	argc      := 0

	for !is_eof() && !has_error() && !at(.Close_Bracket)
	{
		append(args,expression(bp))
		skip_comma()
		argc += 1
	}

	expect(.Close_Bracket,"expected ']'.")
	return container
}


transform2 :: proc(bp: BindPower) -> ^Node {

	loc := peek_clocalization(); advance()

	container := create_container_generic_node(.TRANSFORM,loc)
	args      := &container.elements
	argc      := 0

	expect(.Open_Paren,"expected '(' after Transform2D.")

	for !is_eof() && !has_error() && !at(.Close_Paren)
	{
		append(args,expression(bp))
		skip_comma()
		argc += 1
	}

	if argc != 3 do error("Transform2D expects 3 args, but got",argc)

	expect(.Close_Paren,"expected ')'.")
	return container
}


color :: proc(bp: BindPower) -> ^Node {

	loc := peek_clocalization(); advance()

	container := create_container_generic_node(.COLOR,loc)
	args      := &container.elements
	argc      := 0

	expect(.Open_Paren,"expected '(' after Color.")

	for !is_eof() && !has_error() && !at(.Close_Paren)
	{
		append(args,expression(bp))
		skip_comma()
		argc += 1
	}

	if argc != 4 do error("Color expects 4 args, but got",argc)

	expect(.Close_Paren,"expected ')'.")
	return container
}




indexing :: proc(lhs: ^Node,bp: BindPower) -> ^Node
{
	loc    := peek_clocalization(); advance(); is_set : bool
	index  := expression(.DEFAULT)
	rhs    : ^Node

	expect(.Close_Bracket,"expected ']'.")
	if at(.Equal) { advance(); rhs = expression(.DEFAULT); is_set = true }
	
	return create_object_operator_node(lhs,index,rhs,is_set,loc)
}


self :: proc(bp: BindPower) -> ^Node {

	loc := peek_clocalization(); advance()
	
	if !is_class() || !is_function() { error("can't use 'self' outside of a class."); return create_bad_node(peek_p(),loc) }

	// Nota(jstn): por ser dentro de um metodo
	// presumimos que sempre será possível determinar
	// o slot do 'self'.
	slot    := -1
	tk_self := peek_p()

	scope_get_var_index(tk_self,&slot)
	return create_named_node(tk_self.text,true,slot,loc) 
}
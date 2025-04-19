#+private

package OScriptVM


import_stmt :: proc(bp: BindPower) -> ^Node {
	
	loc := peek_clocalization(); advance()
	if !is_global_scope() { error("cannot use 'import' out of the file scope "); return create_bad_node(peek_p(),loc)}


	expect(.Identifier,"expected a import name.")
	import_name := peek_p()

	// Nota(jstn): carrega o script
	if has_error() do return create_bad_node(peek_c(),loc)

	if !at(.From) do return import_native_stmt(import_name,loc)

	expect(.From,  "expected 'from' after import name.")
	expect(.String,"expected import path.")

	import_path := peek_p()

	// Nota(jstn): antes de carregar o script, verifica se já foi importado, caso sim, é um erro
	if has, loc := has_dependencie(import_path.text); has do error("duplicate import.")

	// Nota(jstn): carrega o script
	if has_error() do return create_bad_node(peek_c(),loc)

	// Nota(jstn): verifica se já foi importado, caso sim,
	// retorna seu hash

	// println(package_was_importated(import_path.text))
	if was, hash := package_was_importated(import_path.text); was {
		// Nota(jstn): depois de sair do import
		// declara o import
		global_declare_import(import_name,loc)
		return create_import_node(create_container_node(),import_name.text,hash,false,true,loc)
	}

	code_p,sucess := load_script(import_path.text)
	if !sucess { error("something went wrong in import."); return create_bad_node(peek_c(),loc) }

	enclosing_tkzr := get_current_tkzr()
	enclosing_psr  := get_current_psr()
	enclosing_dep  := get_dependencies()

	// Nota(jstn): registra o actual script como depencia
	// para evitar referencias ciclicas de scripts
	register_dependencies(import_path.text,loc)

	// Nota(jstn): regista como importado
	global_register_imported_package(import_path)

	// 
	defer 
	{
		has_error_t := has_error()
		set_current_tkzr(enclosing_tkzr)
		set_current_psr(enclosing_psr)

		// Nota(jstn): depois de sair do import
		// declara o import
		global_declare_import(import_name,loc)

		if has_error_t do mute_error()
	}

	// Nota(jstn): inicializa a analise do novo ficheiro
	set_current_tkzr(tk_create(compile_default_allocator()))
	tk_init(get_current_tkzr(),code_p,import_path.text)
	set_current_psr(p_create(compile_default_allocator()))

	// Nota(jstn): inicializa um novo compilador evitando
	// assim dados compartilhados
	      begin_new_compiler()
	defer end_compiler ()

	// Nota(jstn): dependecias
	set_enclosing_dependencies(enclosing_dep)

    //Nota(jstn): prepass
    register_prepass()
    prepass()

	// start
	advance()
	skip()

	// Nota(jstn): adiciona todos os nós dentro desse container
	container := create_container_node()
	stmt      := &container.elements

	for !is_eof() && !has_error() {
		stmt_node := parse_stmt(bp)
		append(stmt,stmt_node)
	}

	return create_import_node(container,import_name.text,hash_string(import_path.text),false,false,loc)
}


import_native_stmt :: proc(name: Token , loc: Localization) -> ^Node {
	if !is_stmt_end() { error("illegal import."); return create_bad_node(peek_p(),loc)}
	global_declare_import(name,loc)
	return create_import_node(create_container_node(),name.text,0,true,false,loc)
}


class_stmt :: proc(bp: BindPower) -> ^Node {

	loc := peek_clocalization(); advance()
	
	expect(.Identifier,"expected a class name.")	
	class_name := peek_p()


	// herança
	super_name : string
	has_super  : bool

	if at(.Extends)
	{
		advance()
		expect(.Identifier,"expected superclass name after 'extends'.")
		super_name = peek_p().text
		has_super  = true
	}

	// 
	skip_newline2(1)
	expect(.Open_Brace,"expected '{' after class name")


	if !is_global_scope() do error("class must be in global scope.")
	if has_error() do return create_bad_node(peek_p(),loc)

	// 
	class_node := create_class_node(class_name.text,loc)

	// 
	class_node.has_super = has_super
	class_node.extends   = super_name

	// 
	fields_container  := create_container_node()
	fields            := &fields_container.elements

	methods_container := create_container_node()
	methods           := &methods_container.elements

	// 
	class_node.fields_nodes  = fields_container
	class_node.methods_nodes = methods_container

	// 
	      begin_class()
	defer end_class()

	// Nota(jstn): declaramos antes, pois pode ser que dentro 
	//  da class, pode haver metodos que estão instanciando a class

	global_declare_class(class_name,loc)
	skip()


	for !is_eof() && !has_error() && !at(.Close_Brace) {

		if at(.Set) { append(fields, parse_field(bp)); skip2() ; continue }
		if at(.Fn)  { append(methods,parse_method(bp)); skip2(); continue }
		
		error("unexpected '",peek_ctype(),"' in class body.")
	}


	expect(.Close_Brace,"expected '}' after class body.")
	class_node.class_data = get_current_class()

	return class_node
}

parse_field :: proc(bp: BindPower) -> ^Node {

	advance(); loc := peek_clocalization()
	expect(.Identifier,"expected a variable name after 'set'.")

	tk_field_name := peek_p()
	rhs: ^Node
	
	// 
	if token_len(&tk_field_name) > MAX_VARIABLE_NAME {
		error("variable name cannot be longer than ",MAX_VARIABLE_NAME," characters.")
		return create_bad_node(tk_field_name,loc)
	}


	if has, _loc :=  class_check_redeclaration_field(&tk_field_name); has {
	     error("variable '",tk_field_name.text,"' has the same name as a previously declared variable at (",_loc.line,",",_loc.column,").")
	}
	if has, _loc :=  class_check_redeclaration_method(&tk_field_name); has {
			error("variable '",tk_field_name.text,"' has the same name as a previously declared method at (",_loc.line,",",_loc.column,").")
	}

	if at(.Equal) { advance(); rhs = expression(.DEFAULT)}
	else do rhs = create_literal_node(.OP_NIL,loc)

	class_declare_field(&tk_field_name)

	//Nota(jstn): como vai se executar o corpo da class,
	// então todo field vai em si ser um set_property, antes de criar
	// a instancia com NEW ela é colocada no top, então tem slot 0. 
	// a string do named não interessa, pois presumimos que é uma variavel local a instancia
	field := create_set_property_node(create_named_node("",true,0,loc),rhs,tk_field_name.text,.OP_SET_PROPERTY,loc)
	return field

}

parse_method :: proc(bp:BindPower) -> ^Node {

	loc := peek_clocalization(); advance()
	expect(.Identifier,"expected a method name after 'fn'.")
	
	tk_method_name := peek_p()

	
	// ======================================================

	if token_len(&tk_method_name) > MAX_VARIABLE_NAME {
		error("method name cannot be longer than ",MAX_VARIABLE_NAME," characters.")
		return create_bad_node(tk_method_name,loc)
	}

	if has, _loc :=  class_check_redeclaration_field(&tk_method_name); has {
	     error("method '",tk_method_name.text,"' has the same name as a previously declared variable at (",_loc.line,",",_loc.column,").")
	}
	if has, _loc :=  class_check_redeclaration_method(&tk_method_name); has {
			error("method '",tk_method_name.text,"' has the same name as a previously declared method at (",_loc.line,",",_loc.column,").")
	}


	// =========================================================
	container        := create_container_node()
	args             := &container.elements
	// =========================================================


	expect(.Open_Paren," expected '(' after method name.")
	arity : int

		  begin_function( tk_method_name.text == "init" ? .TYPE_INITIALIZER: .TYPE_METHOD)
	defer end_function()

          begin_scope()
    defer end_scope()
	

	for !is_eof() && !has_error() && !at(.Close_Paren) 
	{
		expect(.Identifier,"expected a parameter name.")
		scope_declare_var(peek_p(),.ID,loc)
		skip_comma()

		arity += 1

		if arity > MAX_ARGUMENTS 
		{ 
			error("can't have more than ",MAX_ARGUMENTS," got ",arity,".")
			return create_bad_node(peek_p(),loc)
		}
	}

	self_tk := synthetic_token("self")
	scope_declare_var(self_tk,.ID,loc)

	expect(.Close_Paren," expected ')' after method parameters.")
	skip_newline2(1)

	if !at(.Open_Brace) do error(" expected '{' after method parameters.")
	if has_error()      do return create_bad_node(peek_c(),loc)


	class_declare_method(&tk_method_name) //depois dos parametros, para evitar que uma função seja seu proprio parametro
	
	body  := block_stmt(.DEFAULT)
	pbody := create_block_node(container,scope_get_local_count(),loc)

	// Nota(jstn): caso esteja no constructor, e o return não foi declarado explicitamente
	// pelo usuario então devemos nos certificar que o metodo vai retornar a instancia
	if is_init_function() 
	{
		slot        := -1
		scope_get_var_index(self_tk,&slot)

		local_count := ast_block_get_local_count(body)+ast_block_get_local_count(pbody)
		ireturn     := create_return_node(create_named_node(self_tk.text,true,slot,loc),local_count,loc)
		block_append_node(body,ireturn)
	} 

	return create_function_node(tk_method_name.text,pbody,body,arity,loc)
}


fn_stmt :: proc(bp: BindPower) -> ^Node {

	loc := peek_clocalization(); advance()

	expect(.Identifier,"expected a function name after 'fn'.")
	tk_function_name := peek_p()

	// Nota(jstn): o prepass já declara as funcções
	// verifica se existe uma declaração global
	// if has, gdata :=  global_check_redeclaration_var(tk_function_name); has {
	//      error("function '",tk_function_name.text,"' has the same name as a previously declared",kind2string(gdata.kind)," at (",gdata.pos.line,",",gdata.pos.column,").")
	// }

	if is_global_scope() do return parse_fn(loc)

	error("function must be in global scope.")
	return create_bad_node(tk_function_name,loc)
}


parse_fn :: proc(loc: Localization) -> ^Node {

	tk_function_name := peek_p()
	container        := create_container_node()
	args             := &container.elements

	expect(.Open_Paren," expected '(' after function name.")
	arity : int

		  begin_function(.TYPE_FUNCTION)
	defer end_function()

		  begin_scope()
	defer end_scope()

	for !is_eof() && !has_error() && !at(.Close_Paren) 
	{
		expect(.Identifier,"expected a parameter name.")
		scope_declare_var(peek_p(),.ID,loc)
		skip_comma()

		arity += 1

		if arity > MAX_ARGUMENTS 
		{ 
			error("can't have more than ",MAX_ARGUMENTS," got ",arity,".")
			return create_bad_node(peek_p(),loc)
		}
	}

	expect(.Close_Paren," expected ')' after function parameters.")
	skip_newline2(1)

	if !at(.Open_Brace) do error(" expected '{' after function parameters.")
	if has_error()      do return create_bad_node(peek_c(),loc)


	global_declare_function(tk_function_name,loc) //depois dos parametros, para evitar que uma função seja seu proprio parametro
	body  := block_stmt(.DEFAULT)
	pbody := create_block_node(container,scope_get_local_count(),loc)

	return create_function_node(tk_function_name.text,pbody,body,arity,loc)
}

set_stmt   :: proc(bp: BindPower) -> ^Node {

	if !is_global_scope() do return set_stmt_local(bp)

	advance()
	loc := peek_clocalization()
	rhs : ^Node

	expect(.Identifier,"expected a variable name after 'set'.")
	tk_var_name := peek_p()

	// 
	if token_len(&tk_var_name) > MAX_VARIABLE_NAME {
		error("variable name cannot be longer than ",MAX_VARIABLE_NAME," characters.")
		return create_bad_node(tk_var_name,loc)
	}

	// verifica se existe uma declaração global, caso seja  uma  variavel global
	if has, gdata :=  global_check_redeclaration_var(tk_var_name); has {
	     error("variable '",tk_var_name.text,"' has the same name as a previously declared",kind2string(gdata.kind)," at (",gdata.pos.line,",",gdata.pos.column,").")
	}

	if at(.Equal) { advance(); rhs = expression(bp) }
	else do rhs = create_literal_node(.OP_NIL,loc)

	// Nota(jstn): declara como global
	global_declare_var(tk_var_name,loc)

	return create_define_node(tk_var_name.text,rhs,false,loc)
}


set_stmt_local :: proc(bp: BindPower ) -> ^Node {

	advance()
	loc := peek_clocalization()
	rhs : ^Node

	expect(.Identifier,"expected a variable name after 'set'.")
	tk_var_name := peek_p()

	if token_len(&tk_var_name) > MAX_VARIABLE_NAME {
		error("variable name cannot be longer than ",MAX_VARIABLE_NAME," characters.")
		return create_bad_node(tk_var_name,loc)
	}

	if has, ldata :=  scope_check_redeclaration_var(tk_var_name); has {
	     error("variable '",tk_var_name.text,"' has the same name as a previously declared",kind2string(ldata.kind)," at (",ldata.pos.line,",",ldata.pos.column,").")
	}
	
	if at(.Equal) { advance(); rhs = expression(bp) }
	else do rhs = create_literal_node(.OP_NIL,loc)

	scope_declare_var(tk_var_name,.ID,loc)

	return create_define_node(tk_var_name.text,rhs,true,loc)
	
}

print_stmt     :: proc(bp: BindPower) -> ^Node {

	advance()
	loc       := peek_clocalization()
	container := create_container_node()
	args      := &container.elements

	if is_stmt_end() do append(args,create_literal_node(.OP_NIL,loc))
	else do for !is_stmt_end() && !has_error() {
		append(args,expression(bp))
		if at(.Comma) do skip_comma()
		else do break
	}

	return create_print_node(container,loc)
}

if_stmt     :: proc(bp: BindPower ) -> ^Node {

	loc := peek_clocalization() ; advance()

	condition : ^Node
	body      : ^Node
	elif      : ^Node
	has_elif  : bool

	condition = expression(bp)
	skip_newline2(1)

	if !at(.Open_Brace) do error("expected closing '{' before block body.")
	
	body = block_stmt(bp)
	
	skip()             // Nota(jstn): consome a newline terminador de stmt
	set_is_if(true)   // cria uma exceção para o if

	for 
	{
		if          at(.Elif) { elif = if_stmt(bp);   has_elif = true }
		else if     at(.Else) { elif = else_stmt(bp); has_elif = true }
		else do break
	}

	return create_if_node(condition,body,elif,has_elif,loc)
}

else_stmt   :: proc(bp: BindPower ) -> ^Node {

	loc := peek_clocalization() ; advance()

	condition : ^Node
	body      : ^Node
	elif      : ^Node

	condition = create_literal_node(.OP_TRUE,loc)
	skip_newline2(1)

	if !at(.Open_Brace) do error("expected closing '{' before block body.")
	body = block_stmt(bp)
	
	return create_if_node(condition,body,elif,false,loc)
}

while_stmt :: proc(bp: BindPower ) -> ^Node {

	loc := peek_clocalization() ; advance()

	condition : ^Node
	body      : ^Node

	condition = expression(bp)
	skip_newline2(1)

	if !at(.Open_Brace) do error("expected closing '{' before block body.")

	body = block_stmt(bp,true)
	return create_while_node(condition,body,loc)
}

for_stmt :: proc(bp: BindPower ) -> ^Node {

	loc := peek_clocalization() ; advance()

	_start     : ^Node
	_condition : ^Node
	_increment : ^Node
	_body      : ^Node
	_ibody     : ^Node
	 
	// for i < 0,10,1

	expect(.Identifier,"expected loop variable name after 'for'.")
	tk_var_name := peek_p()

	sucess,op := iteratoropcode(peek_ctype())
	if !sucess do error("expected '<','<=','>' or '>=' after variable name.")

	advance()
	container := create_container_node()
	args      := &container.elements

	// Nota(jstn): cria um escopo separado para variavel de iteração
	      begin_scope()
	defer end_scope()

	if has, ldata :=  scope_check_redeclaration_var(tk_var_name); has {
	     error("variable '",tk_var_name.text,"' has the same name as a previously declared",kind2string(ldata.kind)," at (",ldata.pos.line,",",ldata.pos.column,").")
	}
	
	scope_declare_var(tk_var_name,.ID,loc)
	
	// start
	_start = expression(bp)
	expect(.Comma,"expected ',' after initialization expression.")

	_condition = expression(bp)
	expect(.Comma,"expected ',' after condition.")

	_increment = expression(bp)
	skip_newline2(1)

	if !at(.Open_Brace) do error("expected closing '{' before block body.")
	
	//       begin_loop()
	// defer end_loop()

	_body   = block_stmt(bp,true)
	_ibody  = create_block_node(container,scope_get_local_count(),loc)
		
	slot : int
	scope_get_var_index(tk_var_name,&slot)
	
	inamedvar := create_named_node(tk_var_name.text,true,slot,loc)

	start     := create_assignment(tk_var_name.text,_start,true,slot,loc)
	condition := create_binary_node(inamedvar,_condition,op,loc)
	increment := create_assignment(tk_var_name.text,create_binary_node(inamedvar,_increment,.OP_ADD,loc),true,slot,loc)
	body      := _body
	ibody     := _ibody

	return create_for_node(start,condition,increment,body,ibody,loc)
}


match_stmt :: proc(bp: BindPower) -> ^Node {

	loc       := peek_clocalization() ; advance()	
	condition := expression(bp)

	skip_newline2(2)
	expect(.Open_Brace,"expected '{' before match statement.")
	
	if has_error() do return create_bad_node(peek_c(),loc)
	skip()

	condictions_container := create_container_node()
	condictions           := &condictions_container.elements

	cases_container       := create_container_node()
	cases                 := &cases_container.elements
	has_default           : bool

	ncases : int

	for !is_eof() && !has_error() && !at(.Close_Brace)
	{

		skip()

		if at(.Case)
		{
			ncases += 1
			if ncases > MAX_MATCH_CASE { error("too many match cases."); break }

			advance()

			if at(.Underscore)
			{
				advance()
				expect(.Colon,"expected ':' after '_' .")

				// Nota(jstn): ignoramos completamente casos extras de fallback
				if has_default do match_block_stmt(bp)
				else do append(cases,match_block_stmt(bp))
				
				has_default = true
				continue
			}

			condition := expression(bp)
			expect(.Colon,"expected ':' after case keyword.")

			append(condictions,condition)
			append(cases,match_block_stmt(bp))
		}
		else do error("'",peek_c().text,"' unexpected token was found in match stmt.")
	}


	expect(.Close_Brace,"expected '}' after match body.")
	return create_match_node(condition,condictions_container,cases_container,has_default,loc)
}


block_stmt :: proc(bp: BindPower, loop := false) -> ^Node {

	loc := peek_clocalization() ; advance()
	skip()

	// 
	container := create_container_node()
	args      := &container.elements

	//
		  begin_scope()
	defer end_scope()

	// Nota(jstn): registra como bloco de um loop.
	if       loop do begin_loop(scope_get_depth())
	defer if loop do end_loop()

	for !is_eof() && !has_error() && !at(.Close_Brace)
	{
		stmt_node := parse_stmt(bp)
		append(args,stmt_node)
	}

	expect(.Close_Brace,"expected closing '}' after block body.")
	return create_block_node(container,scope_get_local_count(),loc)
}


match_block_stmt :: proc(bp: BindPower) -> ^Node {

	loc := peek_clocalization()
	skip()

	// 
	container := create_container_node()
	args      := &container.elements
	has_brace : bool

	//
		  begin_scope()
	defer end_scope()

	for !is_eof() && !has_error() && !at(.Case) && !at(.Close_Brace)
	{
		stmt_node := parse_stmt(bp)
		append(args,stmt_node)
		skip()
	}

	return create_block_node(container,scope_get_local_count(),loc)
}


break_stmt :: proc(bp: BindPower) -> ^Node {
	loc := peek_clocalization() ; advance()
	if !is_loop() { error("cannot use 'break' outside of a loop."); return create_bad_node(peek_p(),loc)}
	return create_break_node(scope_get_local_count_from_depth(get_loop_scope_depth()),loc)
}

continue_stmt :: proc(bp: BindPower) -> ^Node {
	loc := peek_clocalization() ; advance()
	if !is_loop() { error("cannot use 'continue' outside of a loop."); return create_bad_node(peek_p(),loc)}
	return create_continue_node(scope_get_local_count_from_depth(get_loop_scope_depth()),loc)
}

return_stmt  :: proc(bp: BindPower) -> ^Node {

	loc := peek_clocalization(); advance()

	if !is_function() { error("you cannot use a return statement in the file scope."); return create_bad_node(peek_p(),loc)}

	// Nota(jstn): caso seja um init, então é um construtor
	// uma vez que só uma class tem essa prerrogativa de atribuir
	// um metodo init, então, presumimos que estamos dentro de
	// uma class
	if is_init_function() {
	
		if !is_stmt_end() { error("constructor cannot return a value."); return create_bad_node(peek_c(),loc) }

		slot    := -1
		tk_self := synthetic_token("self")
		
		scope_get_var_index(tk_self,&slot)

		local_count := scope_get_local_count_from_depth(0)
        return create_return_node(create_named_node(tk_self.text,true,slot,loc),local_count,loc)
	}

	rhs : ^Node
	if is_stmt_end() do rhs = create_literal_node(.OP_NIL,loc)
	else do             rhs = expression(bp)

	// Nota(jstn): remove até os argumentos
	// o id do escopo da função sempre será 0.
	local_count := scope_get_local_count_from_depth(0)
	return create_return_node(rhs,local_count,loc)
}
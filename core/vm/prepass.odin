#+private

package OScriptVM

prepass_call_type :: #type proc()


@(cold,private = "file")
_prepass :: proc "contextless" (type: TokenType, callable: prepass_call_type ) {
	cludata        := get_call_lookup_data(type)
	cludata.ppass   = callable
}

get_prepass_call :: proc "contextless" (type: TokenType ) -> (bool,prepass_call_type){
	cludata := get_call_lookup_data(type)
	ok      := cludata.ppass != nil
	return ok, cludata.ppass
}


@(optimization_mode="favor_size")
prepass :: proc()
{
	// 
	      tk_save_state(get_current_tkzr())
	defer tk_restore_state(get_current_tkzr())

	// start
	advance()
	skip()

	for !is_eof() && !has_error()
	{
		skip()
		if !check_compiler_permissions() do error("bad prepass token.")
		
		ok, ppass_stmt := get_prepass_call(peek_ctype())

		if ok 
		{
			ppass_stmt()
			
			if is_eof()    do break
			if has_error(){
				error(peek_c().text)
				break 
			}

			expect_terminator("expected newline or semicolan at end of statement.")
			skip()
			continue
		}

		error("bad prepass token. token not register. ", peek_c().text)
	}

	
}


register_prepass ::proc()
{
	_prepass(.Import,prepass_default)
	_prepass(.Set,prepass_default)
	_prepass(.Fn,prepass_fn)
	_prepass(.Class,prepass_class)
}

prepass_default :: proc() { skip3() }

prepass_fn  :: proc()
{

	advance(); 
	expect(.Identifier,"function name.")
	loc := peek_clocalization(); fn_name := peek_p()

	//Nota(jstn): registo, primeiro checa
	// se já foi declarada uma função com mesmo nome.
	if has, gdata :=  global_check_redeclaration_var(fn_name); has do error("function '",fn_name.text,"' has the same name as a previously declared",kind2string(gdata.kind)," at (",gdata.pos.line,",",gdata.pos.column,").")
	else do global_declare_function(fn_name,loc)


	arity       : int
	brace_count : int

	expect(.Open_Paren," expected '(' after function name.")

	for !is_eof() && !has_error() && !at(.Close_Paren) 
	{
		expect(.Identifier,"expected a parameter name.")
		skip_comma()

		arity += 1

		if arity > MAX_ARGUMENTS 
		{ 
			error("can't have more than ",MAX_ARGUMENTS," got ",arity,".")
			return
		}
	}

	expect(.Close_Paren," expected ')' after function parameters.")
	skip_newline2(1)

	expect(.Open_Brace," expected '{' after function parameters.")
	brace_count = 1



	for !is_eof() && !has_error() && !(brace_count <= 0)
	{	
		if at(.Open_Brace)  do brace_count += 1
		if at(.Close_Brace) do brace_count -= 1
		advance()
	}



	if brace_count > 0 do error("expected '}' after function body.")
}

prepass_class :: proc()
{

	loc := peek_clocalization(); advance()
	
	expect(.Identifier,"expected a class name.")
	class_name := peek_p()

	if at(.Extends)
	{   advance()
		expect(.Identifier,"expected superclass name after 'extends'.")
	}

	//Nota(jstn): registo, primeiro checa se já foi declarada uma função com mesmo nome.
	if has, gdata :=  global_check_redeclaration_var(class_name); has do error("class '",class_name.text,"' has the same name as a previously declared",kind2string(gdata.kind)," at (",gdata.pos.line,",", gdata.pos.column,").")
	else do global_declare_class(class_name,loc)

	skip_newline2(1)
	expect(.Open_Brace,"expected '{' after class name")

	brace_count : int
	brace_count = 1

	for !is_eof() && !has_error() && !(brace_count <= 0)
	{	
		if at(.Open_Brace)  do brace_count += 1
		if at(.Close_Brace) do brace_count -= 1
		advance()
	}

	if brace_count > 0 do error("expected '}' after function body.")
}
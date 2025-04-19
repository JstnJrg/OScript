#+private

package OScriptVM


/* Nota(Jstn) : esta função é onde a magica toda acontence, por favor, cuidado, saiba o que estas fazendo antes de fazer qualquer alteração */
@(optimization_mode="favor_size")
parse_stmt :: proc(bp : BindPower =.DEFAULT) -> ^Node {

	/* Nota(Jstn): skippa qualquer nova linha, afim de permitir que qualquer função abaixo trate qualquer token diferente de newline */
	skip(); loc := peek_clocalization() 

	if !check_compiler_permissions() do return create_bad_node(peek_c(),peek_clocalization())
	
	ok, stmt_calle := get_stmt_lu(peek_ctype())



	if ok 
	{
		stmt_node := stmt_calle(bp)
		if is_stmt_end2() { skip(); return create_stmt_node(stmt_node) } 
		if is_if()        { set_is_if(false); skip_semicolon(); skip(); return create_stmt_node(stmt_node) } //remove o bug dos if's consumirem paragrafos
		

		expect_terminator("expected newline or semicolan at end of statement.")
		skip()
		return create_stmt_node(stmt_node)
	}

	// expression handlers
	expr_node := expression(.DEFAULT)

	/*Nota(jstn): evita expressões com um termianador de expressões, caso seja  um e esteja em um bloco */	

	if is_stmt_end2() { skip(); return create_expr_node(expr_node,loc)  }
	expect_terminator("expected newline or semicolan at end of expression.")
	
	/*Nota(jstn): remove todas quebras desnecessarias afim de de que caso encontre EOF, então, sai do loop
	 prepara o proximo token diferente dos terminadores  */	
	skip()
	return create_expr_node(expr_node,loc)
}



@(optimization_mode="favor_size")
expression :: proc(bp :BindPower) -> ^Node 
{	
	loc           := peek_clocalization() 
	lookup_p      := get_current_lookup()
	type          := peek_ctype()
	ok,nud_callee := get_nud_lu(type)

	/* Nota(jstn): funções únarias a serem chamadas primeiro , tudo isso levando em conta o registro dos tokens */
	if !ok { error("expect a nud handler for \'",peek_c().text,"\'.");  return create_bad_node(peek_c(),loc) }
	left := nud_callee(bp)


	/* Nota(jstn): funções binarias a serem chamadas depois, tudo isso levando em conta o registro dos tokens */
	for !is_eof() && !has_error() 
	{
		type   = peek_ctype()
		lbp   := get_led_bp(type)

		if lbp > bp 
		{
			ok,led_callee := get_led_lu(type)
			
			if !ok 
			{ 
				led_tk := peek_c()
				loc     = peek_clocalization()
				error("expect a led handler for \'",led_tk.text,"\'.")
				return create_bad_node(led_tk,loc) 
			}

			left = led_callee(left,lbp)
		}
		else do break
	}

	return left
}
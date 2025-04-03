package OScriptVM


@(private="file")   current_parser    : ^psr
@(private="file")   current_tokenizer : ^tkzr






@(optimization_mode="favor_size")
compile :: proc(path: string) -> (bool,FunctionID)
{

	// Nota(jstn): carrega o script
	code_p,sucess := load_script(path)
	if !sucess do return false,-1

	set_current_tkzr(tk_create(compile_default_allocator()))
	tk_init(get_current_tkzr(),code_p,path)

	// Nota(jstn): parser
	set_current_psr(p_create(compile_default_allocator()))

	//Nota(jstn): lookup
	create_lookup()
	register_lookups()

	// Nota(jstn): codegen
		  create_codegen()
    defer destroy_codegen()

	//Nota(jstn): program
	create_program() 

	// start
	advance()
	skip()

	// Nota(jstn): registra o actual script como depencia
	// para evitar referencias ciclicas de scripts
	register_dependencies(path,peek_clocalization())


	// parse loop
	for !is_eof() && !has_error() {

		arena_temp := ast_arena_temp_begin()
		ast_node   := parse_stmt()
		if !has_error() do codegen_generate(ast_node)
		ast_arena_temp_end(arena_temp)
	}

	return end_current_program()
}









set_current_tkzr :: proc "contextless" (t: ^tkzr) { current_tokenizer = t }
set_current_psr  :: proc "contextless" (p: ^psr)  { current_parser    = p }

get_current_tkzr :: proc "contextless" () -> ^tkzr { return current_tokenizer }
get_current_psr  :: proc "contextless" () -> ^psr { return current_parser    }


destroy_tkzr    :: proc "contextless" () { current_tokenizer = nil }
destroy_psr     :: proc "contextless" () { current_parser = nil    }

at   			:: proc(type: TokenType) -> bool { return p_at(get_current_psr(),type) }
at_p 			:: proc(type: TokenType) -> bool { return p_at_previous(get_current_psr(),type)}
is_eof 			:: proc() -> bool 	{ return p_is_eof(get_current_psr())}
is_stmt_end 	:: proc() -> bool   { if at(.Newline) || at(.Semicolon) || at(.EOF) || at(.Close_Brace) do return true; else do return false}
is_stmt_end2    :: proc() -> bool   { return at(.Close_Brace) ? true:false }

skip_semicolon	:: proc() 			{ p_skip_semicolon(get_current_psr(),get_current_tkzr())   }
skip_comma	    :: proc() 			{ if at(.Comma) do advance()   }

skip_newline2   :: proc(count: int )           { for i in 0..<count do if at(.Newline) do advance() }
skip            :: proc()			{ p_skip(get_current_psr(),get_current_tkzr()) }
has_error		:: proc() -> bool 	{ return p_has_error(get_current_psr()) }
skip2           :: proc() { for at(.Semicolon) || at(.Newline) do advance()}



advance         :: proc() -> bool   { return p_advance(get_current_psr(),get_current_tkzr())}
unreachable     :: proc() { oscript_assert_mode(false);assert(false,"unreachable")}

set_is_if       :: proc(on: bool) { get_current_compiler().is_if = on}
is_if           :: proc() -> bool { return get_current_compiler().is_if } 

peek_c          :: proc() -> Token  { return p_peek_current (get_current_psr())}
peek_p          :: proc() -> Token  { return p_peek_previous(get_current_psr())}

peek_ctype      :: proc() -> TokenType { return p_peek_ctype(get_current_psr()) }
peek_ptype      :: proc() -> TokenType { return p_peek_ptype(get_current_psr()) }

expect          :: proc(type: TokenType, msg: string )    { if !p_expected(get_current_psr(),get_current_tkzr(),type) do error(msg)          }
expect_p        :: proc(type: TokenType, msg: string )    { if !p_expected_previous(get_current_psr(),get_current_tkzr(),type) do error(msg) }


expect_terminator 	:: proc(message: string) 
{ 
	if at(.Newline) || at(.Semicolon) { advance(); return } 
	else if at(.EOF) do return
	error(message)
}

peek_clocalization :: proc() -> Localization { 

	// Nota(jstn): como queremos acessar esse dado até ao tempo de execução,
	// então, precisamos preserverar esse dado, pois depois do tempo de compilação, 
	// a região file do Localization é invalida

	@static current_path := ""
	loc                  := peek_c().pos
	if current_path      != get_current_tkzr().path do current_path,_  = clone_s(loc.file,runtime_default_allocator())

	loc.file             = current_path
	return loc 
}





assignmetopcode :: proc(t : TokenType ) -> (bool,Opcode) {

	opcode : Opcode = .OP_MAX

    #partial switch t {
	case .Add_Eq			: opcode = .OP_ADD
	case .Sub_Eq			: opcode = .OP_SUB
	case .Mult_Eq			: opcode = .OP_MULT
	case .Quo_Eq			: opcode = .OP_DIV
	case .Mod_Eq			: opcode = .OP_MOD
	case .And_Bit_Eq	 	: opcode = .OP_BIT_AND
	case .Or_Bit_Eq		  	: opcode = .OP_BIT_OR
	case .Xor_Bit_Eq		: opcode = .OP_BIT_XOR
	case .Shift_L_Bit_Eq  	: opcode = .OP_SHIFT_LEFT
	case .Shift_R_Bit_Eq  	: opcode = .OP_SHIFT_RIGHT
    }
	return opcode != .OP_MAX, opcode
}



iteratoropcode :: proc(t : TokenType ) -> (bool,Opcode) {
	opcode : Opcode = .OP_MAX

    #partial switch t {
	case .Less			    : opcode = .OP_LESS
	case .Less_Eq			: opcode = .OP_LESS_EQUAL
	case .Greater			: opcode = .OP_GREATER
	case .Greater_Eq		: opcode = .OP_GREATER_EQUAL
    }
	return opcode != .OP_MAX, opcode
}


check_compiler_permissions :: proc() -> bool
{
	if !is_global_scope() do return true
	#partial switch peek_ctype() { case .Import, .Fn, .Set, .Class: return true }

	error("expected token was found in filescope.")
	return false
}


error 			:: proc(args: ..any) {
	
	if get_current_psr().panic_mode do return

	   get_current_psr().panic_mode = true
	   get_current_psr().has_error = true

	localization := peek_c().pos
	print("[COMPILE: ",localization.file,"] Error ","(",localization.line,",",localization.column,") --> ")
	println(..args)
	
}

mute_error :: proc() {
	
	if get_current_psr().panic_mode do return
	   get_current_psr().panic_mode = true
	   get_current_psr().has_error = true	
}

synthetic_token 	:: proc(value: string) -> Token { t: Token; t.pos = peek_clocalization() ; t.text = value; return t  }
token_str_cmp       :: proc(a: ^Token,str: string) -> bool { return a.text == str}




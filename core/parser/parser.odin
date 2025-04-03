package OScriptParser

import mem       "core:mem"
import tokenizer "oscript:tokenizer"


Tokenizer       :: tokenizer.Tokenizer
Token      		:: tokenizer.Token
TokenType  		:: tokenizer.TokenType
Lolalization 	:: tokenizer.Localization
Allocator       :: mem.Allocator


Parser :: struct 
{
	previous_token: Token,
	current_token : Token,
	error_str     : string,
	has_error     : bool,
	panic_mode    : bool
}


create  	:: proc(alloator: Allocator) -> ^Parser { return new(Parser,alloator)}
destroy 	:: proc(p: ^Parser) { free(p) }

has_error	:: proc(p: ^Parser) -> bool { return p.has_error }

at 			:: proc(p: ^Parser,type: TokenType) -> bool { return p.current_token.type == type }
at_previous :: proc(p: ^Parser,type: TokenType) -> bool { return p.previous_token.type == type }

is_eof 		   :: proc(p: ^Parser) -> bool { return p.current_token.type == .EOF }
skip 		   :: proc(p: ^Parser,t: ^Tokenizer) { for at(p,.Newline) do advance(p,t)  }
skip_semicolon :: proc(p: ^Parser,t: ^Tokenizer) { if  at(p,.Semicolon) do advance(p,t) }

advance 	:: proc(p: ^Parser,t: ^Tokenizer) -> (sucess: bool) {
	
	p.previous_token = p.current_token

	for	{
		tk := tokenizer.scan(t) ; p.current_token = tk
		if p.current_token.type != .Error { sucess = true ; break}
		p.error_str = tk.text 
		break
	}

	return
}

expected	:: proc(p: ^Parser,t: ^Tokenizer,type: TokenType) -> (sucess: bool) {
	if  peek_current(p).type  == type { advance(p,t); sucess = true; return }
	return 
}

expected_previous	:: proc(p: ^Parser,t: ^Tokenizer,type: TokenType) -> (sucess: bool) { 
	if peek_previous(p).type  == type { advance(p,t); sucess = true; return }
	return 
}

peek_previous 		:: proc(p: ^Parser) -> Token { return p.previous_token }
peek_current 		:: proc(p: ^Parser) -> Token { return p.current_token  }

peek_current_type 	:: proc(p: ^Parser) -> TokenType { return  peek_current(p).type }
peek_previous_type 	:: proc(p: ^Parser) -> TokenType { return peek_previous(p).type }

// reset_error         :: proc(p: ^Pa)
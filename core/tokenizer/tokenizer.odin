package OScriptTokenizer

import utf8string "core:unicode/utf8/utf8string"
import unicode    "core:unicode"
import strings 	  "core:strings"
import mem        "core:mem"
import fmt        "core:fmt"

import types      "oscript:types"

Int               :: types.Int
OScriptTerminator :: `EOF`

Tokenizer 	:: struct {
	path: string,
	src : 			strings.Builder,
	bf 	: 			utf8string.String,
	len : 			Int,
	offset_start  : Int,
	offset_current: Int,
	line  : 		Int,
	column: 		Int,
	t_state:        TokenizerState,
	allocator:      mem.Allocator 
}


// Nota(jstn): útil somente para o pré-pass
TokenizerState :: struct {
	offset_start   : Int,
	offset_current : Int,
	line           : Int,
	column         : Int
}

create   :: proc(alloc: mem.Allocator ) -> ^Tokenizer { t := new(Tokenizer,alloc); bf, _ := strings.builder_make_none(alloc); t.src = bf; t.allocator = alloc ; return t }
destroy  :: proc(t: ^Tokenizer){ strings.builder_destroy(&t.src) }

save_state :: proc(t: ^Tokenizer) {

	state := &t.t_state
	state.offset_start   = t.offset_start
	state.offset_current = t.offset_current
	state.line           = t.line
	state.column         = t.column
}

restore_state :: proc(t: ^Tokenizer) {
	
	state := &t.t_state
	t.offset_start   = state.offset_start
	t.offset_current = state.offset_current
	t.line           = state.line
	t.column         = state.column
}



init     :: proc(t: ^Tokenizer,src: string, path : string) {
	
	strings.write_string(&t.src,src)
	strings.write_string(&t.src,OScriptTerminator)

	utf8string.init(&t.bf,strings.to_string(t.src))

	t.path 		     = path
	t.len  		     = utf8string.len(&t.bf)-len(OScriptTerminator)
	t.line   		 = t.len > 0 ? 1:0
	t.column 		 = t.len > 0 ? 1:0
}

scan :: proc(t: ^Tokenizer) -> Token {

	
	skip_whitespace(t)
	skip_comment(t)

	if is_eof(t) do return create_eof_token(t)

	switch at(t) {

		case '0'..='9': 			return scan_number(t)
		case 'a'..='z','A'..='Z':	return scan_identifier(t)
		case '_':  					return scan_underscore(t)
		case '"': 					return scan_string(t)

		case '\n': 

			eat(t)
			token := create_token(t,.Newline); same(t)
			t.line   += 1
			t.column  = 0
			return token

		case '+':

			eat(t)
			
			c_rune := at(t)
			token  : Token

			if      c_rune == '=' { eat(t); token = create_token(t,.Add_Eq) }
			else do token = create_token(t,.Add)

			same(t)
			return token

		case '-':

			eat(t)
			c_rune := at(t)
			token  : Token

			if 		c_rune == '=' { eat(t); token = create_token(t,.Sub_Eq) }
			else do token = create_token(t,.Sub)

			same(t)
			return token

		case '*':

			eat(t)
			c_rune := at(t)
			token: Token

			if c_rune == '=' { eat(t); token = create_token(t,.Mult_Eq) }
			else if c_rune == '*' { eat(t); token = create_token(t,.Mult_Mult) }
			else do token = create_token(t,.Mult)

			same(t)
			return token

		case '/':

			eat(t)
			c_rune := at(t)
			token: Token

			if 		c_rune == '=' { eat(t); token = create_token(t,.Quo_Eq) }
			else do token = create_token(t,.Quo)

			same(t)
			return token

		case '%':

			eat(t)
			c_rune := at(t)
			token: Token

			if c_rune == '=' { eat(t); token = create_token(t,.Mod_Eq)	}
			else do token = create_token(t,.Mod)

			same(t)
			return token


		case '&':

			eat(t)
			c_rune := at(t)
			token: Token

			if 		c_rune == '=' { eat(t);token = create_token(t,.And_Bit_Eq)}
			else if c_rune == '&' { eat(t);token = create_token(t,.And)}
			else do token = create_token(t,.And_Bit)

			same(t)
			return token

		case '|':

			eat(t)
			c_rune := at(t)
			token: Token

			if 		c_rune == '=' { eat(t);token = create_token(t,.Or_Bit_Eq)}
			else if c_rune == '|' { eat(t);token = create_token(t,.Or)}
			else do token = create_token(t,.Or_Bit)

			same(t)
			return token

		case '~':

			eat(t)
			c_rune := at(t)
			token  := create_token(t,.Not_Bit)

			same(t)
			return token

		case '^':

			eat(t)
			c_rune := at(t)
			token: Token

			if 		c_rune == '=' { eat(t);token = create_token(t,.Xor_Bit_Eq)}
			else do token = create_token(t,.Xor_Bit)

			same(t)
			return token

		
		case '<':
			
			eat(t)
			c_rune := at(t)
			token: Token

			if 		c_rune == '=' { eat(t); token = create_token(t,.Less_Eq) }
			else if c_rune == '<' { 
				eat(t) 
				if at(t) == '=' { eat(t); token = create_token(t,.Shift_L_Bit_Eq) }
				else do token = create_token(t,.Shift_L_Bit)
			}
			else do token = create_token(t,.Less)

			same(t)
			return token

	 	case '>':
			
			eat(t)
			c_rune := at(t)
			token: Token

			if 		c_rune == '=' { eat(t); token = create_token(t,.Greater_Eq) }
			else if c_rune == '>' {
				eat(t) 
				if at(t) == '=' { eat(t); token = create_token(t,.Shift_R_Bit_Eq) }
				else do token = create_token(t,.Shift_R_Bit)
			}
			else do token = create_token(t,.Greater)
		
			same(t)
			return token

	 	case '!':
			
			eat(t)
			c_rune := at(t)
			token: Token

			if 		c_rune == '=' { eat(t); token = create_token(t,.Not_Eq) }
			else do token = create_token(t,.Not)
		
			same(t)
			return token

	 	case '=':
			
			eat(t)
			c_rune := at(t)
			token: Token

			if c_rune == '=' { eat(t); token = create_token(t,.Equal_Eq) }
			else do token = create_token(t,.Equal)
			
			same(t)
			return token
	 	
	 	case '.':
			
			eat(t)
			c_rune := at(t)
			token: Token

			if c_rune == '.' { eat(t); token = create_token(t,.Dot_Dot) }
			else do token = create_token(t,.Dot)

			same(t)
			return token

	 	case ';':
	 		eat(t)
	 		token := create_token(t,.Semicolon)
	 		same(t)
	 		return token

	 	case ':':
	 		eat(t)
	 		token := create_token(t,.Colon)
	 		same(t)
	 		return token

	 	case '?':
	 		eat(t)
	 		token := create_token(t,.Question)
	 		same(t)
	 		return token
	 	
	 	case ',':
	 		eat(t)
	 		token := create_token(t,.Comma)
	 		same(t)
	 		return token

	 	case '{':
	 		eat(t)
	 		token := create_token(t,.Open_Brace)
	 		same(t)
	 		return token

		case '}':
			eat(t)
	 		token := create_token(t,.Close_Brace)
	 		same(t)
	 		return token

	 	case '[':
	 		eat(t)
	 		token := create_token(t,.Open_Bracket)
	 		same(t)
	 		return token

	 	case ']':
	 		eat(t)
	 		token := create_token(t,.Close_Bracket)
	 		same(t)
	 		return token
			
	 	case '(':
	 		eat(t)
	 		token := create_token(t,.Open_Paren)
	 		same(t)
	 		return token

	 	case ')':
	 		eat(t)
	 		token := create_token(t,.Close_Paren)
	 		same(t)
	 		return token	


	}

	fmt.println(at(t))
	return create_error_token(t,"unexpected character was found.")

}


create_token 	 :: proc(t: ^Tokenizer,type: TokenType ) -> (token: Token) {
	token.type 		= type
	token.text 		= at_slice(t)
	token.pos		= {t.path,t.line,t.column,t.offset_current}
	return
}

create_string_token 	 :: proc(t: ^Tokenizer,data: string ) -> (token: Token) {
	token.type 		= .String
	token.text 		= data
	token.pos		= {t.path,t.line,t.column,t.offset_current}
	return
}


create_token_offset :: proc(t: ^Tokenizer,type: TokenType,a,b: Int) -> (token: Token) {
	token.type 		= type
	token.text 		= utf8string.slice(&t.bf,a,b)
	token.pos		= {t.path,t.line,t.column,t.offset_current}
	return
}

synthetic_token 	:: proc(value: string) -> Token { t: Token; t.text = value; return t  }
token_equals 		:: proc(t : ^Token, s: string) -> bool { return t.text == s }


create_eof_token :: proc(t: ^Tokenizer) -> (token: Token) {
	token.type 		= .EOF
	token.text 		= "EOF"
	token.pos		= {t.path,t.line,t.column,t.offset_current}
	return
}

create_error_token :: proc(t: ^Tokenizer,message : string) -> (token: Token){
	token.type 		= .Error
	token.text 		= message
	token.pos		= {t.path,t.line,t.column,t.offset_current}
	return
}

at  	  :: proc(t: ^Tokenizer) -> rune { return utf8string.at(&t.bf,t.offset_current)}

at_next   :: proc(t: ^Tokenizer) -> rune { return utf8string.at(&t.bf,t.offset_current+1)}

eat 	  :: proc(t: ^Tokenizer) {	t.offset_current +=1; t.column +=1 }

at_slice  :: proc(t: ^Tokenizer) -> string { return utf8string.slice(&t.bf,t.offset_start,t.offset_current) }

same      :: proc(t: ^Tokenizer) { t.offset_start = t.offset_current }

is_eof    :: proc(t: ^Tokenizer) -> bool { return t.offset_current >= t.len }



skip_whitespace :: proc(t: ^Tokenizer) {
	
	loop: for
	{
		if is_eof(t) do break loop
		switch at(t) 
		{ 
			case '\t','\r','\v',' ','\f':  eat(t)
			case : break loop
		}
	}
	
	same(t)
}

skip_comment :: proc(t: ^Tokenizer) { if at(t) != '#' do return; for !is_eof(t) && at(t) != '\n' do eat(t); same(t)	}

scan_number :: proc(t: ^Tokenizer) -> (token: Token) {

	is_float : b8 

	for  unicode.is_digit(at(t)) do eat(t)
	
	if at(t) == '_' &&  unicode.is_digit(at_next(t)) {
		eat(t)
		for  unicode.is_digit(at(t)) { eat(t); if at(t) == '_' &&  unicode.is_digit(at_next(t)) do eat(t)} 
	}

	if at(t) == '.' &&  unicode.is_digit(at_next(t)) { 
		eat(t)
		is_float = true
		for  unicode.is_digit(at(t)) { eat(t); if at(t) == '_' &&  unicode.is_digit(at_next(t)) do eat(t)}  
	}
		
	token = create_token(t, is_float? .Float:.Int)
	same(t)
	return
}

scan_identifier :: proc(t: ^Tokenizer) -> (token: Token)
{
	for !is_eof(t) && unicode.is_letter(at(t)) 
	{
		eat(t)
		c_rune := at(t)
		for unicode.is_digit(c_rune) || c_rune == '_' { eat(t); c_rune = at(t) }
	}

	kind,ok := keywoords[at_slice(t)]
	token = create_token(t,kind if ok else .Identifier)
	same(t)
	return
}

scan_underscore :: proc(t: ^Tokenizer) -> (token: Token)
{
	eat(t)
	// number_sucess : bool
	letter_sucess : b8
	is_underscore : b8
	nunderscore   : int

	for !is_eof(t) 
	{
		c_rune  := at(t)
		if 		unicode.is_letter(c_rune) { token = scan_identifier(t); return }
		else if c_rune == '_' { nunderscore += 1}
		else if nunderscore <= 0 && !letter_sucess { is_underscore = true; break }
		else do break

		eat(t)
	}

	if is_underscore {
		token = create_token(t,.Underscore)
		same(t)
		return
	}

	if !letter_sucess {
		token = create_error_token(t,"unexpected character was found in identifier.")
		same(t)
		return
	}	


	token = create_token(t,.Identifier)
	same(t)
	return
}

scan_string :: proc(t: ^Tokenizer) -> (token: Token)
{
	eat(t)
	same(t)

	buffer, _ := strings.builder_make_none(t.allocator)

	for !is_eof(t) && at(t) != '"' {

		r := at(t); 
		eat(t)

		if r == '\\' 
		{
			switch at(t)
			{
				case '"'  : strings.write_rune(&buffer,'"')    ; eat(t); continue
				case '\\' : strings.write_rune(&buffer,'\\')   ; eat(t); continue
				case '0'  : strings.write_rune(&buffer,'\x00') ; eat(t); continue				
				case 'a'  : strings.write_rune(&buffer,'\a')   ; eat(t); continue
				case 'b'  : strings.write_rune(&buffer,'\b')   ; eat(t); continue
				case 'e'  : strings.write_rune(&buffer,'\x1b') ; eat(t); continue
				case 'n'  : strings.write_rune(&buffer,'\n')   ; eat(t); continue
 				case 'f'  : strings.write_rune(&buffer,'\f')   ; eat(t); continue
 				case 'r'  : strings.write_rune(&buffer,'\r')   ; eat(t); continue
 				case 't'  : strings.write_rune(&buffer,'\t')   ; eat(t); continue
				case 'v'  : strings.write_rune(&buffer,'\v')   ; eat(t); continue
				case '%'  : strings.write_rune(&buffer,'%')    ; eat(t); continue
				case      :
					token = create_error_token(t,"invalid escape character.")
					return
			}
		}

		strings.write_rune(&buffer,r)
	}

	if at(t) == '"'	{ token = create_string_token(t,strings.to_string(buffer)); eat(t); return }
	 token = create_error_token(t,"unterminated string.")
	return
}


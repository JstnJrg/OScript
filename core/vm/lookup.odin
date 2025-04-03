package OScriptVM


BindPower :: distinct enum u8 {
	DEFAULT,
	COMMA,
	ASSIGNMENT,
	LOGICAL,
	RELATIONAL,
	ADDITIVE,
	MULTIPLICATIVE,
	UNARY,
	CALL,
	MEMBER,
	INDEXING,
	PRIMARY
}

Lookup :: struct {
	bp_map  	: bp_lu,
	bp_led_map	: bp_lu,
	nud_map 	: nu_lu,
	led_map 	: led_lu,
	stmt_map	: stmt_lu
}

call_nud 	:: #type proc(bp : BindPower) -> ^Node
call_led 	:: #type proc(left: ^Node,bp : BindPower) -> ^Node
call_stmt  	:: #type proc(bp : BindPower) -> ^Node

@(private = "file") bp_lu 	:: map[TokenType]BindPower
@(private = "file") nu_lu 	:: map[TokenType]call_nud
@(private = "file") led_lu 	:: map[TokenType]call_led
@(private = "file") stmt_lu :: map[TokenType]call_stmt

@(private = "file") current_lookup : ^Lookup = nil



@(cold,private = "file")
led :: proc(type: TokenType, power : BindPower ,callable: call_led) {
	current_lookup.bp_map[type] = power
	current_lookup.bp_led_map[type] = power
	current_lookup.led_map[type] = callable
}

@(cold,private = "file")
nud :: proc(type: TokenType,callable: call_nud) {
	current_lookup.bp_map[type] = .PRIMARY
	current_lookup.nud_map[type] = callable
}

@(cold,private = "file")
stmt :: proc(type: TokenType,callable: call_stmt) {
	current_lookup.bp_map[type] = .DEFAULT
	current_lookup.stmt_map[type] = callable
}


// lookup_allow_block     :: proc() { stmt(.Open_Brace,block_stmt) }
// lookup_not_allow_block :: proc() { delete_key(&current_lookup.bp_map,.Open_Brace); delete_key(&current_lookup.stmt_map,.Open_Brace) }



create_lookup 	   :: proc() { 
	current_lookup 				= new(Lookup,  compile_default_allocator()) 
	current_lookup.bp_map 		= make(bp_lu,  compile_default_allocator())
	current_lookup.bp_led_map   = make(bp_lu,  compile_default_allocator())
	current_lookup.nud_map      = make(nu_lu,  compile_default_allocator())
	current_lookup.led_map      = make(led_lu, compile_default_allocator())
	current_lookup.stmt_map     = make(stmt_lu,compile_default_allocator())
}

get_current_lookup :: proc() -> ^Lookup { return current_lookup }
destroy_lookup 	   :: proc() { 	current_lookup = nil }

@(cold)
register_lookups 	:: proc()
{

	//PRIMARY
	nud(.True,primary)
	nud(.False,primary)
	nud(.Null,primary)
	nud(.Int,primary)
	nud(.Float,primary)
	nud(.String,primary)

	// IDENTIFIER
	nud(.Identifier,identifier)
	// nud(.New,_new)

	//UNARY
	nud(.Sub,    unary) 
	nud(.Add,    unary) 
	nud(.Not,    unary) 
	nud(.Not_Bit,unary) 

	// BIT
	led(.And_Bit,    .MULTIPLICATIVE,binary)
	led(.Or_Bit,     .MULTIPLICATIVE,binary)
	led(.Xor_Bit,    .MULTIPLICATIVE,binary)
	led(.Shift_L_Bit,.MULTIPLICATIVE,binary)
	led(.Shift_R_Bit,.MULTIPLICATIVE,binary)



	//ADDITIVE E MULTIPLICATIVE
	led(.Add,.ADDITIVE,binary)
	led(.Sub,.ADDITIVE,binary)

	led(.Mult,.MULTIPLICATIVE,binary)
	led(.Mult_Mult,.MULTIPLICATIVE,binary)
	led(.Mod,.MULTIPLICATIVE,binary)
	led(.Quo,.MULTIPLICATIVE,binary)

	// GROUP
	nud(.Open_Paren,group)

	// RELATIONAL
	led(.Equal_Eq,.RELATIONAL,binary)
	led(.Less,.RELATIONAL,binary)
	led(.Greater,.RELATIONAL,binary)
	led(.Not_Eq,.RELATIONAL,binary)
	led(.Less_Eq,.RELATIONAL,binary)
	led(.Greater_Eq,.RELATIONAL,binary)

	// // TERNARY
	// led(.If,.LOGICAL,binary)

	// // LOGICAL
	led(.Or,.LOGICAL,binary)
	led(.And,.LOGICAL,binary)


	// // // ASSIGNMENT
	led(.Equal,.ASSIGNMENT,assignment)

	led(.Add_Eq,.ASSIGNMENT,assignment2)
	led(.Sub_Eq,.ASSIGNMENT,assignment2)
	led(.Mult_Eq,.ASSIGNMENT,assignment2)
	led(.Quo_Eq,.ASSIGNMENT,assignment2)
	led(.Mod_Eq,.ASSIGNMENT,assignment2)

	led(.And_Bit_Eq,.ASSIGNMENT,assignment2)
	led(.Or_Bit_Eq,.ASSIGNMENT,assignment2)
	led(.Shift_R_Bit_Eq,.ASSIGNMENT,assignment2)
	led(.Shift_L_Bit_Eq,.ASSIGNMENT,assignment2)

	// CALL
	led(.Open_Paren,.CALL,call)


	// // NEW
	// led(.New,.CALL,_new)

	// // MEMBER
	led(.Dot,.MEMBER,member)

	// // // VECTOR2D
	// nud(.Vector2D,vector)
	// nud(.Rect2D,rect)
	// nud(.Color,color)
	// nud(.Transform2D,transform)


	// // ARRAY
	// nud(.Open_Bracket,array)

	// // // INDEXING
	led(.Open_Bracket,.INDEXING,indexing)


	// SELF & SUPER && OTHERS
	nud(.Self,self)
	nud(.Vector2,vector)
	nud(.Open_Bracket,array)
	nud(.Transform2,transform2)
	nud(.Color,color)
	nud(.Rect2,rect2)
	// // nud(.Super,super)

	
	// // // STMT
	stmt(.Import,import_stmt)
	stmt(.Fn,fn_stmt)
	stmt(.Class,class_stmt)
	stmt(.Set,set_stmt)
	stmt(.If,if_stmt)
	stmt(.Print,print_stmt)
	stmt(.While,while_stmt)
	stmt(.For,for_stmt)
	stmt(.Match,match_stmt)
	// stmt(.Assert,assert_stmt)
	// stmt(.Do,do_while_stmt)
	stmt(.Break,break_stmt)
	stmt(.Continue,continue_stmt)
	stmt(.Return,return_stmt)
	

}


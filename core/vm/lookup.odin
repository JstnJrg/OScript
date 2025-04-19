#+private -file

package OScriptVM

BindPower :: distinct enum u8 
{
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

Lookup         :: struct { lu_map : [TokenType]CallLookUpData }

CallLookUpData :: struct 
{
	nud   : call_nud,
	led   : call_led,
	stmt  : call_stmt,
	ppass : prepass_call_type,
	bp    : BindPower,
	lbp   : BindPower
}

call_nud 	:: #type proc(bp   : BindPower) -> ^Node
call_led 	:: #type proc(left : ^Node,bp : BindPower) -> ^Node
call_stmt  	:: #type proc(bp   : BindPower) -> ^Node


@(private = "file") current_lookup : ^Lookup = nil


@(cold,private = "file")
led :: proc "contextless" (type: TokenType, power : BindPower ,callable: call_led) {
	cludata      := &current_lookup.lu_map[type]
	cludata.lbp   = power
	cludata.led   = callable
}

@(cold,private = "file")
nud :: proc "contextless" (type: TokenType,callable: call_nud) {
	cludata     := &current_lookup.lu_map[type]
	cludata.bp   = .PRIMARY
	cludata.nud  = callable
}

@(cold,private = "file")
stmt :: proc "contextless" (type: TokenType,callable: call_stmt) {
	cludata      := &current_lookup.lu_map[type]
	cludata.bp    = .DEFAULT
	cludata.stmt  = callable
}

get_stmt_lu :: proc "contextless" (type: TokenType ) -> (bool,call_stmt){
	lu_data := &get_current_lookup().lu_map[type]
	ok      := lu_data.stmt != nil
	return ok, lu_data.stmt
}

get_nud_lu :: proc "contextless" (type: TokenType ) -> (bool,call_nud){
	lu_data := &get_current_lookup().lu_map[type]
	ok      := lu_data.nud != nil
	return ok, lu_data.nud
}

get_led_lu :: proc "contextless" (type: TokenType ) -> (bool,call_led){
	lu_data := &get_current_lookup().lu_map[type]
	ok      := lu_data.led != nil   
	return ok, lu_data.led
}

get_led_bp :: proc "contextless" (type: TokenType ) -> BindPower {
	lu_data := &get_current_lookup().lu_map[type]
	return lu_data.lbp
}


get_call_lookup_data :: proc "contextless" (type: TokenType) -> ^CallLookUpData {
	return &current_lookup.lu_map[type]
}


@(cold,private)
create_lookup :: proc () { current_lookup = new(Lookup,  compile_default_allocator()) }

@(cold,private)
get_current_lookup :: proc "contextless" () -> ^Lookup { return current_lookup }

@(cold,private)
destroy_lookup 	   :: proc "contextless" () { 	current_lookup = nil }

@(cold,private)
register_lookups 	:: proc()
{
	//PRIMARY
	nud(.True,  primary)
	nud(.False, primary)
	nud(.Null,  primary)
	nud(.Int,   primary)
	nud(.Float, primary)
	nud(.String,primary)

	// IDENTIFIER
	nud(.Identifier,identifier)

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

	led(.Mult,     .MULTIPLICATIVE,binary)
	led(.Mult_Mult,.MULTIPLICATIVE,binary)
	led(.Mod,      .MULTIPLICATIVE,binary)
	led(.Quo,      .MULTIPLICATIVE,binary)

	// GROUP
	nud(.Open_Paren,group)

	// RELATIONAL
	led(.Equal_Eq,  .RELATIONAL,binary)
	led(.Less,      .RELATIONAL,binary)
	led(.Greater,   .RELATIONAL,binary)
	led(.Not_Eq,    .RELATIONAL,binary)
	led(.Less_Eq,   .RELATIONAL,binary)
	led(.Greater_Eq,.RELATIONAL,binary)

	// TERNARY
	led(.If,.LOGICAL,ternary)

	// LOGICAL
	led(.Or, .LOGICAL,binary)
	led(.And,.LOGICAL,binary)

	// ASSIGNMENT
	led(.Equal,.ASSIGNMENT,assignment)

	led(.Add_Eq, .ASSIGNMENT,assignment2)
	led(.Sub_Eq, .ASSIGNMENT,assignment2)
	led(.Mult_Eq,.ASSIGNMENT,assignment2)
	led(.Quo_Eq, .ASSIGNMENT,assignment2)
	led(.Mod_Eq, .ASSIGNMENT,assignment2)

	led(.And_Bit_Eq,     .ASSIGNMENT,assignment2)
	led(.Or_Bit_Eq,      .ASSIGNMENT,assignment2)
	led(.Shift_R_Bit_Eq, .ASSIGNMENT,assignment2)
	led(.Shift_L_Bit_Eq, .ASSIGNMENT,assignment2)

	// CALL
	led(.Open_Paren,.CALL,call)

	// MEMBER
	led(.Dot,.MEMBER,member)

	// INDEXING
	led(.Open_Bracket,.INDEXING,indexing)

	// SELF & SUPER & OTHERS
	nud(.Self,self)
	nud(.Vector2,vector)
	nud(.Open_Bracket,array)
	nud(.Transform2,transform2)
	nud(.Color,color)
	nud(.Rect2,rect2)
	
	// STMT
	stmt(.Import,import_stmt)
	stmt(.Fn,fn_stmt)
	stmt(.Class,class_stmt)
	stmt(.Set,set_stmt)
	stmt(.If,if_stmt)
	stmt(.Print,print_stmt)
	stmt(.While,while_stmt)
	stmt(.For,for_stmt)
	stmt(.Match,match_stmt)
	stmt(.Break,break_stmt)
	stmt(.Continue,continue_stmt)
	stmt(.Return,return_stmt)
}


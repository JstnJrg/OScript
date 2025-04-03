package  OScriptAst

AstType :: enum u8 {

	NONE,
	PROGRAM,
	IMPORT,
	FUNCTION,
	CLASS,
	BLOCK,

	// 
	ERROR,

	// 
	STATEMENT,
	EXPRESSION,

	// 
	LITERAL,
	FLOAT,
	INT,
	STRING,
	ARRAY,
	VECTOR, // qualquer
	COLOR,
	RECT,  // qualquer
	TRANSFORM, // qualquer

	// 
	GROUP,
	UNARY,
	BINARY,
	LOGICAL,

	SETVAR,
	// SETLOCALVAR,

	NAMEDVAR,
	NAMEDLOCAVAR,
	OBJECTOPERATOR,

	ASSIGNMENT,
	MEMBER,
	TERNARY,

	BOCK,
	CONTAINER,

	CALL,
	IF,
	WHILE,
	MATCH,
	FOR,
	BREAK,
	CONTINUE,
	NEW,
	SET_PROPERTY,
	GET_PROPERTY,
	CALL_METHOD,

	ASSERT,
	// LOGICAL,
	RETURN,

	PRINT,
	SELF
}




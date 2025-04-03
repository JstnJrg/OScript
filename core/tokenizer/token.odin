#+feature dynamic-literals

package OScriptTokenizer

TokenMetaData  :: enum u8 
{
   INT,
   FLOAT
}

Token :: struct {
    type       : TokenType,
    text       : string,
    pos		   : Localization
}

Localization :: struct{
	file  : string, // esse dado prevalece até ao runtime, então é inseguro, pois posso estar acessando uma região já
	line  : 	int,   // invalida, que durou apenas até ao tempo de compilação.
	column: int,
	offset: int, 
}

TokenType 	 :: enum u8 {
   
   Begin, //
   Error,
   EOF,
   Underscore,
   Comment,

   Int,
   Float,
   String,
   Identifier,

    Equal,      // =
    Not,        // !
    Hash,       // #
    At,         // @
    Dollar,     // $
    Question,   // ?
    Add,        // +
    Sub,        // -
    Mult,       // *
    Quo,        // /
    Mod,        // %

    Mult_Mult, // **

    And_Bit,    // &
    Or_Bit,     // |
    Xor_Bit,    // ^
    And_Not_Bit,// &~
    Shift_L_Bit,// <<
    Shift_R_Bit,// >>

    And,        // and,&&
    Or,         // or,||
    Not_Literal,// Not

    Add_Eq,     // +=
    Sub_Eq,     // -=
    Mult_Eq,    // *=
    Quo_Eq,     // /=
    Mod_Eq,     // %=

    And_Bit_Eq, // &=
    Or_Bit_Eq,  // |=
    Not_Bit,    // ~
    Xor_Bit_Eq, // ^=
    Shift_L_Bit_Eq, // <<=
    Shift_R_Bit_Eq, // >>=

    Equal_Eq,   // ==
    Not_Eq,     // !=
    Less,       // <
    Less_Eq,    // <=
    Greater,      // >
    Greater_Eq,   // >=


    Open_Paren,     // (
    Close_Paren,    // )
    Open_Bracket,   // [
    Close_Bracket,  // ]
    Open_Brace,     // {
    Close_Brace,    // }

    Colon,      // :
    Comma,      // ,
    Semicolon,  // ;
    Dot,        // .
    Dot_Dot,    // ..


    Range_Half, // ..<
    Range_Full, // ..=

    Import,     // import
    Class,      // class
    This,       // this
    IN,         // in
    Vector2,    // vector2d
    Extends,    // extends
    New,        // new
    Set,        // set
    Print,      // print
    Self,       // self
    Super,      // super
    Color,      // color
    Transform2, //Transform2D
    Rect2,
    If,         // if
    Elif,       // elif
    Else,       // else
    For,        // for
    While,      // while,
    Match,      // Match
    Case,       // case
    Until,      // until
    Do,         // do,
    Break,      // break
    As,         // as
    From,
    Continue,   // continue
    Return,     // return
    Defer,      // defer
    Fn,         // fn
    Enum,       // enum
    Assert,     // assert
    True,       // true
    False,      // false
    Null,       // null
    Newline,    // '\n'

    COUNT,
}


@(private)
keywoords := map[string]TokenType{

   "import"    = .Import,
   "from"      = .From,
   "new"       = .New,
	
	"if"  		= .If,
	"elif"		= .Elif,
	"else"		= .Else,

   "while"     = .While,
   "match"     = .Match,
   "case"      = .Case,
   // "until"     = .Until,
   "in"        = .IN,
   "continue"  = .Continue,
   "return"    = .Return,
   "break"     = .Break,


	"and"		   = .And,
	"or" 		   = .Or,
   "true"      = .True,
   "false"     = .False,
    "nil"      = .Null,
    // "do"       = .Do,

	"assert" 	= .Assert,
	"set" 		= .Set,
	"not" 		= .Not,
	"self"		= .Self,
	"print"		= .Print,
	"class"		= .Class,
   "this"      = .This,
   "super"     = .Super,
   "Color"     = .Color,
   "Vector2"   = .Vector2,
   "Rect2"     = .Rect2,
   "Transform2D" = .Transform2,

    // "new"       = .New,

   "extends"   = .Extends,
	"for"		   = .For,
	"super"		= .Super,
	"fn" 		   = .Fn,
    "_"  		= .Underscore
}

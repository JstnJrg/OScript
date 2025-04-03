package OScriptVariant

import types      "oscript:types"
import tokenizer  "oscript:tokenizer"
import opcode     "oscript:opcode"
import _context   "oscript:context"


// Nota(jstn): context

OSCRIPT_DEBUG   :: _context.OSCRIPT_DEBUG


// Nota(jstn): tipos Oscript 
Int 			:: types.Int
Float			:: types.Float
U8				:: types.U8
Uint 			:: types.Uint
Uint_32 		:: types.U32
OpCode 			:: opcode.OpCode
Localization	:: tokenizer.Localization

Vector2d        :: [2]Float
Color           :: [4]U8
Rect2           :: [2]Vector2d
mat2x3          :: matrix[2,3]Float
Transform3D     :: matrix[2,3]Float  
ValueArray      :: [dynamic]Value
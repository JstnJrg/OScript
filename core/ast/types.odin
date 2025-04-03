package  OScriptAst

import mem       "core:mem"
import tokenizer "oscript:tokenizer"
import opcode    "oscript:opcode"
import types     "oscript:types"


Int				:: types.Int
Float 			:: types.Float

Opcode          :: opcode.OpCode


Token      		:: tokenizer.Token
TokenType  		:: tokenizer.TokenType
Localization 	:: tokenizer.Localization
Allocator       :: mem.Allocator
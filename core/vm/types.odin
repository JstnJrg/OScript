package OScriptVM

import fmt       "core:fmt"
import mem       "core:mem"
import strings   "core:strings"
import strconv   "core:strconv"

import types     "oscript:types"
import tokenizer "oscript:tokenizer"
import parser    "oscript:parser"
import opcode    "oscript:opcode"

// Strings
atof                :: strconv.atof
atoi 				:: strconv.atoi

clone_s             :: strings.clone
replace_s           :: strings.replace


// mem
Kilobyte            :: mem.Kilobyte
Megabyte            :: mem.Megabyte
Gigabyte            :: mem.Gigabyte

ptr_offset          :: mem.ptr_offset
ptr_sub				:: mem.ptr_sub


// Types
Int 				:: types.Int
Float				:: types.Float
U8					:: types.U8
U32				    :: types.U32
Uint				:: types.Uint

// 
Opcode 				:: opcode.OpCode

// Fmt
print 				:: fmt.print
println				:: fmt.println

// Tokenizer
Token      			:: tokenizer.Token
TokenType  			:: tokenizer.TokenType
Localization 		:: tokenizer.Localization

tkzr            	:: tokenizer.Tokenizer
tk_scan				:: tokenizer.scan
tk_init				:: tokenizer.init
tk_create			:: tokenizer.create

// opcode
get_operator_name	:: opcode.get_operator_name

// Parser
psr                 :: parser.Parser
p_create       		:: parser.create
p_at 		   		:: parser.at
p_advance           :: parser.advance
p_at_previous  		:: parser.at_previous
p_expected          :: parser.expected
p_expected_previous :: parser.expected_previous
p_peek_current      :: parser.peek_current
p_peek_previous     :: parser.peek_previous
p_peek_ctype        :: parser.peek_current_type
p_peek_ptype        :: parser.peek_previous_type
p_is_eof       		:: parser.is_eof
p_skip         		:: parser.skip
p_skip_semicolon	:: parser.skip_semicolon
p_has_error	   		:: parser.has_error










package OScriptAst

import mem "core:mem"

allocator :: mem.Allocator


Node       :: struct { type : AstType }
ErrorNode  :: struct { using base : Node, loc: Localization }


    





#+private

package OScriptVM

import ast "oscript:ast"

Node 	:: ast.Node
AstType :: ast.AstType


ast_is_identifier        :: proc(node: ^Node) -> bool { return node.type == .NAMEDVAR }
ast_identifier_get_name  :: proc(node: ^Node) -> string { return (^ast.NamedNode)(node).name }
ast_as_namednode         :: proc(node: ^Node) -> ^ast.NamedNode { return (^ast.NamedNode)(node) }

ast_is_get_property       :: proc(node: ^Node) -> bool { return node.type == .GET_PROPERTY}
ast_as_getpropertynode    :: proc(node: ^Node) -> ^ast.GetPropertyNode { return (^ast.GetPropertyNode)(node) }
ast_block_get_local_count :: proc(node: ^Node) -> int {
	block := (^ast.Block)(node)
	return block.local_count
} 

block_append_node        :: proc(block,node: ^Node) 
{
	block     := (^ast.Block)(block)
	container := (^ast.ContainerNode)(block.body)
	append(&container.elements,node)
}


// ast_is_mem  :: proc(node: ^Node) -> bool { return node.type == .NAMEDVAR }


create_temp_dynamic :: proc($T: typeid) -> [dynamic]T {return make([dynamic]T,compile_default_allocator()) }


create_node 		:: proc( $T : typeid, type:  AstType ) -> ^T { 
	node 		:=  new(T,compile_default_allocator())
	node.type    = type
	return node
} 

unreachable_ast     :: proc(node: ^Node) {
	print("ast ",node.type," not handler")
	oscript_assert_mode(false)
	assert(false,"")
}


// ERROR
create_bad_node    :: proc(token: Token, loc : Localization) -> ^ast.BadExpr {
	bad_expr := create_node(ast.BadExpr,.ERROR)
	bad_expr.loc = loc
	bad_expr.tk  = token
	return bad_expr
}

create_container_node    :: proc() -> ^ast.ContainerNode {
	node := create_node(ast.ContainerNode,.NONE)
	node.elements = make([dynamic]^Node,compile_default_allocator())
	return node
}




// ========================= STMT
create_stmt_node :: proc(expr: ^Node) -> ^ast.StmtNode {
	stmt_node 		:= create_node(ast.StmtNode,.STATEMENT)
	stmt_node.stmt   = expr
	return stmt_node
}

create_return_node :: proc(expr: ^Node,local_count: int , loc : Localization ) -> ^ast.ReturnNode {
	node 				:= create_node(ast.ReturnNode,.RETURN)
	node.expr    		= expr
	node.local_count    = local_count
	node.loc     		= loc
	return node
}

create_print_node :: proc(container: ^ast.ContainerNode, loc : Localization ) -> ^ast.PrintNode {
	node          := create_node(ast.PrintNode,.PRINT)
	node.container = container
	node.loc       = loc
	return node
}

create_define_node :: proc(var_name: string, value: ^Node, is_local : bool, loc : Localization ) -> ^ast.DefineNode {
	node         := create_node(ast.DefineNode,.SETVAR)
	node.name 	  = var_name
	node.expr 	  = value
	node.is_local = is_local
	node.loc      = loc
	return node
}

create_block_node  :: proc(container: ^ast.ContainerNode, local_count: int ,loc: Localization) -> ^ast.Block {
	node 			   := create_node(ast.Block,.BLOCK)
	node.body	 		= container
	node.local_count	= local_count
	node.loc 			= loc
	return node
}

create_if_node  :: proc(condition,body,elif: ^Node,has_elif: bool ,loc: Localization) -> ^ast.IfNode {
	node 			   := create_node(ast.IfNode,.IF)
	node.condition      = condition
	node.body           = body
	node.elif           = elif
	node.has_elif       = has_elif
	node.loc 			= loc
	return node
}

create_while_node  :: proc(condition,body: ^Node,loc: Localization) -> ^ast.WhileNode {
	node 			   := create_node(ast.WhileNode,.WHILE)
	node.condition      = condition
	node.body           = body
	node.loc 			= loc
	return node
}

create_for_node  :: proc(start,condition,increment,body,ibody: ^Node,loc: Localization) -> ^ast.ForNode {
	node 			   := create_node(ast.ForNode,.FOR)
	node.start          = start
	node.condition      = condition
	node.increment      = increment
	node.body           = body
	node.ibody          = ibody
	node.loc 			= loc
	return node
}


create_match_node :: proc(condition,conditions,cases: ^Node, has_default: bool , loc : Localization ) -> ^ast.MatchNode
{
	node            := create_node(ast.MatchNode,.MATCH)
	node.condition   = condition
	node.conditions  = conditions
	node.cases       = cases
	node.has_default = has_default
	node.loc         = loc
	return node
}



create_break_node  :: proc(local_count: int ,loc: Localization) -> ^ast.BreakNode {
	node 			   := create_node(ast.BreakNode,.BREAK)
	node.local_count    = local_count
	node.loc 			= loc
	return node
}

create_continue_node  :: proc(local_count: int ,loc: Localization) -> ^ast.ContinueNode {
	node 			   := create_node(ast.ContinueNode,.CONTINUE)
	node.local_count    = local_count
	node.loc 			= loc
	return node
}

create_class_node :: proc(name: string,loc: Localization) -> ^ClassNode {
	node     := create_node(ClassNode,.CLASS)
	node.name = name
	node.loc  = loc
	return node
}

create_import_node :: proc(container: ^Node,name: string, hash : u32, is_native,is_duplicate : bool, loc : Localization ) -> ^ast.ImportNode {
	node              := create_node(ast.ImportNode,.IMPORT)
	node.container     = container
	node.name          = name
	node.hash          = hash
	node.is_native     = is_native
	node.is_duplicate  = is_duplicate
	node.loc           = loc
	return node
}

// ============================================================================= EXPR

create_expr_node  :: proc(expr: ^Node, loc : Localization ) -> ^ast.ExprNode {
	expr_node 		:= create_node(ast.ExprNode,.EXPRESSION)
	expr_node.expr   = expr
	expr_node.loc    = loc
	return expr_node
}

create_string_node :: proc(str: string, loc : Localization ) -> ^ast.StringNode {
	str_node 		:= create_node(ast.StringNode,.STRING)
	str_node.str     = str
	str_node.len     = len(str)
	str_node.loc     = loc
	return str_node
}

create_literal_node :: proc(op: Opcode , loc : Localization ) -> ^ast.LiteralNode {
	literal_node 		:= create_node(ast.LiteralNode,.LITERAL)
	literal_node.op      = op
	literal_node.loc     = loc
	return literal_node
}

create_int_node 	:: proc(number : Int , loc : Localization ) -> ^ast.IntNode {
	int_node 		:= create_node(ast.IntNode,.INT)
	int_node.number  = number
	int_node.loc     = loc
	return int_node
}

create_float_node 	:: proc(number : Float , loc : Localization ) -> ^ast.FloatNode {
	float_node 		  := create_node(ast.FloatNode,.FLOAT)
	float_node.number  = number
	float_node.loc     = loc
	return float_node
}

create_unary_node :: proc(rhs: ^Node, op: Opcode , loc : Localization ) -> ^ast.UnaryNode {
	unary_node 		  := create_node(ast.UnaryNode,.UNARY)
	unary_node.rhs     = rhs
	unary_node.op      = op
	unary_node.loc     = loc
	return unary_node
}

create_binary_node :: proc(lhs,rhs: ^Node, op: Opcode , loc : Localization ) -> ^ast.BinaryNode {
	binary_node 	   := create_node(ast.BinaryNode,.BINARY)
	binary_node.lhs     = lhs
	binary_node.rhs     = rhs
	binary_node.op      = op
	binary_node.loc     = loc
	return binary_node
}

create_logical_node :: proc(lhs,rhs: ^Node, op: Opcode , loc : Localization ) -> ^ast.LogicalNode {
	node 	    := create_node(ast.LogicalNode,.LOGICAL)
	node.lhs     = lhs
	node.rhs     = rhs
	node.op      = op
	node.loc     = loc
	return node
}

create_ternary_node :: proc(lhs,condition,rhs: ^Node, loc : Localization ) -> ^ast.TernaryNode{
	node 	      := create_node(ast.TernaryNode,.TERNARY)
	node.lhs       = lhs
	node.condition = condition
	node.rhs       = rhs
	node.loc       = loc
	return node
}


create_named_node 	:: proc(name: string, is_local: bool, local_indx : int , loc : Localization ) -> ^ast.NamedNode {
	node 		   := create_node(ast.NamedNode,.NAMEDVAR)
	node.name       = name
	node.is_local   = is_local
	node.local_indx = local_indx
	node.loc        = loc
	return node
}

create_assignment   :: proc(name: string, expr: ^Node, is_local: bool, local_indx: int, loc: Localization) -> ^ast.AssignmentNode {
	node 		 	:= create_node(ast.AssignmentNode,.ASSIGNMENT)
	node.name     	= name
	node.expr     	= expr
	node.is_local 	= is_local
	node.local_indx = local_indx
	node.loc        = loc
	return node
}

create_call_node  :: proc(callee,container: ^Node,argc: int ,loc: Localization) -> ^ast.CallNode {
	node 			   := create_node(ast.CallNode,.CALL)
	node.callee         = callee
	node.args           = container
	node.argc           = argc
	node.loc 			= loc
	return node
}

create_new_node :: proc(class,args: ^Node,argc :int,loc: Localization) -> ^ast.NewNode {
	node      := create_node(ast.NewNode,.NEW)
	node.class = class
	node.args  = args
	node.argc  = argc 
	node.loc   = loc
	return node
}

create_set_property_node :: proc(lhs,value: ^Node,property: string, op: Opcode ,loc: Localization) -> ^ast.SetPropertyNode {
	node          := create_node(ast.SetPropertyNode,.SET_PROPERTY)
	node.lhs       = lhs
	node.expr      = value
	node.property  = property
	node.op        = op 
	node.loc       = loc
	return node
}

create_get_property_node :: proc(lhs: ^Node,property: string, op: Opcode ,loc: Localization) -> ^ast.GetPropertyNode {
	node          := create_node(ast.GetPropertyNode,.GET_PROPERTY)
	node.lhs       = lhs
	node.property  = property
	node.op        = op 
	node.loc       = loc
	return node
}

create_call_method_node :: proc(lhs,args: ^Node,method: string,argc: int,loc: Localization) -> ^ast.CallMethodNode {
	node          := create_node(ast.CallMethodNode,.CALL_METHOD)
	node.lhs       = lhs
	node.args      = args
	node.method    = method
	node.argc      = argc 
	node.loc       = loc
	return node
}

create_container_generic_node    :: proc(type: ast.AstType, loc : Localization ) -> ^ast.ContainerNode {
	node         := create_node(ast.ContainerNode,type)
	node.elements = make([dynamic]^Node,compile_default_allocator())
	node.loc      = loc
	return node
}


create_object_operator_node :: proc(lhs,index,rhs: ^Node,is_set : bool ,loc: Localization) -> ^ast.ObjectOperatorNode {
	node          := create_node(ast.ObjectOperatorNode,.OBJECTOPERATOR)
	node.lhs       = lhs
	node.index     = index
	node.rhs       = rhs
	node.is_set    = is_set
	node.loc       = loc
	return node
}



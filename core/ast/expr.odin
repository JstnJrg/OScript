package OScriptAst

ExprNode   :: struct {
	using base : Node,
	expr 	   : ^Node,
	loc 	   : Localization  			
}

BadExpr     :: struct {
	using base : Node,
	tk         : Token,
	loc        : Localization
}

LiteralNode  :: struct { 
	using base : Node,
	op         : Opcode,
	loc        : Localization
}

IntNode  :: struct { 
	using base : Node,
	number     : Int,
	loc        : Localization
}

FloatNode :: struct {
	using base : Node,
	number     : Float,
	loc        : Localization
}

StringNode :: struct {
	using base : Node,
	str        : string,
	len        : int,
	loc        : Localization
}

UnaryNode :: struct {
	using base: Node,
	rhs       : ^Node,
	op        : Opcode,
	loc       : Localization
} 

BinaryNode :: struct {
	using base : Node,
	lhs        : ^Node,
	rhs        : ^Node,
	op         : Opcode,
	loc        : Localization
}


TernaryNode :: struct {
	using base :  Node,
	lhs        : ^Node,
	condition  : ^Node,
	rhs        : ^Node,
	loc        : Localization
}

LogicalNode :: struct {
	using base : Node,
	lhs        : ^Node,
	rhs        : ^Node,
	op         : Opcode,
	loc        : Localization
}


ContainerNode :: struct {
	using base : Node,
	elements   : [dynamic]^Node,
	loc        : Localization
}


NamedNode   :: struct {
  using base   : Node,
  name         : string,
  is_local     : bool,
  local_indx   : int,
  loc          : Localization
}

AssignmentNode   :: struct {
  using base   : Node,
  name         : string,
  expr         : ^Node, 
  is_local     : bool, 
  local_indx   : int,        
  loc          : Localization
}


CallNode :: struct {
	using base :  Node,
	callee     : ^Node,
	args       : ^Node,
	argc       :  int,
	loc        :  Localization 
}



NewNode      :: struct {
	using base : Node,
	class      : ^Node,
	args       : ^Node,
	argc       : int,
	loc        : Localization
}

SetPropertyNode :: struct {
	using base : Node,
	lhs        : ^Node,
	property   : string,
	expr       : ^Node,     
	op         : Opcode,
	loc        : Localization
}

GetPropertyNode :: struct {
	using base : Node,
	lhs        : ^Node,
	property   : string,    
	op         : Opcode,
	loc        : Localization
}

CallMethodNode :: struct {
	using base : Node,
	lhs        : ^Node,
	method     : string,
	args       : ^Node,
	argc       : int,     
	loc        : Localization
}

ObjectOperatorNode :: struct {
	using base : Node,
	lhs        : ^Node,
	index      : ^Node,
	rhs        : ^Node,
	is_set     : bool,
	loc        : Localization
}

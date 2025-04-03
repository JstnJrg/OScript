package OScriptAst

StmtNode   :: struct {
	using base : Node,
	stmt 	   : ^Node  			
}  


ReturnNode :: struct {
	using base  :  Node,
	expr        : ^Node,
	local_count : int,
	loc         : Localization,
}


PrintNode :: struct {
	using base: Node,
	container : ^ContainerNode,
	loc       : Localization
}

DefineNode :: struct {
	using base: Node,
	name      : string,
	expr      : ^Node,
	is_local  : bool,
	loc       : Localization
}

IfNode     :: struct {
	using base :  Node,
	condition  : ^Node,
	body       : ^Node,
	elif       : ^Node,
	has_elif   : bool,
	loc        : Localization
}

WhileNode     :: struct {
	using base :  Node,
	condition  : ^Node,
	body       : ^Node,
	loc        : Localization
}

ForNode     :: struct {
	using base :  Node,
	start      : ^Node,
	condition  : ^Node,
	increment  : ^Node,
	body       : ^Node,
	ibody      : ^Node,
	loc        : Localization
}

Block     :: struct {
	using base  : Node,
	body        : ^ContainerNode,
	local_count : int,
	loc         : Localization
}


BreakNode    :: struct {
	using base : Node,
	local_count: int,
	loc        : Localization 
}

ContinueNode :: struct {
	using base : Node,
	local_count: int,
	loc        : Localization
}


ImportNode :: struct {
	using base    : Node,
	container     : ^Node,
	name          : string,
	is_native     : bool,
	is_duplicate  : bool,
	hash          : u32,
	loc           : Localization
}


MatchNode  :: struct {
	using base    :  Node,
	condition     : ^Node,
	conditions    : ^Node,
	cases         : ^Node,
	has_default   : bool,
	loc           : Localization
}

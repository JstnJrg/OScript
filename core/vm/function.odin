#+private

package OScriptVM

FunctionType :: distinct enum u8 
{
	TYPE_SCRIPT,
	TYPE_FUNCTION,
	TYPE_INITIALIZER,
	TYPE_METHOD,
}

FunctionNode :: struct {
  using base  	:  Node,
  pbody       	: ^Node,
  body        	: ^Node,
  name          : string,
  arity       	: int,
  loc           : Localization
  // enclosing     : ^FunctionNode
}


begin_function  :: proc(type: FunctionType) { 
  cc := get_current_compiler()
  cc.function_depth += 1
  cc.function_type   = type
}

end_function  :: proc() { 
  cc := get_current_compiler()
  cc.function_depth -= 1
  cc.function_type   = .TYPE_SCRIPT
}

is_function         :: proc() -> bool  { return get_current_compiler().function_depth > 0 }
is_init_function    :: proc() -> bool  { return get_current_compiler().function_type == .TYPE_INITIALIZER }
is_method_function  :: proc() -> bool  { return get_current_compiler().function_type == .TYPE_METHOD }

get_current_type    :: proc() -> FunctionType { return get_current_compiler().function_type }

create_function_node :: proc(name: string,pbody,body: ^Node,arity: int,loc: Localization) -> ^FunctionNode {
  node       := create_node(FunctionNode,.FUNCTION)
  node.name   = name
  node.pbody  = pbody
  node.body   = body
  node.arity  = arity
  node.loc    = loc
  return node
}



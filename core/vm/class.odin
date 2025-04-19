#+private
package OScriptVM

ClassNode  :: struct 
{
	using base    : Node,
	name          : string,
	extends       : string,
	class_data    : ^Class,
	fields_nodes  : ^Node,
	methods_nodes : ^Node,
	has_super     : bool,
	loc           : Localization,
}



@(private="file") current_class : ^Class

Class :: struct 
{
	fields       : map[string]Localization,
	methods      : map[string]Localization,
	// method_type  : FunctionType
}


begin_class :: proc() 
{
	current_class = new(Class,compile_default_allocator())

	oscript_assert_mode(current_class != nil)
	assert(current_class != nil, "current_class is nullptr.")
	
	current_class.fields  = make(map[string]Localization,compile_default_allocator())
	current_class.methods = make(map[string]Localization,compile_default_allocator())
}

get_current_class :: proc() -> ^Class { return current_class }

end_class         :: proc() { current_class = nil }
is_class          :: proc() ->  bool { return current_class != nil }


class_check_redeclaration_field :: proc(field: ^Token) -> (has: bool, loc: Localization) {
	loc,has = current_class.fields[field.text]
	return
}

class_check_redeclaration_method :: proc(method : ^Token) -> (has: bool, loc: Localization) {
	loc,has = current_class.methods[method.text]
	return
}

class_declare_field   :: proc(field: ^Token)  { current_class.fields[field.text]  = field.pos }
class_declare_method  :: proc(method: ^Token) { current_class.methods[method.text] = method.pos }








package OScriptVM

oscript_get_global :: proc (name : string,value_p : ^Value ) -> bool {
	hash := hash_string(name)
	return table_get_hash(&current_vm.globals,hash,value_p)
}

oscript_get_global_hash :: proc(hash: u32,value_p : ^Value ) -> bool{
	return table_get_hash(&current_vm.globals,hash,value_p)
}

oscript_frame_get_global :: proc(name : string, value_p : ^Value ) -> bool {
	hash  := hash_string(name)
	frame := get_current_frame()
	return table_get_hash(frame.globals,hash,value_p)
}

oscript_frame_get_global_hash :: proc(hash: u32,value_p : ^Value ) -> bool{
	frame := get_current_frame()
	return table_get_hash(frame.globals,hash,value_p)
}


oscript_set_global :: proc (name : string,value_p : ^Value ) -> bool {
	hash := hash_string(name)
	return !table_set_hash_vptr(&current_vm.globals,hash,value_p)
}

oscript_set_global_hash :: proc(hash: u32,value_p : ^Value ) -> bool{
	return !table_set_hash_vptr(&current_vm.globals,hash,value_p)
}

oscript_frame_set_global :: proc(name : string, value_p : ^Value ) -> bool {
	hash  := hash_string(name)
	frame := get_current_frame()
	return !table_set_hash_vptr(frame.globals,hash,value_p)
}

oscript_frame_set_global_hash :: proc(hash: u32,value_p : ^Value ) -> bool{
	frame := get_current_frame()
	return !table_set_hash_vptr(frame.globals,hash,value_p)
}

oscript_define_global :: proc(name : string,value: Value) {
	hash := hash_string(name)
	table_set_hash(&current_vm.globals,hash,value)
}

oscript_define_global_hash :: proc(hash: u32 ,value: Value) {
	table_set_hash(&current_vm.globals,hash,value)
}

oscript_frame_define_global :: proc(name : string,value: Value) {
	hash  := hash_string(name)
	frame := get_current_frame()
	table_set_hash(frame.globals,hash,value)
}

oscript_frame_define_global_hash :: proc(hash: u32 ,value: Value) {
	frame := get_current_frame()
	table_set_hash(frame.globals,hash,value)
}

oscript_push :: proc(value: ^Value) { peek_cptr()^ = value^; push_empty()}
oscript_pop  :: proc(offset: Int)   { pop_offset(offset)}


// Nota(jstn): nenhuma verificação é feita, é da reponsabilidade de quem chama
call_oscript_function :: proc(value_p: ^Value, argc, default_arity: Int, has_error: ^bool) {
	callee := get_foreign_call_type_ptr(value_p)
	callee(value_p,argc,default_arity,has_error)
}

call_oscript_function_safe :: proc(value_p: ^Value, argc, default_arity: Int, has_error: ^bool) {
	callee := get_foreign_call_type_ptr(value_p)
	if callee != nil { callee(value_p,argc,default_arity,has_error); return }
	has_error^ = true
}

oscript_declare_class :: proc(name: string) -> ClassID {
	class_id := register_class_classBD(name)	
	hash     := hash_string(name)	
	table_set_hash(&current_vm.globals,hash,CLASS_BD_ID_VAL(class_id,.OBJ_CLASS))
	return class_id
}

oscript_declare_class_property :: proc(class_id: ClassID, property : string,set,get  : SetGetType ) {
	register_class_property_classBD(class_id,property)
	if set == nil do register_class_property_set_classBD(class_id,property,get_default_set_classBD(.OBJ_CLASS_INSTANCE)) 
	if get == nil do register_class_property_get_classBD(class_id,property,get_default_get_classBD(.OBJ_CLASS_INSTANCE))
}

oscript_declare_class_method  :: proc(class_id: ClassID, method_name : string, value : Value) { 
	register_class_method_classBD(class_id,method_name,value) 
}




// IMPORT
oscript_declare_import_package :: proc(name: string) -> ImportID {
	import_id := register_import_importID(name)	
	hash      := hash_string(name)	
	table_set_hash(&current_vm.globals,hash,IMPORT_BD_ID_VAL(import_id,.OBJ_PACKAGE))
	return import_id
}

oscript_register_import_function :: proc(iid: ImportID, name : string, fn : NativeFn)    { register_method(iid,name,fn) }


oscript_import_declare_class :: proc(iid: ImportID ,name: string) -> ClassID {
	class_id := register_class_classBD(name)	
	hash     := hash_string(name)	
	table_set_hash(get_import_context_importID(iid),hash,CLASS_BD_ID_VAL(class_id,.OBJ_CLASS))
	return class_id
}



// 
oscript_get_native_method_value :: proc(fn: NativeFn) -> Value { return NATIVE_OP_FUNC_VAL(fn) }

check_type   :: proc(value_p: ^Value, type: ValueType) -> bool { return value_p.type == type}

is_oscript_function :: proc (value_p: ^Value) -> bool { return value_p.type == .OBJ_FUNCTION || value_p.type == .NATIVE_OP_FUNC_VAL}




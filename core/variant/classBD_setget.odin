package OScriptVariant

SetGetType           :: #type EVALUATE_FUNCTION


// Nota(jstn): é suposto não chegar aqui, isso significa que não possui essa propriedade
default_set :: #force_inline proc(_,property,_: ^Value, has_error: ^bool, call_error_p: ^ObjectCallError) {
	sym_indx 	  := AS_SYMID_PTR(property)
	property_name := get_symbol_str_BD(sym_indx)
	CALL_ERROR_STRING( call_error_p,"invalid assignment. cannot find property '",property_name,"'."); has_error^ = true
}

default_get :: #force_inline proc(_,property,_: ^Value, has_error: ^bool, call_error_p: ^ObjectCallError) {
	sym_indx 	  := AS_SYMID_PTR(property)
	property_name := get_symbol_str_BD(sym_indx)
	CALL_ERROR_STRING( call_error_p,"invalid get, cannot find property '",property_name,"'."); has_error^ = true
}





// Nota(jstn): usado principalmente para instancia, caso não seja definida um get e set
default_set_instance         :: #force_inline proc(object,property,variant_set: ^Value, has_error: ^bool, call_error_p: ^ObjectCallError)
{
	instance_     := VAL_AS_OBJ_CLASS_INSTANCE_PTR(object)
	sym_indx 	  := AS_SYMID_PTR(property)
	
	// property_name := get_symbol_str_BD(sym_indx)
	hash          := get_symbol_hash_BD(sym_indx)


	table_set_hash(&instance_.fields,hash,variant_set^) 
	
    // Nota(jstn): não usa o buffer, portanto pula o registro, ou seja, não será reguardado
	BOOL_VAL_PTR(object,true)	
}


default_get_instance :: #force_inline proc(object,property,variant_return: ^Value, has_error: ^bool, call_error_p: ^ObjectCallError)
{
	instance_     := VAL_AS_OBJ_CLASS_INSTANCE_PTR(object)
	sym_indx      := AS_SYMID_PTR(property)

	// property_name := get_symbol_str_BD(sym_indx)
	hash          := get_symbol_hash_BD(sym_indx)	
	table_get_hash(&instance_.fields,hash,variant_return) 

    // Nota(jstn): não usa o buffer, portanto pula o registro, ou seja, não será reguardado
	// BOOL_VAL_PTR(object,true)	
}
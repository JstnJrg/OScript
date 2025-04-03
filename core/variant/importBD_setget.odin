package OScriptVariant

ImportSetGet :: #type proc( id : ImportID, property,variant_return: ^Value, has_error: ^bool, call_error_p: ^ObjectCallError)

import_get   :: #force_inline proc( id : ImportID, property,variant_return: ^Value, has_error: ^bool, call_error_p: ^ObjectCallError) {
	
	@static cannot := ValueBitSet{.OBJ_PACKAGE} //Nota(jstn): restrição de objectos que pode acessar
	cannot_assign  := false
	
	sym_indx 	   := AS_SYMID_PTR(property)
	hash           := get_symbol_hash_BD(sym_indx)
	
	if !table_pget_hash(get_import_context_importID(id),hash,variant_return,&cannot_assign,&cannot) {
		CALL_ERROR_STRING(call_error_p,"'",get_symbol_str_BD(sym_indx),"' is not declared by '",get_import_name(id),"'." )
		has_error^ = true
	}

	if cannot_assign { CALL_ERROR_STRING(call_error_p,"illegal get field '",get_symbol_str_BD(sym_indx),"' in '",get_import_name(id),"'." ); has_error^ = true }
}

import_set :: #force_inline proc( id : ImportID, property,variant_return: ^Value, has_error: ^bool, call_error_p: ^ObjectCallError) {
	
	@static cannot := ValueBitSet{.OBJ_FUNCTION,.OBJ_CLASS,.OBJ_PACKAGE}
	cannot_assign  := false

	sym_indx 	   := AS_SYMID_PTR(property)
	hash           := get_symbol_hash_BD(sym_indx)
	
	if table_pset_hash(get_import_context_importID(id),hash,variant_return,&cannot_assign,&cannot) {
		CALL_ERROR_STRING(call_error_p,"'",get_symbol_str_BD(sym_indx),"' is not declared by '",get_import_name(id),"'." )
		has_error^ = true
	}

	if cannot_assign { CALL_ERROR_STRING(call_error_p,"illegal assignment '",get_symbol_str_BD(sym_indx),"' in '",get_import_name(id),"'." ); has_error^ = true }
}



// Nota(jstn): é o padrão 
import_default_get :: #force_inline proc( id : ImportID, property,variant_return: ^Value, has_error: ^bool, call_error_p: ^ObjectCallError) {
	CALL_ERROR_STRING(call_error_p,"illegal get '",get_import_name(id),"'." )
	has_error^ = true
}

import_default_set :: #force_inline proc( id : ImportID, property,variant_return: ^Value, has_error: ^bool, call_error_p: ^ObjectCallError) {
	CALL_ERROR_STRING(call_error_p,"illegal assignment '",get_import_name(id),"'." )
	has_error^ = true
}

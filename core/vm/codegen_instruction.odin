#+private
package OScriptVM


// Nota(jstn): emite qualquer instrunção sem qualquer informação extra
emit_instruction :: proc(op : Opcode, loc : Localization ) { add_opcode(get_current_chunk(),Uint(op),loc) }

// Nota(jstn): util para passar metadados para instrunções
emit_slot_index  :: proc(#any_int indx: Uint, loc : Localization ) { add_opcode(get_current_chunk(),indx,loc) }

// Nota(jstn): emite uma intrução com o indice, que diz respeito a um metadado, que pode ser
// a localização do value no pool de constantes ou um informação extra
emit_instruction_and_slot_index :: proc(op: Opcode,#any_int indx: Uint,loc : Localization ) {
	add_opcode(get_current_chunk(),Uint(op),loc)
	add_opcode(get_current_chunk(),indx,loc)
}

// Nota(jstn): carrega uma constante no pool da chunk corrente, e com o respectivo slot da constante
// emite a instrução para carregar a constante na pilha da VM
 emit_constant_load_instruction :: proc(value: Value, loc : Localization ) { emit_instruction_and_slot_index(.OP_CONSTANT,add_constant_in_chunk_and_get_slot_index(value),loc) }

// Nota(jstn): simplesmente adiciona a constante no pool e retorna seu index, o indx relactivo
//  ao pool em que está adicionada
add_constant_in_chunk_and_get_slot_index :: proc(value: Value) -> Uint {
	indx := add_constant(get_current_chunk(),value)
	if indx > MAX_CHUNK_CONSTANT do error("too many constants in one chunk, got ",indx)
	return indx
}

add_variable_name_in_chunk_and_get_indx_s :: proc(string_ptr: ^string) -> Uint {
	variable_name := CREATE_OBJ_STRING(string_ptr,vm_get_internal_strings())
	return add_constant_in_chunk_and_get_slot_index(OBJECT_VAL(variable_name,.OBJ_STRING))	
}

add_value_in_chunk_and_get_indx :: proc(value : Value) -> Uint {
	return add_constant_in_chunk_and_get_slot_index(value)	
}


check_jump_limit :: proc(indx: Int){ if indx >= MAX_JUMP do error(" too much code to jump over.") }

emit_jump_and_get_address:: proc(op: Opcode,loc: Localization) -> Int {
	emit_instruction(op,loc)
	emit_instruction(op,loc)
	return get_current_address()
}

fill_label_jump_placehold :: proc(#any_int indx: Int, #any_int offset: Uint) {
	check_jump_limit(indx)
	if has_error() do return
	get_current_chunk().code[indx] = offset+1
}
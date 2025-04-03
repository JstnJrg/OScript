package OScriptVariant

register_natives :: proc() {

	// Nota(jstn): o import_default_set não permite atribuições, já 
	// o import_get permite obter dados da tabela
	register_import_native_importID("Math",      import_default_set,import_get)
	register_import_native_importID("Time",      import_default_set,import_get)

	register_import_class_importID ("String",    import_default_set,import_get)
	register_import_class_importID ("Array",     import_default_set,import_get)
	register_import_class_importID ("Vector2",   import_default_set,import_get)
	register_import_class_importID ("Rect2",     import_default_set,import_get)
	register_import_class_importID ("Color",     import_default_set,import_get)
	register_import_class_importID ("Transform2",import_default_set,import_get)

}


// Nota(jstn): não será feito nenhuma checagem, pois acredita-se
//  que o ID está correcto.
register_method :: proc(id: ImportID, name: string, method : NativeFn) {
	table_set_s(get_import_context_importID(id),name,NATIVE_OP_FUNC_VAL(method))
}

register_value :: proc(id: ImportID, name: string, value : Value) {
	table_set_s(get_import_context_importID(id),name,value)
}



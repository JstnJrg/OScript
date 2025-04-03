package OScriptVariant

CONSTRUCT_FUNCTION	 :: #type proc(args: []Value, #any_int argc: Int ,variant_return: ^Value, r_valid: ^bool,call_error: ^ObjectCallError)

// Nota(jstn): table usada para guardar as devidas funcoes com base no tipo
dispatch_construct_table       : [OpCode.OP_MAX]CONSTRUCT_FUNCTION


// Nota(jstn): registra os constructores
register_variant_constructs :: proc() {
	// register_construct(.OP_CONSTRUCT_CLASS,construct_class)
	register_construct(.OP_CONSTRUCT_VECTOR2,construct_vector2)
	register_construct(.OP_CONSTRUCT_COLOR,construct_color)
	register_construct(.OP_CONSTRUCT_ARRAY,construct_array)
	register_construct(.OP_CONSTRUCT_RECT2,construct_rect2)
	register_construct(.OP_CONSTRUCT_TRANSFORM2,construct_transform2d)
}

register_construct 		:: proc(op: OpCode,function: CONSTRUCT_FUNCTION) { dispatch_construct_table[op] = function }

get_construct_evaluator	:: #force_inline proc(op: OpCode) -> CONSTRUCT_FUNCTION { return dispatch_construct_table[op] }





// construct_class   :: #force_inline proc(args: []Value, #any_int argc: Int, r_variant: ^Value,  has_error : ^bool, _: ^ObjectCallError){

// 	class_name_obj := VAL_AS_OBJ_STRING_PTR(&args[0])

// 	class_p := CREATE_OBJ_CLASS(class_name_obj)
// 	OBJECT_VAL_PTR(r_variant,class_p,.OBJ_CLASS)


// 	// Nota(jstn): registra a função Class primeiro
// 	class_function      := args[1]
// 	class_function_name := VAL_AS_OBJ_STRING_PTR(&args[2])
// 	// println("script class name | construct_class ",class_function_name.hash,"|",VAL_STRING_DATA_PTR(&args[2]))
// 	table_set(&class_p.methods,class_function_name,class_function)

// 	// Nota(jstn): os metodos e seus nomes são postos em ordem: FUNCTION, NAME
// 	// argc > 3, tem metodos
// 	if argc > 3
// 	{
// 		methods := args[3:]
// 		for mcount  := 0 ; mcount < argc-3; mcount += 2
// 		{
// 			method        := methods[mcount]
// 			method_name   := VAL_AS_OBJ_STRING_PTR(&methods[mcount+1])
// 			table_set(&class_p.methods,method_name,method) //substitui o metodo da classe super
// 		}
// 	}

// 	// has_error^ = true
// }


construct_vector2 		:: #force_inline proc(args: []Value, #any_int argc: Int, r_variant: ^Value, has_error: ^bool, call_error_p : ^ObjectCallError){

	components : [2]Float

	if !IS_FLOAT_CAST_PTR(&args[0], &components[0]) || !IS_FLOAT_CAST_PTR(&args[1], &components[1]) {
		CALL_ERROR_STRING(call_error_p,TYPE_TO_STRING(.VECTOR2_VAL)," expects numbers, but got ",VAL_TYPE_STRING(args[0])," and ",VAL_TYPE_STRING(args[1]))
		has_error^ = true; return
	}
	VECTOR2_VAL_PTR(r_variant,&components)
}


construct_array 		:: #force_inline proc(args: []Value, #any_int argc: Int, r_variant: ^Value, _: ^bool, _: ^ObjectCallError){
	arr_p 	      :=  CREATE_OBJ_ARRAY()
	arr_p.len      = argc
	append(&arr_p.data,..args)
	r_variant^ = OBJECT_VAL(arr_p,.OBJ_ARRAY)
}



construct_color	:: #force_inline proc(args: []Value, #any_int argc: Int, r_variant: ^Value, has_error: ^bool, call_error_p : ^ObjectCallError){

	channels : [4]u8

	for i in 0..<4 do if !IS_INT_CAST_PTR(&args[i],&channels[i],u8) {
		CALL_ERROR_STRING(call_error_p,"'",TYPE_TO_STRING(.COLOR_VAL),"' expects ",TYPE_TO_STRING(.INT_VAL), " but got ",GET_TYPE_NAME(&args[i]))
		has_error^ = true
		return
	}

	COLOR_VAL_PTR(r_variant,&channels)
}

construct_transform2d	:: #force_inline proc(args: []Value, #any_int argc: Int, r_variant: ^Value, has_error: ^bool, call_error_p : ^ObjectCallError){

	for i in 0..<3 do if !IS_VECTOR2_PTR(&args[i]) {
		CALL_ERROR_STRING(call_error_p,"'",TYPE_TO_STRING(.OBJ_TRANSFORM2),"' expects '",TYPE_TO_STRING(.VECTOR2_VAL),"' but got '",GET_TYPE_NAME(&args[i]),"'.")
		has_error^ = true
		return
	}

	t := create_transform2_ptr(AS_VECTOR2_PTR(&args[0]),AS_VECTOR2_PTR(&args[1]),AS_VECTOR2_PTR(&args[2]))
	OBJECT_VAL_PTR(r_variant,t,.OBJ_TRANSFORM2)
}

construct_rect2	       :: #force_inline proc(args: []Value, #any_int argc: Int, r_variant: ^Value, has_error: ^bool, call_error_p : ^ObjectCallError){

	for i in 0..<2 do if !IS_VECTOR2_PTR(&args[i]) {
		CALL_ERROR_STRING(call_error_p,"'",TYPE_TO_STRING(.VECTOR2_VAL),"' expects '",TYPE_TO_STRING(.VECTOR2_VAL),"' but got '",GET_TYPE_NAME(&args[i]),"'.")
		has_error^ = true
		return
	}

	pos  := AS_VECTOR2_PTR(&args[0])
	size := AS_VECTOR2_PTR(&args[1])
	
	rect2 := Rect2{pos^,size^}
	RECT2_VAL_PTR(r_variant,&rect2)
}
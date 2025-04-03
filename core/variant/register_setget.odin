package OScriptVariant


register_variant_getter_and_setter :: proc(){ 

	register_op(.OP_GET_PROPERTY,.OBJ_CLASS_INSTANCE,.SYMID_VAL,get_property_class_instance)
	register_op(.OP_SET_PROPERTY,.OBJ_CLASS_INSTANCE,.SYMID_VAL,set_property_class_instance)

	// ARRAY
	register_op(.OP_GET_INDEXING,.OBJ_ARRAY,.INT_VAL,get_element_array)
	register_op(.OP_SET_INDEXING,.OBJ_ARRAY,.INT_VAL,set_element_array)


	//VECTOR2D
	register_op(.OP_GET_PROPERTY,.VECTOR2_VAL,.SYMID_VAL,get_vector2_component)
	register_op(.OP_SET_PROPERTY,.VECTOR2_VAL,.SYMID_VAL,set_vector2_component)

	// COLOR
	register_op(.OP_SET_PROPERTY,.COLOR_VAL,.SYMID_VAL,set_color_channel)
	register_op(.OP_GET_PROPERTY,.COLOR_VAL,.SYMID_VAL,get_color_channel)


	// Rect2
	register_op(.OP_GET_PROPERTY,.RECT2_VAL,.SYMID_VAL,get_rect2_component)
	register_op(.OP_SET_PROPERTY,.RECT2_VAL,.SYMID_VAL,set_rect2_component)

	// transform2d
	register_op(.OP_GET_PROPERTY,.OBJ_TRANSFORM2,.SYMID_VAL,get_transform2_component)
	register_op(.OP_SET_PROPERTY,.OBJ_TRANSFORM2,.SYMID_VAL,set_transform2_component)

	// package
	register_op(.OP_SET_PROPERTY,.OBJ_PACKAGE,.SYMID_VAL,set_package_field)
	register_op(.OP_GET_PROPERTY,.OBJ_PACKAGE,.SYMID_VAL,get_package_field)

	// native class
	register_op(.OP_SET_PROPERTY,.OBJ_NATIVE_CLASS,.SYMID_VAL,set_package_field)
	register_op(.OP_GET_PROPERTY,.OBJ_NATIVE_CLASS,.SYMID_VAL,get_package_field)
}


get_property_class_instance :: #force_inline proc(object,property,variant_return: ^Value, has_error: ^bool, call_error_p: ^ObjectCallError)
{
	instance_ 	  := VAL_AS_OBJ_CLASS_INSTANCE_PTR(object)
	sym_indx 	  := AS_SYMID_PTR(property)

	property_name := get_symbol_str_BD(sym_indx)
	getter        := get_property_get_method_classBD(instance_.klass_ID,property_name)
	
	getter(object,property,variant_return,has_error,call_error_p)	
}

set_property_class_instance :: #force_inline proc(object,property,variant_set: ^Value, has_error: ^bool, call_error_p: ^ObjectCallError)
{
	instance_ 	  := VAL_AS_OBJ_CLASS_INSTANCE_PTR(object)
	sym_indx 	  := AS_SYMID_PTR(property)

	property_name := get_symbol_str_BD(sym_indx)

	setter        := get_property_set_method_classBD(instance_.klass_ID,property_name)
	setter(object,property,variant_set,has_error,call_error_p)	
}




get_element_array :: #force_inline proc(object,indx,variant_return: ^Value, has_error: ^bool, call_error_p: ^ObjectCallError)
{
	array_p  := VAL_AS_OBJ_ARRAY_PTR(object)
	slot     := AS_INT_PTR(indx)
	len      := array_p.len

	slot     = slot >= 0 ? slot: slot+len

	if slot < 0 || slot >= len {
		CALL_ERROR_STRING( call_error_p,"index",slot," is out of range 0..<",len," on base '",GET_TYPE_NAME(object),"'.")
	    has_error^ = true
	    return
	}

	variant_return^ = array_p.data[slot]
}

set_element_array           :: #force_inline proc(object,indx,assign: ^Value, has_error: ^bool, call_error_p: ^ObjectCallError)
{
	array_p  := VAL_AS_OBJ_ARRAY_PTR(object)
	slot     := AS_INT_PTR(indx)
	len      := array_p.len

	slot     = slot >= 0 ? slot: slot+len

	if slot < 0 || slot >= len {
		CALL_ERROR_STRING( call_error_p,"index",slot," is out of range 0..<",len,"on base '",GET_TYPE_NAME(object),"'.")
	    has_error^ = true
	    return
	}

	array_p.data[slot] = assign^

	// Nota(jstn): não usa o buffer, portanto pula o registro
	BOOL_VAL_PTR(object,true)
}



// Vector2D

get_vector2_component :: #force_inline proc(vector2,component,variant_return: ^Value, has_error: ^bool, call_error_p: ^ObjectCallError)
{
	vector2d      := AS_VECTOR2_PTR(vector2)
	sym_indx 	  := AS_SYMID_PTR(component)
	property_name := get_symbol_str_BD(sym_indx)

	switch property_name
	{
		case "x": FLOAT_VAL_PTR(variant_return,vector2d[0]); return
		case "y": FLOAT_VAL_PTR(variant_return,vector2d[1]); return
	}

	CALL_ERROR_STRING(call_error_p,"cannot find property '",property_name,"' on base  '",GET_TYPE_NAME(vector2),"'.")
    has_error^ = true
}

set_vector2_component :: #force_inline proc(vector2,component,variant_return: ^Value, has_error: ^bool, call_error_p: ^ObjectCallError)
{
	vector2d      := AS_VECTOR2_PTR(vector2)
	sym_indx 	  := AS_SYMID_PTR(component)


	property_name := get_symbol_str_BD(sym_indx)
	value         : Float

	if !IS_FLOAT_CAST_PTR(variant_return,&value) 
	{
		CALL_ERROR_STRING(call_error_p,"cannot assign a value of type '",GET_TYPE_NAME(variant_return),"' as '",TYPE_TO_STRING(.FLOAT_VAL),"'.")
	    has_error^ = true
	    return
	}

	switch property_name
	{
		case "x": vector2d[0] = value
		case "y": vector2d[1] = value
		case    : 
			CALL_ERROR_STRING(call_error_p,"cannot find property '",property_name,"' on base  '",GET_TYPE_NAME(vector2),"'.")
			has_error^ = true
			return
	}


	//Nota(jstn): como usa o buffer, tem que redifinir aonde os valores estão guardados
	VECTOR2_VAL_PTR(variant_return,vector2d)
	BOOL_VAL_PTR(vector2,false)	
}


// COLOR
get_color_channel :: #force_inline proc(color,component,variant_return: ^Value, has_error: ^bool, call_error_p: ^ObjectCallError)
{
	data          := AS_COLOR_PTR(color)
	sym_indx 	  := AS_SYMID_PTR(component)
	
	property_name := get_symbol_str_BD(sym_indx)
	switch property_name
	{
		case "r": INT_VAL_PTR(variant_return,Int(data[0])); return
		case "g": INT_VAL_PTR(variant_return,Int(data[1])); return
		case "b": INT_VAL_PTR(variant_return,Int(data[2])); return
		case "a": INT_VAL_PTR(variant_return,Int(data[3])); return		
	}

	CALL_ERROR_STRING(call_error_p,"cannot find property '",property_name,"' on base  '",GET_TYPE_NAME(color),"'.")
	has_error^ = true
}

set_color_channel :: #force_inline proc(color,component,variant_return: ^Value, has_error: ^bool, call_error_p: ^ObjectCallError)
{
	
	data          := AS_COLOR_PTR(color)
	sym_indx 	  := AS_SYMID_PTR(component)
	
	property_name := get_symbol_str_BD(sym_indx)
	value         : u8

	if !IS_INT_CAST_PTR(variant_return,&value,u8)
	{
		CALL_ERROR_STRING(call_error_p,"cannot assign a value of type '",GET_TYPE_NAME(variant_return),"' as '",TYPE_TO_STRING(.INT_VAL),"'.")
	    has_error^ = true
	    return
	}

	switch property_name
	{
		case "r": data[0] = value
		case "g": data[1] = value
		case "b": data[2] = value
		case "a": data[3] = value
		case    : 
			CALL_ERROR_STRING(call_error_p,"cannot find property '",property_name,"' on base  '",GET_TYPE_NAME(color),"'.")
			has_error^ = true
			return		
	}

	//Nota(jstn): como usa o buffer, tem que redifinir aonde os valores estão guardados
	COLOR_VAL_PTR(variant_return,data)
	BOOL_VAL_PTR(color,false)	
}

// Rect2


get_rect2_component :: #force_inline proc(rect2,component,variant_return: ^Value, has_error: ^bool, call_error_p: ^ObjectCallError)
{
	rect2d    := AS_RECT2_PTR(rect2)
	sym_indx  := AS_SYMID_PTR(component)
	
	property_name := get_symbol_str_BD(sym_indx)

	switch property_name
	{
		case "position": position := rect2d[0]  ;VECTOR2_VAL_PTR(variant_return,&position); return
		case "size"    : size     := rect2d[1]  ;VECTOR2_VAL_PTR(variant_return,&size); return
	}

	CALL_ERROR_STRING(call_error_p,"cannot find property '",property_name,"' on base  '",GET_TYPE_NAME(rect2),"'.")
    has_error^ = true
}

set_rect2_component :: #force_inline proc(rect2,component,variant_return: ^Value, has_error: ^bool, call_error_p: ^ObjectCallError)
{
	rect2d    := AS_RECT2_PTR(rect2)
	sym_indx  := AS_SYMID_PTR(component)
	
	property_name := get_symbol_str_BD(sym_indx)

	if !IS_VECTOR2_PTR(variant_return) {
		CALL_ERROR_STRING(call_error_p,"cannot assign a value of type '",GET_TYPE_NAME(variant_return),"' as '",TYPE_TO_STRING(.VECTOR2_VAL),"'.")
	    has_error^ = true
	    return
	}


	vector2d := AS_VECTOR2_PTR(variant_return)
	switch property_name
	{
		case "position": rect2d[0] = vector2d^
		case "size"    : rect2d[1] = vector2d^
		case    : 
			CALL_ERROR_STRING(call_error_p,"cannot find property '",property_name,"' on base  '",GET_TYPE_NAME(rect2),"'.")
			has_error^ = true
			return
	}

	//Nota(jstn): como usa o buffer, tem que redifinir aonde os valores estão guardados
	RECT2_VAL_PTR(variant_return,rect2d)
	BOOL_VAL_PTR(rect2,false)	
}


set_transform2_component :: #force_inline proc(t,component,variant_return: ^Value, has_error: ^bool, call_error_p: ^ObjectCallError)
{

// IS_TRANSFORM2_PTR
// 
	transform2d    := AS_TRANSFORM2_DATA_PTR(t)
	sym_indx 	   := AS_SYMID_PTR(component)
	
	property_name := get_symbol_str_BD(sym_indx)

	if !IS_VECTOR2_PTR(variant_return) 
	{
		CALL_ERROR_STRING(call_error_p,"cannot assign a value of type '",GET_TYPE_NAME(variant_return),"' as '",TYPE_TO_STRING(.VECTOR2_VAL),"'.")
	    has_error^ = true
	    return
	}


	vector2d := AS_VECTOR2_PTR(variant_return)

	switch property_name
	{
		case "x"       : transform2d[0] = vector2d^
		case "y"       : transform2d[1] = vector2d^
		case "origin"  : transform2d[2] = vector2d^
		case    : 
			CALL_ERROR_STRING(call_error_p,"cannot find property '",property_name,"' on base  '",GET_TYPE_NAME(t),"'.")
			has_error^ = true
			return
	}

	//Nota(jstn): como usa o buffer, tem que redifinir aonde os valores estão guardados
    TRANSFORM2_VAL_MAT2x3_PTR(variant_return,transform2d)
	BOOL_VAL_PTR(t,true)	
}


get_transform2_component :: #force_inline proc(t,component,variant_return: ^Value, has_error: ^bool, call_error_p: ^ObjectCallError)
{

	transform2d    := AS_TRANSFORM2_DATA_PTR(t)
	sym_indx 	   := AS_SYMID_PTR(component)
	
	property_name := get_symbol_str_BD(sym_indx)

	switch property_name
	{
		case "x"       : VECTOR2_VAL_PTR(variant_return,&transform2d[0]); return
		case "y"       : VECTOR2_VAL_PTR(variant_return,&transform2d[1]); return
		case "origin"  : VECTOR2_VAL_PTR(variant_return,&transform2d[2]); return
		case    : 
			CALL_ERROR_STRING(call_error_p,"cannot find property '",property_name,"' on base  '",GET_TYPE_NAME(t),"'.")
			has_error^ = true
			return
	}
}

get_package_field :: #force_inline proc(pack,field,variant_return: ^Value, has_error: ^bool, call_error_p: ^ObjectCallError) {
	id     := AS_IMPORT_BD_ID_PTR(pack)
    getter := get_getter_importID(id)
	getter(id,field,variant_return,has_error,call_error_p)
}

set_package_field :: #force_inline proc(pack,field,variant_return: ^Value, has_error: ^bool, call_error_p: ^ObjectCallError) {
	id     := AS_IMPORT_BD_ID_PTR(pack)
	setter := get_setter_importID(id)
	setter(id,field,variant_return,has_error,call_error_p)
	BOOL_VAL_PTR(pack,true)
}
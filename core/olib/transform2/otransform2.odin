#+private

package OScriptTransform2D

import fmt "core:fmt"


error_msg :: proc(fn_name: string, expected,argc: Int,be: string ,call_error_p: ^ObjectCallError) {
	CALL_ERROR_STRING(call_error_p,"'",fn_name,"' function expects '",expected,"' args, but got ",argc,", and the argument must be ",be,".")
}

error_msg0 :: proc(fn_name: string, expected,argc: Int ,call_error_p: ^ObjectCallError) {
	CALL_ERROR_STRING(call_error_p,"'",fn_name,"' function expects '",expected,"' args, but got ",argc,".")
}


basis_xform_inv :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError){
	
	if argc != 1 || !IS_VECTOR2D_PTR(&args[0]) {
		when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("basis_xform_inv",1,argc,"Vector2",call_error_p)
		return
	}
	
	t := AS_TRANSFORM2_DATA_PTR(&args[argc])
	v := AS_VECTOR2_PTR(&args[0])
	r := #force_inline _basis_xform_inv(t,v)

	VECTOR2_VAL_PTR(result,&r)
}

basis_xform :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError){

	if argc != 1 || !IS_VECTOR2D_PTR(&args[0]) {
		when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("basis_xform",1,argc,"Vector2",call_error_p)
		return
	}
	
	t := AS_TRANSFORM2_DATA_PTR(&args[argc])
	v := AS_VECTOR2_PTR(&args[0])
	r := #force_inline _basis_xform(t,v)

	VECTOR2_VAL_PTR(result,&r)
}

determinant :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError){

	if argc != 0 { 
		when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("determinant",0,argc,call_error_p)
		return
	}
	
	t := AS_TRANSFORM2_DATA_PTR(&args[argc])
	FLOAT_VAL_PTR(result, #force_inline _basis_determinant(t))
}

xform :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError){
	
	if argc != 1 || !IS_VECTOR2D_PTR(&args[0]) {
		when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("xform",1,argc,"Vector2",call_error_p)
		return
	}
	
	t := AS_TRANSFORM2_DATA_PTR(&args[argc])
	v := AS_VECTOR2_PTR(&args[0])
	r := #force_inline _xform(t,v)

	VECTOR2_VAL_PTR(result,&r)
}

xform_inv :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError){
	
	if argc != 1 || !IS_VECTOR2D_PTR(&args[0]) {
		when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("xform_inv",1,argc,"Vector2",call_error_p)
		return
	}
	
	t := AS_TRANSFORM2_DATA_PTR(&args[argc])
	v := AS_VECTOR2_PTR(&args[0])
	r := #force_inline _xform_inv(t,v)

	VECTOR2_VAL_PTR(result,&r)
}

xform_rect :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError){
	
	if argc != 1 || !IS_RECT2_PTR(&args[0]) {
		when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("xform_rect",1,argc,"Rect2",call_error_p)
		return
	}
	
	o : Rect2
	t := AS_TRANSFORM2_DATA_PTR(&args[argc])
	r := AS_RECT2_PTR(&args[0])

	#force_inline _xform_rect(t,r,&o)
	RECT2_VAL_PTR(result,&o)
}


// get_ox_rotation :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError){
	
// 	if argc != 0 { 
// 		when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("determinant",0,argc,call_error_p)
// 		return
// 	}
	
// 	t := VAL_AS_TRANSFORM2_DATA_PTR(&args[argc])
// 	NUMBER_VAL_PTR(result,_get_rotation_ox(t))
// }

// get_oy_rotation :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError){
	
// 	argc := argc-1

// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 0 { 
// 		CALL_ERROR_STRING(call_error_p," 'get_oy_rotation' function expects '0' arg, but got ",argc,".")
// 		return
// 	}
	
// 	t := VAL_AS_TRANSFORM2_DATA_PTR(&args[argc])
// 	NUMBER_VAL_PTR(result,_get_rotation_oy(t))
// }

// get_origin :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError){
	
// 	argc := argc-1

// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 0 { 
// 		CALL_ERROR_STRING(call_error_p," 'get_origin' function expects '0' arg, but got ",argc,".")
// 		return
// 	}
	
// 	t := VAL_AS_TRANSFORM2_DATA_PTR(&args[argc])
// 	r := _get_origin(t)
// 	VECTOR2_VAL_PTR(result,&r)
// }

// get_scale :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError){
	
// 	argc := argc-1

// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 0 { 
// 		CALL_ERROR_STRING(call_error_p," 'get_scale' function expects '0' arg, but got ",argc,".")
// 		return
// 	}
	
// 	t := VAL_AS_TRANSFORM2_DATA_PTR(&args[argc])
// 	r := _get_scale(t)
// 	VECTOR2_VAL_PTR(result,&r)
// }

get_inverse :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError){
	
	if argc != 0 { 
		when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("get_inverse",0,argc,call_error_p)
		return
	}

	from    := AS_TRANSFORM2_DATA_PTR(&args[argc])
	inverse := create_transform2_no_data_ptr()

	#force_inline _inverse(from,&inverse.data)
	OBJECT_VAL_PTR(result,inverse,.OBJ_TRANSFORM2)
}

// move_toward :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError){
	
// 	argc   := argc-1
// 	dt     : Float

// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 2 || !IS_VECTOR2D_PTR(&args[0]) || !IS_NUMERIC_PTR(&args[1],&dt)  { 
// 		CALL_ERROR_STRING(call_error_p," 'move_toward' function expects '2' arg, but got ",argc," and the argument must be '",TYPE_TO_STRING(.VECTOR2_VAL),"' and '",TYPE_TO_STRING(.NUMBER_VAL),"'.")
// 		return
// 	}

// 	from    := VAL_AS_TRANSFORM2_DATA_PTR(&args[argc])
// 	to      := AS_VECTOR2_PTR(&args[0])

// 	_move_toward(from,to,dt)
// 	NIL_VAL_PTR(result)
// }

orthonormalize :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError){
	
	if argc != 0 { 
		when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("orthonormalize",0,argc,call_error_p)
		return
	}

	from  := AS_TRANSFORM2_DATA_PTR(&args[argc])
	o     := create_transform2_no_data_ptr()

	#force_inline _orthonormalize(from,&o.data)
	OBJECT_VAL_PTR(result,o,.OBJ_TRANSFORM2)
}

rotated :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError){
	
	theta : Float

	if argc != 1 || !IS_FLOAT_CAST_PTR(&args[0],&theta) {
		when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("rotated",1,argc,"float",call_error_p)
		return
	}

	t  := AS_TRANSFORM2_DATA_PTR(&args[argc])
	o  := create_transform2_no_data_ptr()

	#force_inline _rotated(t,&o.data,theta)
	OBJECT_VAL_PTR(result,o,.OBJ_TRANSFORM2)	
	
}


// rotate :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError){
	
// 	argc  := argc-1
// 	theta : Float

// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 1 || !IS_NUMERIC_PTR(&args[0],&theta) { 
// 		CALL_ERROR_STRING(call_error_p," 'rotate' function expects '1' arg, but got ",argc," and the argument must be a '",TYPE_TO_STRING(.NUMBER_VAL),"'.")
// 		return
// 	}

// 	t  := VAL_AS_TRANSFORM2_DATA_PTR(&args[argc])
// 	_rotate(t,theta)

// 	NIL_VAL_PTR(result)	
// }

// set_rotation :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError){
	
// 	argc  := argc-1
// 	theta : Float

// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 1 || !IS_NUMERIC_PTR(&args[0],&theta) { 
// 		CALL_ERROR_STRING(call_error_p," 'set_rotation' function expects '1' arg, but got ",argc," and the argument must be a '",TYPE_TO_STRING(.NUMBER_VAL),"'.")
// 		return
// 	}

// 	t  := VAL_AS_TRANSFORM2_DATA_PTR(&args[argc])
// 	_set_rotation(t,theta)

// 	NIL_VAL_PTR(result)	
// }

// set_rotation_no_origin :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError){
	
// 	argc  := argc-1
// 	theta : Float

// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 1 || !IS_NUMERIC_PTR(&args[0],&theta) { 
// 		CALL_ERROR_STRING(call_error_p," 'set_rotation_no_origin' function expects '1' arg, but got ",argc," and the argument must be a '",TYPE_TO_STRING(.NUMBER_VAL),"'.")
// 		return
// 	}

// 	t  := VAL_AS_TRANSFORM2_DATA_PTR(&args[argc])
// 	_set_rotation_no_origin(t,theta)

// 	NIL_VAL_PTR(result)	
// }

// set_identity :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError){
	
// 	argc  := argc-1

// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 0  { 
// 		CALL_ERROR_STRING(call_error_p," 'set_identity' function expects '0' arg, but got ",argc,".")
// 		return
// 	}

// 	t  := VAL_AS_TRANSFORM2_DATA_PTR(&args[argc])
// 	_set_identity(t)
// 	NIL_VAL_PTR(result)	
// }

// set_scale :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError){
	
// 	argc  := argc-1
// 	scale : Float

// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 1 || !IS_NUMERIC_PTR(&args[0],&scale) { 
// 		CALL_ERROR_STRING(call_error_p," 'set_scale' function expects '1' arg, but got ",argc," and the argument must be a '",TYPE_TO_STRING(.NUMBER_VAL),"'.")
// 		return
// 	}

// 	t  := VAL_AS_TRANSFORM2_DATA_PTR(&args[argc])
// 	_set_scale(t,scale)

// 	NIL_VAL_PTR(result)	
// }

scaled :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError){
	
	scale : Float

	 if argc != 1 || !IS_FLOAT_CAST_PTR(&args[0],&scale) { 
	 	when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("scaled",1,argc,"float",call_error_p)
	 	return
	}

	t  := AS_TRANSFORM2_DATA_PTR(&args[argc])
	o  := create_transform2_no_data_ptr()

	#force_inline _scaled(t,&o.data,scale)
	OBJECT_VAL_PTR(result,o,.OBJ_TRANSFORM2)	
}


// relative :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError){
	
// 	argc  := argc-1

// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 1 || !IS_TRANSFORM2_PTR(&args[0]) { 
// 		CALL_ERROR_STRING(call_error_p," 'relactive' function expects '1' arg, but got ",argc," and the argument must be a '",TYPE_TO_STRING(.OBJ_TRANSFORM2),"'.")
// 		return
// 	}

// 	t  := VAL_AS_TRANSFORM2_DATA_PTR(&args[argc])
// 	r  := VAL_AS_TRANSFORM2_DATA_PTR(&args[0])
// 	o  := create_transform2_no_data_ptr()

// 	_relative(t,r,&o.data)
// 	OBJECT_VAL_PTR(result,o,.OBJ_TRANSFORM2)	
// }




// translate :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError){
	
// 	argc := argc-1

// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 1 || !IS_VECTOR2D_PTR(&args[0]) { 
// 		CALL_ERROR_STRING(call_error_p," 'translate' function expects '1' arg, but got ",argc," and the argument must be a '",TYPE_TO_STRING(.VECTOR2_VAL),"'.")
// 		return
// 	}
	
// 	t := VAL_AS_TRANSFORM2_DATA_PTR(&args[argc])
// 	v := AS_VECTOR2_PTR(&args[0])
// 	_translate(t,v)

// 	NIL_VAL_PTR(result)
// }

// translate_inv :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError){
	
// 	argc := argc-1

// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 1 || !IS_VECTOR2D_PTR(&args[0]) { 
// 		CALL_ERROR_STRING(call_error_p," 'translate_inv' function expects '1' arg, but got ",argc," and the argument must be a '",TYPE_TO_STRING(.VECTOR2_VAL),"'.")
// 		return
// 	}
	
// 	t := VAL_AS_TRANSFORM2_DATA_PTR(&args[argc])
// 	v := AS_VECTOR2_PTR(&args[0])
// 	_translate_inv(t,v)

// 	NIL_VAL_PTR(result)
// }

translated :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError){
	

	if argc != 1 || !IS_VECTOR2D_PTR(&args[0]) { 
	 	when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("translated",1,argc,"Vector2",call_error_p)
		return
	}
	
	t := AS_TRANSFORM2_DATA_PTR(&args[argc])
	o := create_transform2_no_data_ptr()

	v := AS_VECTOR2_PTR(&args[0])
	#force_inline _translated(t,&o.data,v)

	OBJECT_VAL_PTR(result,o,.OBJ_TRANSFORM2)
}

// translate_no_relactive :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError){
	
// 	argc := argc-1

// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 1 || !IS_VECTOR2D_PTR(&args[0]) { 
// 		CALL_ERROR_STRING(call_error_p," 'translate_no_relactive' function expects '1' arg, but got ",argc," and the argument must be a '",TYPE_TO_STRING(.VECTOR2_VAL),"'.")
// 		return
// 	}
	
// 	t := VAL_AS_TRANSFORM2_DATA_PTR(&args[argc])
// 	v := AS_VECTOR2_PTR(&args[0])

// 	_translateV_no_relactive(t,v)
// 	NIL_VAL_PTR(result)
// }
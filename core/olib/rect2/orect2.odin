#+private

package OScriptRect2D

// abs :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
// {
// 	argc := argc-1

// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 0 { 
// 		CALL_ERROR_STRING(call_error_p," 'abs' function expects '0' arg, but got ",argc,".")
// 		return
// 	}


// 	rect    : Rect2
// 	rect2_0 := AS_RECT2_PTR(&args[argc])

// 	_abs(rect2_0,&rect)
// 	RECT2_VAL_PTR(result,&rect)
// }

// distance_to :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
// {
// 	argc := argc-1

// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 1 || !IS_VECTOR2D_PTR(&args[0]) { 
// 		CALL_ERROR_STRING(call_error_p," 'distance_to' function expects '1' arg, but got ",argc,
// 			" and the argument must be a ",TYPE_TO_STRING(.VECTOR2_VAL)," .")
// 		return
// 	}

// 	rect2_0  := AS_RECT2_PTR(&args[argc])
// 	pos_p    := AS_VECTOR2_PTR(&args[0])
// 	distance : Float

// 	_distance_to(rect2_0,pos_p,&distance)
// 	NUMBER_VAL_PTR(result,distance)
// }

// encloses :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
// {
// 	argc := argc-1

// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 1 || !IS_RECT2_PTR(&args[0]) { 
// 		CALL_ERROR_STRING(call_error_p," 'encloses' function expects '1' arg, but got ",argc,
// 			" and the argument must be a ",TYPE_TO_STRING(.RECT2_VAL)," .")
// 		return
// 	}

// 	rect2_0  := AS_RECT2_PTR(&args[argc])
// 	rect2_1  := AS_RECT2_PTR(&args[0])


// 	ok : bool
// 	_encloses(rect2_0,rect2_1,&ok)
// 	BOOL_VAL_PTR(result,ok)
// }

// expand :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
// {
// 	argc := argc-1

// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 1 || !IS_VECTOR2D_PTR(&args[0]) { 
// 		CALL_ERROR_STRING(call_error_p," 'expand' function expects '1' arg, but got ",argc,
// 			" and the argument must be a ",TYPE_TO_STRING(.VECTOR2_VAL)," .")
// 		return
// 	}

// 	rect    : Rect2
// 	rect2_0  := AS_RECT2_PTR(&args[argc])
// 	pos_p    := AS_VECTOR2_PTR(&args[0])
	
// 	_expand(rect2_0,&rect,pos_p)
// 	RECT2_VAL_PTR(result,&rect)

// }

// get_center :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
// {
// 	argc := argc-1

// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 0 { 
// 		CALL_ERROR_STRING(call_error_p," 'get_center' function expects '0' arg, but got ",argc," .")
// 		return
// 	}

// 	v        : Vec2
// 	rect2_0  := AS_RECT2_PTR(&args[argc])
// 	_get_center(rect2_0,&v)

// 	VECTOR2_VAL_PTR(result,&v)

// }

// get_area :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
// {
// 	argc := argc-1

// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 0 { 
// 		CALL_ERROR_STRING(call_error_p," get_area' function expects '0' arg, but got ",argc," .")
// 		return
// 	}

// 	rect2_0  := AS_RECT2_PTR(&args[argc])
// 	o        : Float
// 	_get_area(rect2_0,&o)

// 	NUMBER_VAL_PTR(result,o)

// }

// grow :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
// {
// 	argc   := argc-1
// 	offset : Float

// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 1 || !IS_NUMERIC_PTR(&args[0],&offset) { 
// 		CALL_ERROR_STRING(call_error_p," 'grow' function expects '1' arg, but got ",argc,
// 			" and the argument must be a ",TYPE_TO_STRING(.NUMBER_VAL)," .")
// 		return
// 	}

// 	rect    : Rect2
// 	rect2_0  := AS_RECT2_PTR(&args[argc])
	
// 	_grow(rect2_0,&rect,&offset)
// 	RECT2_VAL_PTR(result,&rect)

// }

// grow_individual :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
// {
// 	argc    := argc-1
// 	offsets : [4]Float

// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do for i in 0..<4 do if argc != 4 || !IS_NUMERIC_PTR(&args[i],&offsets[i]) { 
// 		CALL_ERROR_STRING(call_error_p," 'grow_individual' function expects '4' arg, but got ",argc,
// 			" and the argument must be a ",TYPE_TO_STRING(.NUMBER_VAL)," .")
// 		return
// 	}

// 	rect    : Rect2
// 	rect2_0  := AS_RECT2_PTR(&args[argc])
	
// 	_grow_individual(rect2_0,&rect,&offsets)
// 	RECT2_VAL_PTR(result,&rect)

// }

// has_point :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
// {
// 	argc := argc-1

// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 1 || !IS_VECTOR2D_PTR(&args[0]) { 
// 		CALL_ERROR_STRING(call_error_p," 'has_point' function expects '1' arg, but got ",argc,
// 			" and the argument must be a ",TYPE_TO_STRING(.VECTOR2_VAL)," .")
// 		return
// 	}

// 	has      : bool
// 	rect2_0  := AS_RECT2_PTR(&args[argc])
// 	pos_p    := AS_VECTOR2_PTR(&args[0])
	
// 	_has_point(rect2_0,pos_p,&has)
// 	BOOL_VAL_PTR(result,has)

// }

// has_no_area :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
// {
// 	argc := argc-1

// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 0 { 
// 		CALL_ERROR_STRING(call_error_p," 'has_no_area' function expects '0' arg, but got ",argc," .")
// 		return
// 	}

// 	has      : bool
// 	rect2_0  := AS_RECT2_PTR(&args[argc])
	
// 	_has_no_area(rect2_0,&has)
// 	BOOL_VAL_PTR(result,has)
// }


// intersects :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
// {
// 	argc := argc-1

// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 1 || !IS_RECT2_PTR(&args[0]) { 
// 		CALL_ERROR_STRING(call_error_p," 'intersects' function expects '1' arg, but got ",argc,
// 			" and the argument must be a ",TYPE_TO_STRING(.RECT2_VAL)," .")
// 		return
// 	}

// 	rect2_0  := AS_RECT2_PTR(&args[argc])
// 	rect2_1  := AS_RECT2_PTR(&args[0])

// 	BOOL_VAL_PTR(result,_intersects(rect2_0,rect2_1))
// }

// merge :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
// {
// 	argc := argc-1

// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 1 || !IS_RECT2_PTR(&args[0]) { 
// 		CALL_ERROR_STRING(call_error_p," 'merge' function expects '1' arg, but got ",argc,
// 			" and the argument must be a ",TYPE_TO_STRING(.RECT2_VAL)," .")
// 		return
// 	}

// 	rect     : Rect2
// 	rect2_0  := AS_RECT2_PTR(&args[argc])
// 	rect2_1  := AS_RECT2_PTR(&args[0])

// 	_merge(rect2_0,rect2_1,&rect)

// 	RECT2_VAL_PTR(result,&rect)
// }


// clip :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
// {
// 	argc := argc-1

// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 1 || !IS_RECT2_PTR(&args[0]) { 
// 		CALL_ERROR_STRING(call_error_p," 'clip' function expects '1' arg, but got ",argc,
// 			" and the argument must be a ",TYPE_TO_STRING(.RECT2_VAL)," .")
// 		return
// 	}

// 	rect     : Rect2
// 	rect2_0  := AS_RECT2_PTR(&args[argc])
// 	rect2_1  := AS_RECT2_PTR(&args[0])

// 	_clip(rect2_0,rect2_1,&rect)
// 	RECT2_VAL_PTR(result,&rect)
// }
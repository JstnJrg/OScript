#+private

package OScriptTransform2D


error_msg :: proc(fn_name: string, expected: Int, be: string ,call_state: ^CallState) {
	CALL_ERROR_STRING(&call_state.error_bf,"'",fn_name,"' function expects '",expected,"' args, but got ",call_state.argc,", and the argument must be ",be,".")
	call_state.has_error = true
}

error_msg0 :: proc(fn_name: string, expected : Int ,call_state: ^CallState) { 
	CALL_ERROR_STRING(&call_state.error_bf,"'",fn_name,"' function expects '",expected,"' args, but got ",call_state.argc,".") 
	call_state.has_error = true
}

error      :: proc(msg: string ,call_state: ^CallState) { CALL_ERROR_STRING(&call_state.error_bf,msg); call_state.has_error = true    }
warning    :: proc(msg: string ,call_state: ^CallState) { CALL_WARNING_STRING(&call_state.error_bf,msg); call_state.has_warning = true }




basis_xform_inv :: proc(call_state: ^CallState)
{
	if call_state.argc != 1 || !IS_VECTOR2D_PTR(&call_state.args[0]) { error_msg("basis_xform_inv",1,"Vector2",call_state); return }
	
	t := AS_TRANSFORM2_PTR(&call_state.args[1])
	v := AS_VECTOR2_PTR(&call_state.args[0])
	r := #force_inline _basis_xform_inv(t,v)

	VECTOR2_VAL_PTR(call_state.result,&r)
}

basis_xform :: proc(call_state: ^CallState)
{
	if call_state.argc != 1 || !IS_VECTOR2D_PTR(&call_state.args[0]) { error_msg("basis_xform",1,"Vector2",call_state); return }
	
	t := AS_TRANSFORM2_PTR(&call_state.args[1])
	v := AS_VECTOR2_PTR(&call_state.args[0])
	r := #force_inline _basis_xform(t,v)

	VECTOR2_VAL_PTR(call_state.result,&r)
}

determinant :: proc(call_state: ^CallState)
{
	if call_state.argc != 0 { error_msg0("determinant",0,call_state); return }	
	t := AS_TRANSFORM2_PTR(&call_state.args[0])
	FLOAT_VAL_PTR(call_state.result, #force_inline _basis_determinant(t))
}

xform :: proc(call_state: ^CallState)
{
	if call_state.argc != 1 || !IS_VECTOR2D_PTR(&call_state.args[0]) { error_msg("xform",1,"Vector2",call_state); return }
	
	t := AS_TRANSFORM2_PTR(&call_state.args[1])
	v := AS_VECTOR2_PTR(&call_state.args[0])
	r := #force_inline _xform(t,v)

	VECTOR2_VAL_PTR(call_state.result,&r)
}

xform_inv :: proc(call_state: ^CallState)
{
	if call_state.argc != 1 || !IS_VECTOR2D_PTR(&call_state.args[0]) { error_msg("xform_inv",1,"Vector2",call_state); return }
	
	t := AS_TRANSFORM2_PTR(&call_state.args[1])
	v := AS_VECTOR2_PTR(&call_state.args[0])
	r := #force_inline _xform_inv(t,v)

	VECTOR2_VAL_PTR(call_state.result,&r)
}

xform_rect :: proc(call_state: ^CallState)
{
	if call_state.argc != 1 || !IS_RECT2_PTR(&call_state.args[0]) { error_msg("xform_rect",1,"Rect2",call_state); return }
	
	o : Rect2
	t := AS_TRANSFORM2_PTR(&call_state.args[1])
	r := AS_RECT2_PTR(&call_state.args[0])

	#force_inline _xform_rect(t,r,&o)
	RECT2_VAL_PTR(call_state.result,&o)
}

get_inverse :: proc(call_state: ^CallState)
{
	if call_state.argc != 0 { error_msg0("get_inverse",0,call_state); return }

	from    := AS_TRANSFORM2_PTR(&call_state.args[0])
	to      : mat2x3

	#force_inline _inverse(from,&to)
	TRANSFORM2_MVAL_PTR(call_state.result,&to)
}

orthonormalized :: proc(call_state: ^CallState)
{
	if call_state.argc != 0 { error_msg0("orthonormalized",0,call_state); return }

	from  := AS_TRANSFORM2_PTR(&call_state.args[0])
	to    : mat2x3

	#force_inline _orthonormalize(from,&to)
	TRANSFORM2_MVAL_PTR(call_state.result,&to)
}


rotated :: proc(call_state: ^CallState)
{
	theta : Float
	if call_state.argc != 1 || !IS_FLOAT_CAST_PTR(&call_state.args[0],&theta) { error_msg("rotated",1,"float",call_state); return }

	t  := AS_TRANSFORM2_PTR(&call_state.args[1])
	o  :  mat2x3

	#force_inline _rotated(t,&o,theta)
	TRANSFORM2_MVAL_PTR(call_state.result,&o,false)		
}

scaled :: proc(call_state: ^CallState)
{
	 if call_state.argc != 1 || !IS_VECTOR2D_PTR(&call_state.args[0]) { error_msg("scaled",1,"Vector2",call_state); return }

	t  := AS_TRANSFORM2_PTR(&call_state.args[1])
	s  := AS_VECTOR2_PTR(&call_state.args[0])
	o  :  mat2x3

	#force_inline _scaledV(t,&o,s)
	TRANSFORM2_MVAL_PTR(call_state.result,&o)	
}

translated :: proc(call_state: ^CallState)
{
	if call_state.argc != 1 || !IS_VECTOR2D_PTR(&call_state.args[0]) { error_msg("translated",1,"Vector2",call_state); return }
	
	t  := AS_TRANSFORM2_PTR(&call_state.args[1])
	v  := AS_VECTOR2_PTR(&call_state.args[0])
	o  :  mat2x3

	#force_inline _translated(t,&o,v)
	TRANSFORM2_MVAL_PTR(call_state.result,&o)	
}

affine_inverse :: proc(call_state: ^CallState)
{
	if call_state.argc != 0 { error_msg0("translated",0,call_state); return }
	
	t  := AS_TRANSFORM2_PTR(&call_state.args[0])
	o  :  mat2x3

	det_is_zero := #force_inline _affine_inverse(t,&o)
	if det_is_zero do warning(" condition det != 0.0 is false.",call_state)

	TRANSFORM2_MVAL_PTR(call_state.result,&o,false)	
}
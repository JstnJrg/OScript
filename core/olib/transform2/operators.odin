#+private

package OScriptTransform2D


register_transform2_operators :: proc(){

	register_op(.OP_MULT ,.TRANSFORM2_VAL,.TRANSFORM2_VAL,evaluate_tran2_tran2_mult)
	register_op(.OP_MULT ,.TRANSFORM2_VAL,.INT_VAL,evaluate_tran2_int_mult)
	register_op(.OP_MULT ,.TRANSFORM2_VAL,.FLOAT_VAL,evaluate_tran2_float_mult)
	register_op(.OP_MULT ,.TRANSFORM2_VAL,.VECTOR2_VAL,evaluate_tran2_vec2_mult)
	register_op(.OP_MULT ,.VECTOR2_VAL,.TRANSFORM2_VAL,evaluate_vec2_tran2_mult)

	register_op(.OP_MULT ,.TRANSFORM2_VAL,.RECT2_VAL,evaluate_tran2_rect2_mult)
	register_op(.OP_MULT ,.RECT2_VAL,.TRANSFORM2_VAL,evaluate_tran2_rect2_mult)

	register_op(.OP_EQUAL,.TRANSFORM2_VAL,.TRANSFORM2_VAL,evaluate_tran2_tran2_equal)
	register_op(.OP_NOT_EQUAL,.TRANSFORM2_VAL,.TRANSFORM2_VAL,evaluate_tran2_tran2_not_equal)
}


evaluate_tran2_tran2_mult :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, _: ^bool,call_error: ^ObjectCallError)
{
	// r  := create_transform2_no_data_ptr()

	t0 := AS_TRANSFORM2_PTR(variant_left)
	t1 := AS_TRANSFORM2_PTR(variant_right)

	o  :  mat2x3
	
	temp  := t1[2] 
	o[2]   = _xform(t0,&temp)
	
	x0 := mult_x(t0,&t1[0])
	x1 := mult_y(t0,&t1[0])

	y0 := mult_x(t0,&t1[1])
	y1 := mult_y(t0,&t1[1])

	o[0,0] = x0
	o[1,0] = x1
	o[0,1] = y0
	o[1,1] = y1



	TRANSFORM2_MVAL_PTR(variant_return,&o,false)	
}


evaluate_tran2_int_mult :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, _: ^bool,call_error: ^ObjectCallError)
{
	t0 := AS_TRANSFORM2_PTR(variant_left)
	s  := Float(AS_INT_PTR(variant_right))
	o  :  mat2x3
	
	o[0] = t0[0]*s
	o[1] = t0[1]*s
	o[2] = t0[2]*s

	TRANSFORM2_MVAL_PTR(variant_return,&o)	
}

evaluate_tran2_float_mult :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, _: ^bool,call_error: ^ObjectCallError)
{
	t0 := AS_TRANSFORM2_PTR(variant_left)
	s  := AS_FLOAT_PTR(variant_right)
	o  :  mat2x3
	
	o[0] = t0[0]*s
	o[1] = t0[1]*s
	o[2] = t0[2]*s

	TRANSFORM2_MVAL_PTR(variant_return,&o)	
}


evaluate_tran2_tran2_equal :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, _: ^bool,call_error: ^ObjectCallError)
{
	t0 := AS_TRANSFORM2_PTR(variant_left)
	t1 := AS_TRANSFORM2_PTR(variant_right)
	eq := true
	
	for i in 0..<3 do if t0[i] != t1[i] { eq = false; break }
	BOOL_VAL_PTR(variant_return,eq)
}

evaluate_tran2_tran2_not_equal :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, _: ^bool,call_error: ^ObjectCallError)
{
	t0 := AS_TRANSFORM2_PTR(variant_left)
	t1 := AS_TRANSFORM2_PTR(variant_right)
	nq := false
	
	for i in 0..<3 do if t0[i] != t1[i] { nq = true; break }

	BOOL_VAL_PTR(variant_return,nq)
}

evaluate_tran2_vec2_mult :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, _: ^bool,call_error: ^ObjectCallError)
{
	t  := AS_TRANSFORM2_PTR(variant_left)
	v  := AS_VECTOR2_PTR(variant_right)

	r := (#force_inline _xform(t,v))
	VECTOR2_VAL_PTR(variant_return,&r)
}

evaluate_vec2_tran2_mult :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, _: ^bool,call_error: ^ObjectCallError)
{
	t  := AS_TRANSFORM2_PTR(variant_right)
	v  := AS_VECTOR2_PTR(variant_left)

	r := (#force_inline _xform_inv(t,v))
	VECTOR2_VAL_PTR(variant_return,&r)
}

evaluate_tran2_rect2_mult :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, _: ^bool,call_error: ^ObjectCallError)
{
	t  := AS_TRANSFORM2_PTR(variant_left)
	r  := AS_RECT2_PTR(variant_right)
	
	o : Rect2
	#force_inline _xform_rect(t,r,&o)
	RECT2_VAL_PTR(variant_return,&o)
}

evaluate_rect2_tran2_mult :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, _: ^bool,call_error: ^ObjectCallError)
{
	t  := AS_TRANSFORM2_PTR(variant_right)
	it : mat2x3

	r  := AS_RECT2_PTR(variant_left)
	o  : Rect2
	
	#force_inline _affine_inverse(t,&it)
	#force_inline _xform_rect(&it,r,&o)

	RECT2_VAL_PTR(variant_return,&o)
}

package OscriptMath


register_operators :: proc(){
	register_op(.OP_MULT_MULT,.FLOAT_VAL,.FLOAT_VAL,evaluate_float_float_mult_mult)
	register_op(.OP_MULT_MULT,.INT_VAL,.INT_VAL,evaluate_int_int_mult_mult)
	register_op(.OP_MULT_MULT,.INT_VAL,.FLOAT_VAL,evaluate_int_float_mult_mult)
	register_op(.OP_MULT_MULT,.FLOAT_VAL,.INT_VAL,evaluate_float_int_mult_mult)
}


evaluate_float_float_mult_mult :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error_p: ^ObjectCallError){
	FLOAT_VAL_PTR(variant_return,math.pow(AS_FLOAT_PTR(variant_left),AS_FLOAT_PTR(variant_right)))
}

evaluate_int_int_mult_mult :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error: ^ObjectCallError){
	b := AS_INT_PTR(variant_left)
	n := AS_INT_PTR(variant_right)
	FLOAT_VAL_PTR(variant_return,math.pow(Float(b),Float(n)))
}


evaluate_float_int_mult_mult :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error: ^ObjectCallError){
	FLOAT_VAL_PTR(variant_return,math.pow(AS_FLOAT_PTR(variant_left),Float(AS_INT_PTR(variant_right))))
}

evaluate_int_float_mult_mult :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error: ^ObjectCallError){
	FLOAT_VAL_PTR(variant_return,math.pow(Float(AS_INT_PTR(variant_left)),AS_FLOAT_PTR(variant_right)))
}



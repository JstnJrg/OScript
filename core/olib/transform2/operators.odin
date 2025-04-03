#+private

package OScriptTransform2D


register_transform2_operators :: proc(){

	register_op(.OP_MULT,.OBJ_TRANSFORM2,.OBJ_TRANSFORM2,evaluate_tran2_tran2_mult)
}




evaluate_tran2_tran2_mult :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, _: ^bool,call_error: ^ObjectCallError)
{
	r  := create_transform2_no_data_ptr()

	t  := AS_TRANSFORM2_DATA_PTR(variant_left)
	t1 := AS_TRANSFORM2_DATA_PTR(variant_right)
	tr := &r.data
	
	x0 := mult_x(t,&t1[0])
	x1 := mult_y(t,&t1[0])

	y0 := mult_x(t,&t1[1])
	y1 := mult_y(t,&t1[1])

	tr[0,0] = x0
	tr[1,0] = x1
	tr[0,1] = y0
	tr[1,1] = y1

	tr[2]   = t[2]

	OBJECT_VAL_PTR(variant_return,r,.OBJ_TRANSFORM2)
}





// evaluate_int_int_mult :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error: ^ObjectCallError){
// 	INT_VAL_PTR(variant_return,AS_INT_PTR(variant_left)*AS_INT_PTR(variant_right))
// }
package OscriptArray

register_array_operators :: proc() {
	register_op(.OP_EQUAL,.OBJ_ARRAY,.OBJ_ARRAY,evaluate_array_array_equal)
}


evaluate_array_array_equal :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, _: ^bool,call_error: ^ObjectCallError)
{
    arr0   := VAL_AS_OBJ_ARRAY_PTR(variant_left)
    _p0    := &arr0.data

    arr1   := VAL_AS_OBJ_ARRAY_PTR(variant_right)
    _p1    := &arr1.data

    if arr0     == arr1     { BOOL_VAL_PTR(variant_return,true); return }
    if arr0.len != arr1.len { BOOL_VAL_PTR(variant_return,false); return }

    BOOL_VAL_PTR(variant_return,value_hash_compare(variant_left,variant_right,0))
}
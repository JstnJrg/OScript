#+private

package OscriptTime


error_msg :: proc(fn_name: string, expected,argc: Int,be: string ,call_error_p: ^ObjectCallError) {
	CALL_ERROR_STRING(call_error_p,"'",fn_name,"' function expects '",expected,"' args, but got ",argc,", and the argument must be ",be,".")
}

error_msg0 :: proc(fn_name: string, expected,argc: Int ,call_error_p: ^ObjectCallError) {
	CALL_ERROR_STRING(call_error_p,"'",fn_name,"' function expects '",expected,"' args, but got ",argc,".")
}


start :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError){
	if argc != 0 { when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("start",0,argc,call_error_p); return }
	NIL_VAL_PTR(result)
}

get_tick_ms :: proc(argc: Int, _: []Value, result : ^Value, call_error_p : ^ObjectCallError) {
	if argc != 0 { when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("get_tick_ms",0,argc,call_error_p); return }
	INT_VAL_PTR(result,#force_inline _get_tick_ms())
}

get_tick_ns :: proc(argc: Int, _: []Value, result : ^Value, call_error_p : ^ObjectCallError) {
if argc != 0 { when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("get_tick_ns",0,argc,call_error_p); return }
	INT_VAL_PTR(result,#force_inline _get_tick_ns())
}


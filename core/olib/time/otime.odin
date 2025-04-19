#+private

package OscriptTime

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



start :: proc(call_state: ^CallState)
{
	if call_state.argc != 0 { error_msg0("start",0,call_state); return }
	NIL_VAL_PTR(call_state.result)
}

get_tick_ms :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("get_tick_ms",0,call_state); return }
	INT_VAL_PTR(call_state.result,#force_inline _get_tick_ms())
}

get_tick_ns :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("get_tick_ns",0,call_state); return }
	INT_VAL_PTR(call_state.result,#force_inline _get_tick_ns())
}


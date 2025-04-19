#+private

package OscriptColor


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


get_luminance :: proc(call_state: ^CallState)
{
	if call_state.argc != 0 { error_msg0("get_luminance",0,call_state); return }
	
	color_p := AS_COLOR_PTR(&call_state.args[0])
	r       := _get_luminance(color_p)

	INT_VAL_PTR(call_state.result,Int(r))
}

darkened      :: proc(call_state: ^CallState)
{
	amount : Float
	if call_state.argc != 1 || !IS_FLOAT_CAST_PTR(&call_state.args[0],&amount){ error_msg("darkened",1,"a number",call_state); return }
	
	color_p := AS_COLOR_PTR(&call_state.args[1])
	r       := _darkened(color_p,&amount)

	COLOR_VAL_PTR(call_state.result,&r)
}

lightened     :: proc(call_state: ^CallState)
{
	amount : Float
	if call_state.argc != 1 || !IS_FLOAT_CAST_PTR(&call_state.args[0],&amount){ error_msg("lightened",1,"a number",call_state); return }
	
	color_p := AS_COLOR_PTR(&call_state.args[1])
	r       := _lightened(color_p,&amount)

	COLOR_VAL_PTR(call_state.result,&r)
}

lerp     :: proc(call_state: ^CallState)
{
	amount : Float
	if call_state.argc != 2 || !IS_COLOR_PTR(&call_state.args[0]) || !IS_FLOAT_CAST_PTR(&call_state.args[1],&amount){ error_msg("lerp",2,"Color and float",call_state); return }
	
	color_p  := AS_COLOR_PTR(&call_state.args[2])
	color_to := AS_COLOR_PTR(&call_state.args[0])
	r        := _lerp(color_p,color_to,amount)

	COLOR_VAL_PTR(call_state.result,&r)
}


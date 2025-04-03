#+private

package OscriptColor


error_msg :: proc(fn_name: string, expected,argc: Int,be: string ,call_error_p: ^ObjectCallError) {
	CALL_ERROR_STRING(call_error_p,"'",fn_name,"' function expects '",expected,"' args, but got ",argc,", and the argument must be ",be,".")
}

error_msg0 :: proc(fn_name: string, expected,argc: Int ,call_error_p: ^ObjectCallError) {
	CALL_ERROR_STRING(call_error_p,"'",fn_name,"' function expects '",expected,"' args, but got ",argc,".")
}


get_luminance :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError){
	
	if argc != 0 { when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("get_luminance",0,argc,call_error_p); return }
	
	color_p := AS_COLOR_PTR(&args[argc])
	r       := _get_luminance(color_p)

	INT_VAL_PTR(result,Int(r))
}

darkened      :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError){
	
	amount : Float

	if argc != 1 || !IS_FLOAT_CAST_PTR(&args[0],&amount){ 
		when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("darkened",1,argc,"a number",call_error_p)
		return
	}
	
	color_p := AS_COLOR_PTR(&args[argc])
	r       := _darkened(color_p,&amount)
	COLOR_VAL_PTR(result,&r)
}

lightened     :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError){
	
	amount : Float

	if argc != 1 || !IS_FLOAT_CAST_PTR(&args[0],&amount){ 
		when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("lightened",1,argc,"a number",call_error_p)
		return
	}
	
	color_p := AS_COLOR_PTR(&args[argc])
	r       := _lightened(color_p,&amount)

	COLOR_VAL_PTR(result,&r)
}



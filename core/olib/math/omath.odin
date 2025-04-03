#+private

package OscriptMath

error_msg :: proc(fn_name: string, argc: Int,be: string ,call_error_p: ^ObjectCallError) {
	CALL_ERROR_STRING(call_error_p,"'",fn_name,"' function expects '",argc,"' args, but got ",argc,", and the argument must be ",be,".")
}

error_msg0 :: proc(fn_name: string, argc: Int ,call_error_p: ^ObjectCallError) {
	CALL_ERROR_STRING(call_error_p,"'",fn_name,"' function expects '",argc,"' args, but got ",argc,".")
}



deg2rad :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	value : Float
	
	if argc != 1 || !IS_FLOAT_CAST_PTR(&args[0],&value) { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("deg2rad",1,"a number",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline math.to_radians(value))
}

rad2deg :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	value : Float
	
	if argc != 1 || !IS_FLOAT_CAST_PTR(&args[0],&value) { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("rad2deg",1,"a number",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline math.to_degrees(value))
}


sin     :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	value : Float
	
	if argc != 1 || !IS_FLOAT_CAST_PTR(&args[0],&value) { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("sin",1,"a number",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline math.sin(value))
}

cos     :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	value : Float
	
	if argc != 1 || !IS_FLOAT_CAST_PTR(&args[0],&value) { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("cos",1,"a number",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline math.cos(value))
}

tan     :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	value : Float
	
	if argc != 1 || !IS_FLOAT_CAST_PTR(&args[0],&value) { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("tan",1,"a number",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline math.tan(value))
}

asin    :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	value : Float
	
	if argc != 1 || !IS_FLOAT_CAST_PTR(&args[0],&value) { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("asin",1,"a number",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline math.asin(value))
}

acos    :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	value : Float
	
	if argc != 1 || !IS_FLOAT_CAST_PTR(&args[0],&value) { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("acos",1,"a number",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline math.acos(value))
}

atan    :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	value : Float
	
	if argc != 1 || !IS_FLOAT_CAST_PTR(&args[0],&value) { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("atan",1,"a number",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline math.atan(value))
}

atan2    :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	y,x : Float
	
	if argc != 2 || !IS_FLOAT_CAST_PTR(&args[0],&y) || IS_FLOAT_CAST_PTR(&args[1],&x) { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("atan2",2,"numbers",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline math.atan2(y,x))
}

sqrt     :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	value : Float
	
	if argc != 1 || !IS_FLOAT_CAST_PTR(&args[0],&value) || value < 0 { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("sqrt",1,"a positive number",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline math.sqrt(value))
}

inv_sqrt :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	value : Float
	
	if argc != 1 || !IS_FLOAT_CAST_PTR(&args[0],&value) || value < 0 { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("inv_sqrt",1,"a positive number",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline linalg.inverse_sqrt(value))
}

ln       :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	value : Float
	
	if argc != 1 || !IS_FLOAT_CAST_PTR(&args[0],&value) || value < 0 { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("ln",1,"a positive number",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline linalg.ln(value))
}

log2     :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	value : Float
	
	if argc != 1 || !IS_FLOAT_CAST_PTR(&args[0],&value) || value < 0 { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("log2",1,"a positive number",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline math.log2(value))
}

log10    :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	value : Float
	
	if argc != 1 || !IS_FLOAT_CAST_PTR(&args[0],&value) || value < 0 { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("log10",1,"a positive number",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline math.log10(value))
}

log      :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	values : [2]Float
	
	for i in 0..< 2 do if argc != 2 || !IS_FLOAT_CAST_PTR(&args[i],&values[i]) || values[i] < 0 { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("log",2," positives numbers",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline linalg.log(values[0],values[1]) )
}

exp      :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	value : Float
	
	if argc != 1 || !IS_FLOAT_CAST_PTR(&args[0],&value) { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("exp",1,"a number",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline math.exp(value))
}

sign     :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	value : Float
	
	if argc != 1 || !IS_FLOAT_CAST_PTR(&args[0],&value) { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("sign",1,"a number",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline linalg.sign(value))
}

clamp    :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	values : [3]Float
	
	for i in 0..<3 do if argc != 3 || !IS_FLOAT_CAST_PTR(&args[i],&values[i]) { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("clamp",3," numbers",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline linalg.clamp(values[0],values[1],values[2]))
}

lerp     :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	values : [3]Float
	
	for i in 0..<3 do if argc != 3 || !IS_FLOAT_CAST_PTR(&args[i],&values[i]) { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("lerp",3," numbers",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline linalg.lerp(values[0],values[1],values[2]))
}

unlerp     :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	values : [3]Float
	
	for i in 0..<3 do if argc != 3 || !IS_FLOAT_CAST_PTR(&args[i],&values[i]) { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("unlerp",3," numbers",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline linalg.unlerp(values[0],values[1],values[2]))
}

smoothstep :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	values : [3]Float
	
	for i in 0..<3 do if argc != 3 || !IS_FLOAT_CAST_PTR(&args[i],&values[i]) { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("smoothstep",3," numbers",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline linalg.smoothstep(values[0],values[1],values[2]))
}

smootherstep :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	values : [3]Float
	
	for i in 0..<3 do if argc != 3 || !IS_FLOAT_CAST_PTR(&args[i],&values[i]) { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("smootherstep",3," numbers",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline linalg.smootherstep(values[0],values[1],values[2]))
}

pow :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	values : [2]Float
	
	for i in 0..<2 do if argc != 2 || !IS_FLOAT_CAST_PTR(&args[i],&values[i]) { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("pow",2," numbers",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline math.pow(values[0],values[1]))
}

ceil :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	value : Float
	
	if argc != 1 || !IS_FLOAT_CAST_PTR(&args[0],&value) { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("ceil",1," a number",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline math.ceil(value))
}

floor :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	value : Float
	
	if argc != 1 || !IS_FLOAT_CAST_PTR(&args[0],&value) { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("floor",1," a number",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline math.floor(value))
}

round :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	value : Float
	
	if argc != 1 || !IS_FLOAT_CAST_PTR(&args[0],&value) { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("round",1," a number",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline math.round(value))
}

mod :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	values : [2]Float
	
	for i in 0..<2 do if argc != 2 || !IS_FLOAT_CAST_PTR(&args[i],&values[i]) { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("mod",2," numbers",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline math.mod(values[0],values[1]))
}

min :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	values : [2]Float
	
	for i in 0..<2 do if argc != 2 || !IS_FLOAT_CAST_PTR(&args[i],&values[i]) { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("min",2," numbers",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline linalg.min(values[0],values[1]))
}

max :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	values : [2]Float
	
	for i in 0..<2 do if argc != 2 || !IS_FLOAT_CAST_PTR(&args[i],&values[i]) { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("min",2," numbers",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline linalg.min(values[0],values[1]))
}

fract :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	value : Float
	
	if argc != 1 || !IS_FLOAT_CAST_PTR(&args[0],&value) { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("fract",1," a number",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline linalg.fract(value))
}

sinh :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	value : Float
	
	if argc != 1 || !IS_FLOAT_CAST_PTR(&args[0],&value) { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("sinh",1," a number",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline math.sinh(value))
}

cosh :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	value : Float
	
	if argc != 1 || !IS_FLOAT_CAST_PTR(&args[0],&value) { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("cosh",1," a number",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline math.cosh(value))
}

tanh :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	value : Float
	
	if argc != 1 || !IS_FLOAT_CAST_PTR(&args[0],&value) { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("tanh",1," a number",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline math.tanh(value))
}

asinh :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	value : Float
	
	if argc != 1 || !IS_FLOAT_CAST_PTR(&args[0],&value) { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("asinh",1," a number",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline math.asinh(value))
}

acosh :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	value : Float
	
	if argc != 1 || !IS_FLOAT_CAST_PTR(&args[0],&value) { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("acosh",1," a number",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline math.acosh(value))
}

atanh :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	value : Float
	
	if argc != 1 || !IS_FLOAT_CAST_PTR(&args[0],&value) { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("atanh",1," a number",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline math.atanh(value))
}

randomize :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	value : Int
	
	if argc != 1 || !IS_INT_PTR(&args[0],&value) { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("randomize",1,"a int",call_error_p)
		return
	}

	#force_inline rand.reset(u64(value))
	NIL_VAL_PTR(result)
}


randi :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
		
	if argc != 0 { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("randi",0,call_error_p)
		return
	}

	INT_VAL_PTR(result, Int( #force_inline rand.int31()) )
}

randf :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
		
	if argc != 0 { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("randf",0,call_error_p)
		return
	}
	
	FLOAT_VAL_PTR(result, Float( #force_inline rand.float64()) )
}

randf_range :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
		
	values : [2]Float

	for i in 0..< 2 do if argc != 2 || !IS_FLOAT_CAST_PTR(&args[i],&values[i])  { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("randf_range",2,"numbers",call_error_p)
		return
	}

	if values[0] > values[1] do values = swizzle(values,1,0)
	when Float == f64 do r := #force_inline rand.float64_range(values[0],values[1])
	else              do r := #force_inline rand.float32_range(values[0],values[1])

	FLOAT_VAL_PTR(result,r)
}

posmodi :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
		
	values : [2]Int

	for i in 0..< 2 do if argc != 2 || !IS_INT_PTR(&args[i],&values[i])  { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("posmodi",2,"int's",call_error_p)
		return
	}

	if values[1] == 0 {
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do CALL_WARNING_STRING(call_error_p,"division by zero in posmodi is undefined. Returnig 0 as fallback.")
		INT_VAL_PTR(result,0)
		return
	}

	INT_VAL_PTR(result, #force_inline _posmodi(values[0],values[1]))
}

posmodf :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
		
	values : [2]Float

	for i in 0..< 2 do if argc != 2 || !IS_FLOAT_CAST_PTR(&args[i],&values[i])  { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("posmodf",2,"numbers",call_error_p)
		return
	}

	if values[1] == 0.0 {
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do CALL_WARNING_STRING(call_error_p,"division by zero in posmodf is undefined. Returnig 0 as fallback.")
		FLOAT_VAL_PTR(result,0.0)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline _posmodf(values[0],values[1]))
}

abs :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	value : Float
	
	if argc != 1 || !IS_FLOAT_CAST_PTR(&args[0],&value) { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("abs",1,"a number",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, math.abs(value))
}

step_decimal :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	value : Float
	
	if argc != 1 || !IS_FLOAT_CAST_PTR(&args[0],&value) { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("step_decimal",1,"a number",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline _step_decimal(value))
}


stepfy :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
		
	values : [2]Float

	for i in 0..< 2 do if argc != 2 || !IS_FLOAT_CAST_PTR(&args[i],&values[i])  { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("stepfy",2,"numbers",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline _stepfy(values[0],values[1]))
}

exp2 :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	value : Float
	
	if argc != 1 || !IS_FLOAT_CAST_PTR(&args[0],&value) { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("exp2",1,"a number",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline linalg.exp2(value))
}

hypot :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
		
	values : [2]Float

	for i in 0..< 2 do if argc != 2 || !IS_FLOAT_CAST_PTR(&args[i],&values[i])  { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("hypot",2,"numbers",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline math.hypot(values[0],values[1]))
}

remap :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
		
	values : [5]Float

	for i in 0..< 5 do if argc != 5 || !IS_FLOAT_CAST_PTR(&args[i],&values[i])  { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("remap",5,"numbers",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline math.remap(values[0],values[1],values[2],values[3],values[4]))
}

remap_clamped :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
		
	values : [5]Float

	for i in 0..< 5 do if argc != 5 || !IS_FLOAT_CAST_PTR(&args[i],&values[i])  { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("remap_clamped",5,"numbers",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline math.remap_clamped(values[0],values[1],values[2],values[3],values[4]))
}

wrap :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
		
	values : [2]Float

	for i in 0..< 2 do if argc != 2 || !IS_FLOAT_CAST_PTR(&args[i],&values[i])  { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("wrap",2,"numbers",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline math.wrap(values[0],values[1]))
}

angle_lerp :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	values : [3]Float
	
	for i in 0..<3 do if argc != 3 || !IS_FLOAT_CAST_PTR(&args[i],&values[i]) { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("angle_lerp",3," numbers",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline math.angle_lerp(values[0],values[1],values[2]))
}

angle_diff :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	values : [2]Float
	
	for i in 0..<2 do if argc != 2 || !IS_FLOAT_CAST_PTR(&args[i],&values[i]) { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("angle_diff",3," numbers",call_error_p)
		return
	}

	FLOAT_VAL_PTR(result, #force_inline math.angle_diff(values[0],values[1]))
}

is_nan :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	value : Float
	
	if argc != 1 || !IS_FLOAT_CAST_PTR(&args[0],&value) { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("is_nan",1,"a number",call_error_p)
		return
	}

	BOOL_VAL_PTR(result, #force_inline math.is_nan(value))
}

is_inf :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
	value : Float
	
	if argc != 1 || !IS_FLOAT_CAST_PTR(&args[0],&value) { 
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("is_inf",1,"a number",call_error_p)
		return
	}

	BOOL_VAL_PTR(result, #force_inline math.is_inf(value))
}

// fmod :: proc(argc: Int, args: []Value,result: ^Value , call_error_p : ^ObjectCallError) {
	
// 	values : [2]Float
	
// 	for i in 0..<2 do if argc != 2 || !IS_FLOAT_CAST_PTR(&args[i],&values[i]) { 
// 		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("fmod",2," numbers",call_error_p)
// 		return
// 	}

// 	FLOAT_VAL_PTR(result, #force_inline math.mod(values[0],values[1]))
// }
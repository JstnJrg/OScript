#+private

package OscriptMath

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


deg2rad :: proc(call_state: ^CallState) 
{	
	value : Float
	if call_state.argc != 1 || !IS_FLOAT_CAST_PTR(&call_state.args[0],&value) { error_msg("deg2rad",1,"a number",call_state); return }
	FLOAT_VAL_PTR(call_state.result, #force_inline math.to_radians(value))
}


rad2deg :: proc(call_state: ^CallState) 
{	
	value : Float
	if call_state.argc != 1 || !IS_FLOAT_CAST_PTR(&call_state.args[0],&value) { error_msg("rad2deg",1,"a number",call_state); return }
	FLOAT_VAL_PTR(call_state.result, #force_inline math.to_degrees(value))
}


sin     :: proc(call_state: ^CallState) 
{	
	value : Float
	if call_state.argc != 1 || !IS_FLOAT_CAST_PTR(&call_state.args[0],&value) { error_msg("sin",1,"a number",call_state); return }

	FLOAT_VAL_PTR(call_state.result, #force_inline math.sin(value))
}

cos     :: proc(call_state: ^CallState) 
{	
	value : Float
	if call_state.argc != 1 || !IS_FLOAT_CAST_PTR(&call_state.args[0],&value) { error_msg("cos",1,"a number",call_state); return }
	FLOAT_VAL_PTR(call_state.result, #force_inline math.cos(value))
}

tan :: proc(call_state: ^CallState) 
{	
	value : Float
	if call_state.argc != 1 || !IS_FLOAT_CAST_PTR(&call_state.args[0],&value) { error_msg("tan",1,"a number",call_state); return }
	FLOAT_VAL_PTR(call_state.result, #force_inline math.tan(value))
}

asin    :: proc(call_state: ^CallState) 
{	
	value : Float
	if call_state.argc != 1 || !IS_FLOAT_CAST_PTR(&call_state.args[0],&value) { error_msg("asin",1,"a number",call_state); return }
	FLOAT_VAL_PTR(call_state.result, #force_inline math.asin(value))
}

acos    :: proc(call_state: ^CallState) 
{	
	value : Float
	if call_state.argc != 1 || !IS_FLOAT_CAST_PTR(&call_state.args[0],&value) { error_msg("acos",1,"a number",call_state); return }
	FLOAT_VAL_PTR(call_state.result, #force_inline math.acos(value))
}

atan    :: proc(call_state: ^CallState) 
{
	value : Float
	if call_state.argc != 1 || !IS_FLOAT_CAST_PTR(&call_state.args[0],&value) { error_msg("atan",1,"a number",call_state); return }
	FLOAT_VAL_PTR(call_state.result, #force_inline math.atan(value))
}

atan2    :: proc(call_state: ^CallState) 
{
	y,x  : Float
	args := &call_state.args
	if call_state.argc != 2 || !IS_FLOAT_CAST_PTR(&args[0],&y) || IS_FLOAT_CAST_PTR(&args[1],&x) { error_msg("atan2",2,"numbers",call_state); return }
	
	FLOAT_VAL_PTR(call_state.result, #force_inline math.atan2(y,x))
}

sqrt     :: proc(call_state: ^CallState) 
{
	value : Float
	if call_state.argc != 1 || !IS_FLOAT_CAST_PTR(&call_state.args[0],&value) || value < 0 { error_msg("sqrt",1,"a positive number",call_state); return }
	
	FLOAT_VAL_PTR(call_state.result, #force_inline math.sqrt(value))
}

inv_sqrt :: proc(call_state: ^CallState) 
{
	value : Float
	if call_state.argc != 1 || !IS_FLOAT_CAST_PTR(&call_state.args[0],&value) || value < 0 { error_msg("inv_sqrt",1,"a positive number",call_state); return }

	FLOAT_VAL_PTR(call_state.result, #force_inline linalg.inverse_sqrt(value))
}

ln  :: proc(call_state: ^CallState) 
{
	value : Float
	if call_state.argc != 1 || !IS_FLOAT_CAST_PTR(&call_state.args[0],&value) || value < 0 { error_msg("ln",1,"a positive number",call_state); return }

	FLOAT_VAL_PTR(call_state.result, #force_inline linalg.ln(value))
}

log2 :: proc(call_state: ^CallState) 
{
	value : Float
	if call_state.argc != 1 || !IS_FLOAT_CAST_PTR(&call_state.args[0],&value) || value < 0 { error_msg("log2",1,"a positive number",call_state); return }

	FLOAT_VAL_PTR(call_state.result, #force_inline math.log2(value))
}

log10    :: proc(call_state: ^CallState) 
{
	value : Float
	if call_state.argc != 1 || !IS_FLOAT_CAST_PTR(&call_state.args[0],&value) || value < 0 { error_msg("log10",1,"a positive number",call_state); return }
	FLOAT_VAL_PTR(call_state.result, #force_inline math.log10(value))
}

log      :: proc(call_state: ^CallState) 
{
	values : [2]Float	
	for i in 0..< 2 do if call_state.argc != 2 || !IS_FLOAT_CAST_PTR(&call_state.args[i],&values[i]) || values[i] < 0 { error_msg("log",2," positives numbers",call_state);	return }
	FLOAT_VAL_PTR(call_state.result, #force_inline linalg.log(values[0],values[1]) )
}

exp      :: proc(call_state: ^CallState) 
{
	value : Float
	if call_state.argc != 1 || !IS_FLOAT_CAST_PTR(&call_state.args[0],&value) { error_msg("exp",1,"a number",call_state); return }
	FLOAT_VAL_PTR(call_state.result, #force_inline math.exp(value))
}

sign     :: proc(call_state: ^CallState) 
{
	value : Float
	if call_state.argc != 1 || !IS_FLOAT_CAST_PTR(&call_state.args[0],&value) { error_msg("sign",1,"a number",call_state); return }
	FLOAT_VAL_PTR(call_state.result, #force_inline linalg.sign(value))
}

clamp    :: proc(call_state: ^CallState) 
{
	values : [3]Float
	for i in 0..<3 do if call_state.argc != 3 || !IS_FLOAT_CAST_PTR(&call_state.args[i],&values[i]) { error_msg("clamp",3," numbers",call_state); return }
	FLOAT_VAL_PTR(call_state.result, #force_inline linalg.clamp(values[0],values[1],values[2]))
}

lerp     :: proc(call_state: ^CallState) 
{
	values : [3]Float	
	for i in 0..<3 do if call_state.argc != 3 || !IS_FLOAT_CAST_PTR(&call_state.args[i],&values[i]) { error_msg("lerp",3," numbers",call_state); return }
	FLOAT_VAL_PTR(call_state.result, #force_inline linalg.lerp(values[0],values[1],values[2]))
}

unlerp     :: proc(call_state: ^CallState) 
{
	values : [3]Float
	for i in 0..<3 do if call_state.argc != 3 || !IS_FLOAT_CAST_PTR(&call_state.args[i],&values[i]) { error_msg("unlerp",3," numbers",call_state); return }
	FLOAT_VAL_PTR(call_state.result, #force_inline linalg.unlerp(values[0],values[1],values[2]))
}

smoothstep :: proc(call_state: ^CallState) 
{
	values : [3]Float	
	for i in 0..<3 do if call_state.argc != 3 || !IS_FLOAT_CAST_PTR(&call_state.args[i],&values[i]) { error_msg("smoothstep",3," numbers",call_state); return }
	FLOAT_VAL_PTR(call_state.result, #force_inline linalg.smoothstep(values[0],values[1],values[2]))
}

smootherstep :: proc(call_state: ^CallState) 
{
	values : [3]Float	
	for i in 0..<3 do if call_state.argc != 3 || !IS_FLOAT_CAST_PTR(&call_state.args[i],&values[i]) { error_msg("smootherstep",3," numbers",call_state); return  }

	FLOAT_VAL_PTR(call_state.result, #force_inline linalg.smootherstep(values[0],values[1],values[2]))
}

pow :: proc(call_state: ^CallState) 
{
	values : [2]Float
	for i in 0..<2 do if call_state.argc != 2 || !IS_FLOAT_CAST_PTR(&call_state.args[i],&values[i]) { error_msg("pow",2," numbers",call_state); return }

	FLOAT_VAL_PTR(call_state.result, #force_inline math.pow(values[0],values[1]))
}

ceil :: proc(call_state: ^CallState) 
{
	value : Float
	if call_state.argc != 1 || !IS_FLOAT_CAST_PTR(&call_state.args[0],&value) { error_msg("ceil",1," a number",call_state); return }

	FLOAT_VAL_PTR(call_state.result, #force_inline math.ceil(value))
}

floor :: proc(call_state: ^CallState) 
{	
	value : Float	
	if call_state.argc != 1 || !IS_FLOAT_CAST_PTR(&call_state.args[0],&value) { error_msg("floor",1," a number",call_state); return }

	FLOAT_VAL_PTR(call_state.result, #force_inline math.floor(value))
}

round :: proc(call_state: ^CallState) 
{	
	value : Float	
	if call_state.argc != 1 || !IS_FLOAT_CAST_PTR(&call_state.args[0],&value) { error_msg("round",1," a number",call_state); return }

	FLOAT_VAL_PTR(call_state.result, #force_inline math.round(value))
}

mod :: proc(call_state: ^CallState) 
{	
	values : [2]Float	
	for i in 0..<2 do if call_state.argc != 2 || !IS_FLOAT_CAST_PTR(&call_state.args[i],&values[i]) { error_msg("mod",2," numbers",call_state); return }

	FLOAT_VAL_PTR(call_state.result, #force_inline math.mod(values[0],values[1]))
}

min :: proc(call_state: ^CallState) 
{
	values : [2]Float	
	for i in 0..<2 do if call_state.argc != 2 || !IS_FLOAT_CAST_PTR(&call_state.args[i],&values[i]) { error_msg("min",2," numbers",call_state); return }

	FLOAT_VAL_PTR(call_state.result, #force_inline linalg.min(values[0],values[1]))
}

max :: proc(call_state: ^CallState) 
{
	values : [2]Float	
	for i in 0..<2 do if call_state.argc != 2 || !IS_FLOAT_CAST_PTR(&call_state.args[i],&values[i]) { error_msg("min",2," numbers",call_state); return }

	FLOAT_VAL_PTR(call_state.result, #force_inline linalg.min(values[0],values[1]))
}

fract :: proc(call_state: ^CallState) 
{
	value : Float	
	if call_state.argc != 1 || !IS_FLOAT_CAST_PTR(&call_state.args[0],&value) { error_msg("fract",1," a number",call_state); return }

	FLOAT_VAL_PTR(call_state.result, #force_inline linalg.fract(value))
}

sinh :: proc(call_state: ^CallState) 
{
	value : Float	
	if call_state.argc != 1 || !IS_FLOAT_CAST_PTR(&call_state.args[0],&value) { error_msg("sinh",1," a number",call_state); return }

	FLOAT_VAL_PTR(call_state.result, #force_inline math.sinh(value))
}

cosh :: proc(call_state: ^CallState) 
{
	value : Float	
	if call_state.argc != 1 || !IS_FLOAT_CAST_PTR(&call_state.args[0],&value) { error_msg("cosh",1," a number",call_state); return }

	FLOAT_VAL_PTR(call_state.result, #force_inline math.cosh(value))
}

tanh :: proc(call_state: ^CallState) 
{
	value : Float	
	if call_state.argc != 1 || !IS_FLOAT_CAST_PTR(&call_state.args[0],&value) { error_msg("tanh",1," a number",call_state); return }

	FLOAT_VAL_PTR(call_state.result, #force_inline math.tanh(value))
}

asinh :: proc(call_state: ^CallState) 
{	
	value : Float
	if call_state.argc != 1 || !IS_FLOAT_CAST_PTR(&call_state.args[0],&value) { error_msg("asinh",1," a number",call_state); return }

	FLOAT_VAL_PTR(call_state.result, #force_inline math.asinh(value))
}

acosh :: proc(call_state: ^CallState) 
{
	value : Float
	if call_state.argc != 1 || !IS_FLOAT_CAST_PTR(&call_state.args[0],&value) { error_msg("acosh",1," a number",call_state); return }

	FLOAT_VAL_PTR(call_state.result, #force_inline math.acosh(value))
}

atanh :: proc(call_state: ^CallState) 
{
	value : Float
	if call_state.argc != 1 || !IS_FLOAT_CAST_PTR(&call_state.args[0],&value) { error_msg("atanh",1," a number",call_state); return }

	FLOAT_VAL_PTR(call_state.result, #force_inline math.atanh(value))
}

randomize :: proc(call_state: ^CallState) 
{
	value : Int
	if call_state.argc != 1 || !IS_INT_PTR(&call_state.args[0],&value) { error_msg("randomize",1,"a int",call_state); return }

	#force_inline rand.reset(u64(value))
	NIL_VAL_PTR(call_state.result)
}


randi :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("randi",0,call_state); return }
	INT_VAL_PTR(call_state.result, Int( #force_inline rand.int31()) )
}

randf :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("randf",0,call_state); return }
	FLOAT_VAL_PTR(call_state.result, Float( #force_inline rand.float64()) )
}

randf_range :: proc(call_state: ^CallState) 
{
	values : [2]Float
	for i in 0..< 2 do if call_state.argc != 2 || !IS_FLOAT_CAST_PTR(&call_state.args[i],&values[i])  { error_msg("randf_range",2,"numbers",call_state); return }

	if values[0] > values[1] do values = swizzle(values,1,0)
	when Float == f64 do r := #force_inline rand.float64_range(values[0],values[1])
	else              do r := #force_inline rand.float32_range(values[0],values[1])

	FLOAT_VAL_PTR(call_state.result,r)
}

posmodi :: proc(call_state: ^CallState) 
{
	values : [2]Int
	for i in 0..< 2 do if call_state.argc != 2 || !IS_INT_PTR(&call_state.args[i],&values[i])  { error_msg("posmodi",2,"int's",call_state); return }

	if values[1] == 0 
	{   warning("division by zero in posmodi is undefined. Returnig 0 as fallback.",call_state)
		INT_VAL_PTR(call_state.result,0)
		return
	}

	INT_VAL_PTR(call_state.result, #force_inline _posmodi(values[0],values[1]))
}

posmodf :: proc(call_state: ^CallState) 
{
	values : [2]Float
	for i in 0..< 2 do if call_state.argc != 2 || !IS_FLOAT_CAST_PTR(&call_state.args[i],&values[i])  { error_msg("posmodf",2,"numbers",call_state); return }

	if values[1] == 0.0 
	{
		warning("division by zero in posmodf is undefined. Returnig 0 as fallback.",call_state)
		FLOAT_VAL_PTR(call_state.result,0.0)
		return
	}

	FLOAT_VAL_PTR(call_state.result, #force_inline _posmodf(values[0],values[1]))
}

abs :: proc(call_state: ^CallState) 
{
	value : Float
	if call_state.argc != 1 || !IS_FLOAT_CAST_PTR(&call_state.args[0],&value) { error_msg("abs",1,"a number",call_state); return }

	FLOAT_VAL_PTR(call_state.result, math.abs(value))
}

step_decimal :: proc(call_state: ^CallState) 
{
	value : Float
	if call_state.argc != 1 || !IS_FLOAT_CAST_PTR(&call_state.args[0],&value) { error_msg("step_decimal",1,"a number",call_state); return }

	FLOAT_VAL_PTR(call_state.result, #force_inline _step_decimal(value))
}


stepfy :: proc(call_state: ^CallState) 
{
	values : [2]Float
	for i in 0..< 2 do if call_state.argc != 2 || !IS_FLOAT_CAST_PTR(&call_state.args[i],&values[i])  { error_msg("stepfy",2,"numbers",call_state); return }

    FLOAT_VAL_PTR(call_state.result, #force_inline _stepfy(values[0],values[1]))
}

exp2 :: proc(call_state: ^CallState) 
{
	value : Float
	if call_state.argc != 1 || !IS_FLOAT_CAST_PTR(&call_state.args[0],&value) { error_msg("exp2",1,"a number",call_state); return }

	FLOAT_VAL_PTR(call_state.result, #force_inline linalg.exp2(value))
}

hypot :: proc(call_state: ^CallState) 
{
	values : [2]Float
	for i in 0..< 2 do if call_state.argc != 2 || !IS_FLOAT_CAST_PTR(&call_state.args[i],&values[i])  { error_msg("hypot",2,"numbers",call_state); return }

	FLOAT_VAL_PTR(call_state.result, #force_inline math.hypot(values[0],values[1]))
}

remap :: proc(call_state: ^CallState) 
{
	values : [5]Float
	for i in 0..< 5 do if call_state.argc != 5 || !IS_FLOAT_CAST_PTR(&call_state.args[i],&values[i])  { error_msg("remap",5,"numbers",call_state); return }

	FLOAT_VAL_PTR(call_state.result, #force_inline math.remap(values[0],values[1],values[2],values[3],values[4]))
}

remap_clamped :: proc(call_state: ^CallState) 
{
	values : [5]Float
	for i in 0..< 5 do if call_state.argc != 5 || !IS_FLOAT_CAST_PTR(&call_state.args[i],&values[i])  { error_msg("remap_clamped",5,"numbers",call_state); return }

	FLOAT_VAL_PTR(call_state.result, #force_inline math.remap_clamped(values[0],values[1],values[2],values[3],values[4]))
}

wrap :: proc(call_state: ^CallState) 
{
	values : [2]Float
	for i in 0..< 2 do if call_state.argc != 2 || !IS_FLOAT_CAST_PTR(&call_state.args[i],&values[i])  { error_msg("wrap",2,"numbers",call_state); return }

	FLOAT_VAL_PTR(call_state.result, #force_inline math.wrap(values[0],values[1]))
}

angle_lerp :: proc(call_state: ^CallState) 
{
	values : [3]Float	
	for i in 0..<3 do if call_state.argc != 3 || !IS_FLOAT_CAST_PTR(&call_state.args[i],&values[i]) { error_msg("angle_lerp",3," numbers",call_state); return }

	FLOAT_VAL_PTR(call_state.result, #force_inline math.angle_lerp(values[0],values[1],values[2]))
}

angle_diff :: proc(call_state: ^CallState) 
{
	values : [2]Float	
	for i in 0..<2 do if call_state.argc != 2 || !IS_FLOAT_CAST_PTR(&call_state.args[i],&values[i]) { error_msg("angle_diff",3," numbers",call_state); return }

	FLOAT_VAL_PTR(call_state.result, #force_inline math.angle_diff(values[0],values[1]))
}

is_nan :: proc(call_state: ^CallState) 
{
	value : Float	
	if call_state.argc != 1 || !IS_FLOAT_CAST_PTR(&call_state.args[0],&value) { error_msg("is_nan",1,"a number",call_state); return }

	BOOL_VAL_PTR(call_state.result, #force_inline math.is_nan(value))
}

is_inf :: proc(call_state: ^CallState) 
{
	value : Float	
	if call_state.argc != 1 || !IS_FLOAT_CAST_PTR(&call_state.args[0],&value) { error_msg("is_inf",1,"a number",call_state); return }
	BOOL_VAL_PTR(call_state.result, #force_inline math.is_inf(value))
}
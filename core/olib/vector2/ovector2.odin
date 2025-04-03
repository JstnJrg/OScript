package OscriptVector2

import fmt     "core:fmt"


error_msg :: proc(fn_name: string, expected,argc: Int,be: string ,call_error_p: ^ObjectCallError) {
	CALL_ERROR_STRING(call_error_p,"'",fn_name,"' function expects '",expected,"' args, but got ",argc,", and the argument must be ",be,".")
}

error_msg0 :: proc(fn_name: string, expected,argc: Int ,call_error_p: ^ObjectCallError) {
	CALL_ERROR_STRING(call_error_p,"'",fn_name,"' function expects '",expected,"' args, but got ",argc,".")
}


abs :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
{
	if argc != 0 { when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("abs",0,argc,call_error_p); return	}
	VECTOR2_VAL_PTRV( result, #force_inline _abs(AS_VECTOR2_PTR(&args[argc])))
}

aspect :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
{
	if argc != 0 { when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("aspect",0,argc,call_error_p); return	}
	FLOAT_VAL_PTR(result,#force_inline _aspect(AS_VECTOR2_PTR(&args[argc])))
}

angle :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
{
	if argc != 0 { when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("angle",0,argc,call_error_p); return	}
	FLOAT_VAL_PTR(result, #force_inline _angle(AS_VECTOR2_PTR(&args[argc])))
}

angle_from :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
{
	if argc != 1 || !IS_VECTOR2D_PTR(&args[0]) {
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("angle_from",1,argc,"a Vector2",call_error_p)
		return
	}

	a   := #force_inline _angle(AS_VECTOR2_PTR(&args[argc]))
	b   := #force_inline _angle(AS_VECTOR2_PTR(&args[0]))

	FLOAT_VAL_PTR(result, b-a)
}

angle_to_point :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
{
	if argc != 1 || !IS_VECTOR2D_PTR(&args[0]) {
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("angle_to_point",1,argc,"a Vector2",call_error_p)
		return
	}

	r := #force_inline _sub(AS_VECTOR2_PTR(&args[0]),AS_VECTOR2_PTR(&args[argc]))
	FLOAT_VAL_PTR(result,#force_inline _angle(&r))
}

bounce :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
{
	if argc != 1 || !IS_VECTOR2D_PTR(&args[0]) {
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("bounce",1,argc,"Vector2",call_error_p)
		return
	}

	n := AS_VECTOR2_PTR(&args[0])

	if !_is_normalized(n){
		CALL_WARNING_STRING(call_error_p,"the normal must be normalized. Returning Vector2(0,0) as fallback.")
		VECTOR2_VAL_PTRV(result,_ZERO)
		return
	}

	VECTOR2_VAL_PTRV( result,- #force_inline _reflect(AS_VECTOR2_PTR(&args[argc]),n))}

clamp :: proc (argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
{

	for i in 0..<2 do if argc != 2 || !IS_VECTOR2D_PTR(&args[i]) {
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("clamp",2,argc,"Vector2's",call_error_p)
		return
	}

	v   := AS_VECTOR2_PTR(&args[argc])
	min := AS_VECTOR2_PTR(&args[0])
	max := AS_VECTOR2_PTR(&args[1])

	VECTOR2_VAL_PTRV( result,#force_inline _clamp(v,min,max))
}

cross :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) {

	if argc != 1 || !IS_VECTOR2D_PTR(&args[0]) {
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("cross",1,argc,"Vector2",call_error_p)
		return
	}
	FLOAT_VAL_PTR(result,#force_inline _cross(AS_VECTOR2_PTR(&args[argc]),AS_VECTOR2_PTR(&args[0])))
}

direction_to :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
{

	if argc != 1 || !IS_VECTOR2D_PTR(&args[0]) {
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("direction_to",1,argc,"Vector2",call_error_p)
		return
	}

	s := _sub(AS_VECTOR2_PTR(&args[argc]),AS_VECTOR2_PTR(&args[0]))
	VECTOR2_VAL_PTRV( result,#force_inline _normalize(&s))
}

dot :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
{
	if argc != 1 || !IS_VECTOR2D_PTR(&args[0]) {
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("dot",1,argc,"Vector2",call_error_p)
		return
	}
	FLOAT_VAL_PTR(result,#force_inline _dot(AS_VECTOR2_PTR(&args[argc]),AS_VECTOR2_PTR(&args[0])))
}

distance_to :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
{
	if argc != 1 || !IS_VECTOR2D_PTR(&args[0]) {
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("distance_to",1,argc,"a Vector2",call_error_p)
		return
	}
	s := _sub(AS_VECTOR2_PTR(&args[0]),AS_VECTOR2_PTR(&args[argc]))
	FLOAT_VAL_PTR(result,#force_inline _length(&s))
}

distance_to_squared :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
{
	if argc != 1 || !IS_VECTOR2D_PTR(&args[0]) {
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("distance_to_squared",1,argc,"a Vector2",call_error_p)
		return
	}

	s := _sub(AS_VECTOR2_PTR(&args[0]),AS_VECTOR2_PTR(&args[argc]))
	FLOAT_VAL_PTR(result,#force_inline _length_squared(&s))
}

floor :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
{
	if argc != 0 { when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("floor",0,argc,call_error_p); return	}
	VECTOR2_VAL_PTRV( result,#force_inline _floor(AS_VECTOR2_PTR(&args[argc])))
}

from_angle :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
{
	value : Float

	if argc != 1 || !IS_FLOAT_CAST_PTR(&args[0],&value) {
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("from_angle",1,argc,"a number",call_error_p)
		return
	}

	VECTOR2_VAL_PTRV( result,#force_inline _from_angle(value))
}

invert :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
{
	if argc != 0 { when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("invert",0,argc,call_error_p); return	}
	VECTOR2_VAL_PTRV( result,#force_inline _invert(AS_VECTOR2_PTR(&args[argc])))
}

is_equal_approx :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
{
	if argc != 1 || !IS_VECTOR2D_PTR(&args[0]) {
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("is_equal_approx",1,argc,"a Vector2",call_error_p)
		return
	}

	BOOL_VAL_PTR(result, #force_inline _is_equal_approx(AS_VECTOR2_PTR(&args[0]),AS_VECTOR2_PTR(&args[argc])))
}

is_normalized :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
{
	if argc != 0 { when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("is_normalized",0,argc,call_error_p); return	}
	BOOL_VAL_PTR(result, #force_inline _is_normalized(AS_VECTOR2_PTR(&args[argc])))
}

length :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
{
	if argc != 0 { when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("length",0,argc,call_error_p); return	}
	FLOAT_VAL_PTR(result,#force_inline _length(AS_VECTOR2_PTR(&args[argc])))
}

length_squared :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
{
	if argc != 0 { when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("length_squared",0,argc,call_error_p); return	}
	FLOAT_VAL_PTR(result,#force_inline _length_squared(AS_VECTOR2_PTR(&args[argc])))
}

lerp :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
{
	l : Float

	if argc != 2 || !IS_VECTOR2D_PTR(&args[0]) || !IS_FLOAT_CAST_PTR(&args[1],&l) {
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("lerp",2,argc,"Vector2 and number",call_error_p)
		return
	}

	VECTOR2_VAL_PTRV( result,#force_inline _lerp(AS_VECTOR2_PTR(&args[argc]),AS_VECTOR2_PTR(&args[0]),l))
}

limit_length :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
{
	value : Float

	if argc != 2 || !IS_VECTOR2D_PTR(&args[0]) || !IS_FLOAT_CAST_PTR(&args[1],&value) {
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("limit_length",2,argc,"Vector2 and number",call_error_p)
		return
	}

	VECTOR2_VAL_PTRV( result,#force_inline _limit_length(AS_VECTOR2_PTR(&args[argc]),value))
}

min :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
{
	if argc != 1 || !IS_VECTOR2D_PTR(&args[0]) {
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("min",1,argc,"a Vector2",call_error_p)
		return
	}

	VECTOR2_VAL_PTRV( result, #force_inline _min(AS_VECTOR2_PTR(&args[argc]),AS_VECTOR2_PTR(&args[0])))
}

max :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
{
	if argc != 1 || !IS_VECTOR2D_PTR(&args[0]) {
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("max",1,argc,"a Vector2",call_error_p)
		return
	}

	v  := AS_VECTOR2_PTR(&args[0])
	VECTOR2_VAL_PTRV( result,#force_inline _max(AS_VECTOR2_PTR(&args[argc]),AS_VECTOR2_PTR(&args[0])))
}

normalize :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
{
	if argc != 0 { when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("normalize",0,argc,call_error_p); return	}
	VECTOR2_VAL_PTRV( result,#force_inline _normalize(AS_VECTOR2_PTR(&args[argc])))
}

move_toward :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
{
	value : Float
	if argc != 2 || !IS_VECTOR2D_PTR(&args[0]) || !IS_FLOAT_CAST_PTR(&args[1],&value) {
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("move_toward",2,argc,"Vector2 and number",call_error_p)
		return
	}

	VECTOR2_VAL_PTRV( result,#force_inline _move_toward(AS_VECTOR2_PTR(&args[argc]),AS_VECTOR2_PTR(&args[0]),value))
}

posmod  :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
{
	value: Float
	
	if argc != 1 || !IS_FLOAT_CAST_PTR(&args[0],&value) {
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("posmod",1,argc,"a number",call_error_p)
		return
	}

	if value == 0 { 
		CALL_WARNING_STRING(call_error_p,"the argument is zero. Returning Vector2(0,0) as fallback.")
		VECTOR2_VAL_PTRV(result,_ZERO)
		return
	}

	VECTOR2_VAL_PTRV( result, #force_inline _posmod(AS_VECTOR2_PTR(&args[argc]),value))
}


reflect :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
{
	if argc != 1 || !IS_VECTOR2D_PTR(&args[0]) {
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("reflect",1,argc,"a Vector2",call_error_p)
		return
	}
	VECTOR2_VAL_PTRV( result, #force_inline _reflect(AS_VECTOR2_PTR(&args[argc]),AS_VECTOR2_PTR(&args[0])))
}

round :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
{
	if argc != 0 { when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("round",0,argc,call_error_p); return	}
	VECTOR2_VAL_PTRV( result,#force_inline _round(AS_VECTOR2_PTR(&args[argc])))
}

rotate :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
{
	value: Float
	if argc != 1 || !IS_FLOAT_CAST_PTR(&args[0],&value) {
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("rotate",1,argc,"a number",call_error_p)
		return
	}
	VECTOR2_VAL_PTRV( result, #force_inline _rotate(AS_VECTOR2_PTR(&args[argc]),value))
}

sign :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
{
	if argc != 0 { when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("sign",0,argc,call_error_p); return	}
	VECTOR2_VAL_PTRV( result,#force_inline _sign(AS_VECTOR2_PTR(&args[argc])))
}

smoothstep :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
{
	value: Float

	if argc != 2 || !IS_VECTOR2D_PTR(&args[0]) || !IS_FLOAT_CAST_PTR(&args[1],&value) {
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("smoothstep",2,argc,"Vector2 and number",call_error_p)
		return
	}

	VECTOR2_VAL_PTRV( result,#force_inline _smoothstep(AS_VECTOR2_PTR(&args[argc]),AS_VECTOR2_PTR(&args[0]),value))
}

slerp :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
{
	value: Float
	if argc != 2 || !IS_VECTOR2D_PTR(&args[0]) || !IS_FLOAT_CAST_PTR(&args[1],&value) {
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("slerp",2,argc,"Vector2 and number",call_error_p)
		return
	}

	VECTOR2_VAL_PTRV( result,#force_inline _slerp(AS_VECTOR2_PTR(&args[argc]),AS_VECTOR2_PTR(&args[0]),value))
}

slide :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
{
	if argc != 1 || !IS_VECTOR2D_PTR(&args[0]) {
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("slide",1,argc,"a Vector2",call_error_p)
		return
	}

	n := AS_VECTOR2_PTR(&args[0])

	if !_is_normalized(n){
		CALL_WARNING_STRING(call_error_p,"the normal must be normalized. Returning Vector2(0,0) as fallback.")
		VECTOR2_VAL_PTRV( result,_ZERO)
		return
	}
	
	VECTOR2_VAL_PTRV( result,#force_inline _slide(AS_VECTOR2_PTR(&args[argc]),n))
}

snapped :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
{
	value: Float

	if argc != 1 || !IS_VECTOR2D_PTR(&args[0]) {
		when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("snapped",1,argc,"a Vector2",call_error_p)
		return
	}

	VECTOR2_VAL_PTRV( result, #force_inline _stepfy(AS_VECTOR2_PTR(&args[argc]),value))
}

orthogonal :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError) 
{
	if argc != 0 { when  OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("orthogonal",0,argc,call_error_p); return	}
	VECTOR2_VAL_PTRV( result,#force_inline _orthogonal(AS_VECTOR2_PTR(&args[argc])))
}
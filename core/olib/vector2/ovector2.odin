package OscriptVector2

import fmt     "core:fmt"


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



abs :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("abs",0,call_state); return	}
	VECTOR2_VAL_PTRV(call_state.result, #force_inline _abs(AS_VECTOR2_PTR(&call_state.args[0])))
}

aspect :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("aspect",0,call_state); return	}
	FLOAT_VAL_PTR(call_state.result,#force_inline _aspect(AS_VECTOR2_PTR(&call_state.args[0])))
}

angle :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("angle",0,call_state); return	}
	FLOAT_VAL_PTR(call_state.result, #force_inline _angle(AS_VECTOR2_PTR(&call_state.args[0])))
}

angle_from :: proc(call_state: ^CallState) 
{
	if call_state.argc != 1 || !IS_VECTOR2D_PTR(&call_state.args[0]) { error_msg("angle_from",1,"a Vector2",call_state); return }

	a   := #force_inline _angle(AS_VECTOR2_PTR(&call_state.args[1]))
	b   := #force_inline _angle(AS_VECTOR2_PTR(&call_state.args[0]))

	FLOAT_VAL_PTR(call_state.result, b-a)
}

angle_to_point :: proc(call_state: ^CallState) 
{
	if call_state.argc != 1 || !IS_VECTOR2D_PTR(&call_state.args[0]) { error_msg("angle_to_point",1,"a Vector2",call_state); return	}
	r := #force_inline _sub(AS_VECTOR2_PTR(&call_state.args[0]),AS_VECTOR2_PTR(&call_state.args[1]))
	FLOAT_VAL_PTR(call_state.result,#force_inline _angle(&r))
}

bounce :: proc(call_state: ^CallState) 
{
	if call_state.argc != 1 || !IS_VECTOR2D_PTR(&call_state.args[0]) { error_msg("bounce",1,"Vector2",call_state); return }
	n := AS_VECTOR2_PTR(&call_state.args[0])

	if !_is_normalized(n)
	{ 
		warning("the normal must be normalized. Returning Vector2(0,0) as fallback.",call_state)
		VECTOR2_VAL_PTRV(call_state.result,_ZERO)
		return
	}

	VECTOR2_VAL_PTRV(call_state.result,-#force_inline _reflect(AS_VECTOR2_PTR(&call_state.args[1]),n))
}

clamp :: proc (call_state: ^CallState) 
{
	for i in 0..<2 do if call_state.argc != 2 || !IS_VECTOR2D_PTR(&call_state.args[i]) { error_msg("clamp",2,"Vector2's",call_state); return }

	v   := AS_VECTOR2_PTR(&call_state.args[2])
	min := AS_VECTOR2_PTR(&call_state.args[0])
	max := AS_VECTOR2_PTR(&call_state.args[1])

	VECTOR2_VAL_PTRV( call_state.result,#force_inline _clamp(v,min,max))
}

cross :: proc(call_state: ^CallState) 
{
	if call_state.argc != 1 || !IS_VECTOR2D_PTR(&call_state.args[0]) {  error_msg("cross",1,"Vector2",call_state); return }
	FLOAT_VAL_PTR(call_state.result,#force_inline _cross(AS_VECTOR2_PTR(&call_state.args[1]),AS_VECTOR2_PTR(&call_state.args[0])))
}

direction_to :: proc(call_state: ^CallState) 
{
	if call_state.argc != 1 || !IS_VECTOR2D_PTR(&call_state.args[0]) { error_msg("direction_to",1,"Vector2",call_state); return }
	s := _sub(AS_VECTOR2_PTR(&call_state.args[1]),AS_VECTOR2_PTR(&call_state.args[0]))
	VECTOR2_VAL_PTRV( call_state.result,#force_inline _normalize(&s))
}

dot :: proc(call_state: ^CallState) 
{
	if call_state.argc != 1 || !IS_VECTOR2D_PTR(&call_state.args[0]) { error_msg("dot",1,"Vector2",call_state); return }
	FLOAT_VAL_PTR(call_state.result,#force_inline _dot(AS_VECTOR2_PTR(&call_state.args[1]),AS_VECTOR2_PTR(&call_state.args[0])))
}

distance_to :: proc(call_state: ^CallState) 
{
	if call_state.argc != 1 || !IS_VECTOR2D_PTR(&call_state.args[0]) {  error_msg("distance_to",1,"a Vector2",call_state); return }
	
	s := _sub(AS_VECTOR2_PTR(&call_state.args[0]),AS_VECTOR2_PTR(&call_state.args[1]))
	FLOAT_VAL_PTR(call_state.result,#force_inline _length(&s))
}

distance_to_squared :: proc(call_state: ^CallState) 
{
	if call_state.argc != 1 || !IS_VECTOR2D_PTR(&call_state.args[0]) { error_msg("distance_to_squared",1,"a Vector2",call_state); return }

	s := _sub(AS_VECTOR2_PTR(&call_state.args[0]),AS_VECTOR2_PTR(&call_state.args[1]))
	FLOAT_VAL_PTR(call_state.result,#force_inline _length_squared(&s))
}

floor :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("floor",0,call_state); return	}
	VECTOR2_VAL_PTRV( call_state.result,#force_inline _floor(AS_VECTOR2_PTR(&call_state.args[0])))
}

from_angle :: proc(call_state: ^CallState) 
{
	value : Float
	if call_state.argc != 1 || !IS_FLOAT_CAST_PTR(&call_state.args[0],&value) { error_msg("from_angle",1,"a number",call_state); return }
	VECTOR2_VAL_PTRV(call_state.result,#force_inline _from_angle(value))
}

invert :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("invert",0,call_state); return	}
	VECTOR2_VAL_PTRV(call_state.result,#force_inline _invert(AS_VECTOR2_PTR(&call_state.args[0])))
}

is_equal_approx :: proc(call_state: ^CallState) 
{
	if call_state.argc != 1 || !IS_VECTOR2D_PTR(&call_state.args[0]) { error_msg("is_equal_approx",1,"a Vector2",call_state); return }
	BOOL_VAL_PTR(call_state.result, #force_inline _is_equal_approx(AS_VECTOR2_PTR(&call_state.args[0]),AS_VECTOR2_PTR(&call_state.args[1])))
}

is_normalized :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("is_normalized",0,call_state); return	}
	BOOL_VAL_PTR(call_state.result, #force_inline _is_normalized(AS_VECTOR2_PTR(&call_state.args[0])))
}

length :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("length",0,call_state); return	}
	FLOAT_VAL_PTR(call_state.result,#force_inline _length(AS_VECTOR2_PTR(&call_state.args[0])))
}

length_squared :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("length_squared",0,call_state); return	}
	FLOAT_VAL_PTR(call_state.result,#force_inline _length_squared(AS_VECTOR2_PTR(&call_state.args[0])))
}

lerp :: proc(call_state: ^CallState) 
{
	l : Float
	if call_state.argc != 2 || !IS_VECTOR2D_PTR(&call_state.args[0]) || !IS_FLOAT_CAST_PTR(&call_state.args[1],&l) { error_msg("lerp",2,"Vector2 and number",call_state); return }
	VECTOR2_VAL_PTRV( call_state.result,#force_inline _lerp(AS_VECTOR2_PTR(&call_state.args[2]),AS_VECTOR2_PTR(&call_state.args[0]),l))
}

limit_length :: proc(call_state: ^CallState) 
{
	value : Float
	if call_state.argc != 2 || !IS_VECTOR2D_PTR(&call_state.args[0]) || !IS_FLOAT_CAST_PTR(&call_state.args[1],&value) { error_msg("limit_length",2,"Vector2 and number",call_state); return }
	VECTOR2_VAL_PTRV( call_state.result,#force_inline _limit_length(AS_VECTOR2_PTR(&call_state.args[2]),value))
}

min :: proc(call_state: ^CallState) 
{
	if call_state.argc != 1 || !IS_VECTOR2D_PTR(&call_state.args[0]) { error_msg("min",1,"a Vector2",call_state); return }
	VECTOR2_VAL_PTRV( call_state.result, #force_inline _min(AS_VECTOR2_PTR(&call_state.args[1]),AS_VECTOR2_PTR(&call_state.args[0])))
}

max :: proc(call_state: ^CallState) 
{
	if call_state.argc != 1 || !IS_VECTOR2D_PTR(&call_state.args[0]) { error_msg("max",1,"a Vector2",call_state); return }
	VECTOR2_VAL_PTRV( call_state.result,#force_inline _max(AS_VECTOR2_PTR(&call_state.args[1]),AS_VECTOR2_PTR(&call_state.args[0])))
}

normalize :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("normalize",0,call_state); return	}
	VECTOR2_VAL_PTRV( call_state.result,#force_inline _normalize(AS_VECTOR2_PTR(&call_state.args[0])))
}

move_toward :: proc(call_state: ^CallState) 
{
	value : Float
	if call_state.argc != 2 || !IS_VECTOR2D_PTR(&call_state.args[0]) || !IS_FLOAT_CAST_PTR(&call_state.args[1],&value) { error_msg("move_toward",2,"Vector2 and number",call_state); return }
	VECTOR2_VAL_PTRV( call_state.result,#force_inline _move_toward(AS_VECTOR2_PTR(&call_state.args[2]),AS_VECTOR2_PTR(&call_state.args[0]),value))
}


posmod  :: proc(call_state: ^CallState) 
{
	value: Float
	if call_state.argc != 1 || !IS_FLOAT_CAST_PTR(&call_state.args[0],&value) { error_msg("posmod",1,"a number",call_state); return }

	if value == 0.0  
	{ 
		warning("the argument is zero. Returning Vector2(0,0) as fallback.",call_state)
		VECTOR2_VAL_PTRV(call_state.result,_ZERO)
		return
	}

	VECTOR2_VAL_PTRV( call_state.result, #force_inline _posmod(AS_VECTOR2_PTR(&call_state.args[1]),value))
}


reflect :: proc(call_state: ^CallState) 
{
	if call_state.argc != 1 || !IS_VECTOR2D_PTR(&call_state.args[0]) { error_msg("reflect",1,"a Vector2",call_state); return }
	VECTOR2_VAL_PTRV( call_state.result, #force_inline _reflect(AS_VECTOR2_PTR(&call_state.args[1]),AS_VECTOR2_PTR(&call_state.args[0])))
}

round :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("round",0,call_state); return	}
	VECTOR2_VAL_PTRV( call_state.result,#force_inline _round(AS_VECTOR2_PTR(&call_state.args[0])))
}

rotate :: proc(call_state: ^CallState) 
{
	value: Float
	if call_state.argc != 1 || !IS_FLOAT_CAST_PTR(&call_state.args[0],&value) { error_msg("rotate",1,"a number",call_state); return }
	VECTOR2_VAL_PTRV( call_state.result, #force_inline _rotate(AS_VECTOR2_PTR(&call_state.args[1]),value))
}

sign :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("sign",0,call_state); return	}
	VECTOR2_VAL_PTRV( call_state.result,#force_inline _sign(AS_VECTOR2_PTR(&call_state.args[0])))
}

smoothstep :: proc(call_state: ^CallState) 
{
	value: Float
	if call_state.argc != 2 || !IS_VECTOR2D_PTR(&call_state.args[0]) || !IS_FLOAT_CAST_PTR(&call_state.args[1],&value) { error_msg("smoothstep",2,"Vector2 and number",call_state); return }

	VECTOR2_VAL_PTRV( call_state.result,#force_inline _smoothstep(AS_VECTOR2_PTR(&call_state.args[2]),AS_VECTOR2_PTR(&call_state.args[0]),value))
}

slerp :: proc(call_state: ^CallState) 
{
	value: Float
	if call_state.argc != 2 || !IS_VECTOR2D_PTR(&call_state.args[0]) || !IS_FLOAT_CAST_PTR(&call_state.args[1],&value) { error_msg("slerp",2,"Vector2 and number",call_state); return }

	VECTOR2_VAL_PTRV( call_state.result,#force_inline _slerp(AS_VECTOR2_PTR(&call_state.args[2]),AS_VECTOR2_PTR(&call_state.args[0]),value))
}

slide :: proc(call_state: ^CallState) 
{
	if call_state.argc != 1 || !IS_VECTOR2D_PTR(&call_state.args[0]) { error_msg("slide",1,"a Vector2",call_state); return }

	n := AS_VECTOR2_PTR(&call_state.args[0])

	if !_is_normalized(n)
	{
		warning("the normal must be normalized. Returning Vector2(0,0) as fallback.",call_state)
		VECTOR2_VAL_PTRV( call_state.result,_ZERO)
		return
	}
	
	VECTOR2_VAL_PTRV( call_state.result,#force_inline _slide(AS_VECTOR2_PTR(&call_state.args[1]),n))
}

snapped :: proc(call_state: ^CallState) 
{
	value: Float
	if call_state.argc != 1 || !IS_VECTOR2D_PTR(&call_state.args[0]) { error_msg("snapped",1,"a Vector2",call_state); return }

	VECTOR2_VAL_PTRV( call_state.result, #force_inline _stepfy(AS_VECTOR2_PTR(&call_state.args[1]),value))
}

orthogonal :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("orthogonal",0,call_state); return	}
	 VECTOR2_VAL_PTRV( call_state.result,#force_inline _orthogonal(AS_VECTOR2_PTR(&call_state.args[0])))
};  
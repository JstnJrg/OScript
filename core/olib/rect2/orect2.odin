#+private

package OScriptRect2D


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
	if call_state.argc != 0 { error_msg0("abs",0,call_state); return }

	r  : Rect2
	r0 := AS_RECT2_PTR(&call_state.args[0])

	_abs(r0,&r)
	RECT2_VAL_PTR(call_state.result,&r)
}

distance_to :: proc(call_state: ^CallState) 
{
	if call_state.argc != 1 || !IS_VECTOR2D_PTR(&call_state.args[0]) { error_msg("distance_to",1,TYPE_TO_STRING(.VECTOR2_VAL),call_state); return }

	r0  := AS_RECT2_PTR(&call_state.args[1])
	p   := AS_VECTOR2_PTR(&call_state.args[0])
	d   : Float

	_distance_to(r0,p,&d)
	FLOAT_VAL_PTR(call_state.result,d)
}

encloses :: proc(call_state: ^CallState) 
{

	if call_state.argc != 1 || !IS_RECT2_PTR(&call_state.args[0]) { error_msg("encloses",1,TYPE_TO_STRING(.RECT2_VAL),call_state); return }

	r0  := AS_RECT2_PTR(&call_state.args[1])
	r1  := AS_RECT2_PTR(&call_state.args[0])

	ok : bool
	_encloses(r0,r1,&ok)
	BOOL_VAL_PTR(call_state.result,ok)
}

expand :: proc(call_state: ^CallState) 
{
	if call_state.argc != 1 || !IS_VECTOR2D_PTR(&call_state.args[0]) { error_msg("expand",1,TYPE_TO_STRING(.VECTOR2_VAL),call_state); return }

	rect : Rect2
	r0   := AS_RECT2_PTR  (&call_state.args[1])
	p    := AS_VECTOR2_PTR(&call_state.args[0])
	
	_expand(r0,&rect,p)
	RECT2_VAL_PTR(call_state.result,&rect)
}

get_center :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("get_center",0,call_state); return	}

	v  : Vec2
	r0 := AS_RECT2_PTR(&call_state.args[0])

	_get_center(r0,&v)
	VECTOR2_VAL_PTR(call_state.result,&v)
}

get_area :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("get_area",0,call_state); return }

	r0  := AS_RECT2_PTR(&call_state.args[0])
	a   : Float

	_get_area(r0,&a)
	FLOAT_VAL_PTR(call_state.result,a)
}

grow :: proc(call_state: ^CallState) 
{
	offset : Float
	if call_state.argc != 1 || !IS_FLOAT_CAST_PTR(&call_state.args[0],&offset) { error_msg("grow",1,TYPE_TO_STRING(.FLOAT_VAL),call_state); return }

	r  : Rect2
	r0 := AS_RECT2_PTR(&call_state.args[1])
	
	_grow(r0,&r,&offset)
	RECT2_VAL_PTR(call_state.result,&r)
}


get_support :: proc(call_state: ^CallState) 
{
	if call_state.argc != 1 || !IS_VECTOR2D_PTR(&call_state.args[0]) { error_msg("get_support",1,TYPE_TO_STRING(.VECTOR2_VAL),call_state); return }

	support   : Vec2
	direction := AS_VECTOR2_PTR(&call_state.args[0])
	
	r0 := AS_RECT2_PTR(&call_state.args[1])
	_get_support(r0,direction,&support)

	VECTOR2_VAL_PTR(call_state.result,&support)
}


grow_individual :: proc(call_state: ^CallState) 
{
	offsets : [4]Float
	for i in 0..<4 do if call_state.argc != 4 || !IS_FLOAT_CAST_PTR(&call_state.args[i],&offsets[i]) { error_msg("grow_individual",4,"float,float,float and float",call_state); return }

	r   : Rect2
	r0  := AS_RECT2_PTR(&call_state.args[4])

	_grow_individual(r0,&r,&offsets)
	RECT2_VAL_PTR(call_state.result,&r)
}

has_point :: proc(call_state: ^CallState) 
{
	if call_state.argc != 1 || !IS_VECTOR2D_PTR(&call_state.args[0]) { error_msg("has_point",1,TYPE_TO_STRING(.VECTOR2_VAL),call_state); return }

	has      : bool
	r0  := AS_RECT2_PTR(&call_state.args[1])
	p   := AS_VECTOR2_PTR(&call_state.args[0])
	
	_has_point(r0,p,&has)
	BOOL_VAL_PTR(call_state.result,has)
}

has_no_area :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("has_no_area",0,call_state); return }

	has : bool
	r0  := AS_RECT2_PTR(&call_state.args[0])

	_has_no_area(r0,&has)
	BOOL_VAL_PTR(call_state.result,has)
}


intersects :: proc(call_state: ^CallState) 
{
	if call_state.argc != 1 || !IS_RECT2_PTR(&call_state.args[0]) { error_msg("intersects",1,TYPE_TO_STRING(.RECT2_VAL),call_state); return }

	r0  := AS_RECT2_PTR(&call_state.args[1])
	r1  := AS_RECT2_PTR(&call_state.args[0])

	BOOL_VAL_PTR(call_state.result,_intersects(r0,r1))
}

merge :: proc(call_state: ^CallState) 
{
	if call_state.argc != 1 || !IS_RECT2_PTR(&call_state.args[0]) { error_msg("merge",1,TYPE_TO_STRING(.RECT2_VAL),call_state); return }

	r   : Rect2
	r0  := AS_RECT2_PTR(&call_state.args[1])
	r1  := AS_RECT2_PTR(&call_state.args[0])

	_merge(r0,r1,&r)
	RECT2_VAL_PTR(call_state.result,&r)
}

clip :: proc(call_state: ^CallState) 
{
	if call_state.argc != 1 || !IS_RECT2_PTR(&call_state.args[0]) { error_msg("clip",1,TYPE_TO_STRING(.RECT2_VAL),call_state); return }

	r   : Rect2
	r0  := AS_RECT2_PTR(&call_state.args[1])
	r1  := AS_RECT2_PTR(&call_state.args[0])

	_clip(r0,r1,&r)
	RECT2_VAL_PTR(call_state.result,&r)
}
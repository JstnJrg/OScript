#+private

package OscriptArray


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



size :: proc(call_state: ^CallState)
{
	if call_state.argc != 0 { error_msg0("size",0,call_state); return }
	array_obj := VAL_AS_OBJ_ARRAY_PTR(&call_state.args[0])

	INT_VAL_PTR(call_state.result,array_obj.len)
}

shuffle :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("shuffle",0,call_state); return }
    arr_p := &VAL_AS_OBJ_ARRAY_PTR(&call_state.args[0]).data
   
    _shuffle(arr_p)
	NIL_VAL_PTR(call_state.result)
}


_clear :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("clear",0,call_state); return }

    arr   := VAL_AS_OBJ_ARRAY_PTR(&call_state.args[0])
    arr_p := &arr.data

    __clear(arr_p)
    arr.len = 0

	NIL_VAL_PTR(call_state.result)
}


resize_ :: proc(call_state: ^CallState) 
{
	amount: Int
	if call_state.argc != 1 || !IS_INT_PTR(&call_state.args[0],&amount) || amount < 0 { error_msg("resize",1,"a positive int",call_state); return }
  
    arr      := VAL_AS_OBJ_ARRAY_PTR(&call_state.args[1])
    arr_p    := &arr.data
    clen     := arr.len
    sucess   :=  #force_inline _resize(arr_p,amount)
    plen     := len(arr_p)

    size := plen-clen-1
    for i := clen ;size >= 0; size -= 1 do NIL_VAL_PTR(&arr_p[i+size])

    arr.len = plen
	BOOL_VAL_PTR(call_state.result, sucess )
}

choice :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("choice",0,call_state); return }
    arr_p := &VAL_AS_OBJ_ARRAY_PTR(&call_state.args[0]).data

	_choice(arr_p,call_state.result)
}

append_ :: proc(call_state: ^CallState) 
{
	if call_state.argc == 0 { error("'append' expects over 0 argument.",call_state); return }

    arr   := VAL_AS_OBJ_ARRAY_PTR(&call_state.args[call_state.argc])
    arr_p := &arr.data

    #force_inline _append(arr_p,call_state.args[0:][:call_state.argc])
    arr.len += call_state.argc

	NIL_VAL_PTR(call_state.result)

}

append_array :: proc(call_state: ^CallState) 
{
	if call_state.argc != 1 { error_msg("append_array",1,"Array",call_state); return }

    arr   := VAL_AS_OBJ_ARRAY_PTR(&call_state.args[1])
    arr_p := &arr.data

    p      := VAL_AS_OBJ_ARRAY_PTR(&call_state.args[0])
    p_data := &p.data

    #force_inline _append(arr_p,p_data[:])
    arr.len += p.len

	NIL_VAL_PTR(call_state.result)
}


pop_back :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("pop_back",0,call_state); return }

    arr   := VAL_AS_OBJ_ARRAY_PTR(&call_state.args[0])
    len_p := &arr.len

    if len_p^ <= 0 { NIL_VAL_PTR(call_state.result); return }
    
    arr_p   := &arr.data
    last, _ := pop_safe(arr_p)
    len_p^ -= 1

    GENERIC_VAL_PTR(&last,call_state.result)
}

pop_front :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("pop_front",0,call_state); return }

    arr   := VAL_AS_OBJ_ARRAY_PTR(&call_state.args[0])
    len_p := &arr.len

    if len_p^ <= 0 { NIL_VAL_PTR(call_state.result); return }

    arr_p   := &arr.data
    first, _ := pop_front_safe(arr_p)
    len_p^ -= 1

    GENERIC_VAL_PTR(&first,call_state.result)
}


qsort :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("qsort",0,call_state); return }
    
    arr_p := &VAL_AS_OBJ_ARRAY_PTR(&call_state.args[0]).data
    size  := len(arr_p)-1

    if size <= 0 { NIL_VAL_PTR(call_state.result); return }

    _quick_short(arr_p,call_state.result,0,size,&call_state.error_bf)
	NIL_VAL_PTR(call_state.result)
}

ssort :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("ssort",0,call_state); return }
    
    arr_p := &VAL_AS_OBJ_ARRAY_PTR(&call_state.args[0]).data
    size  := len(arr_p)-1

    if size <= 0 { NIL_VAL_PTR(call_state.result); return }

    _shell_short(arr_p,call_state.result,&call_state.error_bf)
	NIL_VAL_PTR(call_state.result)
}

find :: proc(call_state: ^CallState) 
{
	if call_state.argc != 1 { error_msg0("find",1,call_state); return }

    arr   := VAL_AS_OBJ_ARRAY_PTR(&call_state.args[1])
    arr_p := &arr.data
    len_p := &arr.len

    if len_p^ <= 0 { INT_VAL_PTR(call_state.result,-1); return }

    INT_VAL_PTR(call_state.result,_binary(arr_p,call_state.args[0],call_state.result,&call_state.error_bf))
}

fill :: proc(call_state: ^CallState) 
{
    if call_state.argc != 1 { error_msg0("fill",1,call_state); return }

    arr   := VAL_AS_OBJ_ARRAY_PTR(&call_state.args[1])
    arr_p := &arr.data
    len   := arr.len-1

    for ; len >= 0; len -= 1 do arr_p[len] = call_state.args[0]

    NIL_VAL_PTR(call_state.result)
}


count :: proc(call_state: ^CallState) 
{
    if call_state.argc != 1 { error_msg0("count",1,call_state); return }

    arr   := VAL_AS_OBJ_ARRAY_PTR(&call_state.args[1])
    arr_p := &arr.data
 
    INT_VAL_PTR(call_state.result,_equal_count(arr_p,&call_state.args[0],&call_state.error_bf))
}

has :: proc(call_state: ^CallState) 
{
    if call_state.argc != 1 { error_msg0("has",1,call_state); return }

    arr   := VAL_AS_OBJ_ARRAY_PTR(&call_state.args[1])
    arr_p := &arr.data
    len   := arr.len

   BOOL_VAL_PTR(call_state.result, len <= 0 ? false: _binary(arr_p,call_state.args[0],call_state.result,&call_state.error_bf) != -1 )  
}

reverse :: proc(call_state: ^CallState) 
{
    if call_state.argc != 0 { error_msg0("reverse",0,call_state); return }

    arr   := VAL_AS_OBJ_ARRAY_PTR(&call_state.args[0])
    arr_p := &arr.data
    len   := arr.len

    _reverse(arr_p,len)
    NIL_VAL_PTR(call_state.result)
}

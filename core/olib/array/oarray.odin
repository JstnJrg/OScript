#+private

package OscriptArray

import fmt "core:fmt"

println :: fmt.println


error_msg :: proc(fn_name: string, expected,argc: Int,be: string ,call_error_p: ^ObjectCallError) {
	CALL_ERROR_STRING(call_error_p,"'",fn_name,"' function expects '",expected,"' args, but got ",argc,", and the argument must be ",be,".")
}

error_msg0 :: proc(fn_name: string, expected,argc: Int ,call_error_p: ^ObjectCallError) {
	CALL_ERROR_STRING(call_error_p,"'",fn_name,"' function expects '",expected,"' args, but got ",argc,".")
}

error_msg2 :: proc(fn_name,msg: string,call_error_p: ^ObjectCallError) {
	CALL_ERROR_STRING(call_error_p,"'",fn_name,"' function '",msg)
}

size :: proc(argc: Int, args: []Value,result: ^Value, call_error_p : ^ObjectCallError){
	if argc != 0 { when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("size",0,argc,call_error_p); return }
	array_obj := VAL_AS_OBJ_ARRAY_PTR(&args[argc])
	INT_VAL_PTR(result,array_obj.len)
}

shuffle :: proc(argc: Int, args: []Value, result: ^Value, call_error_p : ^ObjectCallError) {
	
	if argc != 0 { when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("shuffle",0,argc,call_error_p); return }
    arr_p := &VAL_AS_OBJ_ARRAY_PTR(&args[argc]).data
   
    _shuffle(arr_p)
	NIL_VAL_PTR(result)
}


_clear :: proc(argc: Int, args: []Value, result: ^Value, call_error_p : ^ObjectCallError) {
	
	if argc != 0 { when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("clear",0,argc,call_error_p); return }

    arr   := VAL_AS_OBJ_ARRAY_PTR(&args[argc])
    arr_p := &arr.data

    __clear(arr_p)
    arr.len = 0

	NIL_VAL_PTR(result)
}


resize_ :: proc(argc: Int, args: []Value, result: ^Value, call_error_p : ^ObjectCallError) {
	
	amount: Int

	if argc != 1 || !IS_INT_PTR(&args[0],&amount) { 
	 when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("resize",1,argc,"a int",call_error_p)
	 return
    }
  

    arr      := VAL_AS_OBJ_ARRAY_PTR(&args[argc])
    arr_p    := &arr.data
    clen     := arr.len
    sucess   :=  #force_inline _resize(arr_p,amount)
    plen     := len(arr_p)

    size := plen-clen-1
    for i := clen ;size >= 0; size -= 1 do NIL_VAL_PTR(&arr_p[i+size])

    arr.len = plen

	BOOL_VAL_PTR(result, sucess )
}

choice :: proc(argc: Int, args: []Value, result: ^Value, call_error_p : ^ObjectCallError) {
	
	if argc != 0 { when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("choice",0,argc,call_error_p); return }
    
    arr_p := &VAL_AS_OBJ_ARRAY_PTR(&args[argc]).data
	_choice(arr_p,result)
}

append_ :: proc(argc: Int, args: []Value, result: ^Value, call_error_p : ^ObjectCallError) {
	
	if argc == 0 { when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg2("append","expects over 0 argument.",call_error_p); return }


    arr   := VAL_AS_OBJ_ARRAY_PTR(&args[argc])
    arr_p := &arr.data

    #force_inline _append(arr_p,args[0:][:argc])
    arr.len += argc

	NIL_VAL_PTR(result)

}

append_array :: proc(argc: Int, args: []Value, result: ^Value, call_error_p : ^ObjectCallError) {
	
	if argc != 1 { when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("append_array",1,argc,"Array",call_error_p); return }

    arr   := VAL_AS_OBJ_ARRAY_PTR(&args[argc])
    arr_p := &arr.data

    p      := VAL_AS_OBJ_ARRAY_PTR(&args[0])
    p_data := &p.data

    #force_inline _append(arr_p,p_data[:])
    arr.len += p.len

	NIL_VAL_PTR(result)
}


pop_back :: proc(argc: Int, args: []Value, result: ^Value, call_error_p : ^ObjectCallError) {
	
	if argc != 0 { when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("pop_back",0,argc,call_error_p); return }

    arr   := VAL_AS_OBJ_ARRAY_PTR(&args[argc])
    len_p := &arr.len

    if len_p^ <= 0 { NIL_VAL_PTR(result); return }

    arr_p   := &arr.data
    last, _ := pop_safe(arr_p)
    len_p^ -= 1

    GENERIC_VAL_PTR(&last,result)
}

pop_front :: proc(argc: Int, args: []Value, result: ^Value, call_error_p : ^ObjectCallError) {
	
	if argc != 0 { when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("pop_front",0,argc,call_error_p); return }

    arr   := VAL_AS_OBJ_ARRAY_PTR(&args[argc])
    len_p := &arr.len

    if len_p^ <= 0 { NIL_VAL_PTR(result); return }

    arr_p   := &arr.data
    first, _ := pop_front_safe(arr_p)
    len_p^ -= 1

    GENERIC_VAL_PTR(&first,result)
}


qsort :: proc(argc: Int, args: []Value, result: ^Value, call_error_p : ^ObjectCallError) {
	
	if argc != 0 { when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("qsort",0,argc,call_error_p); return }
    
    arr_p := &VAL_AS_OBJ_ARRAY_PTR(&args[argc]).data
    size  := len(arr_p)-1

    if size <= 0 { NIL_VAL_PTR(result); return }

    _quick_short(arr_p,result,0,size,call_error_p)
	NIL_VAL_PTR(result)
}

ssort :: proc(argc: Int, args: []Value, result: ^Value, call_error_p : ^ObjectCallError) {
	
	if argc != 0 { when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("ssort",0,argc,call_error_p); return }
    
    arr_p := &VAL_AS_OBJ_ARRAY_PTR(&args[argc]).data
    size  := len(arr_p)-1

    if size <= 0 { NIL_VAL_PTR(result); return }

    _shell_short(arr_p,result,call_error_p)
	NIL_VAL_PTR(result)
}

find :: proc(argc: Int, args: []Value, result: ^Value, call_error_p : ^ObjectCallError) {
	
	if argc != 1 { when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("find",1,argc,call_error_p); return }

    arr   := VAL_AS_OBJ_ARRAY_PTR(&args[argc])
    arr_p := &arr.data
    len_p := &arr.len

    if len_p^ <= 0 { INT_VAL_PTR(result,-1); return }

    INT_VAL_PTR(result,_binary(arr_p,args[0],result,call_error_p))

}

fill :: proc(argc: Int, args: []Value, result: ^Value, call_error_p : ^ObjectCallError) {
    
    if argc != 1 { when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("fill",1,argc,call_error_p); return }

    arr   := VAL_AS_OBJ_ARRAY_PTR(&args[argc])
    arr_p := &arr.data
    len   := arr.len-1

    for ; len >= 0; len -= 1 do arr_p[len] = args[0]

    NIL_VAL_PTR(result)
}


count :: proc(argc: Int, args: []Value, result: ^Value, call_error_p : ^ObjectCallError) {
    
    if argc != 1 { when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("count",1,argc,call_error_p); return }

    arr   := VAL_AS_OBJ_ARRAY_PTR(&args[argc])
    arr_p := &arr.data
 
    INT_VAL_PTR(result,_equal_count(arr_p,&args[0],call_error_p))
}

has :: proc(argc: Int, args: []Value, result: ^Value, call_error_p : ^ObjectCallError) {
    
    if argc != 1 { when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("has",1,argc,call_error_p); return }

    arr   := VAL_AS_OBJ_ARRAY_PTR(&args[argc])
    arr_p := &arr.data
    len   := arr.len

   BOOL_VAL_PTR(result, len <= 0 ? false: _binary(arr_p,args[0],result,call_error_p) != -1 )  
}

reverse :: proc(argc: Int, args: []Value, result: ^Value, call_error_p : ^ObjectCallError) {
    
    if argc != 0 { when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("reverse",0,argc,call_error_p); return }

    arr   := VAL_AS_OBJ_ARRAY_PTR(&args[argc])
    arr_p := &arr.data
    len   := arr.len

    _reverse(arr_p,len)
    NIL_VAL_PTR(result)
}

#+private

package OscriptString

import strings "core:strings"

error_msg :: proc(fn_name: string, expected,argc: Int,be: string ,call_error_p: ^ObjectCallError) {
	CALL_ERROR_STRING(call_error_p,"'",fn_name,"' function expects '",expected,"' args, but got ",argc,", and the argument must be ",be,".")
}

error_msg0 :: proc(fn_name: string, expected,argc: Int ,call_error_p: ^ObjectCallError) {
	CALL_ERROR_STRING(call_error_p,"'",fn_name,"' function expects '",expected,"' args, but got ",argc,".")
}

error_msg1 :: proc(fn_name,costum: string, argc: Int,be: string ,call_error_p: ^ObjectCallError) {
	CALL_ERROR_STRING(call_error_p,"'",fn_name,"' function expects ",costum,", but got ",argc,", and the argument must be ",be,".")
}



length :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {

	if argc != 0 { when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("length",0,argc,call_error_p); return }
   INT_VAL_PTR(result,len(VAL_STRING_DATA_PTR(&args[argc])))
}

contains :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {


	
	if argc != 1 || !IS_VAL_STRING_PTR(&args[0]) { 
	  	when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("contains",1,argc," string",call_error_p)
	  	return
	}

	BOOL_VAL_PTR(result, #force_inline strings.contains(VAL_STRING_DATA_PTR(&args[argc]),VAL_STRING_DATA_PTR(&args[0])))
}


contains_space :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {

	if argc != 0 { when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("contains_space",0,argc,call_error_p); return }
	BOOL_VAL_PTR(result,#force_inline strings.contains_space(VAL_STRING_DATA_PTR(&args[argc])))
}


char_count :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {

	if argc != 0 { when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("char_count",0,argc,call_error_p); return }
	INT_VAL_PTR( result, #force_inline strings.rune_count(VAL_STRING_DATA_PTR(&args[argc])))
}

equaln :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
	if argc != 1 || !IS_VAL_STRING_PTR(&args[0]) { 
		when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("equaln",1,argc,"string",call_error_p)
	  	return
	}

	BOOL_VAL_PTR(result, #force_inline strings.equal_fold(VAL_STRING_DATA_PTR(&args[argc]),VAL_STRING_DATA_PTR(&args[0])))
}


prefix_commom_length :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {

	if argc != 1 || !IS_VAL_STRING_PTR(&args[0]) { 
		when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("prefix_commom_length",1,argc,"string",call_error_p)
	  	return
	}
	INT_VAL_PTR( result, #force_inline strings.prefix_length(VAL_STRING_DATA_PTR(&args[argc]),VAL_STRING_DATA_PTR(&args[0])))
}

has_prefix :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
	if argc != 1 || !IS_VAL_STRING_PTR(&args[0]) { 
		when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("has_prefix",1,argc,"string",call_error_p)
	  	return
	}
	BOOL_VAL_PTR( result, #force_inline strings.has_prefix(VAL_STRING_DATA_PTR(&args[argc]),VAL_STRING_DATA_PTR(&args[0])))
}

has_suffix :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
	if argc != 1 || !IS_VAL_STRING_PTR(&args[0]) { 
		when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("has_suffix",1,argc,"string",call_error_p)
	  	return
	}

	BOOL_VAL_PTR( result, #force_inline strings.has_suffix(VAL_STRING_DATA_PTR(&args[argc]),VAL_STRING_DATA_PTR(&args[0])))
}

join :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
	for i in 0..< argc do if argc < 2 || !IS_VAL_STRING_PTR(&args[i]) { 
		when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg1("join","over 1 args",argc,"string's",call_error_p)
	  	return
	}

	string_r    := CREATE_OBJ_STRING_NO_DATA()
	OBJ_STRING_WRITE_DATA(string_r,VAL_AS_OBJ_STRING_PTR(&args[argc]))

	for i in 0..< argc-1 {
		OBJ_STRING_WRITE_DATA(string_r,VAL_AS_OBJ_STRING_PTR(&args[argc-1]))
		OBJ_STRING_WRITE_DATA(string_r,VAL_AS_OBJ_STRING_PTR(&args[i]))
	}

	OBJ_STRING_COMPUTE_HASH(string_r)
	OBJECT_VAL_PTR(result,string_r,.OBJ_STRING)
}

replace :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
	amount : Int

	if argc != 3 || !IS_VAL_STRING_PTR(&args[0]) || !IS_VAL_STRING_PTR(&args[1]) || !IS_INT_PTR(&args[2],&amount) { 
		when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("replace",3,argc,"string's and int",call_error_p)
	  	return
	}

	string_r    := CREATE_OBJ_STRING_NO_DATA()
	allocator   := context.temp_allocator

	r,allocated := #force_inline strings.replace(VAL_STRING_DATA_PTR(&args[argc]),VAL_STRING_DATA_PTR(&args[0]),VAL_STRING_DATA_PTR(&args[1]),amount,allocator)
	
	OBJ_STRING_WRITE_DATA_STRING(string_r,r,true)
	OBJECT_VAL_PTR(result,string_r,.OBJ_STRING)

	free_all(allocator)
}

remove :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
	value : Int

	if argc != 2 || !IS_VAL_STRING_PTR(&args[0]) || !IS_INT_PTR(&args[1],&value) { 
		when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("remove",2,argc,"string and int",call_error_p)
	  	return
	}

	string_r     := CREATE_OBJ_STRING_NO_DATA()
	allocator    := context.temp_allocator

	r, _ := #force_inline strings.remove(VAL_STRING_DATA_PTR(&args[argc]),VAL_STRING_DATA_PTR(&args[0]),value,allocator)
	
	OBJ_STRING_WRITE_DATA_STRING(string_r,r,true)
	OBJECT_VAL_PTR(result,string_r,.OBJ_STRING)

	free_all(allocator)
}

repeat :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
	value: Int

	if argc != 1 || !IS_INT_PTR(&args[0],&value) { 
		when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("repeat",1,argc,"string and int",call_error_p)
	  	return
	}

	l := VAL_AS_OBJ_STRING_PTR(&args[argc]).len

	if value < 0 { 
	  	when OSCRIPT_ALLOW_RUNTIME_WARNINGS do CALL_ERROR_STRING(call_error_p,"negative repeat count.")
	  	return
	}

	if value > 0 && (l*value)/value != l { 
	  	when OSCRIPT_ALLOW_RUNTIME_WARNINGS do CALL_ERROR_STRING(call_error_p,"repeat count will cause an overflow.")
	  	return
	}

	string_r     := CREATE_OBJ_STRING_NO_DATA()
	allocator    := context.temp_allocator

	r,_ := #force_inline strings.repeat(VAL_STRING_DATA_PTR(&args[argc]),value,allocator)

	OBJ_STRING_WRITE_DATA_STRING(string_r,r,true)
	OBJECT_VAL_PTR(result,string_r,.OBJ_STRING)

	free_all(allocator)
}

reverse :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {

	
	if argc != 0 { 
		when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("remove",0,argc,call_error_p)
	  	return
	}

	allocator   := context.temp_allocator
	r,_         := #force_inline strings.reverse(VAL_STRING_DATA_PTR(&args[argc]),allocator)

	string_r 	 := CREATE_OBJ_STRING_NO_DATA()

	OBJ_STRING_WRITE_DATA_STRING(string_r,r,true)
	OBJECT_VAL_PTR(result,string_r,.OBJ_STRING)
	free_all(allocator)
}

center_justify :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
	value: Int

	if argc != 2 || !IS_VAL_STRING_PTR(&args[0]) || !IS_INT_PTR(&args[1],&value) { 
		when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("center_justify",2,argc,"string and int",call_error_p)
	  	return
	}

	allocator   := context.temp_allocator
	r,_         := #force_inline strings.center_justify(VAL_STRING_DATA_PTR(&args[argc]),value,VAL_STRING_DATA_PTR(&args[0]),allocator)
	
	string_r := CREATE_OBJ_STRING_NO_DATA()
	
	OBJ_STRING_WRITE_DATA_STRING(string_r,r,true)
	free_all(allocator)

	OBJECT_VAL_PTR(result,string_r,.OBJ_STRING)
}


right_justify :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
	value: Int

	if argc != 2 || !IS_VAL_STRING_PTR(&args[0]) || !IS_INT_PTR(&args[1],&value) { 
		when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("right_justify",2,argc,"string and int",call_error_p)
	  	return
	}

	allocator   := context.temp_allocator
	r,_         := #force_inline strings.right_justify(VAL_STRING_DATA_PTR(&args[argc]),value,VAL_STRING_DATA_PTR(&args[0]),allocator)
	
	string_r := CREATE_OBJ_STRING_NO_DATA()
	
	OBJ_STRING_WRITE_DATA_STRING(string_r,r,true)
	free_all(allocator)

	OBJECT_VAL_PTR(result,string_r,.OBJ_STRING)
}

left_justify :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
	value: Int

	if argc != 2 || !IS_VAL_STRING_PTR(&args[0]) || !IS_INT_PTR(&args[1],&value) { 
		when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("left_justify",2,argc,"string and int",call_error_p)
	  	return
	}

	allocator   := context.temp_allocator
	r,_         := #force_inline strings.left_justify(VAL_STRING_DATA_PTR(&args[argc]),value,VAL_STRING_DATA_PTR(&args[0]),allocator)
	
	string_r := CREATE_OBJ_STRING_NO_DATA()
	
	OBJ_STRING_WRITE_DATA_STRING(string_r,r,true)
	free_all(allocator)

	OBJECT_VAL_PTR(result,string_r,.OBJ_STRING)
}

cut :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
	values : [2]Int

    for i in 0..< 2 do if argc != 2 || !IS_INT_PTR(&args[i],&values[i]) { 
		when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("cut",2,argc,"int's",call_error_p)
	  	return
	}

	string_r := CREATE_OBJ_STRING_NO_DATA()
	OBJ_STRING_WRITE_DATA_STRING(string_r,#force_inline strings.cut(VAL_STRING_DATA_PTR(&args[argc]),values[0],values[1]),true)

	OBJECT_VAL_PTR(result,string_r,.OBJ_STRING)
}


substring :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
	values: [2]Int

    for i in 0..< 2 do if argc != 2 || !IS_INT_PTR(&args[i],&values[i]) { 
		when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("substring",2,argc,"int's",call_error_p)
	  	return
	}

	r, _ := #force_inline strings.substring(VAL_STRING_DATA_PTR(&args[argc]),values[0],values[1])
	
	string_r := CREATE_OBJ_STRING_NO_DATA()
	OBJ_STRING_WRITE_DATA_STRING(string_r,r,true)

	OBJECT_VAL_PTR(result,string_r,.OBJ_STRING)
}

substring_from :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
	value: Int

    if argc != 1 || !IS_INT_PTR(&args[0],&value) { 
		when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("substring_from",1,argc,"int",call_error_p)
	  	return
	}

	r, _ := #force_inline strings.substring_from(VAL_STRING_DATA_PTR(&args[argc]),value)

	string_r := CREATE_OBJ_STRING_NO_DATA()
	OBJ_STRING_WRITE_DATA_STRING(string_r,r,true)

	OBJECT_VAL_PTR(result,string_r,.OBJ_STRING)
}

substring_to :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
	value: Int

    if argc != 1 || !IS_INT_PTR(&args[0],&value) { 
		when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("substring_to",1,argc,"int",call_error_p)
	  	return
	}

	r, _ := #force_inline strings.substring_to(VAL_STRING_DATA_PTR(&args[argc]),value)
	
	string_r := CREATE_OBJ_STRING_NO_DATA()
	OBJ_STRING_WRITE_DATA_STRING(string_r,r,true)

	OBJECT_VAL_PTR(result,string_r,.OBJ_STRING)
}

expand_tabs :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
	value: Int

    if argc != 1 || !IS_INT_PTR(&args[0],&value) { 
		when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("expand_tabs",1,argc,"int",call_error_p)
	  	return
	}

	allocator   := context.temp_allocator

	r,_         := #force_inline strings.replace(VAL_STRING_DATA_PTR(&args[argc]),"\\t","\t",-1,allocator)
	s,_         := #force_inline strings.expand_tabs(r,value,allocator)
	
	string_r := CREATE_OBJ_STRING_NO_DATA()
	
	OBJ_STRING_WRITE_DATA_STRING(string_r,s,true)
	free_all(allocator)

	OBJECT_VAL_PTR(result,string_r,.OBJ_STRING)
}


trim_suffix :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
    if argc != 1 || !IS_VAL_STRING_PTR(&args[0]) { 
		when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("trim_suffix",1,argc,"string",call_error_p)
	  	return
	}

	string_r := CREATE_OBJ_STRING_NO_DATA()
	OBJ_STRING_WRITE_DATA_STRING(string_r,#force_inline strings.trim_suffix(VAL_STRING_DATA_PTR(&args[argc]),VAL_STRING_DATA_PTR(&args[0])),true)

	OBJECT_VAL_PTR(result,string_r,.OBJ_STRING)
}

trim_prefix :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
    if argc != 1 || !IS_VAL_STRING_PTR(&args[0]) { 
		when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("trim_prefix",1,argc,"string",call_error_p)
	  	return
	}

	string_r := CREATE_OBJ_STRING_NO_DATA()
	OBJ_STRING_WRITE_DATA_STRING(string_r,#force_inline strings.trim_prefix(VAL_STRING_DATA_PTR(&args[argc]),VAL_STRING_DATA_PTR(&args[0])),true)

	OBJECT_VAL_PTR(result,string_r,.OBJ_STRING)
}

trim :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
    if argc != 1 || !IS_VAL_STRING_PTR(&args[0]) { 
		when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("trim",1,argc,"string",call_error_p)
	  	return
	}

	string_r := CREATE_OBJ_STRING_NO_DATA()
	OBJ_STRING_WRITE_DATA_STRING(string_r,#force_inline strings.trim(VAL_STRING_DATA_PTR(&args[argc]),VAL_STRING_DATA_PTR(&args[0])),true)

	OBJECT_VAL_PTR(result,string_r,.OBJ_STRING)
}

compare :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
    if argc != 1 || !IS_VAL_STRING_PTR(&args[0]) { 
		when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg("compare",1,argc,"string",call_error_p)
	  	return
	}

	INT_VAL_PTR( result,#force_inline strings.compare(VAL_STRING_DATA_PTR(&args[argc]),VAL_STRING_DATA_PTR(&args[0])))
}

// count :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
//


// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 1 || !IS_VAL_STRING_PTR(&args[0]) { 
// 	  	CALL_ERROR_STRING(call_error_p,"'count' function expects '1' arg, but got ",argc,", and the arguments must be a string.")
// 	  	return
// 	}
// 	INT_VAL_PTR( result, #force_inline strings.count(VAL_STRING_DATA_PTR(&args[argc]),VAL_STRING_DATA_PTR(&args[0])))
// }

// get_last_index :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
//


// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 1 || !IS_VAL_STRING_PTR(&args[0]) { 
// 	  	CALL_ERROR_STRING(call_error_p,"'get_last_index' function expects '1' arg, but got ",argc,", and the arguments must be a string.")
// 	  	return
// 	}
// 	INT_VAL_PTR( result, #force_inline strings.last_index_any(VAL_STRING_DATA_PTR(&args[argc]),VAL_STRING_DATA_PTR(&args[0])))
// }


// get_first_index :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
//


// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 1 || !IS_VAL_STRING_PTR(&args[0]) { 
// 	  	CALL_ERROR_STRING(call_error_p,"'get_first_index' function expects '1' arg, but got ",argc,", and the arguments must be a string.")
// 	  	return
// 	}
// 	INT_VAL_PTR( result, #force_inline strings.index_any(VAL_STRING_DATA_PTR(&args[argc]),VAL_STRING_DATA_PTR(&args[0])))
// }

// get_index :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
//


// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 1 || !IS_VAL_STRING_PTR(&args[0]) { 
// 	  	CALL_ERROR_STRING(call_error_p,"'get_index' function expects '1' arg, but got ",argc,", and the arguments must be a string.")
// 	  	return
// 	}
// 	INT_VAL_PTR( result, #force_inline strings.index(VAL_STRING_DATA_PTR(&args[argc]),VAL_STRING_DATA_PTR(&args[0])))
// }


hash :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {	
	if argc != 0 { when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("hash",0,argc,call_error_p); return }
	INT_VAL_PTR( result, int(VAL_AS_OBJ_STRING_PTR(&args[argc]).hash))
}

to_lower :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
	if argc != 0 { when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("to_lower",0,argc,call_error_p); return }

	allocator   := context.temp_allocator
	s, _        := #force_inline strings.to_lower(VAL_STRING_DATA_PTR(&args[argc]),allocator)	
	
	string_r := CREATE_OBJ_STRING_NO_DATA()

	OBJ_STRING_WRITE_DATA_STRING(string_r,s,true)
	free_all(allocator)

	OBJECT_VAL_PTR(result,string_r,.OBJ_STRING)
}

to_upper :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
	if argc != 0 { when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("to_upper",0,argc,call_error_p); return }

	allocator   := context.temp_allocator
	s,_         := #force_inline strings.to_upper(VAL_STRING_DATA_PTR(&args[argc]),allocator)	
	
	string_r := CREATE_OBJ_STRING_NO_DATA()

	OBJ_STRING_WRITE_DATA_STRING(string_r,s,true)
	free_all(allocator)

	OBJECT_VAL_PTR(result,string_r,.OBJ_STRING)
}

to_camel_case :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {

	if argc != 0 { when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("to_camel_case",0,argc,call_error_p); return }

	allocator   := context.temp_allocator
	s,_         := #force_inline strings.to_camel_case(VAL_STRING_DATA_PTR(&args[argc]))	
	
	string_r := CREATE_OBJ_STRING_NO_DATA()

	OBJ_STRING_WRITE_DATA_STRING(string_r,s,true)
	free_all(allocator)

	OBJECT_VAL_PTR(result,string_r,.OBJ_STRING)
}

to_pascal_case :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
	if argc != 0 { when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("to_pascal_case",0,argc,call_error_p); return }

	allocator   := context.temp_allocator
	s,_         := #force_inline strings.to_pascal_case(VAL_STRING_DATA_PTR(&args[0]),allocator)

	string_r := CREATE_OBJ_STRING_NO_DATA()

	OBJ_STRING_WRITE_DATA_STRING(string_r,s,true)
	free_all(allocator)

	OBJECT_VAL_PTR(result,string_r,.OBJ_STRING)
}

to_snake_case :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
	if argc != 0 { when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("to_snake_case",0,argc,call_error_p); return }


	allocator   := context.temp_allocator
	s,_         := #force_inline strings.to_snake_case(VAL_STRING_DATA_PTR(&args[argc]),allocator)	
	
	string_r := CREATE_OBJ_STRING_NO_DATA()
	
	OBJ_STRING_WRITE_DATA_STRING(string_r,s,true)
	free_all(allocator)

	OBJECT_VAL_PTR(result,string_r,.OBJ_STRING)
}

// to_upper_snake_case :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
//


// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 0 { 
// 	  	CALL_ERROR_STRING(call_error_p,"'to_upper_snake_case' function expects '0' arg, but got ",argc,".")
// 	  	return
// 	}

// 	allocator   := context.temp_allocator
// 	s,_ 		:= #force_inline strings.to_upper_snake_case(VAL_STRING_DATA_PTR(&args[argc]),allocator)	
	
// 	string_r := CREATE_OBJ_STRING_NO_DATA()

// 	OBJ_STRING_WRITE_DATA_STRING(string_r,s,true)
// 	free_all(allocator)

// 	OBJECT_VAL_PTR(result,string_r,.OBJ_STRING)
// }

to_kebab_case :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
	if argc != 0 { when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("to_kebab_case",0,argc,call_error_p); return }

	allocator   := context.temp_allocator
	s,e_ 		:= #force_inline strings.to_kebab_case(VAL_STRING_DATA_PTR(&args[argc]),allocator)	
	
	string_r := CREATE_OBJ_STRING_NO_DATA()

	OBJ_STRING_WRITE_DATA_STRING(string_r,s,true)
	free_all(allocator)

	OBJECT_VAL_PTR(result,string_r,.OBJ_STRING)
}

// to_upper_kebab_case :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
//


// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 0 { 
// 	  	CALL_ERROR_STRING(call_error_p,"'to_upper_kebab_case' function expects '0' arg, but got ",argc,".")
// 	  	return
// 	}

// 	allocator   := context.temp_allocator
// 	s,_ 		:= #force_inline strings.to_upper_kebab_case(VAL_STRING_DATA_PTR(&args[argc]),allocator)	
	
// 	string_r := CREATE_OBJ_STRING_NO_DATA()
// 	OBJ_STRING_WRITE_DATA_STRING(string_r,s,true)
// 	free_all(allocator)

// 	OBJECT_VAL_PTR(result,string_r,.OBJ_STRING)
// }

to_ada_case :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
	if argc != 0 { when OSCRIPT_ALLOW_RUNTIME_WARNINGS do error_msg0("to_ada_case",0,argc,call_error_p); return }

	allocator   := context.temp_allocator
	s,_ 		:= #force_inline strings.to_ada_case(VAL_STRING_DATA_PTR(&args[argc]),allocator)	
	
	string_r := CREATE_OBJ_STRING_NO_DATA()
	
	OBJ_STRING_WRITE_DATA_STRING(string_r,s,true)
	free_all(allocator)

	OBJECT_VAL_PTR(result,string_r,.OBJ_STRING)
}

// get_volume_name :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
//


// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 0 { 
// 	  	CALL_ERROR_STRING(call_error_p,"'get_volume_name' function expects '0' arg, but got ",argc,".")
// 	  	return
// 	}	
	
// 	string_r := CREATE_OBJ_STRING_NO_DATA()
// 	OBJ_STRING_WRITE_DATA_STRING(string_r,#force_inline filepath.volume_name(VAL_STRING_DATA_PTR(&args[argc])),true)

// 	OBJECT_VAL_PTR(result,string_r,.OBJ_STRING)
// }

// get_base_name :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
//


// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 0 { 
// 	  	CALL_ERROR_STRING(call_error_p,"'get_base_name' function expects '0' arg, but got ",argc,".")
// 	  	return
// 	}	
	
// 	string_r := CREATE_OBJ_STRING_NO_DATA()
// 	OBJ_STRING_WRITE_DATA_STRING(string_r,#force_inline filepath.base(VAL_STRING_DATA_PTR(&args[argc])),true)

// 	OBJECT_VAL_PTR(result,string_r,.OBJ_STRING)
// }

// get_filename :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
//


// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 0 { 
// 	  	CALL_ERROR_STRING(call_error_p,"'get_filename' function expects '0' arg, but got ",argc,".")
// 	  	return
// 	}	
	
// 	string_r := CREATE_OBJ_STRING_NO_DATA()
// 	OBJ_STRING_WRITE_DATA_STRING(string_r,#force_inline filepath.stem(VAL_STRING_DATA_PTR(&args[argc])),true)

// 	OBJECT_VAL_PTR(result,string_r,.OBJ_STRING)
// }

// get_short_filename :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
//


// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 0 { 
// 	  	CALL_ERROR_STRING(call_error_p,"'get_short_filename' function expects '0' arg, but got ",argc,".")
// 	  	return
// 	}	
	
// 	string_r := CREATE_OBJ_STRING_NO_DATA()
// 	OBJ_STRING_WRITE_DATA_STRING(string_r,#force_inline filepath.short_stem(VAL_STRING_DATA_PTR(&args[argc])),true)

// 	OBJECT_VAL_PTR(result,string_r,.OBJ_STRING)
// }

// get_extension :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
//


// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 0 { 
// 	  	CALL_ERROR_STRING(call_error_p,"'get_extension' function expects '0' arg, but got ",argc,".")
// 	  	return
// 	}	
	
// 	string_r := CREATE_OBJ_STRING_NO_DATA()
// 	OBJ_STRING_WRITE_DATA_STRING(string_r,#force_inline filepath.ext(VAL_STRING_DATA_PTR(&args[argc])),true)

// 	OBJECT_VAL_PTR(result,string_r,.OBJ_STRING)
// }

// get_long_extension :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
//


// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 0 { 
// 	  	CALL_ERROR_STRING(call_error_p,"'get_long_extension' function expects '0' arg, but got ",argc,".")
// 	  	return
// 	}	
	
// 	string_r := CREATE_OBJ_STRING_NO_DATA()
// 	OBJ_STRING_WRITE_DATA_STRING(string_r,#force_inline filepath.long_ext(VAL_STRING_DATA_PTR(&args[argc])),true)

// 	OBJECT_VAL_PTR(result,string_r,.OBJ_STRING)
// }


// get_shortest_path :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
//


// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 0 { 
// 	  	CALL_ERROR_STRING(call_error_p,"'get_shortest_path' function expects '0' arg, but got ",argc,".")
// 	  	return
// 	}	
	
// 	string_r  := CREATE_OBJ_STRING_NO_DATA()

// 	allocator := context.temp_allocator
// 	s,_       := #force_inline filepath.clean(VAL_STRING_DATA_PTR(&args[argc]),allocator)

// 	OBJ_STRING_WRITE_DATA_STRING(string_r,s,true)
// 	free_all(allocator)

// 	OBJECT_VAL_PTR(result,string_r,.OBJ_STRING)
// }

// get_relative_path :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
//


// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 1 || !IS_VAL_STRING_PTR(&args[0]) { 
// 	  	CALL_ERROR_STRING(call_error_p,"'get_relative_path' function expects '1' arg, but got ",argc,"and the argument must be a string.")
// 	  	return
// 	}	
	
// 	string_r := CREATE_OBJ_STRING_NO_DATA()

// 	allocator := context.temp_allocator
// 	s,_       := #force_inline filepath.rel(VAL_STRING_DATA_PTR(&args[argc]),VAL_STRING_DATA_PTR(&args[0]),allocator)

// 	OBJ_STRING_WRITE_DATA_STRING(string_r,s,true)
// 	free_all(allocator)

// 	OBJECT_VAL_PTR(result,string_r,.OBJ_STRING)
// }

// get_dir :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	

//


// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 0 { 
// 	  	CALL_ERROR_STRING(call_error_p,"'get_dir' function expects '0' arg, but got ",argc,".")
// 	  	return
// 	}	
	
// 	string_r := CREATE_OBJ_STRING_NO_DATA()

// 	allocator := context.temp_allocator
// 	s    	  := #force_inline filepath.dir(VAL_STRING_DATA_PTR(&args[argc]),allocator)

// 	OBJ_STRING_WRITE_DATA_STRING(string_r,s,true)
// 	free_all(allocator)

// 	OBJECT_VAL_PTR(result,string_r,.OBJ_STRING)
// }





// // ==============================

// split :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
//


// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 1 || !IS_VAL_STRING_PTR(&args[0]) { 
// 	  	CALL_ERROR_STRING(call_error_p,"'split' function expects '1' arg, but got ",argc,", and the argument must be a string.")
// 	  	return
// 	}

// 	allocator       := context.temp_allocator
// 	s_arr,_         := #force_inline strings.split(VAL_STRING_DATA_PTR(&args[argc]),VAL_STRING_DATA_PTR(&args[0]),allocator)
// 	arr_p 			:= CREATE_OBJ_ARRAY()
	
// 	for s in s_arr 
// 	{
// 		string_r := CREATE_OBJ_STRING_NO_DATA()
// 		OBJ_STRING_WRITE_DATA_STRING(string_r,s,true)
// 		append(&arr_p.data,OBJECT_VAL(string_r,.OBJ_STRING))
// 	}

// 	free_all(allocator)
// 	OBJECT_VAL_PTR(result,arr_p,.OBJ_ARRAY)
// }

// split_after :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
//


// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 1 || !IS_VAL_STRING_PTR(&args[0]) { 
// 	  	CALL_ERROR_STRING(call_error_p,"'split_after' function expects '1' arg, but got ",argc,", and the argument must be a string.")
// 	  	return
// 	}

// 	allocator := context.temp_allocator
// 	s_arr,_   := #force_inline strings.split_after(VAL_STRING_DATA_PTR(&args[argc]),VAL_STRING_DATA_PTR(&args[0]),allocator)
// 	arr_p     := CREATE_OBJ_ARRAY()

// 	for s in s_arr {
// 		string_r := CREATE_OBJ_STRING_NO_DATA()
// 		OBJ_STRING_WRITE_DATA_STRING(string_r,s,true)
// 		append(&arr_p.data,OBJECT_VAL(string_r,.OBJ_STRING))
// 	}

// 	free_all(allocator)
// 	OBJECT_VAL_PTR(result,arr_p,.OBJ_ARRAY)
// }

// split_n :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	
// 	value : Int
//

// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 2 || !IS_VAL_STRING_PTR(&args[0]) || !IS_INT_PTR(&args[1],&value){ 
// 	  	CALL_ERROR_STRING(call_error_p,"'split_n' function expects '2' arg, but got ",argc,", and the arguments must be 'string' and 'int'.")
// 	  	return
// 	}

// 	allocator       := context.temp_allocator
// 	s_arr,_         := #force_inline strings.split_n(VAL_STRING_DATA_PTR(&args[argc]),VAL_STRING_DATA_PTR(&args[0]),value,allocator)
// 	arr_p 			:= CREATE_OBJ_ARRAY()
	
// 	for s in s_arr {
// 		string_r := CREATE_OBJ_STRING_NO_DATA()
// 		OBJ_STRING_WRITE_DATA_STRING(string_r,s,true)
// 		append(&arr_p.data,OBJECT_VAL(string_r,.OBJ_STRING))
// 	}

// 	free_all(allocator)
// 	OBJECT_VAL_PTR(result,arr_p,.OBJ_ARRAY)
// }


// to_float :: proc(argc: Int, args : []Value,result: ^Value,call_error_p : ^ObjectCallError) {
	

//


// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 0 { 
// 	  	CALL_ERROR_STRING(call_error_p,"'to_float' function expects '0' arg, but got ",argc,".")
// 	  	return
// 	}	

// 	number := Float(strconv.atof(VAL_STRING_DATA_PTR(&args[argc])))
// 	NUMBER_VAL_PTR(result,number)
// }


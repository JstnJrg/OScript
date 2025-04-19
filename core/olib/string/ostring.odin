#+private

package OscriptString

import strings  "core:strings"
import filepath "core:path/filepath"

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




length :: proc(call_state: ^CallState) 
{
   if call_state.argc != 0 { error_msg0("length",0,call_state); return }
   INT_VAL_PTR(call_state.result,len(VAL_STRING_DATA_PTR(&call_state.args[0])))
}

contains :: proc(call_state: ^CallState) 
{
	if call_state.argc != 1 || !IS_VAL_STRING_PTR(&call_state.args[0]) { error_msg("contains",1," string",call_state); return }
	BOOL_VAL_PTR(call_state.result, #force_inline strings.contains(VAL_STRING_DATA_PTR(&call_state.args[1]),VAL_STRING_DATA_PTR(&call_state.args[0])))
}


contains_space :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("contains_space",0,call_state); return }
	BOOL_VAL_PTR(call_state.result,#force_inline strings.contains_space(VAL_STRING_DATA_PTR(&call_state.args[0])))
}


char_count :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("char_count",0,call_state); return }
	INT_VAL_PTR( call_state.result, #force_inline strings.rune_count(VAL_STRING_DATA_PTR(&call_state.args[0])))
}

equaln :: proc(call_state: ^CallState) 
{
	if call_state.argc != 1 || !IS_VAL_STRING_PTR(&call_state.args[0]) { error_msg("equaln",1,"string",call_state); return }
	BOOL_VAL_PTR(call_state.result, #force_inline strings.equal_fold(VAL_STRING_DATA_PTR(&call_state.args[1]),VAL_STRING_DATA_PTR(&call_state.args[0])))
}


prefix_commom_length :: proc(call_state: ^CallState) 
{
	if call_state.argc != 1 || !IS_VAL_STRING_PTR(&call_state.args[0]) { error_msg("prefix_commom_length",1,"string",call_state); return }
	INT_VAL_PTR( call_state.result, #force_inline strings.prefix_length(VAL_STRING_DATA_PTR(&call_state.args[1]),VAL_STRING_DATA_PTR(&call_state.args[0])))
}

has_prefix :: proc(call_state: ^CallState) 
{
	if call_state.argc != 1 || !IS_VAL_STRING_PTR(&call_state.args[0]) { error_msg("has_prefix",1,"string",call_state); return }
	BOOL_VAL_PTR( call_state.result, #force_inline strings.has_prefix(VAL_STRING_DATA_PTR(&call_state.args[1]),VAL_STRING_DATA_PTR(&call_state.args[0])))
}

has_suffix :: proc(call_state: ^CallState) 
{
	if call_state.argc != 1 || !IS_VAL_STRING_PTR(&call_state.args[0]) { error_msg("has_suffix",1,"string",call_state); return }
	BOOL_VAL_PTR( call_state.result, #force_inline strings.has_suffix(VAL_STRING_DATA_PTR(&call_state.args[1]),VAL_STRING_DATA_PTR(&call_state.args[0])))
}

join :: proc(call_state: ^CallState) 
{
	for i in 0..< call_state.argc do if call_state.argc < 2 || !IS_VAL_STRING_PTR(&call_state.args[i]) { error(" 'join' expects over 1 args and must be String's",call_state); return }

	string_r    := CREATE_OBJ_STRING_NO_DATA()
	OBJ_STRING_WRITE_DATA(string_r,VAL_AS_OBJ_STRING_PTR(&call_state.args[call_state.argc]))

	for i in 0..< call_state.argc-1 
	{
		OBJ_STRING_WRITE_DATA(string_r,VAL_AS_OBJ_STRING_PTR(&call_state.args[call_state.argc-1]))
		OBJ_STRING_WRITE_DATA(string_r,VAL_AS_OBJ_STRING_PTR(&call_state.args[i]))
	}

	OBJ_STRING_COMPUTE_HASH(string_r)
	OBJECT_VAL_PTR(call_state.result,string_r,.OBJ_STRING)
}

replace :: proc(call_state: ^CallState) 
{
	amount : Int
	if call_state.argc != 3 || !IS_VAL_STRING_PTR(&call_state.args[0]) || !IS_VAL_STRING_PTR(&call_state.args[1]) || !IS_INT_PTR(&call_state.args[2],&amount) { error_msg("replace",3,"String's and int",call_state); return }

	string_r    := CREATE_OBJ_STRING_NO_DATA()

	temp_arena  := call_state.init_temp()
	allocator   := call_state.get_allocator()

	r,allocated := #force_inline strings.replace(VAL_STRING_DATA_PTR(&call_state.args[3]),VAL_STRING_DATA_PTR(&call_state.args[0]),VAL_STRING_DATA_PTR(&call_state.args[1]),amount,allocator)
	defer call_state.end_temp(temp_arena)

	OBJ_STRING_WRITE_DATA_STRING(string_r,r,true)
	OBJECT_VAL_PTR(call_state.result,string_r,.OBJ_STRING)
}


remove :: proc(call_state: ^CallState) 
{
	value : Int
	if call_state.argc != 2 || !IS_VAL_STRING_PTR(&call_state.args[0]) || !IS_INT_PTR(&call_state.args[1],&value) { error_msg("remove",2,"String and int",call_state); return }

	string_r     := CREATE_OBJ_STRING_NO_DATA()

	temp_arena  := call_state.init_temp()
	allocator   := call_state.get_allocator()

	r, _ := #force_inline strings.remove(VAL_STRING_DATA_PTR(&call_state.args[2]),VAL_STRING_DATA_PTR(&call_state.args[0]),value,allocator)
	defer call_state.end_temp(temp_arena)

	OBJ_STRING_WRITE_DATA_STRING(string_r,r,true)
	OBJECT_VAL_PTR(call_state.result,string_r,.OBJ_STRING)
}

repeat :: proc(call_state: ^CallState) 
{
	value: Int
	if call_state.argc != 1 || !IS_INT_PTR(&call_state.args[0],&value) { error_msg("repeat",1,"String and int",call_state); return }

	l := VAL_AS_OBJ_STRING_PTR(&call_state.args[1]).len

	if value < 0 { error("negative repeat count.",call_state); return }
	if value > 0 && (l*value)/value != l { error("repeat count will cause an overflow.",call_state); return }

	string_r     := CREATE_OBJ_STRING_NO_DATA()

	temp_arena  := call_state.init_temp()
	allocator   := call_state.get_allocator()

	r,_ := #force_inline strings.repeat(VAL_STRING_DATA_PTR(&call_state.args[1]),value,allocator)
	defer call_state.end_temp(temp_arena)

	OBJ_STRING_WRITE_DATA_STRING(string_r,r,true)
	OBJECT_VAL_PTR(call_state.result,string_r,.OBJ_STRING)
}

reverse :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("remove",0,call_state); return }

	temp_arena  := call_state.init_temp()
	allocator   := call_state.get_allocator()

	r,_         := #force_inline strings.reverse(VAL_STRING_DATA_PTR(&call_state.args[0]),allocator)
	defer call_state.end_temp(temp_arena)

	string_r 	 := CREATE_OBJ_STRING_NO_DATA()

	OBJ_STRING_WRITE_DATA_STRING(string_r,r,true)
	OBJECT_VAL_PTR(call_state.result,string_r,.OBJ_STRING)
}

center_justify :: proc(call_state: ^CallState) 
{
	value: Int
	if call_state.argc != 2 || !IS_VAL_STRING_PTR(&call_state.args[0]) || !IS_INT_PTR(&call_state.args[1],&value) { error_msg("center_justify",2,"String and int",call_state); return }

	temp_arena  := call_state.init_temp()
	allocator   := call_state.get_allocator()

	r,_         := #force_inline strings.center_justify(VAL_STRING_DATA_PTR(&call_state.args[2]),value,VAL_STRING_DATA_PTR(&call_state.args[0]),allocator)
	defer call_state.end_temp(temp_arena)
	
	string_r := CREATE_OBJ_STRING_NO_DATA()
	
	OBJ_STRING_WRITE_DATA_STRING(string_r,r,true)
	OBJECT_VAL_PTR(call_state.result,string_r,.OBJ_STRING)
}

right_justify :: proc(call_state: ^CallState) 
{
	value: Int
	if call_state.argc != 2 || !IS_VAL_STRING_PTR(&call_state.args[0]) || !IS_INT_PTR(&call_state.args[1],&value) { error_msg("right_justify",2,"String and int",call_state); return }

	temp_arena  := call_state.init_temp()
	allocator   := call_state.get_allocator()

	r,_         := #force_inline strings.right_justify(VAL_STRING_DATA_PTR(&call_state.args[2]),value,VAL_STRING_DATA_PTR(&call_state.args[0]),allocator)
	defer call_state.end_temp(temp_arena)
	
	string_r := CREATE_OBJ_STRING_NO_DATA()
	
	OBJ_STRING_WRITE_DATA_STRING(string_r,r,true)
	OBJECT_VAL_PTR(call_state.result,string_r,.OBJ_STRING)
}

left_justify :: proc(call_state: ^CallState) 
{
	value: Int
	if call_state.argc != 2 || !IS_VAL_STRING_PTR(&call_state.args[0]) || !IS_INT_PTR(&call_state.args[1],&value) { error_msg("left_justify",2,"String and int",call_state); return }

	temp_arena  := call_state.init_temp()
	allocator   := call_state.get_allocator()

	r,_         := #force_inline strings.left_justify(VAL_STRING_DATA_PTR(&call_state.args[2]),value,VAL_STRING_DATA_PTR(&call_state.args[0]),allocator)
	defer call_state.end_temp(temp_arena)
	
	string_r := CREATE_OBJ_STRING_NO_DATA()
	
	OBJ_STRING_WRITE_DATA_STRING(string_r,r,true)
	OBJECT_VAL_PTR(call_state.result,string_r,.OBJ_STRING)
}

cut :: proc(call_state: ^CallState) 
{
	values : [2]Int
    for i in 0..< 2 do if call_state.argc != 2 || !IS_INT_PTR(&call_state.args[i],&values[i]) { error_msg("cut",2,"int's",call_state); return }

	string_r := CREATE_OBJ_STRING_NO_DATA()
	OBJ_STRING_WRITE_DATA_STRING(string_r,#force_inline strings.cut(VAL_STRING_DATA_PTR(&call_state.args[2]),values[0],values[1]),true)
	OBJECT_VAL_PTR(call_state.result,string_r,.OBJ_STRING)
}

substring :: proc(call_state: ^CallState) 
{
	values: [2]Int
    for i in 0..< 2 do if call_state.argc != 2 || !IS_INT_PTR(&call_state.args[i],&values[i]) { error_msg("substring",2,"int's",call_state); return }

	r, _ := #force_inline strings.substring(VAL_STRING_DATA_PTR(&call_state.args[2]),values[0],values[1])
	
	string_r := CREATE_OBJ_STRING_NO_DATA()
	OBJ_STRING_WRITE_DATA_STRING(string_r,r,true)
	OBJECT_VAL_PTR(call_state.result,string_r,.OBJ_STRING)
}

substring_from :: proc(call_state: ^CallState) 
{
	value: Int
    if call_state.argc != 1 || !IS_INT_PTR(&call_state.args[0],&value) { error_msg("substring_from",1,"int",call_state); return }

	r, _ := #force_inline strings.substring_from(VAL_STRING_DATA_PTR(&call_state.args[1]),value)

	string_r := CREATE_OBJ_STRING_NO_DATA()
	OBJ_STRING_WRITE_DATA_STRING(string_r,r,true)
	OBJECT_VAL_PTR(call_state.result,string_r,.OBJ_STRING)
}

substring_to :: proc(call_state: ^CallState) 
{
	value: Int
    if call_state.argc != 1 || !IS_INT_PTR(&call_state.args[0],&value) { error_msg("substring_to",1,"int",call_state); return }

	r, _ := #force_inline strings.substring_to(VAL_STRING_DATA_PTR(&call_state.args[1]),value)
	
	string_r := CREATE_OBJ_STRING_NO_DATA()
	OBJ_STRING_WRITE_DATA_STRING(string_r,r,true)
	OBJECT_VAL_PTR(call_state.result,string_r,.OBJ_STRING)
}

expand_tabs :: proc(call_state: ^CallState) 
{
	value: Int
    if call_state.argc != 1 || !IS_INT_PTR(&call_state.args[0],&value) { error_msg("expand_tabs",1,"int",call_state); return }

	temp_arena  := call_state.init_temp()
	allocator   := call_state.get_allocator()

	r,_         := #force_inline strings.replace(VAL_STRING_DATA_PTR(&call_state.args[1]),"\\t","\t",-1,allocator)
	s,_         := #force_inline strings.expand_tabs(r,value,allocator)	

	defer call_state.end_temp(temp_arena)
	
	string_r := CREATE_OBJ_STRING_NO_DATA()
	
	OBJ_STRING_WRITE_DATA_STRING(string_r,s,true)
	OBJECT_VAL_PTR(call_state.result,string_r,.OBJ_STRING)
}


trim_suffix :: proc(call_state: ^CallState) 
{
    if call_state.argc != 1 || !IS_VAL_STRING_PTR(&call_state.args[0]) { error_msg("trim_suffix",1,"string",call_state); return }

	string_r := CREATE_OBJ_STRING_NO_DATA()
	OBJ_STRING_WRITE_DATA_STRING(string_r,#force_inline strings.trim_suffix(VAL_STRING_DATA_PTR(&call_state.args[1]),VAL_STRING_DATA_PTR(&call_state.args[0])),true)

	OBJECT_VAL_PTR(call_state.result,string_r,.OBJ_STRING)
}

trim_prefix :: proc(call_state: ^CallState) 
{
    if call_state.argc != 1 || !IS_VAL_STRING_PTR(&call_state.args[0]) { error_msg("trim_prefix",1,"string",call_state); return }

	string_r := CREATE_OBJ_STRING_NO_DATA()
	OBJ_STRING_WRITE_DATA_STRING(string_r,#force_inline strings.trim_prefix(VAL_STRING_DATA_PTR(&call_state.args[1]),VAL_STRING_DATA_PTR(&call_state.args[0])),true)

	OBJECT_VAL_PTR(call_state.result,string_r,.OBJ_STRING)
}

trim :: proc(call_state: ^CallState) 
{
    if call_state.argc != 1 || !IS_VAL_STRING_PTR(&call_state.args[0]) { error_msg("trim",1,"string",call_state); return }

	string_r := CREATE_OBJ_STRING_NO_DATA()
	OBJ_STRING_WRITE_DATA_STRING(string_r,#force_inline strings.trim(VAL_STRING_DATA_PTR(&call_state.args[1]),VAL_STRING_DATA_PTR(&call_state.args[0])),true)

	OBJECT_VAL_PTR(call_state.result,string_r,.OBJ_STRING)
}

compare :: proc(call_state: ^CallState) 
{
    if call_state.argc != 1 || !IS_VAL_STRING_PTR(&call_state.args[0]) { error_msg("compare",1,"String",call_state); return }
	INT_VAL_PTR( call_state.result,#force_inline strings.compare(VAL_STRING_DATA_PTR(&call_state.args[1]),VAL_STRING_DATA_PTR(&call_state.args[0])))
}

// count :: proc(call_state: ^CallState) {
	
//


// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 1 || !IS_VAL_STRING_PTR(&args[0]) { 
// 	  	CALL_ERROR_STRING(call_state,"'count' function expects '1' arg, but got ",", and the arguments must be a string.")
// 	  	return
// 	}
// 	INT_VAL_PTR( call_state.result, #force_inline strings.count(VAL_STRING_DATA_PTR(&args[argc]),VAL_STRING_DATA_PTR(&args[0])))
// }

// get_last_index :: proc(call_state: ^CallState) {
	
//


// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 1 || !IS_VAL_STRING_PTR(&args[0]) { 
// 	  	CALL_ERROR_STRING(call_state,"'get_last_index' function expects '1' arg, but got ",", and the arguments must be a string.")
// 	  	return
// 	}
// 	INT_VAL_PTR( call_state.result, #force_inline strings.last_index_any(VAL_STRING_DATA_PTR(&args[argc]),VAL_STRING_DATA_PTR(&args[0])))
// }


// get_first_index :: proc(call_state: ^CallState) {
	
//


// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 1 || !IS_VAL_STRING_PTR(&args[0]) { 
// 	  	CALL_ERROR_STRING(call_state,"'get_first_index' function expects '1' arg, but got ",", and the arguments must be a string.")
// 	  	return
// 	}
// 	INT_VAL_PTR( call_state.result, #force_inline strings.index_any(VAL_STRING_DATA_PTR(&args[argc]),VAL_STRING_DATA_PTR(&args[0])))
// }

// get_index :: proc(call_state: ^CallState) {
	
//


// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 1 || !IS_VAL_STRING_PTR(&args[0]) { 
// 	  	CALL_ERROR_STRING(call_state,"'get_index' function expects '1' arg, but got ",", and the arguments must be a string.")
// 	  	return
// 	}
// 	INT_VAL_PTR( call_state.result, #force_inline strings.index(VAL_STRING_DATA_PTR(&args[argc]),VAL_STRING_DATA_PTR(&args[0])))
// }


hash :: proc(call_state: ^CallState) 
{	
	if call_state.argc != 0 { error_msg0("hash",0,call_state); return }
	INT_VAL_PTR( call_state.result, int(VAL_AS_OBJ_STRING_PTR(&call_state.args[0]).hash))
}

to_lower :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("to_lower",0,call_state); return }

	temp_arena  := call_state.init_temp()
	allocator   := call_state.get_allocator()

	s, _        := #force_inline strings.to_lower(VAL_STRING_DATA_PTR(&call_state.args[0]),allocator)	
	defer call_state.end_temp(temp_arena)
	
	string_r := CREATE_OBJ_STRING_NO_DATA()

	OBJ_STRING_WRITE_DATA_STRING(string_r,s,true)
	OBJECT_VAL_PTR(call_state.result,string_r,.OBJ_STRING)
}

to_upper :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("to_upper",0,call_state); return }

	temp_arena  := call_state.init_temp()
	allocator   := call_state.get_allocator()

	s, _        := #force_inline strings.to_upper(VAL_STRING_DATA_PTR(&call_state.args[0]),allocator)	
	defer call_state.end_temp(temp_arena)
	
	string_r := CREATE_OBJ_STRING_NO_DATA()

	OBJ_STRING_WRITE_DATA_STRING(string_r,s,true)
	OBJECT_VAL_PTR(call_state.result,string_r,.OBJ_STRING)
}

to_camel_case :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("to_camel_case",0,call_state); return }

	temp_arena  := call_state.init_temp()
	allocator   := call_state.get_allocator()

	s,_         := #force_inline strings.to_camel_case(VAL_STRING_DATA_PTR(&call_state.args[0]))
	defer call_state.end_temp(temp_arena)
	
	string_r := CREATE_OBJ_STRING_NO_DATA()

	OBJ_STRING_WRITE_DATA_STRING(string_r,s,true)
	OBJECT_VAL_PTR(call_state.result,string_r,.OBJ_STRING)
}

to_pascal_case :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("to_pascal_case",0,call_state); return }

	temp_arena  := call_state.init_temp()
	allocator   := call_state.get_allocator()

	s,_         := #force_inline strings.to_pascal_case(VAL_STRING_DATA_PTR(&call_state.args[0]),allocator)
	defer call_state.end_temp(temp_arena)
	
	string_r := CREATE_OBJ_STRING_NO_DATA()

	OBJ_STRING_WRITE_DATA_STRING(string_r,s,true)
	OBJECT_VAL_PTR(call_state.result,string_r,.OBJ_STRING)
}

to_snake_case :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("to_snake_case",0,call_state); return }

	temp_arena  := call_state.init_temp()
	allocator   := call_state.get_allocator()

	s,_         := #force_inline strings.to_snake_case(VAL_STRING_DATA_PTR(&call_state.args[0]),allocator)	
	defer call_state.end_temp(temp_arena)

	string_r := CREATE_OBJ_STRING_NO_DATA()
	
	OBJ_STRING_WRITE_DATA_STRING(string_r,s,true)
	OBJECT_VAL_PTR(call_state.result,string_r,.OBJ_STRING)
}

to_kebab_case :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("to_kebab_case",0,call_state); return }

	temp_arena  := call_state.init_temp()
	allocator   := call_state.get_allocator()

	s,e_ 		:= #force_inline strings.to_kebab_case(VAL_STRING_DATA_PTR(&call_state.args[0]),allocator)	
	defer call_state.end_temp(temp_arena)

	string_r := CREATE_OBJ_STRING_NO_DATA()

	OBJ_STRING_WRITE_DATA_STRING(string_r,s,true)
	free_all(allocator)

	OBJECT_VAL_PTR(call_state.result,string_r,.OBJ_STRING)
}

to_ada_case :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("to_ada_case",0,call_state); return }

	temp_arena  := call_state.init_temp()
	allocator   := call_state.get_allocator()

	s,_ 		:= #force_inline strings.to_ada_case(VAL_STRING_DATA_PTR(&call_state.args[0]),allocator)
	defer call_state.end_temp(temp_arena)
	
	string_r := CREATE_OBJ_STRING_NO_DATA()
	
	OBJ_STRING_WRITE_DATA_STRING(string_r,s,true)
	OBJECT_VAL_PTR(call_state.result,string_r,.OBJ_STRING)
}

get_file :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("get_file",0,call_state); return }

	path     := VAL_STRING_DATA_PTR(&call_state.args[0])
	string_r := CREATE_OBJ_STRING_NO_DATA()
	
	OBJ_STRING_WRITE_DATA_STRING(string_r,filepath.base(path),true)
	OBJECT_VAL_PTR(call_state.result,string_r,.OBJ_STRING)
}

get_filename :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("get_filename",0,call_state); return }

	path     := VAL_STRING_DATA_PTR(&call_state.args[0])
	string_r := CREATE_OBJ_STRING_NO_DATA()
	
	OBJ_STRING_WRITE_DATA_STRING(string_r,filepath.stem(path),true)
	OBJECT_VAL_PTR(call_state.result,string_r,.OBJ_STRING)
}

get_short_filename :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("get_short_filename",0,call_state); return }

	path     := VAL_STRING_DATA_PTR(&call_state.args[0])
	string_r := CREATE_OBJ_STRING_NO_DATA()
	
	OBJ_STRING_WRITE_DATA_STRING(string_r,filepath.stem(path),true)
	OBJECT_VAL_PTR(call_state.result,string_r,.OBJ_STRING)
}

get_extension :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("get_extension",0,call_state); return }

	path     := VAL_STRING_DATA_PTR(&call_state.args[0])
	string_r := CREATE_OBJ_STRING_NO_DATA()
	
	OBJ_STRING_WRITE_DATA_STRING(string_r,filepath.ext(path),true)
	OBJECT_VAL_PTR(call_state.result,string_r,.OBJ_STRING)
}

get_long_extension :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("get_long_extension",0,call_state); return }

	path     := VAL_STRING_DATA_PTR(&call_state.args[0])
	string_r := CREATE_OBJ_STRING_NO_DATA()
	
	OBJ_STRING_WRITE_DATA_STRING(string_r,filepath.long_ext(path),true)
	OBJECT_VAL_PTR(call_state.result,string_r,.OBJ_STRING)
}

// get_volume_name :: proc(call_state: ^CallState) {
	
//


// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 0 { 
// 	  	CALL_ERROR_STRING(call_state,"'get_volume_name' function expects '0' arg, but got ",".")
// 	  	return
// 	}	
	
// 	string_r := CREATE_OBJ_STRING_NO_DATA()
// 	OBJ_STRING_WRITE_DATA_STRING(string_r,#force_inline filepath.volume_name(VAL_STRING_DATA_PTR(&args[argc])),true)

// 	OBJECT_VAL_PTR(call_state.result,string_r,.OBJ_STRING)
// }

// get_base_name :: proc(call_state: ^CallState) {
	
//


// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 0 { 
// 	  	CALL_ERROR_STRING(call_state,"'get_base_name' function expects '0' arg, but got ",".")
// 	  	return
// 	}	
	
// 	string_r := CREATE_OBJ_STRING_NO_DATA()
// 	OBJ_STRING_WRITE_DATA_STRING(string_r,#force_inline filepath.base(VAL_STRING_DATA_PTR(&args[argc])),true)

// 	OBJECT_VAL_PTR(call_state.result,string_r,.OBJ_STRING)
// }

// get_filename :: proc(call_state: ^CallState) {
	
//


// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 0 { 
// 	  	CALL_ERROR_STRING(call_state,"'get_filename' function expects '0' arg, but got ",".")
// 	  	return
// 	}	
	
// 	string_r := CREATE_OBJ_STRING_NO_DATA()
// 	OBJ_STRING_WRITE_DATA_STRING(string_r,#force_inline filepath.stem(VAL_STRING_DATA_PTR(&args[argc])),true)

// 	OBJECT_VAL_PTR(call_state.result,string_r,.OBJ_STRING)
// }

// get_short_filename :: proc(call_state: ^CallState) {
	
//


// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 0 { 
// 	  	CALL_ERROR_STRING(call_state,"'get_short_filename' function expects '0' arg, but got ",".")
// 	  	return
// 	}	
	
// 	string_r := CREATE_OBJ_STRING_NO_DATA()
// 	OBJ_STRING_WRITE_DATA_STRING(string_r,#force_inline filepath.short_stem(VAL_STRING_DATA_PTR(&args[argc])),true)

// 	OBJECT_VAL_PTR(call_state.result,string_r,.OBJ_STRING)
// }

// get_extension :: proc(call_state: ^CallState) {
	
//


// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 0 { 
// 	  	CALL_ERROR_STRING(call_state,"'get_extension' function expects '0' arg, but got ",".")
// 	  	return
// 	}	
	
// 	string_r := CREATE_OBJ_STRING_NO_DATA()
// 	OBJ_STRING_WRITE_DATA_STRING(string_r,#force_inline filepath.ext(VAL_STRING_DATA_PTR(&args[argc])),true)

// 	OBJECT_VAL_PTR(call_state.result,string_r,.OBJ_STRING)
// }

// get_long_extension :: proc(call_state: ^CallState) {
	
//


// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 0 { 
// 	  	CALL_ERROR_STRING(call_state,"'get_long_extension' function expects '0' arg, but got ",".")
// 	  	return
// 	}	
	
// 	string_r := CREATE_OBJ_STRING_NO_DATA()
// 	OBJ_STRING_WRITE_DATA_STRING(string_r,#force_inline filepath.long_ext(VAL_STRING_DATA_PTR(&args[argc])),true)

// 	OBJECT_VAL_PTR(call_state.result,string_r,.OBJ_STRING)
// }


// get_shortest_path :: proc(call_state: ^CallState) {
	
//


// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 0 { 
// 	  	CALL_ERROR_STRING(call_state,"'get_shortest_path' function expects '0' arg, but got ",".")
// 	  	return
// 	}	
	
// 	string_r  := CREATE_OBJ_STRING_NO_DATA()

// 	allocator := context.temp_allocator
// 	s,_       := #force_inline filepath.clean(VAL_STRING_DATA_PTR(&args[argc]),allocator)

// 	OBJ_STRING_WRITE_DATA_STRING(string_r,s,true)
// 	free_all(allocator)

// 	OBJECT_VAL_PTR(call_state.result,string_r,.OBJ_STRING)
// }

// get_relative_path :: proc(call_state: ^CallState) {
	
//


// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 1 || !IS_VAL_STRING_PTR(&args[0]) { 
// 	  	CALL_ERROR_STRING(call_state,"'get_relative_path' function expects '1' arg, but got ","and the argument must be a string.")
// 	  	return
// 	}	
	
// 	string_r := CREATE_OBJ_STRING_NO_DATA()

// 	allocator := context.temp_allocator
// 	s,_       := #force_inline filepath.rel(VAL_STRING_DATA_PTR(&args[argc]),VAL_STRING_DATA_PTR(&args[0]),allocator)

// 	OBJ_STRING_WRITE_DATA_STRING(string_r,s,true)
// 	free_all(allocator)

// 	OBJECT_VAL_PTR(call_state.result,string_r,.OBJ_STRING)
// }

// get_dir :: proc(call_state: ^CallState) {
	

//


// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 0 { 
// 	  	CALL_ERROR_STRING(call_state,"'get_dir' function expects '0' arg, but got ",".")
// 	  	return
// 	}	
	
// 	string_r := CREATE_OBJ_STRING_NO_DATA()

// 	allocator := context.temp_allocator
// 	s    	  := #force_inline filepath.dir(VAL_STRING_DATA_PTR(&args[argc]),allocator)

// 	OBJ_STRING_WRITE_DATA_STRING(string_r,s,true)
// 	free_all(allocator)

// 	OBJECT_VAL_PTR(call_state.result,string_r,.OBJ_STRING)
// }





// // ==============================

// split :: proc(call_state: ^CallState) {
	
//


// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 1 || !IS_VAL_STRING_PTR(&args[0]) { 
// 	  	CALL_ERROR_STRING(call_state,"'split' function expects '1' arg, but got ",", and the argument must be a string.")
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
// 	OBJECT_VAL_PTR(call_state.result,arr_p,.OBJ_ARRAY)
// }

// split_after :: proc(call_state: ^CallState) {
	
//


// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 1 || !IS_VAL_STRING_PTR(&args[0]) { 
// 	  	CALL_ERROR_STRING(call_state,"'split_after' function expects '1' arg, but got ",", and the argument must be a string.")
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
// 	OBJECT_VAL_PTR(call_state.result,arr_p,.OBJ_ARRAY)
// }

// split_n :: proc(call_state: ^CallState) {
	
// 	value : Int
//

// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 2 || !IS_VAL_STRING_PTR(&args[0]) || !IS_INT_PTR(&args[1],&value){ 
// 	  	CALL_ERROR_STRING(call_state,"'split_n' function expects '2' arg, but got ",", and the arguments must be 'string' and 'int'.")
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
// 	OBJECT_VAL_PTR(call_state.result,arr_p,.OBJ_ARRAY)
// }


// to_float :: proc(call_state: ^CallState) {
	

//


// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 0 { 
// 	  	CALL_ERROR_STRING(call_state,"'to_float' function expects '0' arg, but got ",".")
// 	  	return
// 	}	

// 	number := Float(strconv.atof(VAL_STRING_DATA_PTR(&args[argc])))
// 	NUMBER_VAL_PTR(call_state.result,number)
// }


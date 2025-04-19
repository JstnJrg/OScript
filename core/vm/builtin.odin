#+private
package OScriptVM


@(private="file")
error_msg :: proc(fn_name: string, expected: Int, be: string ,call_state: ^CallState) {
	CALL_ERROR_STRING(&call_state.error_bf,"'",fn_name,"' function expects '",expected,"' args, but got ",call_state.argc,", and the argument must be ",be,".")
	call_state.has_error = true
}

@(private="file")
error_msg0 :: proc(fn_name: string, expected : Int ,call_state: ^CallState) { 
	CALL_ERROR_STRING(&call_state.error_bf,"'",fn_name,"' function expects '",expected,"' args, but got ",call_state.argc,".") 
	call_state.has_error = true
}

@(private="file")
_error      :: proc(msg: string ,call_state: ^CallState) { CALL_ERROR_STRING(&call_state.error_bf,msg); call_state.has_error = true    }

@(private="file")
warning    :: proc(msg: string ,call_state: ^CallState) { CALL_WARNING_STRING(&call_state.error_bf,msg); call_state.has_warning = true }


// 
register_builtin :: proc(builtin_id : ImportID)
{

	register_method(builtin_id,"typeof",typeof)
	register_method(builtin_id,"print_stack",print_stack)
	register_method(builtin_id,"print_tos",print_tos)

	register_value(builtin_id,"TYPE_NIL",  INT_VAL(_typeof(.NIL_VAL)))
	register_value(builtin_id,"TYPE_BOOL", INT_VAL(_typeof(.BOOL_VAL)))
	register_value(builtin_id,"TYPE_FLOAT",INT_VAL(_typeof(.FLOAT_VAL)))
	register_value(builtin_id,"TYPE_INT",  INT_VAL(_typeof(.INT_VAL)))
	register_value(builtin_id,"TYPE_OID",  INT_VAL(_typeof(.OID_VAL)))
	register_value(builtin_id,"TYPE_VECTOR2", INT_VAL(_typeof(.VECTOR2_VAL)))
	register_value(builtin_id,"TYPE_COLOR",   INT_VAL(_typeof(.COLOR_VAL)))
	register_value(builtin_id,"TYPE_RECT2",   INT_VAL(_typeof(.RECT2_VAL)))
	register_value(builtin_id,"TYPE_TRANSFORM2",INT_VAL(_typeof(.TRANSFORM2_VAL)))
	register_value(builtin_id,"TYPE_ANY",INT_VAL(_typeof(.OBJ_ANY)))
	register_value(builtin_id,"TYPE_NATIVE_FUNCTION",INT_VAL(_typeof(.NATIVE_OP_FUNC_VAL)))
	register_value(builtin_id,"TYPE_STRING",INT_VAL(_typeof(.OBJ_STRING)))
	register_value(builtin_id,"TYPE_ARRAY",INT_VAL(_typeof(.OBJ_ARRAY)))
	register_value(builtin_id,"TYPE_FUNCTION",INT_VAL(_typeof(.OBJ_FUNCTION)))
	register_value(builtin_id,"TYPE_CLASS",INT_VAL(_typeof(.OBJ_CLASS)))
	register_value(builtin_id,"TYPE_CLASS_INSTANCE",INT_VAL(_typeof(.OBJ_CLASS_INSTANCE)))
	register_value(builtin_id,"TYPE_PACKAGE",INT_VAL(_typeof(.OBJ_PACKAGE)))
	// register_value(builtin_id,"",)
	// register_value(builtin_id,"",)
	// register_value(builtin_id,"",)
	// register_value(builtin_id,"",)
	// register_value(builtin_id,"",)
	// register_value(builtin_id,"",)
	// register_value(builtin_id,"",)
	// register_value(builtin_id,"",)
	// register_value(builtin_id,"",)
	// register_value(builtin_id,"",)

	// register_value(builtin_id,"",)
	// register_value(builtin_id,"",)
	// register_value(builtin_id,"",)
	// register_value(builtin_id,"",)
	// register_value(builtin_id,"",)
	// register_value(builtin_id,"",)

}




@(private="file")
_typeof :: proc "contextless" (type: ValueType) -> Int
{
	#partial switch type
	{
		case .NIL_VAL    : return 0
	    case .BOOL_VAL   : return 1
	    case .INT_VAL    : return 2
	    case .FLOAT_VAL  : return 3
	    case .OID_VAL    : return 5

	    case .VECTOR2_VAL: return 6
	    case .COLOR_VAL  : return 7
	    case .RECT2_VAL  : return 8

	    case .TRANSFORM2_VAL: return 9
	    case .OSTRING_VAL   : return 10

	    case .NATIVE_OP_FUNC_VAL: return 11
	    case .OBJ_ANY           : return 12

	    case .OBJ_STRING        : return 13
	    case .OBJ_ARRAY         : return 14
	    case .OBJ_FUNCTION      : return 15
	    case .OBJ_CLASS         : return 16
	    case .OBJ_CLASS_INSTANCE: return 17
	    case .OBJ_PACKAGE       : return 19
	    case                    : return -1
	}
}



 

// 
@(private="file")
typeof     :: proc(call_state: ^CallState)
{
	if call_state.argc != 1 { error_msg0("typeoof",1,call_state); return }
	INT_VAL_PTR(call_state.result,_typeof(call_state.args[0].type))
}

@(private="file")
print_stack :: proc(call_state: ^CallState)
{
	if call_state.argc != 0 { error_msg0("print_stack",0,call_state); return }

	frame        := get_current_frame()
	instruction  := ptr_sub(frame.ip,&frame.function.chunk.code[0])
	localization := frame.function.chunk.localization[instruction-1]

	finfo := frame.function.info
	id    := finfo.id
	name  := get_function_name_functionBD(id)
	arity := finfo.arity
	darity:= finfo.default_arity

	println("Frame",get_vm().frame_count-1,"-",localization.file,":",localization.line,"in function '",name,"'")
	NIL_VAL_PTR(call_state.result)
}

@(private="file")
print_tos :: proc(call_state: ^CallState)
{
	if call_state.argc != 0 { error_msg0("print_tos",0,call_state); return }
	println("stack size - ",get_vm().tos-1)
	NIL_VAL_PTR(call_state.result)
}
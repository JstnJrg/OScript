package OScriptVariant


// Nota(jstn): verifica tipos OScript
IS_NUMBER   :: #force_inline proc "contextless" (value: Value) -> bool { return value.type == .FLOAT_VAL}
IS_INT      :: #force_inline proc "contextless" (value: Value) -> bool { return value.type == .INT_VAL}
IS_BOOL     :: #force_inline proc "contextless" (value: Value) -> bool { return value.type == .BOOL_VAL}
IS_NIL      :: #force_inline proc "contextless" (value: Value) -> bool { return value.type == .NIL_VAL}
// IS_VECTOR2  :: #force_inline proc "contextless" (value: Value) -> bool { return value.type == .VECTOR2_VAL }
IS_OBJECT   :: #force_inline proc "contextless" (value: Value) -> bool { return value.type >= .OBJ_VAL   }

IS_GENERIC_PTR  :: #force_inline proc "contextless" (value_p: ^Value, type: ValueType) -> bool { return value_p.type == type }


IS_FLOAT_PTR    :: #force_inline proc "contextless" (value: ^Value) -> bool { return value.type == .FLOAT_VAL}
IS_BOOL_PTR     :: #force_inline proc "contextless" (value: ^Value) -> bool { return value.type == .BOOL_VAL}
IS_NIL_PTR      :: #force_inline proc "contextless" (value: ^Value) -> bool { return value.type == .NIL_VAL}

IS_VECTOR2_PTR :: #force_inline proc "contextless" (value: ^Value) -> bool { return value.type ==  .VECTOR2_VAL }
IS_COLOR_PTR   :: #force_inline proc "contextless" (value: ^Value) -> bool { return value.type ==  .COLOR_VAL }
IS_RECT2_PTR   :: #force_inline proc "contextless" (value: ^Value) -> bool { return value.type ==  .RECT2_VAL }

IS_OBJECT_PTR   :: #force_inline proc "contextless" (value: ^Value) -> bool { return value.type >= .OBJ_VAL   }


// Nota(jstn): utíl somemente para o GC, posi classes BD, guardam apenas ID, e através desse ID, podemos 
// localizar sua tabela
IS_CLASS_BD_ID_PTR  :: #force_inline proc "contextless" (value: ^Value) -> bool {
	#partial switch value.type {
		case .OBJ_CLASS: return true
		case 		   : return false
	}
}

IS_FUNCTION_BD_PTR :: #force_inline proc "contextless" (value: ^Value) -> bool {
	#partial switch value.type {
		case .OBJ_FUNCTION: return true
		case 			  : return false
	}
}

IS_IMPORT_BD_PTR :: #force_inline proc "contextless" (value: ^Value) -> bool {
	#partial switch value.type {
		case .OBJ_PACKAGE,.OBJ_NATIVE_CLASS : return true
		case 			                    : return false
	}
}

IS_FLOAT_CAST_PTR  :: #force_inline proc "contextless" (value: ^Value, n : ^$T) -> bool {
	if          value.type == .FLOAT_VAL  { n^ = AS_FLOAT_PTR(value); return true }
	else if     value.type == .INT_VAL    { n^ = Float(AS_INT_PTR(value));    return true }
	return false
}

IS_INT_CAST_GENERIC_PTR    :: #force_inline proc "contextless" (value: ^Value, n : ^$T) -> bool {
	if          value.type == .FLOAT_VAL  { n^ = Int(AS_FLOAT_PTR(value)); return true }
	else if     value.type == .INT_VAL    { n^ = AS_INT_PTR(value);    return true }
	return false
}


IS_INT_PTR     :: #force_inline proc "contextless" (value: ^Value, n : ^$T) -> bool {
	if value.type == .INT_VAL    { n^ = AS_INT_PTR(value);    return true }
	return false
}

IS_INT_CAST_PTR     :: #force_inline proc "contextless" (value: ^Value, n : ^$T, $C: typeid) -> bool {
	if value.type == .INT_VAL    { n^ = C(AS_INT_PTR(value));    return true }
	return false
}


IS_BOOL_PTRV     :: #force_inline proc "contextless" (value: ^Value, n : ^$T) -> bool {
	if value.type == .BOOL_VAL    { n^ = AS_BOOL_PTR(value);    return true }
	return false
}


IS_TRANSFORM2_PTR          :: #force_inline proc(value_p: ^Value) -> bool { return IS_GENERIC_PTR(value_p,.OBJ_TRANSFORM2) }


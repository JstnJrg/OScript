package OScriptVariant


// Nota(jstn): converte valores  OScript para valores Odin
AS_FLOAT    :: #force_inline proc "contextless" (value: Value) -> Float 	{ return value.variant.(Float) }
AS_INT	    :: #force_inline proc "contextless" (value: Value) -> Int   	{ return value.variant.(Int) }
AS_BOOL     :: #force_inline proc "contextless" (value: Value) -> bool  	{ return value.variant.(bool)}
AS_OBJECT   :: #force_inline proc "contextless" (value: Value) -> ^Object 	{ return value.variant.(^Object) }


AS_OP_FUNC	:: #force_inline proc "contextless" (value: Value) -> NativeFn  { return value.variant.(NativeFn) }

AS_FLOAT_PTR   	       :: #force_inline proc "contextless" (value: ^Value) -> Float 	 { return value.variant.(Float) }

AS_CLASS_BD_ID_PTR     :: #force_inline proc "contextless" (value: ^Value) -> ClassID    { return value.variant.(ClassID)}
AS_FUNCTION_BD_ID_PTR  :: #force_inline proc "contextless" (value: ^Value) -> FunctionID { return value.variant.(FunctionID)}
AS_IMPORT_BD_ID_PTR    :: #force_inline proc "contextless" (value: ^Value) -> ImportID   { return value.variant.(ImportID)}

AS_INT_PTR      	   :: #force_inline proc "contextless" (value: ^Value) -> Int   	 { return value.variant.(Int) }
AS_BOOL_PTR     	   :: #force_inline proc "contextless" (value: ^Value) -> bool  	 { return value.variant.(bool) }
AS_OBJECT_PTR   	   :: #force_inline proc "contextless" (value: ^Value) -> ^Object    { return value.variant.(^Object)}
AS_SYMID_PTR           :: #force_inline proc "contextless" (value: ^Value) -> Uint       { return value.variant.(Uint)}
AS_OID_PTR             :: #force_inline proc "contextless" (value: ^Value) -> ^Oid       { return &value.variant.(Oid)}


AS_OP_FUNC_PTR		   :: #force_inline proc "contextless" (value: ^Value) -> NativeFn  { return value.variant.(NativeFn)  }
AS_OP_FUNCP_PTR		   :: #force_inline proc "contextless" (value: ^Value) -> ^NativeFn  { return &value.variant.(NativeFn) }


AS_TRANSFORM2_PTR  :: #force_inline proc "contextless" (value_p: ^Value) -> ^mat2x3 { return (^mat2x3)(&value_p.variant.(_mem)) }


AS_RECT2_PTR  :: #force_inline proc "contextless" (value_p: ^Value) -> ^Rect2 { return (^Rect2)(&value_p.variant.(_mem)) }


AS_RECT2_PTRV  :: #force_inline proc "contextless" (value_p: ^Value) -> Rect2 {
	return (^Rect2)(&value_p.variant.(_mem))^
}

AS_RECT2       :: #force_inline proc "contextless" (value: Value)    -> ^Rect2 {
	value := value
	return (^Rect2)(&value.variant.(_mem))	
}


AS_COLOR_PTR  :: #force_inline proc "contextless" (value_p: ^Value) -> ^Color {
	return (^Color)(&value_p.variant.(_mem))
}

AS_COLOR_PTRV  :: #force_inline proc "contextless" (value_p: ^Value) -> Color {
	return (^Color)(&value_p.variant.(_mem))^
}

AS_COlOR     :: #force_inline proc "contextless" (value: Value) -> ^Color {
	value := value
	return (^Color)(&value.variant.(_mem))	
}


AS_VECTOR2_PTR  :: #force_inline proc "contextless" (value_p: ^Value) -> ^Vector2d {
	return (^Vector2d)(&value_p.variant.(_mem))
}

AS_VECTOR2_PTRV  :: #force_inline proc "contextless" (value_p: ^Value) -> Vector2d {
	return (^Vector2d)(&value_p.variant.(_mem))^
}

AS_VECTOR2     :: #force_inline proc "contextless" (value: Value) -> ^Vector2d {
	value := value
	return (^Vector2d)(&value.variant.(_mem))	
}


AS_ANY_PTR             :: #force_inline proc "contextless" (value: ^Value) -> ^Any       { return (^Any)(AS_OBJECT_PTR(value))}



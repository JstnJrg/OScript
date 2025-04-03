package OScriptVariant

import mem "core:mem"

// Nota(jstn): converte valores Odin para valores OScript
FLOAT_VAL  :: #force_inline proc "contextless" (value: Float)  -> Value      { return Value{.FLOAT_VAL, value} }
INT_VAL    :: #force_inline proc "contextless" (value: Int)    -> Value      { return Value{.INT_VAL,   value} }
BOOL_VAL   :: #force_inline proc "contextless" (value: bool)   -> Value      { return Value{.BOOL_VAL,  value} }
NIL_VAL    :: #force_inline proc "contextless" ()			   -> Value      { return Value{.NIL_VAL,     nil }}
SYMID_VAL  :: #force_inline proc "contextless" (id: Uint)      -> Value      { return Value{.SYMID_VAL, id}        }

CLASS_BD_ID_VAL     :: #force_inline proc "contextless" (id : ClassID,   type: ValueType )   -> Value { return Value{type,id} }
FUNCTION_BD_ID_VAL  :: #force_inline proc "contextless" (id: FunctionID, type: ValueType)  -> Value { return Value{type,id}}  
IMPORT_BD_ID_VAL    :: #force_inline proc "contextless" (id: ImportID,   type: ValueType)  -> Value { return Value{type,id}}  
OBJECT_VAL 		    :: #force_inline proc "contextless" (value: ^Object, type: ValueType) -> Value { return Value{type, value}}


NATIVE_OP_FUNC_VAL :: #force_inline proc "contextless" (function: NativeFn) -> Value { return Value{.NATIVE_OP_FUNC_VAL,function}}


FLOAT_VAL_PTR  :: #force_inline proc (value_p: ^Value,value: Float)   {  value_p.type = .FLOAT_VAL   ; value_p.variant  = value}
INT_VAL_PTR    :: #force_inline proc (value_p: ^Value,value: Int)     {  value_p.type = .INT_VAL     ; value_p.variant  = value}
BOOL_VAL_PTR   :: #force_inline proc (value_p: ^Value,value: bool)    {  value_p.type = .BOOL_VAL    ; value_p.variant  = value}
NIL_VAL_PTR    :: #force_inline proc (value_p: ^Value)				  {  value_p.type = .NIL_VAL     ; value_p.variant  = nil  }


OBJECT_VAL_PTR  :: #force_inline proc (value_p: ^Value,value: ^Object,type: ValueType) { value_p.type = type ; value_p.variant  = value }
GENERIC_VAL_PTR :: #force_inline proc (from_p,to_p: ^Value)    { to_p.type = from_p.type ; to_p.variant = from_p.variant }


NATIVE_OP_FUNC_VAL_PTR :: #force_inline proc (value_p: ^Value, function: NativeFn) {  value_p.type = .NATIVE_OP_FUNC_VAL; value_p.variant = function }


COPY_DATA     :: #force_inline proc "contextless" (bptr: ^_mem, data : ^$T)   { mem.copy(bptr,data,size_of(T)) }


VECTOR2xy_VAL :: #force_inline proc "contextless" (x,y: Float)	-> Value   { 
	value  		:= Value{.VECTOR2_VAL,_mem{0..<_memlen = 0}}
	bf_ptr 		:= &value.variant.(_mem)
	
	mem.copy(bf_ptr,&Vector2d{x,y},size_of(Vector2d))
	return value
}

VECTOR2_VAL  :: #force_inline proc "contextless" (vector: Vector2d)	-> Value   {

	value       := Value{.VECTOR2_VAL,_mem{0..<_memlen = 0}}
	bf_ptr      := &value.variant.(_mem)
	vector      := vector

	mem.copy(bf_ptr,&vector,size_of(Vector2d))
	return value
}


VECTOR2xy_VAL_PTR :: #force_inline proc "contextless" (value_p: ^Value,x,y: Float)  {

	value_p.type    = .VECTOR2_VAL
	value_p.variant = _mem{0..<_memlen= 0}

	bf_ptr := &value_p.variant.(_mem)
	mem.copy(bf_ptr,&Vector2d{x,y},size_of(Vector2d))
}

VECTOR2_VAL_PTR  :: #force_inline proc "contextless" (value_p: ^Value,vector_p: ^Vector2d)	{
	
	value_p.type    = .VECTOR2_VAL
	value_p.variant = _mem{0..<_memlen= 0}

	bf_ptr        := &value_p.variant.(_mem)
	mem.copy(bf_ptr,vector_p,size_of(Vector2d))
}

VECTOR2_VAL_PTRV  :: #force_inline proc "contextless" (value_p: ^Value,vector: Vector2d)	{
	value_p.type    = .VECTOR2_VAL
	value_p.variant = _mem{0..<_memlen= 0}

	bf_ptr         := &value_p.variant.(_mem)

	vector := vector

	mem.copy(bf_ptr,&vector,size_of(Vector2d)) 
}

COLOR_VAL  :: #force_inline proc "contextless" (data: []u8)	-> Value   {
	value  		:= Value{.COLOR_VAL,_mem{0..<_memlen = 0}}
	bf_ptr 		:= &value.variant.(_mem)
	mem.copy(bf_ptr,raw_data(data),size_of(data))
	return value
}

COLOR_VAL_PTR  :: #force_inline proc "contextless" (value_p: ^Value,data: ^Color)	{
	value_p.type    = .COLOR_VAL
	value_p.variant = _mem{0..<_memlen= 0}

	bf_ptr := &value_p.variant.(_mem)
	mem.copy(bf_ptr,data,size_of(data))
}

RECT2_VAL_PTR  :: #force_inline proc (value_p: ^Value, data : ^Rect2)	{

	value_p.type    = .RECT2_VAL
	value_p.variant = _mem{0..<_memlen= 0}

	bf_ptr := &value_p.variant.(_mem)
	mem.copy(bf_ptr,data,size_of(Rect2))
}

RECT2_VAL  :: #force_inline proc "contextless" (pos,size : Vector2d)	-> Value   {

	value  := Value{.RECT2_VAL,_mem{0..<_memlen = 0}}
	data   := Rect2{pos,size}
	
	bf_ptr      := &value.variant.(_mem)
	mem.copy(bf_ptr,&data,size_of(data))

	return value
}


TRANSFORM2_VAL_PTR         :: #force_inline proc(value_p: ^Value,x,y,o: ^Vector2d ) { OBJECT_VAL_PTR(value_p,create_transform2_ptr(x,y,o),.OBJ_TRANSFORM2) }

TRANSFORM2_VAL_MAT2x3_PTR  :: #force_inline proc(value_p: ^Value, m : ^mat2x3 ) { OBJECT_VAL_PTR(value_p,create_transform2_mat2x3_ptr(m),.OBJ_TRANSFORM2) }


OSTRING_VAL_PTR  :: #force_inline proc (value_p: ^Value, data : ^string )	{

	value_p.type    = .OSTRING_VAL
	value_p.variant = _mem{0..<_memlen= 0}

	bf_ptr := &value_p.variant.(_mem)
	mem.copy(bf_ptr,data,_memlen)
}

OSTRING_VAL  :: #force_inline proc "contextless" (data: ^string)	-> Value   {

	value  := Value{.OSTRING_VAL,_mem{0..<_memlen = 0}}
	
	bf_ptr := &value.variant.(_mem)
	mem.copy(bf_ptr,data,_memlen)

	return value
}
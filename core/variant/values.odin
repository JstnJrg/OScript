package OScriptVariant

ValueType :: distinct enum u8 {
	
	// Types
	NONE_VAL,
	BOOL_VAL,
	NIL_VAL,
	FLOAT_VAL,
	INT_VAL,
	SYMID_VAL,

	// 
	VECTOR2_VAL,
	COLOR_VAL,
	RECT2_VAL,
	OSTRING_VAL, //strings que cabem dentro do buffer

	// Optimized objects
	NATIVE_OP_FUNC_VAL,

	// 
	OBJ_VAL,

	// buffer
	OBJ_TRANSFORM2,

	// heap
	OBJ_STRING,
	OBJ_ARRAY,
	OBJ_PROGRAM, 
	OBJ_FUNCTION, 
	OBJ_NATIVE_FUNCTION, 
	OBJ_CLASS, 
	OBJ_CLASS_INSTANCE,
	OBJ_PACKAGE, 


	// OBJ_BOUND_METHOD,
	OBJ_NATIVE_CLASS, //não pode ser instanciada
	OBJ_ERROR, //funções
	OBJ_MAX,

}


ValueBitSet :: bit_set[ValueType; u32]

_memlen :: 16
_mem    :: [_memlen]byte


Variant :: union
{
	Int,
	Float,
		
	ClassID,
	FunctionID,
	ImportID,
	Uint,

	bool,
	^Object,
	NativeFn,
	_mem
}


// Nota(jstn): o Variant ocupa 32 bytes para [24]u8, [16]u8 ocupa 24, para suportar Transfomr2D afim de que não aloque memoria,
// Value vai ocupar 40bytes,caso seja desassociado, afim de que Transform2D aloque memoria, Value será 32bytes
Value :: struct  #align(8) { 
	type 		: ValueType,
	variant     : Variant
}



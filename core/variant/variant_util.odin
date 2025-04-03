package OScriptVariant

import strconv "core:strconv"
import strings "core:strings"
import hash    "core:hash"


GET_TYPE     :: proc "contextless" (value: Value) ->  ValueType { return value.type}
GET_TYPE_PTR :: proc "contextless" (value: ^Value) -> ValueType { return value.type}


VAL_COMPARABLE 		:: #force_inline proc "contextless" (a,b: ValueType) -> bool {
	
	if a != b	  do return false

	#partial switch a 
	{
		case .FLOAT_VAL,.INT_VAL,.OBJ_STRING  : return true
		case 								  : return false
	}
}


IS_ZERO_PTR  :: #force_inline proc(value: ^Value) -> bool {

	#partial switch value.type 
	{
		case .INT_VAL			: return AS_INT_PTR(value)    == 0
		case .FLOAT_VAL		    : return AS_FLOAT_PTR(value)  == 0
		case .BOOL_VAL 			: return !AS_BOOL_PTR(value)
		case .VECTOR2_VAL 		: return AS_VECTOR2_PTR(value)^ == Vector2d{0,0}	
		case .NIL_VAL 			: return true
		case .OBJ_STRING		: return VAL_STRING_DATA_PTR(value) == ""
		case 					: return true
	}
}

BOOLEANIZE :: #force_inline proc(value: ^Value) -> bool { return !IS_ZERO_PTR(value)}


VAL_TYPE_STRING :: proc "contextless" (value: Value) -> string { return TYPE_TO_STRING(GET_TYPE(value)) } 


TYPE_TO_STRING     :: proc             "contextless" (type : ValueType) -> string {
	@static default : Value
	default = {type,nil}
	return GET_TYPE_NAME(&default)
} 

GET_TYPE_NAME     :: #force_inline proc "contextless" (value: ^Value) -> string
{
	#partial switch value.type
	{
		case .NONE_VAL 		: return ""

		case .BOOL_VAL   	: return "bool"
		case .NIL_VAL    	: return "nil"
		case .FLOAT_VAL     : return "float"
		case .INT_VAL 		: return "int"
		case .RECT2_VAL		: return "Rect2"
		// case .COLOR_VAL		: return "Color"

		// case .NATIVE_OP_FUNC_VAL : return "function"
		case .VECTOR2_VAL        : return "Vector2"
		case .COLOR_VAL          : return "Color"
		case .OBJ_TRANSFORM2     : return "Transfrom2D"

		case .OBJ_STRING    : return "String"
		case .OBJ_ARRAY		: return "Array"
		case .OBJ_CLASS     : return "Class"
		// case .O

		case .OBJ_CLASS_INSTANCE				: return "class instance"
		case .NATIVE_OP_FUNC_VAL, .OBJ_FUNCTION : return "function"
		case .OBJ_NATIVE_CLASS 					: return "OScriptNativeClass"
		case .OBJ_PACKAGE						: return "Package"
		// case .OBJ_CLASS                         : return "class"
		case 				: return "<!>"
	}
}



value_hash :: #force_inline proc "contextless" (value_p : ^Value) -> u32
{
	#partial switch value_p.type
	{
		case .NONE_VAL 		: return 0

		case .BOOL_VAL   	: return AS_BOOL_PTR(value_p) ? 1:0
		case .NIL_VAL    	: return 0
		case .INT_VAL 		: return one_64(AS_INT_PTR(value_p))
		case .FLOAT_VAL     : return murmur3_one_float(AS_FLOAT_PTR(value_p))
		case .RECT2_VAL		: 

							  r := AS_RECT2_PTR(value_p)
							  p := &r[0]
							  s := &r[1]
							  h := murmur3_one_float(p.x)
							  h  = murmur3_one_float(p.y,h)
							  h  = murmur3_one_float(s.x,h)
							  h  = murmur3_one_float(s.y,h)
							  return fmix32(h)

		case .NATIVE_OP_FUNC_VAL : 

							  h0 := (uintptr)(AS_OP_FUNCP_PTR(value_p))
							  h  := one_64(h0)
							  return fmix32(h)
		case .VECTOR2_VAL        : 

							  v := AS_VECTOR2_PTR(value_p)
							  h := murmur3_one_float(v.x)
							  h  = murmur3_one_float(v.y,h)
							  return fmix32(h)
		case .COLOR_VAL          : 

							  c := AS_COLOR_PTR(value_p)
							  h := murmur3_one_32(c.r)
							  h  = murmur3_one_32(c.g,h)
							  h  = murmur3_one_32(c.b,h)
							  h  = murmur3_one_32(c.a,h)
							  return fmix32(h)

		case .OBJ_TRANSFORM2     : 

							  m := AS_TRANSFORM2_DATA_PTR(value_p)
							  x := &m[0]
							  y := &m[1]
							  o := &m[2]
							  h := murmur3_one_float(x.x)
							  h  = murmur3_one_float(x.y,h)
							  h  = murmur3_one_float(y.x,h)
							  h  = murmur3_one_float(y.y,h)
							  h  = murmur3_one_float(o.x,h)
							  h  = murmur3_one_float(o.y,h)
							  return fmix32(h)

		case .OBJ_STRING    : return hash_string(VAL_STRING_DATA_PTR(value_p))

		case .OBJ_CLASS     : 
							  h  := hash_string("Class")
							  id := AS_CLASS_BD_ID_PTR(value_p)
							  h   = murmur3_one_32(id,h)
							  return fmix32(h)

		case .OBJ_CLASS_INSTANCE : 

							  h0 := (uintptr)(VAL_AS_OBJ_CLASS_INSTANCE_PTR(value_p))
							  h  := one_64(h0)
							  return fmix32(h)

		case .OBJ_FUNCTION : 
							  h  := hash_string("function")
							  id := AS_FUNCTION_BD_ID_PTR(value_p)
							  h   = murmur3_one_32(id,h)
							  return fmix32(h)
		case .OBJ_PACKAGE						: 

							  h   := hash_string("Package")
							  id  := AS_IMPORT_BD_ID_PTR(value_p)
							  h    = murmur3_one_32(id,h)
							  return fmix32(h)

		case 				: return 0
	}
}

value_hash_compare :: proc (value_a,value_b : ^Value, rcount: int, max_recursion := 100) -> bool
{

	if      value_a.type != value_b.type  do return false
	else if rcount  >= max_recursion      
	{ 
		when OSCRIPT_DEBUG do println("Max recursion reached.")
		return false 
	}

	#partial switch value_a.type
	{
		case .NONE_VAL 		: return  value_hash(value_a) == value_hash(value_b)

		case .BOOL_VAL   	: return  value_hash(value_a) == value_hash(value_b)
		case .NIL_VAL    	: return  value_hash(value_a) == value_hash(value_b)
		case .INT_VAL 		: return  value_hash(value_a) == value_hash(value_b)
		case .FLOAT_VAL     : return  value_hash(value_a) == value_hash(value_b)
		case .RECT2_VAL		: return  value_hash(value_a) == value_hash(value_b)

		case .NATIVE_OP_FUNC_VAL : return value_hash(value_a) == value_hash(value_b)
		case .VECTOR2_VAL        : return value_hash(value_a) == value_hash(value_b)
		case .COLOR_VAL          : return value_hash(value_a) == value_hash(value_b)

		case .OBJ_TRANSFORM2     : return value_hash(value_a) == value_hash(value_b)
		case .OBJ_STRING         : return value_hash(value_a) == value_hash(value_b)
		case .OBJ_ARRAY		     : 

							 arr0  := VAL_AS_OBJ_ARRAY_PTR(value_a)
    						 p0    := &arr0.data

							 arr1  := VAL_AS_OBJ_ARRAY_PTR(value_b)
    						 p1    := &arr1.data

    						 min   := arr0.len > arr1.len ? arr1.len:arr0.len

    						 for i in 0..< min do if !value_hash_compare(&p0[i],&p1[i],rcount+1,max_recursion) do return false

							 return true

		case .OBJ_CLASS          : return value_hash(value_a) == value_hash(value_b)
		case .OBJ_CLASS_INSTANCE : return value_hash(value_a) == value_hash(value_b)

		case .OBJ_FUNCTION :  return value_hash(value_a) == value_hash(value_b)
		case .OBJ_PACKAGE  :  return value_hash(value_a) == value_hash(value_b) 

		case 				: return false
	}
}


atof   		:: #force_inline proc(value: string) 	-> Float { return Float(strconv.atof(value)) }
hash_string :: #force_inline proc "contextless" (data: string) 	-> u32 { return djb2(transmute([]byte)data) }
hash_bytes  :: #force_inline proc(data: []u8) 		-> u32 { return hash.djb2(data) }
combine 	:: #force_inline proc(a,b: u32) 		-> u32 { return a*7+b*11 }
str_clone   :: #force_inline proc(str: string, allocator: Allocator)  -> string { str_r, _ := strings.clone(str,allocator); return str_r }
// min         :: #force_inline proc "contextless" (a,b: )





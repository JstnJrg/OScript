#+private

package OScriptRect2D

import variant    "oscript:variant"
import constants  "oscript:constants"
import types	  "oscript:types"



println   :: variant.println
register_op			::  variant.register_op

// 
Value 				:: variant.Value
CallState           :: variant.CallState
mat2x3				:: variant.mat2x3
Vec2 				:: variant.Vector2d
Rect2 				:: variant.Rect2
// NativeFn 			:: variant.NativeFn

// Nota(jstn): tipos Oscript 
Int 				:: types.Int
Float				:: types.Float
ImportID            :: variant.ImportID
// U8		:: types.U8
// Uint 	:: types.Uint
// Uint_32 :: types.Uint_32


// 
VECTOR2_VAL_PTR  :: variant.VECTOR2_VAL_PTR
VECTOR2_VAL_PTRV :: variant.VECTOR2_VAL_PTRV


VECTOR2_VAL 	 :: variant.VECTOR2_VAL
RECT2_VAL_PTR    :: variant.RECT2_VAL_PTR
RECT2_VAL		 :: variant.RECT2_VAL

AS_RECT2_PTR	 :: variant.AS_RECT2_PTR
AS_RECT2_PTRV    :: variant.AS_RECT2_PTRV

AS_VECTOR2_PTR   :: variant.AS_VECTOR2_PTR
AS_VECTOR2_PTRV  :: variant.AS_VECTOR2_PTRV

AS_TRANSFORM2_PTR :: variant.AS_TRANSFORM2_PTR


// Nota(jstn): procedures
IS_VECTOR2D_PTR				:: variant.IS_VECTOR2_PTR
IS_FLOAT_CAST_PTR   		:: variant.IS_FLOAT_CAST_PTR
IS_RECT2_PTR				:: variant.IS_RECT2_PTR

FLOAT_VAL_PTR	:: variant.FLOAT_VAL_PTR
INT_VAL_PTR    	:: variant.INT_VAL_PTR 
BOOL_VAL_PTR   	:: variant.BOOL_VAL_PTR 
NIL_VAL_PTR		:: variant.NIL_VAL_PTR


register_method				:: variant.register_method
register_value      		:: variant.register_value

TYPE_TO_STRING				:: variant.TYPE_TO_STRING
CALL_ERROR_STRING			:: variant.CALL_ERROR_STRING
CALL_WARNING_STRING 		:: variant.CALL_WARNING_STRING


OSCRIPT_ALLOW_RUNTIME_WARNINGS :: constants.OSCRIPT_ALLOW_RUNTIME_WARNINGS

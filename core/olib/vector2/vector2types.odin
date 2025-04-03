package OscriptVector2

import linalg	  "core:math/linalg"
// import rand       "core:math/rand"
import math       "core:math"
import intrinsics "base:intrinsics"

import variant    "oscript:variant"
import constants  "oscript:constants"
import types	  "oscript:types"


@private IS_NUMERIC :: intrinsics.type_is_numeric


linalg :: linalg
math   :: math

Value 				:: variant.Value
Vec2                :: variant.Vector2d
Int 				:: types.Int
Float				:: types.Float
ImportID            :: variant.ImportID

ObjectCallError 	:: variant.ObjectCallError

register_method		:: variant.register_method
register_value      :: variant.register_value

BOOL_VAL_PTR   		:: variant.BOOL_VAL_PTR 
FLOAT_VAL_PTR		:: variant.FLOAT_VAL_PTR
NIL_VAL_PTR			:: variant.NIL_VAL_PTR
INT_VAL_PTR 		:: variant.INT_VAL_PTR

IS_INT_PTR			:: variant.IS_INT_PTR
IS_FLOAT_PTR        :: variant.IS_FLOAT_PTR
IS_VECTOR2D_PTR		:: variant.IS_VECTOR2_PTR
IS_FLOAT_CAST_PTR   :: variant.IS_FLOAT_CAST_PTR

FLOAT_VAL			:: variant.FLOAT_VAL
INT_VAL  			:: variant.INT_VAL

VECTOR2_VAL_PTR  	:: variant.VECTOR2_VAL_PTR
VECTOR2_VAL_PTRV 	:: variant.VECTOR2_VAL_PTRV

VECTOR2_VAL 	 	:: variant.VECTOR2_VAL

AS_VECTOR2_PTR   	:: variant.AS_VECTOR2_PTR
AS_VECTOR2_PTRV  	:: variant.AS_VECTOR2_PTRV



CALL_ERROR_STRING	:: variant.CALL_ERROR_STRING
CALL_WARNING_STRING :: variant.CALL_WARNING_STRING

OSCRIPT_ALLOW_RUNTIME_WARNINGS :: constants.OSCRIPT_ALLOW_RUNTIME_WARNINGS

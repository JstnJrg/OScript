package OscriptString

import variant    "oscript:variant"
import constants  "oscript:constants"
import types	  "oscript:types"



println             :: variant.println


Value 				:: variant.Value
CallState           :: variant.CallState
Int 				:: types.Int
// Float				:: types.Float
ImportID            :: variant.ImportID

ObjectCallError 	:: variant.ObjectCallError

register_method		:: variant.register_method
register_value      :: variant.register_value


BOOL_VAL_PTR   		:: variant.BOOL_VAL_PTR 
// FLOAT_VAL_PTR		:: variant.FLOAT_VAL_PTR
NIL_VAL_PTR			:: variant.NIL_VAL_PTR
INT_VAL_PTR 		:: variant.INT_VAL_PTR
OBJECT_VAL_PTR      :: variant.OBJECT_VAL_PTR

IS_INT_PTR			:: variant.IS_INT_PTR
// IS_FLOAT_PTR        :: variant.IS_FLOAT_PTR
// IS_FLOAT_PTR_INT    :: variant.IS_INT_PTR
// IS_FLOAT_CAST_PTR   :: variant.IS_FLOAT_CAST_PTR

IS_VAL_STRING_PTR   :: variant.IS_VAL_STRING_PTR

// FLOAT_VAL			:: variant.FLOAT_VAL
INT_VAL  			:: variant.INT_VAL



VAL_STRING_DATA_PTR 		:: variant.VAL_STRING_DATA_PTR 
VAL_AS_OBJ_STRING_PTR		:: variant.VAL_AS_OBJ_STRING_PTR
VAL_STRING_GET_SLICE		:: variant.VAL_STRING_GET_SLICE


OBJ_STRING_WRITE_DATA		:: variant.OBJ_STRING_WRITE_DATA
OBJ_STRING_WRITE_DATA_STRING:: variant.OBJ_STRING_WRITE_DATA_STRING
OBJ_STRING_COMPUTE_HASH		:: variant.OBJ_STRING_COMPUTE_HASH

CREATE_OBJ_STRING_NO_DATA	:: variant.CREATE_OBJ_STRING_NO_DATA




CALL_ERROR_STRING	:: variant.CALL_ERROR_STRING
CALL_WARNING_STRING :: variant.CALL_WARNING_STRING

OSCRIPT_ALLOW_RUNTIME_WARNINGS :: constants.OSCRIPT_ALLOW_RUNTIME_WARNINGS

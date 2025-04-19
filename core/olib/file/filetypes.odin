#+private

package OscriptFile

import variant    "oscript:variant"
import constants  "oscript:constants"
import types	  "oscript:types"

Value 				:: variant.Value
CallState           :: variant.CallState
Any                 :: variant.Any
Int 				:: types.Int
Float				:: types.Float
ImportID            :: variant.ImportID

TYPE_TO_STRING      :: variant.TYPE_TO_STRING

ObjectCallError 	:: variant.ObjectCallError
register_method		:: variant.register_method


BOOL_VAL_PTR   		:: variant.BOOL_VAL_PTR 
// FLOAT_VAL_PTR		:: variant.FLOAT_VAL_PTR
NIL_VAL_PTR			:: variant.NIL_VAL_PTR
INT_VAL_PTR 		:: variant.INT_VAL_PTR       
ANY_VAL_PTR         :: variant.ANY_VAL_PTR
OBJECT_VAL_PTR      :: variant.OBJECT_VAL_PTR

IS_INT_PTR			:: variant.IS_INT_PTR
IS_VAL_STRING_PTR   :: variant.IS_VAL_STRING_PTR
IS_ANY_PTR          :: variant.IS_ANY_PTR
// IS_FLOAT_PTR        :: variant.IS_FLOAT_PTR
// IS_FLOAT_PTR_INT    :: variant.IS_INT_PTR
// IS_FLOAT_CAST_PTR   :: variant.IS_FLOAT_CAST_PTR

// FLOAT_VAL			:: variant.FLOAT_VAL
// INT_VAL  			:: variant.INT_VAL

VAL_STRING_DATA_PTR  :: variant.VAL_STRING_DATA_PTR

AS_INT_PTR           :: variant.AS_INT_PTR
AS_ANY_PTR			 :: variant.AS_ANY_PTR


create_any_ptr      :: variant.create_any_ptr

CREATE_OBJ_STRING_NO_DATA    :: variant.CREATE_OBJ_STRING_NO_DATA
OBJ_STRING_WRITE_DATA_STRING :: variant.OBJ_STRING_WRITE_DATA_STRING


CALL_ERROR_STRING	:: variant.CALL_ERROR_STRING
CALL_WARNING_STRING :: variant.CALL_WARNING_STRING

OSCRIPT_ALLOW_RUNTIME_WARNINGS :: constants.OSCRIPT_ALLOW_RUNTIME_WARNINGS

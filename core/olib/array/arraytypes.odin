#+private

package OscriptArray

import rand       "core:math/rand"
import variant    "oscript:variant"
import constants  "oscript:constants"
import types	  "oscript:types"


rand                :: rand

Value 				:: variant.Value
// NativeFn 			:: variant.NativeFn
Int 				:: types.Int
// Float				:: types.Float
ImportID            :: variant.ImportID

ObjectCallError 	:: variant.ObjectCallError

register_method		   :: variant.register_method
get_operator_evaluator :: variant.get_operator_evaluator


BOOL_VAL_PTR   		:: variant.BOOL_VAL_PTR 
// FLOAT_VAL_PTR		:: variant.FLOAT_VAL_PTR
NIL_VAL_PTR			:: variant.NIL_VAL_PTR
INT_VAL_PTR 		:: variant.INT_VAL_PTR
GENERIC_VAL_PTR     :: variant.GENERIC_VAL_PTR

IS_INT_PTR			 :: variant.IS_INT_PTR

VAL_AS_OBJ_ARRAY_PTR :: variant.VAL_AS_OBJ_ARRAY_PTR
AS_BOOL_PTR          :: variant.AS_BOOL_PTR


CREATE_OBJ_ARRAY     :: variant.CREATE_OBJ_ARRAY

// IS_FLOAT_PTR        :: variant.IS_FLOAT_PTR
// IS_FLOAT_PTR_INT    :: variant.IS_INT_PTR
// IS_FLOAT_CAST_PTR   :: variant.IS_FLOAT_CAST_PTR

// FLOAT_VAL			:: variant.FLOAT_VAL
// INT_VAL  			:: variant.INT_VAL

register_op			:: variant.register_op
value_hash_compare  :: variant.value_hash_compare

CALL_ERROR_STRING	:: variant.CALL_ERROR_STRING
CALL_WARNING_STRING :: variant.CALL_WARNING_STRING

OSCRIPT_ALLOW_RUNTIME_WARNINGS :: constants.OSCRIPT_ALLOW_RUNTIME_WARNINGS

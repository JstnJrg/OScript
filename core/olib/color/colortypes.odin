#+private

package OscriptColor

import linalg	  "core:math/linalg"
// import rand       "core:math/rand"
import math       "core:math"
import intrinsics "base:intrinsics"

import variant    "oscript:variant"
import constants  "oscript:constants"
import types	  "oscript:types"


linalg :: linalg
// rand   :: rand
math   :: math


Value 				:: variant.Value
CallState 			:: variant.CallState
Int 				:: types.Int
Float				:: types.Float
Color               :: variant.Color
ImportID            :: variant.ImportID

ObjectCallError 	:: variant.ObjectCallError

register_method		:: variant.register_method


// BOOL_VAL_PTR   		:: variant.BOOL_VAL_PTR 
// FLOAT_VAL_PTR		:: variant.FLOAT_VAL_PTR
// NIL_VAL_PTR			:: variant.NIL_VAL_PTR
INT_VAL_PTR 		:: variant.INT_VAL_PTR
COLOR_VAL_PTR       :: variant.COLOR_VAL_PTR

// IS_INT_PTR			:: variant.IS_INT_PTR
// IS_FLOAT_PTR        :: variant.IS_FLOAT_PTR
// IS_FLOAT_PTR_INT    :: variant.IS_INT_PTR
IS_FLOAT_CAST_PTR   :: variant.IS_FLOAT_CAST_PTR
IS_COLOR_PTR        :: variant.IS_COLOR_PTR

// FLOAT_VAL			:: variant.FLOAT_VAL
INT_VAL  			:: variant.INT_VAL


AS_COLOR_PTR		:: variant.AS_COLOR_PTR



CALL_ERROR_STRING	:: variant.CALL_ERROR_STRING
CALL_WARNING_STRING :: variant.CALL_WARNING_STRING

OSCRIPT_ALLOW_RUNTIME_WARNINGS :: constants.OSCRIPT_ALLOW_RUNTIME_WARNINGS

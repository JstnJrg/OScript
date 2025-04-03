#+private

package OScriptTransform2D

import variant    "oscript:variant"
import constants  "oscript:constants"
import types	  "oscript:types"


register_op			:: variant.register_op


// Nota(jstn): tipos Oscript 

Value 				:: variant.Value
Vec2 				:: variant.Vector2d
Transform2D 		:: variant.Transform2D
mat2x3				:: variant.mat2x3
Rect2 				:: variant.Rect2

Int 				:: types.Int
Float				:: types.Float
ImportID            :: variant.ImportID

ObjectCallError 	:: variant.ObjectCallError

// Nota(jstn): procedures
// INT_VAL_PTR					:: variant.INT_VAL_PTR
BOOL_VAL_PTR				:: variant.BOOL_VAL_PTR
NIL_VAL_PTR					:: variant.NIL_VAL_PTR
FLOAT_VAL_PTR               :: variant.FLOAT_VAL_PTR
TRANSFORM2_VAL_PTR          :: variant.TRANSFORM2_VAL_PTR
OBJECT_VAL_PTR              :: variant.OBJECT_VAL_PTR
RECT2_VAL_PTR				:: variant.RECT2_VAL_PTR

// GENERIC_VAL_PTR         	:: variant.GENERIC_VAL_PTR
VECTOR2_VAL_PTR				:: variant.VECTOR2_VAL_PTR
VECTOR2_VAL_PTRV			:: variant.VECTOR2_VAL_PTRV

AS_BOOL_PTR             	:: variant.AS_BOOL_PTR
AS_VECTOR2_PTR      		:: variant.AS_VECTOR2_PTR
AS_RECT2_PTR				:: variant.AS_RECT2_PTR

AS_TRANSFORM2_PTR     		:: variant.AS_TRANSFORM2_PTR
AS_TRANSFORM2_DATA_PTR		:: variant.AS_TRANSFORM2_DATA_PTR

IS_VECTOR2D_PTR				:: variant.IS_VECTOR2_PTR
IS_TRANSFORM2_PTR			:: variant.IS_TRANSFORM2_PTR
// IS_INT_PTR					:: variant.IS_INT_PTR
// IS_FLOAT_PTR        		:: variant.IS_FLOAT_PTR
// IS_FLOAT_PTR_INT    		:: variant.IS_INT_PTR
IS_FLOAT_CAST_PTR   		:: variant.IS_FLOAT_CAST_PTR
IS_RECT2_PTR				:: variant.IS_RECT2_PTR


register_method				:: variant.register_method
register_value      		:: variant.register_value

CALL_ERROR_STRING			:: variant.CALL_ERROR_STRING
CALL_WARNING_STRING 		:: variant.CALL_WARNING_STRING


create_transform2_no_data_ptr :: variant.create_transform2_no_data_ptr


OSCRIPT_ALLOW_RUNTIME_WARNINGS :: constants.OSCRIPT_ALLOW_RUNTIME_WARNINGS
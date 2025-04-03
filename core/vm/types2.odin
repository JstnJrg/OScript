package OScriptVM

import variant 		"oscript:variant"
import constants	"oscript:constants"
import _context     "oscript:context"



variant :: variant

// Nota(jstn): context

OSCRIPT_DEBUG           :: _context.OSCRIPT_DEBUG


// Nota(jstn): constants
MAX_FRAMES 				:: constants.MAX_FRAMES
MAX_STACK  				:: constants.MAX_STACK_SIZE
MAX_PROGRAM				:: constants.MAX_PROGRAM
MAX_GLOBAL_FRAME		:: constants.MAX_GLOBAL_FRAME
MAX_VARIABLE_NAME		:: constants.MAX_VARIABLE_NAME
MAX_OPCODE				:: constants.MAX_OPCODE
MAX_LOCAL				:: constants.MAX_LOCAL
MAX_MATCH_CASE			:: constants.MAX_MATCH_CASE
MAX_COURROTINE			:: constants.MAX_COURROTINE
MAX_ARGUMENTS			:: constants.MAX_ARGUMENTS
MAX_JUMP				:: constants.MAX_JUMP
MAX_GRAY				:: constants.MAX_GRAY
MAX_CHUNK_CONSTANT		:: constants.MAX_CHUNK_CONSTANT

OSCRIPT_ALLOW_RUNTIME_WARNINGS	:: constants.OSCRIPT_ALLOW_RUNTIME_WARNINGS
OSCRIPT_REPORT_TOS				:: constants.OSCRIPT_REPORT_TOS



// Nota(jstn): variants types
Value 				:: variant.Value
Chunk       		:: variant.Chunk
Table 	   			:: variant.Table
ValueBitSet         :: variant.ValueBitSet
Object      		:: variant.Object
FreeList			:: variant.FreeList
_memlen             :: variant._memlen

// 
FunctionID 			:: variant.FunctionID
Function 			:: variant.Function
ImportID            :: variant.ImportID
ClassID 			:: variant.ClassID
SeachModule         :: variant.SeachModule


ObjectCallError 	:: variant.ObjectCallError
NativeFn    		:: variant.NativeFn
ObjectFunction		:: variant.ObjectFunction
ObjectNative 		:: variant.ObjectNative
ObjectString		:: variant.ObjectString
ObjectClass 		:: variant.ObjectClass
ObjectClassInstance :: variant.ObjectClassInstance
ObjectNativeClass   :: variant.ObjectNativeClass
ObjectProgram 		:: variant.ObjectProgram


// variant's
hash_string			:: variant.hash_string
printer				:: variant.printer
falsey				:: variant.IS_ZERO_PTR
variant_register    :: variant.variant_register


// table
TableString 		:: variant.TableString
TableHash			:: variant.TableHash
table_set 			:: variant.table_set
table_pset          :: variant.table_pset
table_get 			:: variant.table_get
table_get_s         :: variant.table_get_s
table_set_s			:: variant.table_set_s
table_set_hash_vptr :: variant.table_set_hash_vptr
table_set_hash 		:: variant.table_set_hash
table_pset_hash		:: variant.table_pset_hash
table_get_hash		:: variant.table_get_hash
table_copy 			:: variant.table_copy
destroy_table		:: variant.destroy_table

// BD

// FunctionBD
initBD							:: variant.initBD
create_function_functionBD		:: variant.create_function_functionBD
get_function_functionBD 		:: variant.get_function_functionBD
get_function_name_functionBD	:: variant.get_function_name_functionBD
get_function_chunk_functionBD	:: variant.get_function_chunk_functionBD
is_valid_functionID_functionBD  :: variant.is_valid_functionID_functionBD

// ClassBD
SetGetType							 :: variant.SetGetType

register_class_classBD				 :: variant.register_class_classBD 
register_class_property_classBD	     :: variant.register_class_property_classBD
register_class_property_set_classBD	 :: variant.register_class_property_set_classBD
register_class_property_get_classBD	 :: variant.register_class_property_get_classBD
register_class_method_classBD		 :: variant.register_class_method_classBD
register_class_private_method_classBD:: variant.register_class_private_method_classBD

get_private_method_classBD 			 :: variant.get_private_method_classBD
get_method_classBD 					 :: variant.get_method_classBD
get_method_hash_classBD				 :: variant.get_method_hash_classBD
get_class_name_classBD               :: variant.get_class_name_classBD
get_default_set_classBD				 :: variant.get_default_set_classBD
get_default_get_classBD				 :: variant.get_default_get_classBD
get_class_table_classBD              :: variant.get_class_table_classBD
get_class_private_table_classBD      :: variant.get_class_private_table_classBD        

initialize_instance_property_classBD :: variant.initialize_instance_property_classBD

// Import
get_native_import_by_name_importID   :: variant.get_native_import_by_name_importID
get_import_by_name_importID			 :: variant.get_import_by_name_importID
get_import_by_hash_importID			 :: variant.get_import_by_hash_importID
get_current_importID     			 :: variant.get_current_importID
get_import_name						 :: variant.get_import_name
get_import_context_importID 		 :: variant.get_import_context_importID
register_import_importID 			 :: variant.register_import_importID
set_current_importID                 :: variant.set_current_importID
register_method 					 :: variant.register_method

//Symbol
register_symbol_BD					 :: variant.register_symbol_BD
get_symbol_str_BD 					 :: variant.get_symbol_str_BD
get_symbol_hash_BD					 :: variant.get_symbol_hash_BD




// chunk
create_chunk        :: variant.create_chunk
destroy_chunk		:: variant.destroy_chunk
add_opcode			:: variant.add_opcode
add_constant		:: variant.add_constant

// objects
free_object			:: variant.free_object


// Nota(jstn): procedures
INT_VAL				:: variant.INT_VAL
SYMID_VAL           :: variant.SYMID_VAL
FLOAT_VAL   		:: variant.FLOAT_VAL
BOOL_VAL   			:: variant.BOOL_VAL
NIL_VAL 			:: variant.NIL_VAL
OSTRING_VAL			:: variant.OSTRING_VAL
OBJECT_VAL			:: variant.OBJECT_VAL
CLASS_BD_ID_VAL		:: variant.CLASS_BD_ID_VAL
FUNCTION_BD_ID_VAL  :: variant.FUNCTION_BD_ID_VAL
IMPORT_BD_ID_VAL    :: variant.IMPORT_BD_ID_VAL
NATIVE_OP_FUNC_VAL  :: variant.NATIVE_OP_FUNC_VAL


BOOL_VAL_PTR		:: variant.BOOL_VAL_PTR


ValueType			:: variant.ValueType
ObjectType			:: variant.ObjectType

INT_VAL_PTR			:: variant.INT_VAL_PTR
FLOAT_VAL_PTR		:: variant.FLOAT_VAL_PTR
OBJECT_VAL_PTR      :: variant.OBJECT_VAL_PTR
NIL_VAL_PTR			:: variant.NIL_VAL_PTR



// IS
IS_OBJECT_PTR		:: variant.IS_OBJECT_PTR
IS_CLASS_BD_ID_PTR  :: variant.IS_CLASS_BD_ID_PTR
IS_FUNCTION_BD_PTR 	:: variant.IS_FUNCTION_BD_PTR
IS_IMPORT_BD_PTR    :: variant.IS_IMPORT_BD_PTR


// AS
AS_SYMID_PTR		   :: variant.AS_SYMID_PTR
AS_CLASS_BD_ID_PTR     :: variant.AS_CLASS_BD_ID_PTR
AS_FUNCTION_BD_ID_PTR  :: variant.AS_FUNCTION_BD_ID_PTR
AS_IMPORT_BD_ID_PTR    :: variant.AS_IMPORT_BD_ID_PTR
AS_OBJECT_PTR		   :: variant.AS_OBJECT_PTR
AS_OP_FUNC_PTR         :: variant.AS_OP_FUNC_PTR
AS_BOOL_PTR			   :: variant.AS_BOOL_PTR
AS_INT_PTR             :: variant.AS_INT_PTR          


// 
OBJ_AS_FUNCTION_OBJ 	:: variant.OBJ_AS_FUNCTION_OBJ
OBJ_AS_PROGRAM			:: variant.OBJ_AS_PROGRAM
OBJ_AS_ARRAY_OBJ		:: variant.OBJ_AS_ARRAY_OBJ
OBJ_AS_CLASS_INSTANCE	:: variant.OBJ_AS_CLASS_INSTANCE

// Create
CREATE_OBJ_FUNCTION_WITH_CHUNK :: variant.CREATE_OBJ_FUNCTION_WITH_CHUNK
CREATE_OBJ_STRING			   :: variant.CREATE_OBJ_STRING
CREATE_OBJ_CLASS_INSTANCE      :: variant.CREATE_OBJ_CLASS_INSTANCE


VAL_AS_OBJ_CLASS_INSTANCE_PTR  :: variant.VAL_AS_OBJ_CLASS_INSTANCE_PTR
VAL_AS_OBJ_STRING_PTR          :: variant.VAL_AS_OBJ_STRING_PTR
VAL_AS_OBJ_STRING	           :: variant.VAL_AS_OBJ_STRING
VAL_STRING_DATA_PTR   		   :: variant.VAL_STRING_DATA_PTR


// General
OBJ_TYPE			:: variant.OBJ_TYPE
TYPE_TO_STRING		:: variant.TYPE_TO_STRING
GET_TYPE_NAME		:: variant.GET_TYPE_NAME

FUNCTION_NAME		:: variant.FUNCTION_NAME
OBJ_STRING_DATA		:: variant.OBJ_STRING_DATA


get_operator_evaluator_unary :: variant.get_operator_evaluator_unary
get_operator_evaluator       :: variant.get_operator_evaluator
get_construct_evaluator		 :: variant.get_construct_evaluator
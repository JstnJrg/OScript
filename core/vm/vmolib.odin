package OScriptVM

import mathlib    		"olib:math"
import stringlib  		"olib:string"
import vector2lib 		"olib:vector2"
import transform2lib	"olib:transform2"
import colorlib   		"olib:color"
import arraylib   		"olib:array"
import timelib    		"olib:time"



OMODULES        :: SeachModule{.NATIVE}
OIMODULES       :: SeachModule{.CLASS}


register_olib   :: proc() {

	mathlib.register(get_native_import_by_name_importID("Math",    OMODULES))
	timelib.register(get_native_import_by_name_importID("Time",    OMODULES))

	// Nota(jstn): atomicos
	stringlib.register(get_native_import_by_name_importID("String",OIMODULES))
	vector2lib.register(get_native_import_by_name_importID("Vector2",OIMODULES))
	colorlib.register(get_native_import_by_name_importID("Color",OIMODULES))
	arraylib.register(get_native_import_by_name_importID("Array",OIMODULES))
	transform2lib.register(get_native_import_by_name_importID("Transform2",OIMODULES))
}
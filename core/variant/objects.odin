package OScriptVariant

import strings "core:strings"
import fmt "core:fmt"


// Nota(jstn): GC
list            : ^^Object
free_list_ptr   : ^[ObjectType]FreeList
bytes_allocated : ^Uint



FreeList   :: struct {
	obj   : ^Object,
	count : int
}


// 
Builder 	:: strings.Builder

ObjectType :: distinct enum u8 { 

	// 
	OBJ_NONE, //ajuda a manter uma correspondencia 1 <--> 1 com ValueType

	//buffer 
	OBJ_TRANSFORM2,


	// heap
	OBJ_STRING,
	OBJ_ARRAY,
	OBJ_PROGRAM, 
	OBJ_FUNCTION, 
	OBJ_NATIVE_FUNCTION, 
	OBJ_CLASS, 
	OBJ_CLASS_INSTANCE, 
	OBJ_PACKAGE,
	// OBJ_BOUND_METHOD,
	OBJ_NATIVE_CLASS, //não pode ser instanciada
	OBJ_ERROR, //funções
	OBJ_MAX,
}


Object :: struct {
	type 			: ObjectType,
	next 			: ^Object,
	is_marked		: bool
}


ObjectProgram :: struct {
	using obj 		: Object,
	function_script : ^ObjectFunction,
	globals 		: Table 
}


ObjectCallError :: struct {
	error  	: bool,
	warning : bool,
	message	: [256]byte,
	msg_str	: string,
}


ObjectString :: struct {
	using obj : Object,
	data 	  : Builder,
	len		  : int,
	hash      : u32
}


ObjectArray :: struct {
	using obj : Object,
	data 	  : [dynamic]Value,
	len		  : int,
}



ObjectFunction :: struct {
	using obj 		: Object,
	arity     		: int,
	default_arity 	: int, //usado principalmente para metodos de classes, para capturar o self,
	local_count		: int,
	chunk	  		: ^Chunk,
	name	  		: ^ObjectString,
	path 	  		: string
}

NativeFn :: proc(argc: int, args: []Value,result: ^Value, callerror: ^ObjectCallError = nil)

ObjectNative :: struct {
	using obj : Object,
	fn 		  : NativeFn
}

ObjectClass :: struct {
	using obj   : Object,
	// class_script_hash
	name     	: ^ObjectString,
	methods   	: Table, //chaves sao nomes de metodos e valores sao funcoes
}


ObjectNativeClass :: struct {
	using obj   : Object,
	name     	: ^ObjectString,
	methods   	: Table, //chaves sao nomes de metodos e valores sao funcoes
	private		: Table,
	fields 		: Table
}

ObjectClassInstance :: struct {
	using obj: Object,
	klass_ID : ClassID,
	fields	 : Table
}

// usado para as classes chamarem metodos
ObjectBoundMethod :: struct{
	using obj: Object,
	method   : ^ObjectFunction,
	receiver : Value //permite que a instancia se torne acessivel dentro do metodo
}


ObjectPackage :: struct{
	using obj: Object,
	globals  : Table,
	name     : ^ObjectString
}



/* Nota(jstn): helpers que nos permitirão converte os objectos/valores em objectos especificos */
VAL_AS_OBJ_STRING 	  	:: #force_inline proc "contextless" (value: Value)  -> ^ObjectString 	{ return (^ObjectString)(AS_OBJECT(value)) }
VAL_AS_OBJ_STRING_PTR 	:: #force_inline proc "contextless" (value: ^Value)  -> ^ObjectString 	{ return (^ObjectString)(AS_OBJECT_PTR(value)) }
// VAL_AS_STRING 	  		:: #force_inline proc "contextless" (value: Value)  -> string 			{ return strings.to_string(VAL_AS_OBJ_STRING(value).data)  }
VAL_STRING_DATA   		:: #force_inline proc "contextless" (value: Value)  -> string 			{ return OBJ_STRING_DATA(VAL_AS_OBJ_STRING(value)) }
VAL_STRING_DATA_PTR   	:: #force_inline proc "contextless" (value: ^Value)  -> string 		{ return OBJ_STRING_DATA(VAL_AS_OBJ_STRING_PTR(value)) }
VAL_STRING_TO_CSTRING   :: #force_inline proc  (value: ^Value)  -> cstring        { obj := (^ObjectString)(AS_OBJECT_PTR(value)); cstr,_ := strings.to_cstring(&obj.data); return cstr}
VAL_STRING_GET_SLICE    :: #force_inline proc "contextless" (value: ^Value) -> []byte          { obj := (^ObjectString)(AS_OBJECT_PTR(value)); return obj.data.buf[:] }


OBJ_AS_OBJ_STRING      :: #force_inline proc "contextless"(obj: ^Object)  -> ^ObjectString { return (^ObjectString)(obj) }
OBJ_AS_STRING 	       :: #force_inline proc "contextless"(obj: ^Object)  -> string 		{ return string((^ObjectString)(obj).data.buf[:]) }
OBJ_STRING_DATA        :: #force_inline proc "contextless" (obj: ^ObjectString) -> string 	{ return string(obj.data.buf[:]) }
OBJ_STRING_SET_BUILDER :: #force_inline proc "contextless" (obj: ^ObjectString, b: ^Builder) { obj.data = b^ }


OBJ_STRING_WRITE_DATA :: #force_inline proc(obj_to,obj_from: ^ObjectString, compute_hash := false) {
	strings.write_string(&obj_to.data,OBJ_STRING_DATA(obj_from))
	if compute_hash do obj_to.hash = hash_bytes(obj_to.data.buf[:]) 
}

OBJ_STRING_WRITE_DATA_STRING :: #force_inline proc(obj: ^ObjectString, str: string, compute_hash := false) {
	strings.write_string(&obj.data,str)
	if compute_hash do obj.hash = hash_bytes(obj.data.buf[:]) 
}

OBJ_STRING_WRITE_DATA_INT :: #force_inline proc(obj: ^ObjectString, data: int ,compute_hash := false) {
	strings.write_int(&obj.data,data)
	if compute_hash do obj.hash = hash_bytes(obj.data.buf[:]) 
}

// OBJ_STRING_POP_ZERO      :: #force_inline proc(obj: ^ObjectString, compute_hash := false) -> cstring {
// 	if compute_hash do obj.hash = hash_bytes(obj.data.buf[:]) 
// 	
// }






OBJ_STRING_COMPUTE_HASH :: #force_inline proc(obj: ^ObjectString) { obj.hash = hash_bytes(obj.data.buf[:]) }


VAL_AS_OBJ_FUNCTION 	:: #force_inline proc "contextless" (value: Value) -> ^ObjectFunction 	{ return (^ObjectFunction)(AS_OBJECT(value)) }
VAL_AS_OBJ_FUNCTION_PTR :: #force_inline proc "contextless" (value: ^Value) -> ^ObjectFunction 	{ return (^ObjectFunction)(AS_OBJECT_PTR(value)) }
OBJ_AS_FUNCTION_OBJ :: #force_inline proc "contextless" (obj: ^Object) -> ^ObjectFunction 	{ return (^ObjectFunction)(obj) }
OBJ_FUNCTION_NAME   :: #force_inline proc "contextless" (obj: ^Object) -> string 			{ return FUNCTION_NAME(OBJ_AS_FUNCTION_OBJ(obj)) }
OBJ_FUNCTION_PATH   :: #force_inline proc "contextless" (obj: ^Object) -> string 			{ return OBJ_AS_FUNCTION_OBJ(obj).path }
FUNCTION_NAME 		:: #force_inline proc "contextless" (fn: ^ObjectFunction) -> string   	{ return OBJ_STRING_DATA(fn.name)}


VAL_AS_OBJ_NATIVE_FUNCTION 		:: #force_inline proc "contextless" (value: Value) -> ^ObjectNative  { return (^ObjectNative)(AS_OBJECT(value)) }
VAL_AS_OBJ_NATIVE_FUNCTION_PTR 	:: #force_inline proc "contextless" (value: ^Value) -> ^ObjectNative  { return (^ObjectNative)(AS_OBJECT_PTR(value)) }
VAL_GET_NATIVE_FN 			:: #force_inline proc "contextless" (value: Value) -> NativeFn       { return VAL_AS_OBJ_NATIVE_FUNCTION(value).fn}
OBJ_AS_NATIVE_FUNCTION 		:: #force_inline  proc "contextless" (obj: ^Object) -> ^ObjectNative { return (^ObjectNative)(obj) }
OBJ_GET_NATIVE_FN 			:: #force_inline  proc "contextless" (obj: ^Object) -> NativeFn      { return OBJ_AS_NATIVE_FUNCTION(obj).fn }


VAL_AS_OBJ_CLASS 				:: #force_inline proc "contextless" (value: Value) -> ^ObjectClass { return (^ObjectClass)(AS_OBJECT(value)) }
VAL_AS_OBJ_CLASS_PTR 			:: #force_inline proc "contextless" (value: ^Value) -> ^ObjectClass { return (^ObjectClass)(AS_OBJECT_PTR(value)) }
OBJ_AS_CLASS 				:: #force_inline proc "contextless" (obj: ^Object) -> ^ObjectClass { return (^ObjectClass)(obj) }
OBJ_CLASS_NAME				:: #force_inline proc "contextless" (obj: ^Object) -> string       { return CLASS_NAME(OBJ_AS_CLASS(obj)) }
CLASS_NAME					:: #force_inline proc "contextless" (obj: ^ObjectClass) -> string  { return OBJ_STRING_DATA(obj.name) }
VAL_CLASS_NAME				:: #force_inline proc "contextless" (value: Value) -> string       { return CLASS_NAME(VAL_AS_OBJ_CLASS(value)) }


VAL_AS_OBJ_CLASS_INSTANCE 		:: #force_inline proc  "contextless" (value: Value) -> ^ObjectClassInstance { return (^ObjectClassInstance)(AS_OBJECT(value)) }
VAL_AS_OBJ_CLASS_INSTANCE_PTR 	:: #force_inline proc "contextless" (value: ^Value) -> ^ObjectClassInstance { return (^ObjectClassInstance)(AS_OBJECT_PTR(value)) }
OBJ_AS_CLASS_INSTANCE 		:: #force_inline proc "contextless" (obj: ^Object) -> ^ObjectClassInstance { return (^ObjectClassInstance)(obj) }
// OBJ_INSTANCE_KLASS_NAME 	:: #force_inline proc(obj: ^Object) -> string 				{ return CLASS_NAME(OBJ_AS_CLASS_INSTANCE(obj).klass) }
// INSTANCE_KLASS_NAME 	    :: #force_inline proc(obj: ^ObjectClassInstance) -> string 	{ return CLASS_NAME(obj.klass) }


VAL_AS_OBJ_BOUND_METHOD 	:: #force_inline proc(value: Value) -> ^ObjectBoundMethod { return (^ObjectBoundMethod)(AS_OBJECT(value)) }
OBJ_AS_BOUND_METHOD 		:: #force_inline proc(obj: ^Object) -> ^ObjectBoundMethod { return (^ObjectBoundMethod)(obj) }


VAL_AS_OBJ_NATIVE_CLASS			:: #force_inline proc(value: Value) -> ^ObjectNativeClass 	{ return (^ObjectNativeClass)(AS_OBJECT(value)) }
VAL_AS_OBJ_NATIVE_CLASS_PTR		:: #force_inline proc(value: ^Value) -> ^ObjectNativeClass 	{ return (^ObjectNativeClass)(AS_OBJECT_PTR(value)) }
OBJ_AS_NATIVE_CLASS			:: #force_inline proc(obj: ^Object) -> ^ObjectNativeClass 	{ return (^ObjectNativeClass)(obj) }
OBJ_NATIVE_CLASS_NAME   	:: #force_inline proc(obj: ^Object) -> string 			    { return OBJ_STRING_DATA(OBJ_AS_NATIVE_CLASS(obj).name) }


VAL_AS_OBJ_ARRAY			:: #force_inline proc(value: Value) -> ^ObjectArray 	{ return (^ObjectArray)(AS_OBJECT(value)) }
VAL_AS_OBJ_ARRAY_PTR		:: #force_inline proc "contextless" (value: ^Value) -> ^ObjectArray 	{ return (^ObjectArray)(AS_OBJECT(value^)) }
OBJ_AS_ARRAY_OBJ			:: #force_inline proc(obj: ^Object) -> ^ObjectArray 	{ return (^ObjectArray)(obj) }


OBJ_AS_PROGRAM				:: #force_inline proc(obj: ^Object) -> ^ObjectProgram 		{ return (^ObjectProgram)(obj) }
VAL_AS_OBJ_PROGRAM_PTR 	  	:: #force_inline proc(value: ^Value)  -> ^ObjectProgram 	{ return (^ObjectProgram)(AS_OBJECT_PTR(value)) }

// Helpers

// IS_VAL_OBJ 				:: #force_inline proc(value: Value) -> bool 					{ return value.type == .OBJ_VAL}
IS_VAL_OBJ_TYPE 		:: #force_inline proc(value : Value, type : ObjectType) -> bool { return  AS_OBJECT(value).type == type }
IS_OBJ_TYPE 			:: #force_inline proc(obj : ^Object, type : ObjectType) -> bool { return obj.type == type }

IS_VAL_STRING    			:: #force_inline proc(value: Value) -> bool { return value.type == .OBJ_STRING}
IS_VAL_STRING_PTR 			:: #force_inline proc(value: ^Value) -> bool { return value.type == .OBJ_STRING}
IS_VAL_FUNCTION_PTR 		:: #force_inline proc(value: ^Value) -> bool { return value.type == .OBJ_FUNCTION}
IS_VAL_ARRAY 			:: #force_inline proc(value: Value) -> bool { return value.type == .OBJ_ARRAY}
IS_VAL_FUNCTION 		:: #force_inline proc(value: Value) -> bool { return value.type == .OBJ_FUNCTION}
IS_VAL_FUNCTION_NATIVE 	:: #force_inline proc(value: Value) -> bool { return value.type == .OBJ_NATIVE_FUNCTION}

IS_VAL_CLASS 			:: #force_inline proc(value: Value) -> bool { return value.type == .OBJ_CLASS}
IS_VAL_CLASS_PTR		:: #force_inline proc(value: ^Value) -> bool { return value.type == .OBJ_CLASS}

IS_VAL_CLASS_INSTANCE  	    :: #force_inline proc(value: Value) -> bool { return value.type == .OBJ_CLASS_INSTANCE}
IS_VAL_CLASS_INSTANCE_PTR  	:: #force_inline proc(value: ^Value) -> bool { return value.type == .OBJ_CLASS_INSTANCE}
// IS_VAL_BOUND_METHOD 	:: #force_inline proc(value: Value) -> bool { return value.type == .OBJ_BOUND_METHOD}
IS_VAL_NATIVE_CLASS	    :: #force_inline proc(value: Value) -> bool { return value.type == .OBJ_NATIVE_CLASS}

IS_CALLABLE             :: #force_inline proc(obj : ^Object) -> (bool,ObjectType) { return  obj.type == .OBJ_FUNCTION || obj.type == .OBJ_NATIVE_FUNCTION, obj.type }

OBJ_TYPE 			:: proc(obj : ^Object) -> ObjectType { return obj.type }

OBJ_CALL_RESET  	:: proc(callerror: ^ObjectCallError) 			  { callerror.error = false; callerror.warning = false}
CALL_ERROR_STRING 	:: proc(callerror: ^ObjectCallError, args: ..any) { callerror.error = true ;callerror.msg_str = fmt.bprintln(callerror.message[:],..args) }
CALL_WARNING_STRING :: proc(callerror: ^ObjectCallError, args: ..any) { callerror.warning = true ;callerror.msg_str = fmt.bprintln(callerror.message[:],..args) }

VAL_AS_OBJ_PACKAGE_PTR 	  	:: #force_inline proc(value: ^Value)  -> ^ObjectPackage 	{ return (^ObjectPackage)(AS_OBJECT_PTR(value)) }
VAL_PACKAGE_NAME_PTR 	  	:: #force_inline proc(value: ^Value)  -> string 	{ package_p := (^ObjectPackage)(AS_OBJECT_PTR(value)); return OBJ_STRING_DATA(package_p.name) }
OBJ_AS_OBJ_PACKAGE      	:: #force_inline proc(obj: ^Object)  -> ^ObjectPackage { return (^ObjectPackage)(obj) }
IS_VAL_PACKAGE_PTR		    :: #force_inline proc(value: ^Value) -> bool { return value.type == .OBJ_PACKAGE}

// OBJ_TYPE_FROM_VALUE 	:: #force_inline proc(value: Value) -> (bool,ObjectType) { return IS_VAL_OBJ(value), }



// Nota(jstn): devolve um objecto livre da lista
PEEK_OBJECT_FROM_FREELIST :: #force_inline proc "contextless" (type: ObjectType) -> (bool, ^Object) {
	
	fl := &free_list_ptr[type]

	if fl.count > 0 
	{
		obj     := fl.obj
		fl.obj   = obj.next
		fl.count -= 1

		// Nota(jstn): coloca na lista geral de objectos
		obj.next  = list^
		list^	  = obj
		return true, obj
	}

	return false,nil
}



// Alocation´s

CREATE_PROGRAM :: proc( function_script: ^ObjectFunction ) -> ^ObjectProgram {
	obj 				:= CREATE_OBJECT(ObjectProgram,.OBJ_PROGRAM)
	obj.function_script	 = function_script
	return obj
}

CREATE_OBJECT  :: #force_inline proc( $T: typeid , type: ObjectType, alloc := context.allocator) -> ^T {
	object_p := new(T,alloc)
	object_p.type = type
	
	// caso não seja 
	if bytes_allocated != nil 
	{
		bytes_allocated^  += size_of(T)
		object_p.next	   = list^
		list^			   = object_p
	}

	return object_p
}

CREATE_OBJ_STRING :: proc( data : ^string, internal_strings: ^TableString, _len := 0) -> ^ObjectString {

	// strings interna
	hash := #force_inline hash_string(data^)

	/* Nota(jstn): é uma otimização que permite que multiplos values apontem para
	uma mesma string, evitando assim uma sobrecarga de alocacao, antes de alterar, saiba o que estas
	a fazer, pois essa otimização é critica para o desempenho 	*/
	has_hash := hash in internal_strings
	if has_hash      do return internal_strings[hash]

	// cria o objecto
	object_p := CREATE_OBJECT(ObjectString,.OBJ_STRING)
	#force_inline strings.write_string(&object_p.data,data^)
	
	object_p.hash = hash
	object_p.len = _len

	/* Nota(jstn): registra a string como uma string internalizada, antes de alterar, saiba o que estas
	a fazer, pois essa otimização é critica para o desempenho */
	internal_strings[hash] = object_p

	return object_p
}

CREATE_OBJ_STRING_NO_DATA :: proc() -> ^ObjectString {
	if sucess, obj := PEEK_OBJECT_FROM_FREELIST(.OBJ_STRING); sucess { clear_obj_data(obj); return (^ObjectString)(obj)}
	object_p := CREATE_OBJECT(ObjectString,.OBJ_STRING)
	return object_p
}


CREATE_OBJ_ARRAY :: proc() -> ^ObjectArray {

	if sucess, obj := PEEK_OBJECT_FROM_FREELIST(.OBJ_ARRAY); sucess { 
		clear_obj_data(obj)
		object_p         := (^ObjectArray)(obj)
		return object_p
	}

	object_p := CREATE_OBJECT(ObjectArray,.OBJ_ARRAY)
	return object_p
}

CREATE_OBJ_FUNCTION :: proc() -> ^ObjectFunction {
	object_p := CREATE_OBJECT(ObjectFunction,.OBJ_FUNCTION)
	return object_p
}

CREATE_OBJ_FUNCTION_WITH_CHUNK :: proc() -> ^ObjectFunction {
	object_p := CREATE_OBJECT(ObjectFunction,.OBJ_FUNCTION)
	object_p.chunk = create_chunk()
	return object_p
}

CREATE_OBJ_NATIVE_FUNCTION :: proc(fn: NativeFn) -> ^ObjectNative {
	object_p := CREATE_OBJECT(ObjectNative,.OBJ_NATIVE_FUNCTION)
	object_p.fn = fn
	return object_p
}

CREATE_OBJ_CLASS :: proc(name: ^ObjectString, is_buildin := false ) -> ^ObjectClass {
	object_p           := CREATE_OBJECT(ObjectClass,.OBJ_CLASS)
	object_p.name       = name
	return object_p
}


CREATE_OBJ_NATIVE_CLASS :: proc(name: ^ObjectString) -> ^ObjectNativeClass {
	object_p            := CREATE_OBJECT(ObjectNativeClass,.OBJ_NATIVE_CLASS)
	object_p.name       = name
	return object_p
}

CREATE_OBJ_CLASS_INSTANCE :: proc( klass_id: ClassID ) -> ^ObjectClassInstance {


	if sucess, obj := PEEK_OBJECT_FROM_FREELIST(.OBJ_CLASS_INSTANCE); sucess
	{ 
		clear_obj_data(obj)
		object_p         := (^ObjectClassInstance)(obj)
		object_p.klass_ID = klass_id
		return object_p
	}

	object_p         := CREATE_OBJECT(ObjectClassInstance,.OBJ_CLASS_INSTANCE)
	object_p.klass_ID = klass_id
	table_init_instance(&object_p.fields)
	return object_p
}


CREATE_OBJ_PACKAGE :: proc( name: ^ObjectString ) -> ^ObjectPackage {
	object_p     := CREATE_OBJECT(ObjectPackage,.OBJ_PACKAGE)
	object_p.name = name
	table_init(&object_p.globals)
	return object_p
}


// CREATE_OBJ_BOUND_METHOD :: proc( receiver: Value, method: ^ObjectFunction ) -> ^ObjectBoundMethod{
// 	object_p := CREATE_OBJECT(ObjectBoundMethod,.OBJ_BOUND_METHOD)
// 	object_p.receiver = receiver
// 	object_p.method   = method
// 	return object_p
// }



// Nota(jstn): com fim de reciclagem, deleta os dados de um objecto
clear_obj_data :: proc(obj: ^Object)
{

	#partial switch obj.type
	{
		case .OBJ_STRING:
			object_p        := (^ObjectString)(obj)
			object_p.len     = 0
			object_p.hash    = 0
			strings.builder_reset(&object_p.data)

	    case .OBJ_CLASS_INSTANCE:
	    	object_p := (^ObjectClassInstance)(obj)
	    	table_clear(&object_p.fields)
	    	object_p.klass_ID = 0

	    case .OBJ_ARRAY:
	    	object_p := (^ObjectArray)(obj)
	    	// object_p.len
	    	clear( &object_p.data) 
	    	shrink(&object_p.data,8)
	}
}




free_object :: proc(obj : ^Object) {

	#partial switch obj.type {
		
		case .OBJ_STRING :
			obj_string_p := OBJ_AS_OBJ_STRING(obj)
			strings.builder_destroy(&obj_string_p.data)
			free(obj)

		case .OBJ_ARRAY:
			obj_arr := OBJ_AS_ARRAY_OBJ(obj)
			delete(obj_arr.data)
			free(obj_arr)
		
		case .OBJ_FUNCTION :
			obj_function_p := OBJ_AS_FUNCTION_OBJ(obj)
			destroy_chunk(obj_function_p.chunk)
			free(obj_function_p)
		
		case .OBJ_NATIVE_FUNCTION :
			obj_fn_native_p := OBJ_AS_NATIVE_FUNCTION(obj)
			free(obj_fn_native_p)
		
		case .OBJ_CLASS :
			obj_class_p := OBJ_AS_CLASS(obj)
			destroy_table(obj_class_p.methods)
			free(obj_class_p)
		
		case .OBJ_NATIVE_CLASS :
			obj_class_p := OBJ_AS_NATIVE_CLASS(obj)
			destroy_table(obj_class_p.methods)
			destroy_table(obj_class_p.private)
			destroy_table(obj_class_p.fields)
			free(obj_class_p)

		case .OBJ_CLASS_INSTANCE :
			obj_class_instance_p := OBJ_AS_CLASS_INSTANCE(obj)
			destroy_table(obj_class_instance_p.fields)
			// destroy_table(obj_class_instance_p.private)
			free(obj_class_instance_p)

		// case .OBJ_BOUND_METHOD :
		// 	obj_bound_p := OBJ_AS_BOUND_METHOD(obj)
		// 	free(obj_bound_p)

		case  .OBJ_PACKAGE:
			package_p := OBJ_AS_OBJ_PACKAGE(obj)
			destroy_table(package_p.globals)
			free(package_p)

		case .OBJ_PROGRAM :
			program_p := OBJ_AS_PROGRAM(obj)
			destroy_table(program_p.globals)
			free(program_p)

		// no heap
		case .OBJ_TRANSFORM2:
			t := (^Transform2D)(obj)
			memfree(t)
	}
}



























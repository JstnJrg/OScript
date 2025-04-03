package OScriptVM

// Nota(jstn): armazena as funções a serem chamadas com base no tipo
// não transferimos isso para o variant, pois precisamos acessar a pilha
distaptch_call_table   : [ValueType]CallData 

handle_type  :: #type proc(#any_int argc: Int,has_error_p: ^bool)
call_type    :: #type proc(func : ^Value, #any_int argc,default_arity: Int, has_error: ^bool)

CallData :: struct 
{
	callee    : call_type,
	handle    : handle_type,
	cforeign  : call_type,
	import_id : ImportID //Nota(jstn): para nativos (e.g: string, color etc.)
}

// Nota(jstn): função que é chamada pela VM no inicio
register_call_data :: proc() {
	register_call_types()
	register_handle_types()
	register_types_import_id()
	register_foreign_call_types()
}




// Nota(jstn): faz o registro com base no tipo de função, ou seja, exisem funções com diferentestratamentos
register_call_types :: proc() 
{
	register_call_type(.OBJ_FUNCTION,call_function_obj)
	register_call_type(.NATIVE_OP_FUNC_VAL,call_native_function)
}

register_foreign_call_types :: proc() 
{
	register_foreign_call_type(.OBJ_FUNCTION,oscript_call_function)
	// register_call_type(.NATIVE_OP_FUNC_VAL,call_native_function)
}

register_handle_types :: proc()
{
	// Nota(jstn): atomicos
	register_handle_type(.OBJ_STRING, atomic_handle_type)
	register_handle_type(.VECTOR2_VAL,atomic_handle_type)
	register_handle_type(.COLOR_VAL,  atomic_handle_type)
	register_handle_type(.OBJ_ARRAY,  atomic_handle_type)
	register_handle_type(.OBJ_TRANSFORM2,  atomic_handle_type)
	register_handle_type(.RECT2_VAL, atomic_handle_type)



	register_handle_type(.OBJ_CLASS_INSTANCE,class_instance_handle_type)
	register_handle_type(.OBJ_PACKAGE,import_handle_type)
	register_handle_type(.OBJ_NATIVE_CLASS,import_handle_type)

	// register_handle_type(.OBJ_STRING)
}


register_types_import_id :: proc() {
	register_type_import(.OBJ_STRING, get_native_import_by_name_importID("String",  OIMODULES))
	register_type_import(.VECTOR2_VAL,get_native_import_by_name_importID("Vector2", OIMODULES))
	register_type_import(.RECT2_VAL, get_native_import_by_name_importID("Rect2"   , OIMODULES))
	register_type_import(.COLOR_VAL,  get_native_import_by_name_importID("Color",   OIMODULES))
	register_type_import(.OBJ_ARRAY,  get_native_import_by_name_importID("Array",   OIMODULES))
	register_type_import(.OBJ_TRANSFORM2,get_native_import_by_name_importID("Transform2",OIMODULES))
}


// ============================================================================


// Nota(jstn): registra um handle tipo para o tipo de objecto que queremos
register_handle_type :: proc "contextless" (type: ValueType ,handle: handle_type) { distaptch_call_table[type].handle = handle }

// Nota(jstn): registra uma função com base no tipo, para tipos objectos
register_call_type   :: proc "contextless" (obj_type: ValueType, function: call_type){ distaptch_call_table[obj_type].callee = function } 

// Nota(jstn): registra uma função com base no tipo, para tipos objectos chamados fora do oscript
register_foreign_call_type  :: proc "contextless" (obj_type: ValueType, function: call_type){ distaptch_call_table[obj_type].cforeign = function } 

// Nota(jstn): registra um id que aponta para uma tabela que contém metodos para tipos nativos
register_type_import :: proc "contextless" (obj_type: ValueType, iid : ImportID ){ distaptch_call_table[obj_type].import_id = iid } 


// =================================================================================

// Nota(jstn): obtem a função com base no tipo
get_call_type_ptr         :: #force_inline proc "contextless" (value: ^Value)   -> call_type   { return distaptch_call_table[value.type].callee  }
get_foreign_call_type_ptr :: #force_inline proc "contextless" (value: ^Value)  -> call_type    { return distaptch_call_table[value.type].cforeign}
get_call_type_by_type     :: #force_inline proc "contextless" (type: ValueType) -> call_type   { return distaptch_call_table[type].callee }

get_handle_ptr            :: #force_inline proc "contextless" (value: ^Value)   -> handle_type { return distaptch_call_table[value.type].handle }
get_handle_type_by_type   :: #force_inline proc "contextless" (type: ValueType) -> handle_type { return distaptch_call_table[type].handle }

get_import_id           :: #force_inline proc "contextless" (type: ValueType) -> ImportID    { return distaptch_call_table[type].import_id }



// Nota(jstn): handler para instancia de classes
@(optimization_mode = "favor_size")
atomic_handle_type :: #force_inline proc(#any_int argc: Int,has_error_p: ^bool) {
	
	sym_indx        := read_byte()
	hash            := get_symbol_hash_BD(sym_indx)

	siid            := get_import_id(peek_type(0))
	@static method 	: Value

	if !table_get_hash(get_import_context_importID(siid),hash,&method){
		runtime_error("method not declared '",get_symbol_str_BD(sym_indx),"' in base of '",GET_TYPE_NAME(peek_ptr(0)),"'")
		has_error_p^ = true
		return
	}

	// Nota(jstn): como quero capturar a string, então será argc+1, pois não removi
	// a string da pilha
	callee := #force_inline get_call_type_ptr(&method) 
		      #force_inline callee(&method,argc,1,has_error_p)
}


// Nota(jstn): handler para instancia de classes
@(optimization_mode = "favor_size")
class_instance_handle_type :: #force_inline proc(#any_int argc: Int,has_error_p: ^bool) {

	sym_indx        := read_byte()
	hash            := get_symbol_hash_BD(sym_indx)
	
	class_instance  := peek_ptr(0)
	instance 		:= VAL_AS_OBJ_CLASS_INSTANCE_PTR(class_instance)
	@static method 	: Value

	// Nota(jstn): não chamamos metodos armazenados em propriedades, pois é problematico

	// Nota(jstn): pode se dar ao caso de uma variavel possuir um metodo,
	// ou seja, lhe ser atribuída um função, então procuramos nela

	// TODO: atribuir um metodo aa uma variavel é problematico sem closure
	// implementar mais tarde closure

	// if table_get(&instance.fields,method_name,&method) {
	// 	callee := #force_inline get_call_type_ptr(&method)
	// 	if callee == nil { has_error_p^ = true; return}
	// 	#force_inline callee(&method,argc,has_error_p); return
	// }

	//Nota(jstn): Invoca apartir da class super
	if !get_method_hash_classBD(instance.klass_ID,hash,&method) {
		runtime_error("method not declared '",get_symbol_str_BD(sym_indx),"' in instance of '",get_class_name_classBD(instance.klass_ID),"'")
		has_error_p^ = true
		return
	}

	callee := #force_inline get_call_type_ptr(&method) 
		      #force_inline callee(&method,argc,1,has_error_p)
}

// Nota(jstn): handler para instancia de classes
@(optimization_mode = "favor_size")
import_handle_type :: #force_inline proc(#any_int argc: Int,has_error_p: ^bool) {

	sym_indx        := read_byte()
	hash            := get_symbol_hash_BD(sym_indx)
	
	import_id 		:= AS_IMPORT_BD_ID_PTR(pop_ptr())
	@static method 	: Value

	if !table_get_hash(get_import_context_importID(import_id),hash,&method){
		runtime_error("method not declared '",get_symbol_str_BD(sym_indx),"' in package '",get_import_name(import_id),"'")
		has_error_p^ = true
		return
	}

	callee := #force_inline get_call_type_ptr(&method) 
		      #force_inline callee(&method,argc,0,has_error_p)
}






















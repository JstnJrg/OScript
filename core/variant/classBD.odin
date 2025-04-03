package OScriptVariant

// import vmem 	    "core:mem/virtual"

ClassID        			:: distinct u64 //é crescente, então é muito importante
Container               :: [dynamic]CLassInfo

ClassContainer 			:: struct { ID : Container }

PropertySetGetInfoMap   :: map[string]PropertySetGetInfo
PropertyHash            :: [dynamic]u32

MethodInfoDynamicArray  :: [dynamic]MethodInfo


@(private="file")  current_class_container : ^ClassContainer
@(private="file")  current_class_allocator : Allocator


// Nota(jstn): o GC não pode apagar a tabela, somente rastrear, então precisamos de encontar uma maneira de ele 
// encontra-la, isso é feita com o ID, precisamos no futuro implementar uma tabela de ID não usados

MethodType       :: enum { PRIVATE, PUBLIC}
// ClassAttributes  :: enum { INSTATIABLE,}

PropertySetGetInfo  :: struct {
	set : SetGetType,
	get : SetGetType
}


MethodInfo :: struct {
	name : string,
	type : MethodType
}

CLassInfo :: struct
{
	id       		: ClassID,
	name     		: string,
	methods  		: Table,
	privates  		: Table,
	methods_info    : MethodInfoDynamicArray,
	property_hash	: PropertyHash,
	property 		: PropertySetGetInfoMap,
}



____default_init_____ : Value


init_classBD :: proc(allocator : Allocator) {
	current_class_allocator    = allocator
	current_class_container    = new(ClassContainer,allocator)
	assert(current_class_container != nil, "ClassBD is nullptr.")
	current_class_container.ID      = make(Container,allocator)
 }


// Nota(jstn): regista uma class e prepara sua tabela de metadados
register_class_classBD        :: proc(class_name : string) -> ClassID {

	append(&current_class_container.ID,CLassInfo{})
	id    := len(current_class_container.ID)-1 
	ID    := ClassID(id)

	// cinfo.name   		= str_clone(class_name,current_class_allocator)
	gsid 	           := register_symbol_BD(class_name)

	// Nota(jstn): prepara a class para metadados
	cinfo              := &current_class_container.ID[ID]
	cinfo.id       		= ID
	cinfo.name          = get_symbol_str_BD(gsid)
	cinfo.methods  		= make(Table,current_class_allocator)
	cinfo.privates      = make(Table,current_class_allocator)
	cinfo.methods_info  = make(MethodInfoDynamicArray,current_class_allocator)
	cinfo.property_hash = make(PropertyHash,current_class_allocator)
	cinfo.property 		= make(PropertySetGetInfoMap,current_class_allocator)

	return ID
}

// Nota(jstn): registra um metodo a uma class
register_class_method_classBD   :: proc(id: ClassID, _method_name: string, method: Value) {
	
	id_count := len(current_class_container.ID)-1

	// Nota(jstn): Id se cumprir essa condição, não foi registrado
	if id_count < 0 || id < 0 || id > ClassID(id_count) do return 

	cinfo 		  := &current_class_container.ID[id]
	// method_name   := str_clone(_method_name,current_class_allocator)
	
	gsid 				 := register_symbol_BD(_method_name)
	method_name          := get_symbol_str_BD(gsid)
	mhash                := get_symbol_hash_BD(gsid)

	table_set_hash(&cinfo.methods,mhash,method)
	append(&cinfo.methods_info,MethodInfo{name = method_name, type = .PUBLIC })
}


// Nota(jstn): registra um metodo a uma class
register_class_private_method_classBD   :: proc(id: ClassID, _method_name: string ,method: Value) {
	
	id_count := len(current_class_container.ID)-1

	// Nota(jstn): Id se cumprir essa condição, não foi registrado
	if id_count < 0 || id < 0 || id > ClassID(id_count) do return 

	cinfo 		  := &current_class_container.ID[id]
	// method_name   := str_clone(_method_name,current_class_allocator)
	gsid 			     := register_symbol_BD(_method_name)
	method_name          := get_symbol_str_BD(gsid)
	mhash                := get_symbol_hash_BD(gsid)

	table_set_hash(&cinfo.privates,mhash,method)
	append(&cinfo.methods_info,MethodInfo{name = method_name,type = .PRIVATE})
}

// Nota(jstn): registra um metodo a uma class
register_class_property_classBD :: proc(id: ClassID, _property_name: string) {
	
	id_count := len(current_class_container.ID)-1
	
	// Nota(jstn): Id se cumprir essa condição, não foi registrado
	if id_count < 0 || id < 0 || id > ClassID(id_count) do return 

	// property_name  			     := str_clone(_property_name,current_class_allocator)
	gsid 	        := register_symbol_BD(_property_name)
	property_name   := get_symbol_str_BD(gsid)
	cinfo           := &current_class_container.ID[id]
	
	// append(&cinfo.property_hash,hash_string(_property_name))
	append(&cinfo.property_hash,get_symbol_hash_BD(gsid))
	cinfo.property[property_name] = PropertySetGetInfo{set = default_set, get = default_get}

}


// Nota(jstn): não fazemos verificações extras, pois acredita-se que a propriedade já está registrada 
register_class_property_set_classBD :: proc "contextless" (id: ClassID, property_name: string, set_method: SetGetType  ) {
	cinfo := &current_class_container.ID[id]
	pinfo := &cinfo.property[property_name]
	pinfo.set = set_method 
}

// Nota(jstn): não fazemos verificações extras, pois acredita-se que a propriedade já está registrada 
register_class_property_get_classBD :: proc "contextless" (id: ClassID, property_name: string, get_method: SetGetType  ) {
	cinfo := &current_class_container.ID[id]
	pinfo := &cinfo.property[property_name]
	pinfo.get = get_method 
}

// Nota(jstn): obtem o nome da class, não fazemos nenhuma verificação, pois acredita-se que o ID esta corretco
get_class_name_classBD          :: #force_inline proc "contextless" (id: ClassID) -> string { return current_class_container.ID[id].name }

// Nota(jstn): util para o GC
get_class_table_classBD         :: #force_inline proc "contextless" (id: ClassID) -> ^Table { return &current_class_container.ID[id].methods }

get_class_private_table_classBD :: #force_inline proc "contextless" (id: ClassID) -> ^Table { return &current_class_container.ID[id].privates }


// Nota(jstn): obtem um metodo qualquer da class, não fazemos nenhuma verificação, pois acredita-se que o ID esta corretco
get_method_classBD             :: #force_inline proc (id: ClassID, _method_name: string, method_p: ^Value ) -> bool {
	cinfo  := &current_class_container.ID[id]
	return table_get_s(&cinfo.methods,_method_name,method_p)
}

// Nota(jstn): obtem um metodo qualquer da class, não fazemos nenhuma verificação, pois acredita-se que o ID esta corretco
get_method_hash_classBD        :: #force_inline proc (id: ClassID, _method_hash: u32, method_p: ^Value ) -> bool {
	cinfo  := &current_class_container.ID[id]
	return table_get_hash(&cinfo.methods,_method_hash,method_p)
}


// Nota(jstn): obtem o getter de uma determinada propriedade
get_property_get_method_classBD  :: #force_inline proc "contextless"  (id: ClassID, property_name : string ) -> SetGetType {
	cinfo              := &current_class_container.ID[id]
	pinfo, ok          := cinfo.property[property_name]
	return ok ? pinfo.get: default_get
}

// Nota(jstn): obtem o setter de uma determinada propriedade
get_property_set_method_classBD  :: #force_inline proc "contextless" (id: ClassID, property_name : string ) -> SetGetType {
	cinfo             := &current_class_container.ID[id]
	pinfo, ok         := cinfo.property[property_name]
	return ok ? pinfo.set: default_set
}

// Nota(jstn): caso quisermos um tipo generico, é para isso que serve essa função, um tipo generico para atribuir
// um valor a uma dada propriedade
get_default_set_classBD         :: #force_inline proc "contextless" (type: ValueType) -> SetGetType {

	#partial switch type 
	{
		case .OBJ_CLASS_INSTANCE : return default_set_instance
		case                     : return default_set
	}
}

// Nota(jstn): caso quisermos um tipo generico, é para isso que serve essa função, um tipo generico para obter uma 
//  propriedade da instancia
get_default_get_classBD         :: #force_inline proc "contextless" (type: ValueType) -> SetGetType {

	#partial switch type 
	{
		case .OBJ_CLASS_INSTANCE : return default_get_instance
		case                     : return default_set
	}
}


// Nota(jstn): obtem o um metodo privado de uma class
get_private_method_classBD             :: #force_inline proc (id: ClassID, _method_name: string, method_p: ^Value ) -> bool {
	cinfo  := &current_class_container.ID[id]
	return table_get_s(&cinfo.privates,_method_name,method_p)
}


initialize_instance_property_classBD   :: #force_inline proc (id: ClassID, fields: ^Table) {
	cinfo := &current_class_container.ID[id]
	for property_hash in cinfo.property_hash do table_set_hash(fields,property_hash,Value{.NIL_VAL,nil})
}























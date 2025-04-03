package OScriptVariant

ImportID        		:: distinct int
ImportType              :: enum u8 {NATIVE,CLASS,MODULE}
ImportMapa              :: [dynamic]^ImportInfo

@(private="file")  current_import_allocator : Allocator
@(private="file")  current_import_mapa      : ImportMapa
@(private="file")  current_import_id        : ImportID = -1 //Nota(jstn): Id do escopo corrente


ImportInfo    :: struct {	
	id       : ImportID,
	type     : ImportType,
	name     : string,
	hash     : u32,
	setter   : ImportSetGet,
	getter   : ImportSetGet,
	globals  : Table,
}

SeachModule   :: bit_set[ImportType;u8]

// Nota(jstn): inicializa a base de dados para import's
init_importBD :: proc(alloc : Allocator ) 
{ 
	current_import_allocator = alloc
	cim,e := make(ImportMapa,alloc)

	assert(e == .None, "importBD is nullptr") 
	current_import_mapa = cim

	// Nota(jstn): nativos
	register_natives()
}

register_import_importID  :: proc(name: string, hash: u32 = 0) -> ImportID {
	iinfo := new(ImportInfo,current_import_allocator)
	
	append(&current_import_mapa,iinfo)
	id    := ImportID(len(current_import_mapa)-1)

	iinfo.id      = id
	iinfo.type    = .MODULE
	iinfo.name    = str_clone(name,current_import_allocator)
	iinfo.hash    = hash
	iinfo.getter  = import_get
	iinfo.setter  = import_set
	iinfo.globals = make(Table,current_import_allocator)

	return id	
}


// Nota(jstn): não pode ser registrado em tempo de compilação
@(private)
register_import_native_importID  :: proc(name: string, set,get : ImportSetGet) -> ImportID {
	iinfo := new(ImportInfo,current_import_allocator)
	
	append(&current_import_mapa,iinfo)
	id    := ImportID(len(current_import_mapa)-1)

	iinfo.id      = id
	iinfo.type    = .NATIVE
	iinfo.name    = name//strings.clone(name,current_import_allocator)
	iinfo.getter  = get
	iinfo.setter  = set
	iinfo.globals = make(Table,current_import_allocator)

	return id	
}

@(private)
register_import_class_importID  :: proc(name: string, set,get : ImportSetGet) -> ImportID {
	iinfo := new(ImportInfo,current_import_allocator)
	
	append(&current_import_mapa,iinfo)
	id    := ImportID(len(current_import_mapa)-1)

	iinfo.id      = id
	iinfo.type    = .CLASS
	iinfo.name    = name//strings.clone(name,current_import_allocator)
	iinfo.getter  = get
	iinfo.setter  = set
	iinfo.globals = make(Table,current_import_allocator)

	return id	
}


// Nota(jstn): 
get_import_by_name_importID :: proc "contextless" (name: string, allow_modules : SeachModule ) -> ImportID {
	for iinfo in current_import_mapa do if iinfo.name == name {
		if iinfo.type in allow_modules do return iinfo.id
	}
	return -1
} 

get_native_import_by_name_importID :: proc "contextless" (name: string, allow_modules : SeachModule ) -> ImportID {

	for iinfo in current_import_mapa do if iinfo.name == name {
		if iinfo.type in allow_modules do return iinfo.id
	}
	return -1
} 

get_import_by_hash_importID :: proc "contextless" (hash: u32) -> ImportID {
	for iinfo in current_import_mapa do if iinfo.hash == hash    do return iinfo.id
	return -1
} 


get_import_name             :: proc "contextless" (id: ImportID) -> string { return current_import_mapa[id].name }

get_current_importID      	:: proc "contextless" () -> ImportID { return current_import_id }
set_current_importID      	:: proc "contextless" (id: ImportID) { current_import_id = id   }

get_import_context_importID :: proc "contextless" (id: ImportID) -> ^Table { return &current_import_mapa[id].globals }

get_getter_importID      	:: proc "contextless" (id: ImportID) -> ImportSetGet { return current_import_mapa[id].getter }
get_setter_importID      	:: proc "contextless" (id: ImportID) -> ImportSetGet { return current_import_mapa[id].setter }

// advance_current_importID  :: proc() { current_import_id += 1   }


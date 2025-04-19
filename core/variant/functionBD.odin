package OScriptVariant

FunctionID    :: distinct i16

FunctonInfo   :: struct 
{
	id            : FunctionID,
	import_id     : ImportID,
	name          : string,
	arity         : int,
	default_arity : int,
}

Function     :: struct 
{
	chunk	: ^Chunk,
	info    : FunctonInfo   
}

FunctionMemory :: [dynamic]^Function


@(private="file")  current_function_memory    : FunctionMemory
@(private="file")  current_function_allocator : Allocator


init_functionBD :: proc(alloc: Allocator) { 
	current_function_allocator = alloc 
	cfm,e                     := make(FunctionMemory,current_function_allocator)
	current_function_memory    = cfm
	assert( e == .None , "functionBD is nullptr")
}

// Nota(jstn): import ID 0 corresponde ao do programa em sí, ou seja, do script a ser executado
create_function_functionBD :: proc(name: string, arity,default_arity: int, import_id : ImportID ) -> FunctionID {
	
	cfuntion 	  := new(Function,current_function_allocator)
	cfuntion.chunk = create_chunk_by_arena(current_function_allocator)
	finfo    	  := &cfuntion.info

	append(&current_function_memory,cfuntion)
	id := FunctionID(len(current_function_memory)-1)

	finfo.id              = id
	finfo.import_id       = import_id
	// finfo.name,_          = strings.clone(name,current_function_allocator)

	gsid 				 := register_symbol_BD(name)
	finfo.name            = get_symbol_str_BD(gsid)
	finfo.arity           = arity
	finfo.default_arity   = default_arity

	return id
}

is_valid_functionID_functionBD :: proc "contextless" ( id : FunctionID ) -> bool { return id >= 0 && id <= FunctionID(len(current_function_memory)-1)}

get_function_name_functionBD   :: #force_inline proc "contextless" (id: FunctionID) -> string       { return current_function_memory[id].info.name }
get_function_functionBD        :: proc "contextless" (id: FunctionID) -> ^Function    { return current_function_memory[id] }
get_function_info_functionBD   :: proc "contextless" (id: FunctionID) -> ^FunctonInfo { return &current_function_memory[id].info }
get_function_chunk_functionBD  :: proc "contextless" (id: FunctionID) -> ^Chunk       { return current_function_memory[id].chunk }
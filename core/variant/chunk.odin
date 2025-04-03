package OScriptVariant


Chunk :: distinct struct 
{
	code 		: 		[dynamic]Uint,
	localization: 		[dynamic]Localization,
	constants	: 	    [dynamic]Value,
} 

create_chunk        :: proc() -> ^Chunk { return new(Chunk) }

create_chunk_by_arena  :: proc(alloc: Allocator) -> ^Chunk { 

	chunk := new(Chunk,alloc)
	assert(chunk != nil, "chunk is nullptr.")

	chunk.code          = make([dynamic]Uint,alloc)
	chunk.localization  = make([dynamic]Localization,alloc)
	chunk.constants     = make([dynamic]Value,alloc)

	return  chunk
}

destroy_chunk :: proc( chunk_p: ^Chunk)
{
	delete(chunk_p.constants)
	delete(chunk_p.localization)
	delete(chunk_p.code)
	free(chunk_p)
}

add_opcode :: proc(chunk_p : ^Chunk, #any_int opcode : Uint, position : Localization)
{
	append(&chunk_p.code,opcode)
	append(&chunk_p.localization,position)
}

add_constant :: proc(chunk_p: ^Chunk, constant : Value) -> Uint 
{
	append(&chunk_p.constants,constant)
	return Uint(len(chunk_p.constants)-1)
}








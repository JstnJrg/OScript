package OScriptVM

@(private="file") current_program : ^Program


Program :: struct 
{
	main_functionID	: FunctionID ,
	path            : string,
	chunk           : ^Chunk,
	enclosing       : ^Program
}

create_program :: proc() 
{
	current_program                     = new(Program,compile_default_allocator())

	oscript_assert_mode(current_program != nil)
	assert(current_program != nil, "error, program is nullptr")

	current_program.main_functionID		= create_function_functionBD("main",0,0,get_current_importID())
	current_program.chunk               = get_function_chunk_functionBD(current_program.main_functionID)
}

end_current_program    :: proc() -> (bool,FunctionID) 
{ 
	generate_default_return()
	if has_error() do return false,-1
	return true,current_program.main_functionID
}

set_current_chunk   :: proc(chunk: ^Chunk) { current_program.chunk = chunk}
get_current_chunk   :: proc() -> ^Chunk    { return current_program.chunk }
get_current_address :: proc() -> Int       { return len(get_current_chunk().code)-1 }



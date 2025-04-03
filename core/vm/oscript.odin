package OScriptVM


FILESCOPE_NAME := `___FILE___`
PACKAGE_FILESCOPE_NAME :: `___PACKAGE___`

@(private="file") current_program : ^Program


Program :: struct {
	main_functionID	: FunctionID ,
	path            : string,
	chunk           : ^Chunk,
	enclosing       : ^Program
}

create_program :: proc() {
	current_program                     = new(Program,compile_default_allocator())
	assert(current_program != nil, "error, program is nullptr")
	current_program.main_functionID		= create_function_functionBD("main",0,0,get_current_importID())
	current_program.chunk               = get_function_chunk_functionBD(current_program.main_functionID)
}

end_current_program    :: proc() -> (bool,FunctionID) { 
	generate_default_return()
	if has_error() do return false,-1
	return true,current_program.main_functionID
}

// Nota(jstn): começa um novo pacote, ou seja, uma nova função para o pacote
begin_package :: proc() {
	enclosing        := current_program
	current_program   = new(Program,compile_default_allocator())
	assert(current_program != nil, "error, package is nullptr")
	current_program.enclosing           = enclosing
	current_program.main_functionID		= create_function_functionBD(PACKAGE_FILESCOPE_NAME,0,0,get_current_importID())
	current_program.chunk               = get_function_chunk_functionBD(current_program.main_functionID)
}

end_package   :: proc() -> (bool,FunctionID) {
	generate_package_return()
	sucess := has_error() ? false: true
	pkg_id := sucess      ? current_program.main_functionID:-1 
	current_program = current_program.enclosing
	return sucess,pkg_id
}




set_current_chunk :: proc(chunk: ^Chunk) { current_program.chunk = chunk}
get_current_chunk :: proc() -> ^Chunk    { return current_program.chunk }

get_current_address :: proc() -> Int { return len(get_current_chunk().code)-1 }



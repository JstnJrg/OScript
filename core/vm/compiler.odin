package OScriptVM


@(private="file") current_compiler : ^Compiler
@(private="file") current_oglobal  : ^OscriptGlobal
@(private="file") current_imanager : ^ImportManager


Compiler :: struct {

	global         : ^GlobalScope,
	cscope		   : ^Scope,
	enclosing      : ^Compiler,

	// 
	dependecies    : Dependecies,

	context_depth  : int,

	function_depth : int,
	function_type  : FunctionType,


	loop_data      : ^Loop,
	loop_depth     : int,
	scope_depth    : int,

	is_if          : bool
}


// Nota(jstn): util somente para declarar entidades fora do script
OscriptGlobal   :: struct { global : ^GlobalScope }

ImportManager   :: struct { import_map : map[string]u32 }


Scope   :: struct 
{
	locals     : map[string]Local,
	enclosing  : ^Scope,
	index_start: int,
	local_count: int,
	depth      : int    
}

Dependecies :: struct 
{ 
	imports     : map[u32]Localization,
	enclosing   : ^Dependecies
 }


GlobalScope :: struct { global_vars : map[string]Global }


IdentifierType :: enum u8 {ID,FUNCTION,CLASS,IMPORT}

Local    :: struct {
	index : int,
	kind  : IdentifierType,
	pos   : Localization
}

Global :: struct {
	index   : int,
	kind    : IdentifierType,
	pos     : Localization
}

Loop  :: struct {
	scope_depth : int, //usado para capturar as variaveis locais de todos os escopos
	enclosing   : ^Loop
}

begin_vm_compiler :: proc() { begin_compiler_allocators(); create_compiler(); create_oglobal() }
end_vm_compiler   :: proc() { destroy_compiler();destroy_oglobal(); end_compiler_allocators() }


create_compiler :: proc() {

	current_compiler = new(Compiler,compiler_data_default_allocator())
	current_imanager = new(ImportManager,compiler_data_default_allocator())

	oscript_assert_mode(current_compiler != nil)
	oscript_assert_mode(current_imanager != nil)

	assert( current_compiler != nil, "compiler is nullptr.")
	assert( current_imanager != nil, "ImportManager is nullptr.")

	
	current_compiler.global                  = new(GlobalScope,compiler_data_default_allocator())
	current_compiler.dependecies.imports     = make(map[u32]Localization,compiler_data_default_allocator())
	current_compiler.global.global_vars 	 = make(map[string]Global,compiler_data_default_allocator())

	current_imanager.import_map              = make(map[string]u32,compiler_data_default_allocator())
}

create_oglobal  :: proc() 
{ 

	current_oglobal = new(OscriptGlobal,compiler_data_default_allocator())
	assert( current_oglobal != nil, "OG is nullptr.")

	current_oglobal.global               = new(GlobalScope,          compiler_data_default_allocator())
	current_oglobal.global.global_vars	 = make(map[string]Global,   compiler_data_default_allocator())
}
destroy_oglobal :: proc() { current_oglobal = nil }


og_copy_to_compiler :: proc()
{
	if current_oglobal  == nil do return
	if current_compiler == nil do return

	gscope  := current_oglobal.global
	for name, global in gscope.global_vars do current_compiler.global.global_vars[name] = global
}




destroy_compiler :: proc() { current_compiler = nil }


get_current_compiler :: proc() -> ^Compiler { return current_compiler }


// Nota(jstn): é usado principalmente na importação de modulos
begin_new_compiler   :: proc() {
	      enclosing := current_compiler
	defer current_compiler.enclosing = enclosing

	current_compiler = new(Compiler,compile_default_allocator())
	assert( current_compiler != nil, "compiler is nullptr.")
	
	current_compiler.global                  = new(GlobalScope,          compile_default_allocator())
	current_compiler.global.global_vars	     = make(map[string]Global,   compile_default_allocator())
	current_compiler.dependecies.imports     = make(map[u32]Localization,compile_default_allocator())

	// Nota(jstn): copia os dados globais para o novo compilador
	og_copy_to_compiler()
}

// Nota(jstn): termina o actual compilador, não usar com escopo global main.
end_compiler       :: proc() { current_compiler = current_compiler.enclosing }



// Nota(jstn): dependencias


register_dependencies      :: proc(path: string, loc: Localization ) { current_compiler.dependecies.imports[hash_string(path)] = loc }
get_dependencies           :: proc() -> ^Dependecies                 { return &current_compiler.dependecies }
set_enclosing_dependencies :: proc(e: ^Dependecies )                 { current_compiler.dependecies.enclosing = e }

has_dependencie :: proc(path: string) -> (has: bool, loc : Localization) {

	path_h := hash_string(path)
	cd     := &current_compiler.dependecies
	
	for cd != nil {
		loc, has = cd.imports[path_h]
		cd = cd.enclosing
		if has do break
	}

	return
}

package_was_importated :: proc(path: string ) -> (was : bool, hash : u32) { hash, was = current_imanager.import_map[path]; return }
get_import_map         :: proc() -> ^map[string]u32 { return &current_imanager.import_map }





// ==================================0



begin_context      :: proc() { current_compiler.context_depth += 1 }
end_context        :: proc() { current_compiler.context_depth -= 1 }

get_context        :: proc() -> int { return current_compiler.context_depth }


begin_scope    :: proc() {

	defer current_compiler.scope_depth += 1

	if current_compiler.cscope == nil 
	{
		current_compiler.cscope 		= new(Scope,compile_default_allocator())
		current_compiler.cscope.locals  = make(map[string]Local,compile_default_allocator())
		return
	}


	enclosing                          := current_compiler.cscope
	current_compiler.cscope             = new(Scope,compile_default_allocator())
	current_compiler.cscope.enclosing   = enclosing
	current_compiler.cscope.locals      = make(map[string]Local,compile_default_allocator())
	current_compiler.cscope.index_start = enclosing.local_count+enclosing.index_start
	current_compiler.cscope.depth       = current_compiler.scope_depth
}


end_scope  :: proc() { current_compiler.cscope	= current_compiler.cscope.enclosing; current_compiler.scope_depth -= 1 }

scope_check_redeclaration_var :: proc(var_name : Token) -> (has: bool, ldata: ^Local ) {

	cscope := current_compiler.cscope

	for cscope != nil {
		l, ok := cscope.locals[var_name.text]
		ldata  = &cscope.locals[var_name.text]
		cscope = cscope.enclosing
		if ok  { has = ok ; break }
	}

	return
}

scope_declare_var :: proc(var_name : Token, kind: IdentifierType , loc: Localization) {
	cscope := current_compiler.cscope
	defer cscope.local_count += 1
	
	locals := &cscope.locals
	locals[var_name.text] = Local{cscope.local_count+cscope.index_start, kind ,loc}
}

scope_get_var_index :: proc(var_name : Token, slot : ^int) -> (has: bool, ldata: ^Local) {

	cscope := current_compiler.cscope

	for cscope != nil 
	{
		l, ok := cscope.locals[var_name.text]
		cscope = cscope.enclosing
		if ok  { slot^ = l.index; ldata = &l ; has = true ; return }
	}

	slot^ = -1
	return
}

scope_get_local_count 				:: proc() -> int { return current_compiler.cscope.local_count }
scope_get_local_count_from_depth    :: proc(depth: int ) ->  (sum: int) {

	cscope := current_compiler.cscope
	for cscope != nil {
		if cscope.depth < depth do break
		sum += cscope.local_count
		cscope = cscope.enclosing
	}
	return
}
scope_get_depth       				:: proc() -> int { return current_compiler.cscope.depth }

get_loop_scope_depth  :: proc() -> int { return current_compiler.loop_data.scope_depth }   

scope_print       :: proc(){
	cscope := current_compiler.cscope

	if cscope == nil {
		println("\n ========== GLOABL SCOPE ========== \n")
		return
	}

	println("\n ========== SCOPE DATA ========== \n")
	println("local_count: ",cscope.local_count)
	println("index_start: ",cscope.index_start)
	println("depth      : ",cscope.depth)
	println("________VARS DATA________")

	for name,localdata in cscope.locals {
		println("var name: ",name,"| stack index: ",localdata.index)
	}
}



global_check_redeclaration_var :: proc(var_name : Token) -> (has: bool, gdata: ^Global) {
	
	gscope  := current_compiler.global
	g, ok   := gscope.global_vars[var_name.text]
	gdata    = &gscope.global_vars[var_name.text]

	if ok do has = ok 
	return
}


global_declare_var      :: proc(var_name : Token,loc: Localization) {
	gscope  := current_compiler.global
	gscope.global_vars[var_name.text] = Global{0, .ID , loc}
}

global_declare_function :: proc(function_name : Token, loc: Localization) {
	gscope  := current_compiler.global
	gscope.global_vars[function_name.text] = Global{0, .FUNCTION, loc}
}

global_declare_class :: proc(class_name : Token, loc: Localization) {
	gscope  := current_compiler.global
	gscope.global_vars[class_name.text] = Global{0, .CLASS , loc}
}

global_declare_import :: proc(class_name: Token, loc: Localization) {
	gscope  := current_compiler.global
	gscope.global_vars[class_name.text] = Global{0, .IMPORT, loc}
}

global_register_imported_package :: proc(path_tk : Token) {
	if _ , ok   := current_imanager.import_map[path_tk.text]; ok do return
	import_s, _ := clone_s(path_tk.text,compiler_data_default_allocator())
	current_imanager.import_map[import_s] = hash_string(path_tk.text)
}



oglobal_declare_class :: proc(class_name : string) {
	gscope    := current_oglobal.global
	class_s,_ := clone_s(class_name,compiler_data_default_allocator())
	gscope.global_vars[class_s] = Global{0, .CLASS ,Localization{"",-1,-1,-1}}
}

oglobal_declare_import :: proc(class_name : string) {
	gscope    := current_oglobal.global
	class_s,_ := clone_s(class_name,compiler_data_default_allocator())
	gscope.global_vars[class_s] = Global{0, .IMPORT ,Localization{"",-1,-1,-1}}
}

// global_check_redeclaration_function :: proc(function_name : Token) -> (has: bool, loc : Localization) {
// 	gscope  := current_compiler.global
// 	g,ok    := gscope.global_functions[function_name.text]
// 	if ok { loc = g.pos; has = ok }
// 	return
// }


is_global_scope  :: proc() -> bool { return current_compiler.cscope == nil }
is_loop          :: proc() -> bool { return current_compiler.loop_depth > 0 }

begin_loop :: proc(depth: int)  
{ 
	current_compiler.loop_depth += 1
	enclosing                 := current_compiler.loop_data
	
	current_compiler.loop_data             = new(Loop,compile_default_allocator()) 
	current_compiler.loop_data.scope_depth = depth
	current_compiler.loop_data.enclosing   = enclosing
}

end_loop :: proc() { 
	current_compiler.loop_depth -= 1 
	current_compiler.loop_data   = current_compiler.loop_data.enclosing 
}


kind2string :: proc(kind : IdentifierType) -> string
{
	switch kind 
	{
		case .ID: 		return "variable"
		case .FUNCTION: return "function"
		case .CLASS:	return "class"
		case .IMPORT:   return "import"
		case:           return "bad kind"
	}
}
package OScriptVM

import vmem 	    "core:mem/virtual"
import mem 		    "core:mem"


@(private="file") current_arena : Ast_Arena
@(private="file") current_compiler_data_arena : Compiler_Data_Arena


Ast_Arena   				:: vmem.Arena
Ast_Arena_Temp 				:: vmem.Arena_Temp
Default_Ast_Arena_Size		:: 2*mem.Megabyte

init_ast_arena             :: proc() { e := vmem.arena_init_growing(&current_arena,Default_Ast_Arena_Size); assert( e == .None,"Ast Arena is nullptr") }

ast_arena_arena_free_all   :: proc() { vmem.arena_free_all(&current_arena) }
ast_arena_destroy		   :: proc() { vmem.arena_destroy(&current_arena)  }

ast_arena_get_allocator	   :: proc() -> mem.Allocator { return vmem.arena_allocator(&current_arena) }
compile_default_allocator  :: proc() -> mem.Allocator { return vmem.arena_allocator(&current_arena) }

ast_arena_temp_begin       :: proc() -> Ast_Arena_Temp { return vmem.arena_temp_begin(&current_arena) }
ast_arena_temp_end         :: proc(t: Ast_Arena_Temp)  { vmem.arena_temp_end(t) }


//  Compiler Data

Compiler_Data_Arena   				:: vmem.Arena
Compiler_Data_Arena_Temp 			:: vmem.Arena_Temp
Default_Compiler_Data_Arena_Size	:: 0.5*mem.Megabyte

init_compiler_data_arena   :: proc() { e := vmem.arena_init_growing(&current_compiler_data_arena,Default_Compiler_Data_Arena_Size); assert( e == .None,"Compiler Data Arena is nullptr") }

compiler_data_arena_free_all   :: proc() { vmem.arena_free_all(&current_compiler_data_arena) }
compiler_data_arena_destroy	   :: proc() { vmem.arena_destroy(&current_compiler_data_arena)  }

compiler_data_arena_get_allocator	   :: proc() -> mem.Allocator { return vmem.arena_allocator(&current_compiler_data_arena) }
compiler_data_default_allocator  	   :: proc() -> mem.Allocator { return vmem.arena_allocator(&current_compiler_data_arena) }

compiler_data_arena_temp_begin       :: proc() -> Compiler_Data_Arena_Temp { return vmem.arena_temp_begin(&current_compiler_data_arena) }
compiler_data_arena_temp_end         :: proc(t: Compiler_Data_Arena_Temp)  { vmem.arena_temp_end(t) }


begin_compiler_allocators  :: proc()  { 
	init_ast_arena()
	init_compiler_data_arena() 
}
end_compiler_allocators    :: proc()  { 
	ast_arena_arena_free_all()
	compiler_data_arena_free_all()
	ast_arena_destroy()
	compiler_data_arena_destroy() 
}





// Nota(jstn): essa  arena permanece durante todo programa, então, ela só cresce classes serão guardadas aqui

@(private="file") current_runtime_arena : Runtime_Arena

Runtime_Arena   			:: vmem.Arena
Runtime_Arena_Temp 			:: vmem.Arena_Temp
Default_Runtime_Arena_Size	:: 3*mem.Megabyte

init_runtime_allocator      :: proc() { e := vmem.arena_init_growing(&current_runtime_arena,Default_Runtime_Arena_Size); assert( e == .None,"Runtime Arena is nullptr") }

runtime_arena_free_all      :: proc() { vmem.arena_free_all(&current_runtime_arena) }
runtime_arena_destroy		:: proc() { vmem.arena_destroy(&current_runtime_arena)  }

runtime_arena_get_allocator    :: proc() -> mem.Allocator { return vmem.arena_allocator(&current_runtime_arena) }
runtime_default_allocator      :: proc() -> mem.Allocator { return vmem.arena_allocator(&current_runtime_arena) }

runtime_arena_temp_begin       :: proc() -> Runtime_Arena_Temp { return vmem.arena_temp_begin(&current_runtime_arena) }
runtime_arena_temp_end         :: proc(t: Runtime_Arena_Temp)  { vmem.arena_temp_end(t) }

init_runtime_arena :: proc() { init_runtime_allocator() }
end_runtime_arena  :: proc() { runtime_arena_free_all(); runtime_arena_destroy()}


// // Nota(jstn): coisas que precisam ser inicializadas, que são importantes
runtime_init :: proc() {
	init_runtime_arena()
	initBD(runtime_default_allocator())
}


runtime_end :: proc() { end_runtime_arena() }



// Nota(jstn): assert's, mas sem vazamentos
oscript_assert_mode :: proc(_true: bool) { 
	if _true do return
	end_compiler_allocators()
	runtime_end() 
}

package OScriptMain

import fmt       "core:fmt"
import mem       "core:mem"
// import tokenizer "oscript:tokenizer"
import os        "core:os"
import vm        "oscript:vm"



// Nota(jstn): helpers
println      :: fmt.println
printfln     :: fmt.printfln



// Nota(jstn): VM

main_name       :: "main"
Value           :: vm.Value
InterpretResult :: vm.InterpretResult

vm_init      :: vm.init_vm
vm_setup     :: vm.setup
vm_interpret :: vm.interpret
vm_destroy   :: vm.destroy_vm

vm_begin_compiler :: vm.begin_vm_compiler
vm_compile        :: vm.compile
vm_end_compiler   :: vm.end_vm_compiler

vm_get_global     :: vm.oscript_get_global
vm_is_function    :: vm.is_oscript_function
vm_call_function  :: vm.call_oscript_function



main :: proc()
{

	when ODIN_DEBUG
	{
		track : mem.Tracking_Allocator
		mem.tracking_allocator_init(&track,context.allocator) 
		context.allocator = mem.tracking_allocator(&track)
		
		defer
		{
			println("\n\n======================================================")

			len_0 := len(track.allocation_map)
			len_1 := len(track.bad_free_array)


			if len_0 > 0
			{
				printfln("allocation not freed: %v\n",len_0)
				for _,entry in track.allocation_map do fmt.printfln("bytes: %v\nplace: %v\n",entry.size,entry.location)
			} 

			if len_1 > 0
			{
				printfln("\nincorrect frees: %v",len_1)
				for entry in track.bad_free_array do fmt.printfln("memory: %p\nlocation:%v",entry.memory,entry.location)
			}

			mem.tracking_allocator_destroy(&track)
		}
	}

	args := os.args
	len  := len(args)

	if len != 2 { println("Oscript expets script path."); return }

	path := args[1]
	Oscript_run(path)
}

// tokens :: proc()
// {

// 	path :: "code2.os"
// 	src  :: #load(path,string)

// 	t := tokenizer.create(context.temp_allocator)
// 	defer free_all(context.temp_allocator)
// 	tokenizer.init(t,src,path)


// 	for 
// 	{
// 		t := tokenizer.scan(t)
// 		println(t)
// 		if t.type == .EOF || t.type == .Error do break
// 	}
// }



Oscript_run :: #force_inline proc(path: string)
{
	vm_interpret_error :: proc( r: InterpretResult ) -> bool { return r == .INTERPRET_OK ? false:true }

	main_fn   : Value
	error     : bool

	      vm_init() 
	defer vm_destroy()

	vm_begin_compiler()
	
	sucess,file_scope_fn_id := vm_compile(path)
	vm_end_compiler()

	if !sucess do return
	vm_setup(file_scope_fn_id)

	if vm_interpret_error(vm_interpret()) do return
	vm_get_global(main_name,&main_fn)

	if !vm_is_function(&main_fn)          do return
		
	vm_call_function(&main_fn,0,0,&error)
	if error || vm_interpret_error(vm_interpret()) do return
}





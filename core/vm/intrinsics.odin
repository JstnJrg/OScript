package OScriptVM

@private current_vm             : ^VM = nil
@private current_global_context : ^GlobalContext = nil


OscriptMode   :: enum u8
{
	COMPILE,
	DISASSEMBLE,

}


GlobalContext :: struct  {
	construct_mode : OscriptMode
	
}



create_vm  :: proc() 
{ 
	current_vm                = new(VM,runtime_default_allocator())
	assert(current_vm != nil, "cannot create VM.")

	current_vm.gray_stack     = make([dynamic]^Object,runtime_default_allocator())
	current_vm.globals        = make(Table,           runtime_default_allocator())
	current_vm.inter_strings  = make(TableString,     runtime_default_allocator())
	current_vm.inter_hash     = make(TableHash,       runtime_default_allocator())

	// Nota(jstn): default state

	// 
	vm_call_state              := &current_vm.call_state 
	vm_call_state.get_allocator = runtime_default_allocator
	vm_call_state.init_temp     = runtime_arena_temp_begin
	vm_call_state.end_temp      = runtime_arena_temp_end

}

init_gc_config :: proc() 
{
	variant.init_alloc()

	variant.bytes_allocated  = &current_vm.bytes_allocated

	current_vm.next_gc       = (2*Megabyte)/size_of(Object)
	current_vm.min_heap_size = (2*Megabyte)/size_of(Object)

	variant.list             = &current_vm.objects
	variant.free_list_ptr    = &free_list
}


change_list_head :: proc(new_list : ^^Object) { variant.list = new_list }


get_vm	       :: #force_inline proc "contextless" () -> ^VM              { return current_vm }
get_obj_error  :: #force_inline proc "contextless" () -> ^ObjectCallError { return &current_vm.call_state.error_bf }
get_error_msg  :: #force_inline proc "contextless" () -> string           { return current_vm.call_state.error_bf.msg_str }

vm_get_internal_strings ::  proc "contextless" () -> ^TableString { return &current_vm.inter_strings }



allow_gc_trigger :: proc "contextless" () { current_vm.gc_trigger = true }

free_objects     :: proc() 
{ 
	list := current_vm.objects
	for list != nil { aux := list; list = aux.next; free_object(aux) }
}



destroy_vm :: proc() 
{ 
	destroy_free_list()
	free_objects()
	runtime_end()
	current_vm = nil 
}

#+private

package OScriptVM

import constants  "oscript:constants"
import thread     "core:thread"



DEBUG_STRESS_GC							:: constants.DEBUG_STRESS_GC	
DEBUG_GC 										:: constants.DEBUG_GC
GC_HEAP_GROW_FACTOR					:: constants.GC_HEAP_GROW_FACTOR


// Nota(jstn): lista de objectos livres
@private free_list  : [ObjectType]FreeList
@private gc_thread  : ^thread.Thread

// Nota(jstn): determina a quantidade de objectos que podem ser armazenados na lista livre
// por tipo
@(private="file",rodata) free_list_maxobj := [ObjectType]int{

	.OBJ_NONE       = 0,

	//buffer 
	.OBJ_ANY        = 1 << 4,

	// heap
	.OBJ_STRING     = 1 << 7,
	.OBJ_ARRAY      = 1 << 7,
	.OBJ_PROGRAM    = 0, 
	.OBJ_FUNCTION   = 0, 
	.OBJ_NATIVE_FUNCTION  = 0, 
	.OBJ_CLASS            = 0, 
	.OBJ_CLASS_INSTANCE   = 1 << 7, 
	.OBJ_PACKAGE          = 0,
	
	// OBJ_BOUND_METHOD,
	.OBJ_NATIVE_CLASS     = 0, //não pode ser instanciada
	.OBJ_ERROR            = 0, //funções
	.OBJ_MAX              = 0,
}


init_gc_thread  :: proc() { gc_thread = thread.create(sweep_t) }
end_gc_thread   :: proc() { thread.destroy(gc_thread); gc_thread = nil}
wait_gc_thread  :: proc() 
{ 
	if thread.is_done(gc_thread) do return
	thread.join(gc_thread)

}

set_in_free_list :: proc "contextless" (obj: ^Object ) -> bool {

	fl := &free_list[obj.type]
	
	if fl.count < free_list_maxobj[obj.type]
	{
		obj.next = fl.obj
		fl.obj   = obj
		fl.count += 1
		return true
	}

	return false
}


get_gray_stack_len :: #force_inline proc "contextless" () 
{ 
	current_vm.gray_stack_Len    = len(current_vm.gray_stack)-1 
	current_vm.gray_stack_count  = 0
}



collect_garbage :: proc()
{


	vm := current_vm
	get_gray_stack_len()

	when DEBUG_GC 
	{
		println("===========================================")
		println("--GC BEGIN")
		println("===========================================")
		before := vm.bytes_allocated 
	}

	// Nota(jstn): reseta-o, isso permite que a quantidade de entidades
	// alocadas não seja muito grande e sua diferença seja pequena.
	vm.bytes_allocated = 0

	#force_inline mark_roots()
	#force_inline trace_references()
	#force_inline table_remove_white()
	#force_inline sweep()
	

	vm.next_gc = vm.bytes_allocated+vm.bytes_allocated*GC_HEAP_GROW_FACTOR
	if vm.next_gc < vm.min_heap_size do vm.next_gc = vm.min_heap_size

	when DEBUG_GC 
	{ 
		println("===========================================")
		println("--GC END\ncolleted -> ",before, "\nfrom     -> ",before,"\nnext at  -> ",vm.next_gc)
		println("===========================================\n")
	}
}

mark_roots  :: proc()
{
	vm := #force_inline get_vm()
	
	// for i in 0..<vm.program_count do #force_inline mark_value(&vm.programs[i])
	for i in 0..<vm.tos           do #force_inline mark_value(&vm.stack[i])
	for i in 0..<vm.frame_count   do #force_inline mark_function_ID_BD(vm.frames[i].function.info.id) //mark_table(vm.frames[i].globals)
	
	mark_table(&vm.globals)
	// mark_table(&vm.intrinsics)
}

mark_value  :: proc(value_p: ^Value)   
{ 
	if      IS_CLASS_BD_ID_PTR(value_p) do mark_class_BD(value_p)
	else if IS_FUNCTION_BD_PTR(value_p) do mark_function_BD(value_p)
	else if IS_IMPORT_BD_PTR(value_p)   do mark_import_ID_BD(value_p)
	else if IS_OBJECT_PTR(value_p)      do mark_object(AS_OBJECT_PTR(value_p)) 
}


mark_class_BD   :: proc(value_p: ^Value) {

		when DEBUG_GC do println("--gc is marking CLASS")    
    class_id := AS_CLASS_BD_ID_PTR(value_p)
		public   := get_class_table_classBD(class_id)
		private  := get_class_private_table_classBD(class_id)
		
		mark_table(public)
		mark_table(private)
}


mark_function_BD :: proc(value_p: ^Value) {

	when DEBUG_GC do println("--gc is marking FUNCTION (VALUE)")
	id    := AS_FUNCTION_BD_ID_PTR(value_p)
	chunk := get_function_chunk_functionBD(id)
	mark_array(chunk.constants[:])
}


mark_function_ID_BD :: proc (id : FunctionID) {
	when DEBUG_GC do println("--gc is marking FUNCTION (ID)")
	chunk := get_function_chunk_functionBD(id)
	mark_array(chunk.constants[:])
}


mark_import_ID_BD :: proc (value_p: ^Value) { 
	when DEBUG_GC do println("--gc is marking IMPORT")
	mark_table(get_import_context_importID(AS_IMPORT_BD_ID_PTR(value_p)))
}


mark_table  :: proc(table : ^Table) { for _,&value in table do mark_value(&value) }

mark_array  :: proc(constants_arr : []Value) { for &v in constants_arr do mark_value(&v) }

mark_object :: proc(obj : ^Object)
{
	if obj == nil || obj.is_marked do return

	when DEBUG_GC do println("--gc is marking ",OBJ_TYPE(obj))
	obj.is_marked = true

	if current_vm.gray_stack_Len >= 0 { current_vm.gray_stack[current_vm.gray_stack_count] = obj ; current_vm.gray_stack_count += 1; current_vm.gray_stack_Len -= 1 }
	else { append(&current_vm.gray_stack,obj); current_vm.gray_stack_count += 1 } 
}




trace_references :: proc()
{
	gray_stack := &current_vm.gray_stack
	current_vm.gray_stack_count -= 1

	for current_vm.gray_stack_count >= 0
	{
		obj := gray_stack[current_vm.gray_stack_count]
		blacken_object(obj)
		current_vm.gray_stack_count -= 1
	}

}

table_remove_white :: proc() { inter_strings := get_vm().inter_strings; for  k,s in inter_strings do if !s.is_marked do delete_key(&inter_strings,k) }

blacken_object :: proc(obj: ^Object)
{
	when DEBUG_GC do println("--gc blacken ",OBJ_TYPE(obj))


	#partial switch obj.type
	{

		// não possuem dependencias
		case .OBJ_STRING         :
		case .OBJ_CLASS          :
		case .OBJ_NATIVE_CLASS   :
		case .OBJ_PROGRAM        :
		case .OBJ_FUNCTION       :
		case .OBJ_NATIVE_FUNCTION:

		case .OBJ_ARRAY:
			array := OBJ_AS_ARRAY_OBJ(obj)
			mark_array(array.data[:])

		case .OBJ_CLASS_INSTANCE:
			klass_instance := OBJ_AS_CLASS_INSTANCE(obj)
			mark_table(&klass_instance.fields)

	}
}

sweep :: proc() 
{

  vm    := current_vm
	list  := vm.objects

	if list == nil do return

	aux       := list
	previous  :  ^Object

	for aux != nil 
	{
		if aux.is_marked 
		{
			aux.is_marked   = false
			previous 		    = aux
			aux     		    = aux.next
		}
		else 
		{
			u    := aux
			aux	  = aux.next
			
			if      previous == nil do vm.objects = aux
			else do previous.next = aux
			
			sucess := set_in_free_list(u)

			when DEBUG_GC 
			{ 
				if !sucess do  println("deleting.......",OBJ_TYPE(u)) 
				else       do  println("recycling.....",OBJ_TYPE(u))
			}			
			
			if !sucess do #force_inline free_object(u)

		}
	}
}

sweep_t :: proc(t: ^thread.Thread) 
{

	temp_list : ^Object

  vm    := current_vm
	list  := vm.objects


	// vm.objects = temp_list
	// println(8888)


	if list == nil do return

	aux       := list
	previous  :  ^Object

	for aux != nil 
	{
		if aux.is_marked 
		{
			aux.is_marked   = false
			previous 		    = aux
			aux     		    = aux.next
		}
		else 
		{
			u    := aux
			aux	  = aux.next
			
			if      previous == nil do vm.objects = aux
			else do previous.next = aux
			
			sucess := set_in_free_list(u)

			when DEBUG_GC 
			{ 
				if !sucess do  println("deleting.......",OBJ_TYPE(u)) 
				else       do  println("recycling.....",OBJ_TYPE(u))
			}
			else do if !sucess do #force_inline free_object(u)

			

		}
	}
}




destroy_free_list :: proc() 
{

	for &fl in free_list
	{
		aux := fl.obj
		for aux != nil 
		{ 
			temp := aux.next 
			free_object(aux) 
			aux = temp
		}

	}
}
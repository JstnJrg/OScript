package OScriptVM


// Nota(jstn): para obejectos function, para funçoes com ID
call_function_obj ::  #force_inline proc(func : ^Value, #any_int argc, default_arity: Int, has_error: ^bool)  {
	funcID        := AS_FUNCTION_BD_ID_PTR(func)
	has_error^     = obj_function_call_type(funcID,argc,default_arity)
}



obj_function_call_type :: #force_inline proc(funcID: FunctionID, #any_int argc,default_arity: Int) -> bool
{

	function := get_function_functionBD(funcID)
	finfo    := &function.info


	if argc != finfo.arity				         { runtime_error("'",get_function_name_functionBD(funcID),"' expected '",finfo.arity,"' but got '",argc,"'."); return true }
	if current_vm.frame_count >= MAX_FRAMES-1    { trace_stack("\nSTACK OVERFLOW");return true }

	frame_p 			:= &current_vm.frames[current_vm.frame_count]
	pframe_p            := &current_vm.frames[current_vm.frame_count-1]

	frame_p.function     = function
	frame_p.ip           = &function.chunk.code[0]
	frame_p.globals      = pframe_p.globals
	frame_p.context_ID   = finfo.import_id

	// frame_p.slots = current_vm.stack[current_vm.tos-argc-finfo.default_arity:]
	frame_p.slots = current_vm.stack[current_vm.tos-argc-default_arity:]
	
	change_context(pframe_p,frame_p)
	next_frame()

	return false
}



// Nota(jstn): é usado para chamar a função main, ou a função script
call_functionID:: #force_inline proc(funcID: FunctionID, #any_int argc: Int, function_script := false) -> bool
{

	function := get_function_functionBD(funcID)
	finfo    := &function.info

	if argc != finfo.arity				         { runtime_error("'",get_function_name_functionBD(funcID),"' expected '",finfo.arity,"' but got '",argc,"'."); return false }
	if current_vm.frame_count >= MAX_FRAMES-1    { trace_stack("\nSTACK OVERFLOW");return false }

	frame_p 			:= &current_vm.frames[current_vm.frame_count]
	frame_p.function     = function
	frame_p.ip           = &function.chunk.code[0]
	frame_p.context_ID   = finfo.import_id

	if      !function_script do frame_p.slots = current_vm.stack[current_vm.tos-argc-1:]
	else do frame_p.slots = current_vm.stack[:]

	next_frame()
	return true
}


// Nota(jstn): para obejectos function, para funçoes com ID
call_native_function ::  #force_inline proc(func : ^Value, #any_int argc,default_arity: Int, has_error: ^bool) 
{
	native_function := AS_OP_FUNC_PTR(func)
	args			:= current_vm.stack[current_vm.tos-argc-default_arity:][:argc+default_arity]
	pop_offset(argc+default_arity)


	result  := peek_cptr()
	#force_inline native_function(argc,args,result,&current_vm.error)
				
	if current_vm.error.error { 
		runtime_error(current_vm.error.msg_str)
		has_error^ = true
	}
	
	if current_vm.error.warning {
		runtime_error(current_vm.error.msg_str)
				// OBJ_CALL_RESET(&current_vm.error)
	}

	push_empty()
	
	// //Nota(jstn): como possuem metodos nativos que podem alocar memoria entao, aciona o GC
	// #force_inline trigger_gc()
}







// Nota(jstn): para o uso extreno da VM
oscript_call_function ::  #force_inline proc(func : ^Value, #any_int argc, default_arity: Int, has_error: ^bool)  {
	funcID        := AS_FUNCTION_BD_ID_PTR(func)
	has_error^     = obj_function_foreing_call_type(funcID,argc,default_arity)
}


// Nota(jstn): normalmente é uma função global, portanto não precisamos setar a tabela que o frame vai apontar
// pois a função vai corresponder ao frame 0, que aponta para tabela do filescope
obj_function_foreing_call_type :: #force_inline proc(funcID: FunctionID, #any_int argc,default_arity: Int) -> bool
{
	function := get_function_functionBD(funcID)
	finfo    := &function.info

	if argc != finfo.arity				         { runtime_error_no_ctx("'",get_function_name_functionBD(funcID),"' expected '",argc,"' but got '",finfo.arity,"'."); return true }
	// Nota(jstn): como somente é método chamado depois de cada execução, então,
	// não precisamos se preocupar com o MAX_FRAME 

	frame_p 			:= &current_vm.frames[current_vm.frame_count]
	frame_p.function     = function
	frame_p.ip           = &function.chunk.code[0]
	// frame_p.globals      = pframe_p.globals
	frame_p.context_ID   = finfo.import_id

	// frame_p.slots = current_vm.stack[current_vm.tos-argc-finfo.default_arity:]
	frame_p.slots = current_vm.stack[current_vm.tos-argc-default_arity:]
	next_frame()

	return false
}
#+private

package OscriptFile

// import fmt "core:fmt"

error_msg :: proc(fn_name: string, expected: Int, be: string ,call_state: ^CallState) {
	CALL_ERROR_STRING(&call_state.error_bf,"'",fn_name,"' function expects '",expected,"' args, but got ",call_state.argc,", and the argument must be ",be,".")
	call_state.has_error = true
}

error_msg0 :: proc(fn_name: string, expected : Int ,call_state: ^CallState) { 
	CALL_ERROR_STRING(&call_state.error_bf,"'",fn_name,"' function expects '",expected,"' args, but got ",call_state.argc,".") 
	call_state.has_error = true
}

error      :: proc(msg: string ,call_state: ^CallState) { CALL_ERROR_STRING(&call_state.error_bf,msg); call_state.has_error = true    }
warning    :: proc(msg: string ,call_state: ^CallState) { CALL_WARNING_STRING(&call_state.error_bf,msg); call_state.has_warning = true }



open :: proc(call_state: ^CallState) 
{
	mode : Int
	if call_state.argc != 2 || !IS_VAL_STRING_PTR(&call_state.args[0]) || !IS_INT_PTR(&call_state.args[1],&mode) { error_msg("open",2,"String and int",call_state); return }

    path_name := VAL_STRING_DATA_PTR(&call_state.args[0])
    if !_is_valid_mode(mode) { warning("invalid mode.",call_state); NIL_VAL_PTR(call_state.result); return }

    f, err  := os2.open(path_name,_get_file_mode(mode))
    if  err != nil { warning(os2.error_string(err),call_state); NIL_VAL_PTR(call_state.result); return }

    _any    := create_any_ptr(.OBJ_PACKAGE,i16(_get_import_id()))
    state   := FileState(File){true,f}

    _copy_data(&_any.mem,&state)
    ANY_VAL_PTR(call_state.result,_any)
}

exists :: proc(call_state: ^CallState) 
{
	if call_state.argc != 1 || !IS_VAL_STRING_PTR(&call_state.args[0]) { error_msg("file_exists",1,"String",call_state); return }
    path_name := VAL_STRING_DATA_PTR(&call_state.args[0])
	BOOL_VAL_PTR(call_state.result,os2.exists(path_name))
}

get_absolute_path :: proc(call_state: ^CallState) 
{
	
	if call_state.argc != 1 || !IS_VAL_STRING_PTR(&call_state.args[0]) { error_msg("get_absolute_path",1,"String",call_state); return }
    path_name := VAL_STRING_DATA_PTR(&call_state.args[0])

    r 	      := CREATE_OBJ_STRING_NO_DATA()
    path      := VAL_STRING_DATA_PTR(&call_state.args[0])

	temp_arena  := call_state.init_temp()
	allocator   := call_state.get_allocator()

	s,e         := os2.get_absolute_path(path,allocator)
	defer call_state.end_temp(temp_arena)

	if e != nil do warning(os2.error_string(e),call_state)

    OBJ_STRING_WRITE_DATA_STRING(r,s)
    OBJECT_VAL_PTR(call_state.result,r,.OBJ_STRING)
}

get_relative_path :: proc(call_state: ^CallState) 
{
	if call_state.argc != 2 || !IS_VAL_STRING_PTR(&call_state.args[0]) || !IS_VAL_STRING_PTR(&call_state.args[1]) { error_msg("get_relative_path",2,"String and String",call_state); return }
    path_name := VAL_STRING_DATA_PTR(&call_state.args[0])

	from      := VAL_STRING_DATA_PTR(&call_state.args[0])
	to        := VAL_STRING_DATA_PTR(&call_state.args[1])
    r 	      := CREATE_OBJ_STRING_NO_DATA()

	temp_arena  := call_state.init_temp()
	allocator   := call_state.get_allocator()

	s,e         := os2.get_relative_path(from,to,allocator)
	defer call_state.end_temp(temp_arena)

	if e != nil do warning(os2.error_string(e),call_state)

    OBJ_STRING_WRITE_DATA_STRING(r,s)
    OBJECT_VAL_PTR(call_state.result,r,.OBJ_STRING)
}

// get_relative_path :: proc(call_state: ^CallState) 
// {
// 	if call_state.argc != 2 || !IS_VAL_STRING_PTR(&call_state.args[0]) || !IS_VAL_STRING_PTR(&call_state.args[1]) { error_msg("get_relative_path",2,"String and String",call_state); return }
//     path_name := VAL_STRING_DATA_PTR(&call_state.args[0])

// 	from      := VAL_STRING_DATA_PTR(&call_state.args[0])
// 	to        := VAL_STRING_DATA_PTR(&call_state.args[1])
//     r 	      := CREATE_OBJ_STRING_NO_DATA()

// 	temp_arena  := call_state.init_temp()
// 	allocator   := call_state.get_allocator()

// 	s,e         := os2.get_relative_path(from,to,allocator)
// 	defer call_state.end_temp(temp_arena)

// 	if e != nil do warning(os2.error_string(e),call_state)

//     OBJ_STRING_WRITE_DATA_STRING(r,s)
//     OBJECT_VAL_PTR(call_state.result,r,.OBJ_STRING)
// }


// is_dir :: proc(call_state: ^CallState) {
	
// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 1 || !IS_VAL_STRING_PTR(&args[1])	{ 
// 	 CALL_ERROR_STRING(call_state,"'is_dir' function expects '1' arg, but got ",", and the argument must be a string.");
// 	 return
//     }

//     path_name := VAL_STRING_DATA_PTR(&args[1])
// 	BOOL_VAL_PTR(call_state.result,os2.is_dir(path_name))
// }

// is_file :: proc(call_state: ^CallState) {
	
// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 1 || !IS_VAL_STRING_PTR(&args[1])	{ 
// 	 CALL_ERROR_STRING(call_state,"'is_file' function expects '1' arg, but got ",", and the argument must be a string.");
// 	 return
//     }

//     path_name := VAL_STRING_DATA_PTR(&args[1])
// 	BOOL_VAL_PTR(call_state.result,os2.is_file(path_name))
// }



// Nota(jstn): cria um link físico (dois nomes para o mesmo arquivo)
link :: proc(call_state: ^CallState) 
{
	if call_state.argc != 2 || !IS_VAL_STRING_PTR(&call_state.args[0]) || !IS_VAL_STRING_PTR(&call_state.args[1]) { error_msg("alias_file",2,"String and String",call_state) ; return }

	old_path   := VAL_STRING_DATA_PTR(&call_state.args[0])
	new_path   := VAL_STRING_DATA_PTR(&call_state.args[1])

    if e := os2.link(old_path,new_path); e != nil do warning(os2.error_string(e),call_state)
    NIL_VAL_PTR(call_state.result)
}

symlink :: proc(call_state: ^CallState) 
{
	if call_state.argc != 2 || !IS_VAL_STRING_PTR(&call_state.args[0]) || !IS_VAL_STRING_PTR(&call_state.args[1]) { error_msg("file_shortcut",2,"String and String",call_state) ; return }

	old_path   := VAL_STRING_DATA_PTR(&call_state.args[0])
	new_path   := VAL_STRING_DATA_PTR(&call_state.args[1])

    if e := os2.symlink(old_path,new_path); e != nil do warning(os2.error_string(e),call_state)
    NIL_VAL_PTR(call_state.result)
}

name :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0      { error_msg0("name",0,call_state); return }
    if len(call_state.args) != 1 { error("cannot call 'name' on the package directly. Make an instance instead.",call_state); return }

	_any       := AS_ANY_PTR(&call_state.args[0])
	file_state := _get_data(&_any.mem,FileState(File))

	file       := file_state.file
    r 	       := CREATE_OBJ_STRING_NO_DATA()
 
	if !file_state.is_open { warning("condition File != null is false.",call_state); OBJECT_VAL_PTR(call_state.result,r,.OBJ_STRING); return }

    OBJ_STRING_WRITE_DATA_STRING(r,os2.name(file))
	OBJECT_VAL_PTR(call_state.result,r,.OBJ_STRING)
}


write :: proc(call_state: ^CallState) 
{
	if call_state.argc != 1 || !IS_VAL_STRING_PTR(&call_state.args[0]) { error_msg("write",1,TYPE_TO_STRING(.OBJ_STRING),call_state); return }

	if len(call_state.args) != 2 {
		error("cannot call 'write' on the package directly. Make an instance instead.",call_state)
		return
	}

	_any       := AS_ANY_PTR(&call_state.args[1])
	file_state := _get_data(&_any.mem,FileState(File))
	if !file_state.is_open { warning("condition File != null is false.",call_state); INT_VAL_PTR(call_state.result,-1); return }

    data   := transmute([]byte)(VAL_STRING_DATA_PTR(&call_state.args[0]))
    file   := file_state.file
    
    n,e := #force_inline os2.write(file,data)

    if 	e != nil do warning(os2.error_string(e),call_state)
    INT_VAL_PTR(call_state.result,n)
}


write_at :: proc(call_state: ^CallState) 
{
	offset : Int

	if call_state.argc != 2 || !IS_VAL_STRING_PTR(&call_state.args[0]) || !IS_INT_PTR(&call_state.args[1],&offset) { error_msg("write_at",2,"String and int",call_state); return }
	if len(call_state.args) != 3 { error("cannot call 'write_at' on the package directly. Make an instance instead.",call_state); return }

	_any       := AS_ANY_PTR(&call_state.args[2])
	file_state := _get_data(&_any.mem,FileState(File))

	if !file_state.is_open { warning("condition File != null is false.",call_state); INT_VAL_PTR(call_state.result,-1); return }

    data   := transmute([]byte)(VAL_STRING_DATA_PTR(&call_state.args[0]))
    file   := file_state.file

    n,e := #force_inline os2.write_at(file,data,i64(offset))

    if 	e != nil do warning(os2.error_string(e),call_state)
    INT_VAL_PTR(call_state.result,n)
}

read :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0      { error_msg0("read",0,call_state); return }
    if len(call_state.args) != 1 { error("cannot call 'read' on the package directly. Make an instance instead.",call_state); return }

	_any       := AS_ANY_PTR(&call_state.args[0])
	file_state := _get_data(&_any.mem,FileState(File))
	file       := file_state.file

    r 	       := CREATE_OBJ_STRING_NO_DATA()
    data       := &r.data.buf

	if !file_state.is_open { warning("condition File != null is false.",call_state); OBJECT_VAL_PTR(call_state.result,r,.OBJ_STRING); return }

    file_size,err     := os2.file_size(file)
    if 	err != nil    { warning(os2.error_string(err),call_state); OBJECT_VAL_PTR(call_state.result,r,.OBJ_STRING); return }

    resize(data,file_size)
    _,e := #force_inline os2.read(file,r.data.buf[:])

    if 	e != nil  do warning(os2.error_string(e),call_state)
    OBJECT_VAL_PTR(call_state.result,r,.OBJ_STRING)
}

read_at :: proc(call_state: ^CallState) 
{
	offset : Int
	if call_state.argc != 1 || !IS_INT_PTR(&call_state.args[0],&offset) { error_msg("read_at",1,TYPE_TO_STRING(.INT_VAL),call_state); return }

    if len(call_state.args) != 2 { error("cannot call 'read_at' on the package directly. Make an instance instead.",call_state); return }

	_any       := AS_ANY_PTR(&call_state.args[1])
	file_state := _get_data(&_any.mem,FileState(File))
	file       := file_state.file

    r 	       := CREATE_OBJ_STRING_NO_DATA()
    data       := &r.data.buf

	if !file_state.is_open { warning("condition File != null is false.",call_state); OBJECT_VAL_PTR(call_state.result,r,.OBJ_STRING); return }

    file_size,err := os2.file_size(file)
    if 	err != nil    { warning(os2.error_string(err),call_state); OBJECT_VAL_PTR(call_state.result,r,.OBJ_STRING) ;return }

    resize(data,file_size-i64(offset*size_of(byte)))
    _,e := #force_inline os2.read_at(file,r.data.buf[:],i64(offset))

    if 	e != nil do warning(os2.error_string(e),call_state)
    OBJECT_VAL_PTR(call_state.result,r,.OBJ_STRING)
}

// seek :: proc(call_state: ^CallState) 
// {
// 	mode_flags: [2]Int
// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if argc != 2 || !IS_INT_PTR(&args[1],&mode_flags[0]) || !IS_INT_PTR(&args[2],&mode_flags[1]) { 
// 	 CALL_ERROR_STRING(call_state,"'seek' function expects '2' arg, but got "," and the arguments must be 'int's.");
// 	 return
//     }

// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if mode_flags[0] < 0 { 
// 	 warning("invalid offset.")
// 	 INT_VAL_PTR(call_state.result,-1)
// 	 return
//     }

// 	when OSCRIPT_ALLOW_RUNTIME_CHECK do if mode_flags[1] < 0{ 
// 	 warning("invalid whence.")
// 	 INT_VAL_PTR(call_state.result,-1)
// 	 return
//     }

//     native := VAL_AS_OBJ_NATIVE_CLASS_PTR(&args[0])
//     id     := _get_file_id(native)
//     file   := _get_file(id)

//     offset := i64(mode_flags[0])
//     whence : Seek_From

//     if !_get_whence(mode_flags[1],&whence) { warning("invalid whence",".");INT_VAL_PTR(call_state.result,-1); return }

//     n,e := #force_inline os2.seek(file,offset,whence)
//     if 	e != nil    { warning(os2.error_string(e),".");INT_VAL_PTR(call_state.result,-1); return }

//     INT_VAL_PTR(call_state.result,Int(n))
// }



// file_size :: proc(call_state: ^CallState) 
// {
// 	if argc != 0 { error_msg0("flush",0,call_state); return }

// 	if len(args) != 1 {error("cannot call 'flush' on the package directly. Make an instance instead.",call_state)
// 		return
// 	}

// 	_any       := AS_ANY_PTR(&args[0])
// 	file_state := _get_data(&_any.mem,FileState(File))

// 	if !file_state.is_open { warning("condition File != null is false.",call_state); NIL_VAL_PTR(call_state.result); return }

// 	defer file_state.file    = nil
// 	defer file_state.is_open = false

//     if e := os2.flush(file_state.file); e != nil { warning(os2.error_string(e),call_state); NIL_VAL_PTR(call_state.result); return }
   
// }

flush :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0 { error_msg0("flush",0,call_state); return }
	if len(call_state.args) != 1 { error("cannot call 'flush' on the package directly. Make an instance instead.",call_state); return }

	_any       := AS_ANY_PTR(&call_state.args[0])
	file_state := _get_data(&_any.mem,FileState(File))

	if !file_state.is_open { warning("condition File != null is false.",call_state); NIL_VAL_PTR(call_state.result); return }

	defer file_state.file    = nil
	defer file_state.is_open = false

    if e := os2.flush(file_state.file); e != nil { warning(os2.error_string(e),call_state); NIL_VAL_PTR(call_state.result); return }
   
    NIL_VAL_PTR(call_state.result)
}



// Nota(jstn):
// flush -> envia os dados do buffer para o SO e não garante que os dados foram/serão gravados
// sync  -> força o SO a escrever no disco tudo que estiver pendente no buffer (garante que os dados foram/serão gravados)
sync :: proc(call_state: ^CallState) 
{
	if call_state.argc      != 0 { error_msg0("force_disk_write",0,call_state); return }
	if len(call_state.args) != 1 { error("cannot call 'force_disk_write' on the package directly. Make an instance instead.",call_state); return }

	_any       := AS_ANY_PTR(&call_state.args[0])
	file_state := _get_data(&_any.mem,FileState(File))

	if !file_state.is_open { warning("condition File != null is false.",call_state); NIL_VAL_PTR(call_state.result); return }

	defer file_state.file    = nil
	defer file_state.is_open = false

    if e := os2.sync(file_state.file); e != nil { warning(os2.error_string(e),call_state); NIL_VAL_PTR(call_state.result); return }
   
    NIL_VAL_PTR(call_state.result)
}

remove :: proc(call_state: ^CallState) 
{
	if call_state.argc != 1 || !IS_VAL_STRING_PTR(&call_state.args[0])   { error_msg("remove",1,"String",call_state); return }
    if e := os2.remove(VAL_STRING_DATA_PTR(&call_state.args[0])); e != nil do warning(os2.error_string(e),call_state)
    NIL_VAL_PTR(call_state.result)
}

rename :: proc(call_state: ^CallState) 
{
	if call_state.argc != 2 || !IS_VAL_STRING_PTR(&call_state.args[0]) || !IS_VAL_STRING_PTR(&call_state.args[1]) { error_msg("rename",2,"String and String",call_state) ; return }

	old_path   := VAL_STRING_DATA_PTR(&call_state.args[0])
	new_path   := VAL_STRING_DATA_PTR(&call_state.args[1])

    if e := os2.rename(old_path,new_path); e != nil do warning(os2.error_string(e),call_state)
    NIL_VAL_PTR(call_state.result)
}


close :: proc(call_state: ^CallState) 
{
	if call_state.argc != 0      { error_msg0("close",0,call_state); return }
	if len(call_state.args) != 1 { error("cannot call 'close' on the package directly. Make an instance instead.",call_state); return }

	_any       := AS_ANY_PTR(&call_state.args[0])
	file_state := _get_data(&_any.mem,FileState(File))

	if !file_state.is_open { warning("condition File != null is false.",call_state); NIL_VAL_PTR(call_state.result); return }

	defer file_state.file    = nil
	defer file_state.is_open = false

    if e := os2.close(file_state.file); e != nil { warning(os2.error_string(e),call_state); NIL_VAL_PTR(call_state.result); return }
   
    NIL_VAL_PTR(call_state.result)
}


#+private

package OScriptVM

import filepath "core:path/filepath"
import os       "core:os"
import os2      "core:os/os2"

OSCRIPT_EXTENSION	:: `.os`
OSCRIPT_FLAGS    	:: os2.O_RDONLY


load_script :: proc(path: string) -> (string,bool) 
{
	if !(filepath.long_ext(path) == OSCRIPT_EXTENSION) { println("'",path,"' is not a valid path to a OScript file."); return "",false } 
	data,ok   := os.read_entire_file_from_filename(path,compile_default_allocator())
	src_code  := transmute(string)data
	return src_code,ok
}

load_script_import :: proc(path: string) -> (string,bool) 
{
	if !(filepath.long_ext(path) == OSCRIPT_EXTENSION) do return "",false 
	data,ok   := os.read_entire_file_from_filename(path,compile_default_allocator())
	src_code  := transmute(string)data
	return src_code,ok
}

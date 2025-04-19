#+private

package OscriptFile

import os2 "core:os/os2"
import io  "core:io"
import mem "core:mem"

os2 :: os2
io  :: io

@(private = "file") 
import_id : ImportID

RDONLY 	   :: 1 << 0
WRONLY 	   :: 1 << 1
RDWR   	   :: 1 << 2
APPEND 	   :: 1 << 3
CREATE 	   :: 1 << 4
EXCL   	   :: 1 << 5
SYNC   	   :: 1 << 6
TRUNC  	   :: 1 << 7
SPARSE 	   :: 1 << 8


File       :: os2.File
File_Flags :: os2.File_Flags

FileState  :: struct ($T: typeid) {
	is_open : bool,
	file    : ^T
}


_copy_data     :: proc "contextless" (bptr: ^$A ,data : ^$B){ mem.copy(bptr,data,size_of(B)) }

_get_data      :: proc "contextless" (ptr: ^$A ,$T : typeid) -> ^T { return (^T)(ptr) }

_set_import_id :: proc "contextless" (id: ImportID)         { import_id = id }

_get_import_id :: proc "contextless" () -> ImportID         { return import_id }

_is_same_id    :: proc "contextless"(id: ImportID ) -> bool { return import_id == id } 

_is_valid_mode :: proc "contextless" (mode: Int) -> bool    { return mode < 0 ? false:true}

_get_file_mode :: proc "contextless" (m: Int) -> File_Flags {

	mode : File_Flags

	if m & RDONLY != 0 do mode += os2.O_RDONLY
	if m & WRONLY != 0 do mode += os2.O_WRONLY
	if m & RDWR   != 0 do mode += os2.O_RDWR
	if m & APPEND != 0 do mode += os2.O_APPEND
	if m & CREATE != 0 do mode += os2.O_CREATE
	if m & EXCL   != 0 do mode += os2.O_EXCL
	if m & SYNC   != 0 do mode += os2.O_SYNC
	if m & TRUNC  != 0 do mode += os2.O_TRUNC
	if m & SPARSE != 0 do mode += os2.O_SPARSE

	return mode
}


















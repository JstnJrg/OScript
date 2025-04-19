package OscriptFile


register :: proc(file_id : ImportID)
{
	// Nota(jstn): define o import_id actual
	_set_import_id(file_id)

	// Nota(jstn): constants
	register_method(file_id,"open",open)
	register_method(file_id,"close",close)
	register_method(file_id,"write",write)
	register_method(file_id,"write_at",write_at)
	register_method(file_id,"read",read)
	register_method(file_id,"read_at",read_at)
	register_method(file_id,"name",name)
	register_method(file_id,"rename",rename)
	register_method(file_id,"remove",remove)
	register_method(file_id,"file_exists",exists)
	register_method(file_id,"alias_file",link)
	register_method(file_id,"file_shortcut",symlink)
	register_method(file_id,"flush",flush)
	register_method(file_id,"force_disk_write",sync)
	register_method(file_id,"get_absolute_path",get_absolute_path)
	register_method(file_id,"get_relative_path",get_relative_path)
	// register_method(file_id,"",)
	// register_method(file_id,"",)
	// register_method(file_id,"",)
	// register_method(file_id,"",)
	// register_method(file_id,"",)
	// register_method(file_id,"",)
}
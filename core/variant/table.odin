package OScriptVariant

INITIAL_CAPACITY :: 30
INITIAL_CAPACITY_INSTANCE :: 10
INITIAL_CAPACITY_CLASS    :: 10

Table 		:: map[u32]Value
TableString :: map[u32]^ObjectString
TableHash 	:: map[u32]u32


table_init 			:: proc(table_p: ^Table) { reserve(table_p,INITIAL_CAPACITY) }
table_init_instance :: proc(table_p: ^Table) { reserve(table_p,INITIAL_CAPACITY_INSTANCE) }
table_init_class 	:: proc(table_p: ^Table) { reserve(table_p,INITIAL_CAPACITY_CLASS) }


table_set :: #force_inline proc   "contextless" (table_p: ^Table, key : ^ObjectString,value: Value) -> bool {
	hash := key.hash
	is_new_key := (hash not_in table_p)
	table_p[hash] = value
	return is_new_key
}


// Nota(jstn): define, porém com restrição

table_pset :: #force_inline proc   "contextless" (table_p: ^Table, key : ^ObjectString,value: ^Value, cannot_assign : ^bool, vbs : ^ValueBitSet) -> bool {
	hash := key.hash
	is_new_key := (hash not_in table_p)

	if is_new_key do table_p[hash] = value^
	else 
	{
		pvalue        := &table_p[hash]
		cannot_assign^ = pvalue.type in vbs
		pvalue^        = value^
	}

	return is_new_key
}


/* Nota(jstn): uaso normalmente para registrar nativos sem alocar memoria*/
table_set_s :: #force_inline proc (table_p: ^Table, key : string,value: Value) -> bool {
	hash := hash_string(key)
	is_new_key := (hash not_in table_p)
	table_p[hash] = value
	return is_new_key
}

/* Nota(jstn): uaso normalmente para registrar nativos sem alocar memoria*/
table_set_hash :: #force_inline proc "contextless" (table_p: ^Table, key : u32 ,value: Value) -> bool {
	is_new_key := (key not_in table_p)
	table_p[key] = value
	return is_new_key
}

table_set_hash_vptr :: #force_inline proc "contextless" (table_p: ^Table, key : u32 ,value: ^Value) -> bool {
	is_new_key := (key not_in table_p)
	table_p[key] = value^
	return is_new_key
}

table_pset_hash :: #force_inline proc   "contextless" (table_p: ^Table, key : u32 ,value: ^Value, cannot_assign : ^bool, vbs : ^ValueBitSet) -> bool {
	
	is_new_key := (key not_in table_p)

	if is_new_key do table_p[key] = value^
	else 
	{
		pvalue        := &table_p[key]
		cannot_assign^ = pvalue.type in vbs
		pvalue^        = value^
	}

	return is_new_key
}


table_get :: #force_inline proc "contextless" (table_p: ^Table, key : ^ObjectString, value_p: ^Value) -> bool {
	hash := key.hash
	(hash in table_p) or_return
	value_p^ = table_p[hash]
	return true
}

table_pget :: #force_inline proc   "contextless" (table_p: ^Table, key : ^ObjectString,value: ^Value, cannot_assign : ^bool, vbs : ^ValueBitSet) -> bool {
	
	hash    := key.hash
	has_key := (hash in table_p)

	has_key or_return

	pvalue        := &table_p[hash]
	value^         = pvalue^

	cannot_assign^ = pvalue.type in vbs
	return true
}

table_pget_hash :: #force_inline proc   "contextless" (table_p: ^Table, hash : u32,value: ^Value, cannot_assign : ^bool, vbs : ^ValueBitSet) -> bool {
	
	has_key := (hash in table_p)

	has_key or_return

	pvalue        := &table_p[hash]
	value^         = pvalue^

	cannot_assign^ = pvalue.type in vbs
	return true
}



table_get2 :: #force_inline proc "contextless" (table_a,table_b: ^Table, key : ^ObjectString, value_p: ^Value) -> bool {
	 hash := key.hash
	if hash in table_a { value_p^ = table_a[hash]; return true }
	if hash in table_b { value_p^ = table_b[hash]; return true }
	return false
}

table_get_hash :: #force_inline proc "contextless" (table_p: ^Table, key : u32 , value_p: ^Value) -> bool {
	(key in table_p) or_return
	value_p^ = table_p[key]
	return true
}

table_get_s :: #force_inline proc (table_p: ^Table, name : string , value_p: ^Value) -> bool {
	key := hash_string(name)
	(key in table_p) or_return
	value_p^ = table_p[key]
	return true
}


// para herança, ou seja, herança de metodos
table_copy :: proc "contextless" (from,to: ^Table) { for key,value in from do to[key] = value }

table_clear :: proc (t: ^Table) { clear(t) }

table_delete_key :: proc(table_p: ^Table, key : ^ObjectString) { delete_key(table_p,key.hash) }

destroy_table :: proc(table_p: Table) {	delete(table_p) } 



table_hash_has_combine	::  #force_inline proc(table_p: ^TableHash, value: u32) -> bool { return value in table_p }
table_hash_get_hash		::  #force_inline proc(table_p: ^TableHash, combine: u32) -> u32 { return table_p[combine] }
table_hash_set_hash		::  #force_inline proc(table_p: ^TableHash, combine,hash: u32) { table_p[combine] = hash }

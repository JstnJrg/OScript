package OScriptVariant

Any         :: struct 
{ 
	using base: Object, 
	etype	  : ValueType,
	id   	  : i16, 
	mem  	  : [32]u8 
}


create_T :: proc($T: typeid, type : ObjectType) -> ^T {
	
	t_ptr     := memnew(T)
	t_ptr.type = type
	
	if bytes_allocated != nil { 
		bytes_allocated^ += size_of(T)
		t_ptr.next = list^
		list^	   = t_ptr
	}

	return t_ptr
}



create_any_ptr :: proc(type: ValueType, id : i16 ) -> ^Any { 

	if sucess, obj := PEEK_OBJECT_FROM_FREELIST(.OBJ_ANY); sucess {
		obj_t       := (^Any)(obj)
		obj_t.etype  = type
		obj_t.id     = id
		return obj_t
	} 

	t      := create_T(Any,.OBJ_ANY)
	t.etype = type
	t.id    = id
	return t
}





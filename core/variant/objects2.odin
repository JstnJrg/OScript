package OScriptVariant


Transform2D :: struct { using base : Object, data: mat2x3 }



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


// Transform
create_transform2_ptr :: proc(x,y,o: ^Vector2d) -> ^Transform2D { 

	// Nota(jstn): busca na lista livre
	if sucess, obj := PEEK_OBJECT_FROM_FREELIST(.OBJ_TRANSFORM2); sucess { 

		t := (^Transform2D)(obj)
		t.data[0] = x^
		t.data[1] = y^
		t.data[2] = o^

		return t
	}

	t := create_T(Transform2D,.OBJ_TRANSFORM2) 

	t.data[0] = x^
	t.data[1] = y^
	t.data[2] = o^

	return t
}


create_transform2_mat2x3_ptr :: proc(m: ^mat2x3) -> ^Transform2D { 
	t := create_T(Transform2D,.OBJ_TRANSFORM2) 
	t.data = m^
	return t
}

create_transform2_no_data_ptr :: proc() -> ^Transform2D { 
	t := create_T(Transform2D,.OBJ_TRANSFORM2) 
	return t
}





package OscriptArray


register :: proc(array_id : ImportID)
{

	register_array_operators()

	register_method(array_id,"size",size)
	register_method(array_id,"shuffle",shuffle)
	register_method(array_id,"clear",_clear)
	register_method(array_id,"resize",resize_)
	register_method(array_id,"choice",choice)
	register_method(array_id,"append",append_)
	register_method(array_id,"pop_back",pop_back)
	register_method(array_id,"pop_front",pop_front)
	register_method(array_id,"qsort",qsort)
	register_method(array_id,"ssort",ssort)
	register_method(array_id,"find",find)
	register_method(array_id,"append_array",append_array)
	register_method(array_id,"fill",fill)
	register_method(array_id,"count",count)
	register_method(array_id,"has",has)
	register_method(array_id,"reverse",reverse)
	// register_method(array_id,"",)
	// register_method(array_id,"",)
	// register_method(array_id,"",)
	// register_method(array_id,"",)
	// register_method(array_id,"",)
	// register_method(array_id,"",)
	// register_method(array_id,"",)
	// register_method(array_id,"",)
	// register_method(array_id,"",)
	// register_method(array_id,"",)
	// register_method(array_id,"",)
	// register_method(array_id,"",)
	// register_method(array_id,"",)
	// register_method(array_id,"",)



}
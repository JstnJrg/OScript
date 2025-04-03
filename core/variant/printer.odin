package OScriptVariant
import fmt "core:fmt"

print 		:: fmt.print
println		:: fmt.println

printf		:: fmt.printf
printfln	:: fmt.printfln

MaxPrinter      :: 10
OScriptOutPut   :: `Oscript :> `

recursion_count := 0 


printer      :: proc(values: []Value) 
{ 
	print(OScriptOutPut)
	for &value in values do print_values(&value)
	print("\n") 
}



print_values :: proc(value: ^Value)
{

	#partial switch value.type {
	
		case .FLOAT_VAL	    : print(AS_FLOAT_PTR(value))
		case .INT_VAL 		: print(AS_INT_PTR(value))
		case .BOOL_VAL  	: print(AS_BOOL_PTR(value))
		case .NIL_VAL   	: print("nil")
		
		case .VECTOR2_VAL	: vector2 := AS_VECTOR2_PTR(value); print("Vector2(",vector2.x,",",vector2.y,")")
		case .COLOR_VAL     : color_p := AS_COLOR_PTR(value)  ; print("Color(",color_p.r,",",color_p.g,",",color_p.b,",",color_p.a,")")

		case .RECT2_VAL:
			rect_p := AS_RECT2_PTR(value)
			pos_p  :=  &rect_p[0] 
			size_p :=  &rect_p[1]
			print("Rect2((",pos_p.x,",",pos_p.y,"),(",size_p.x,",",size_p.y,"))")


		case .OBJ_TRANSFORM2:

			mat2x3 := AS_TRANSFORM2_DATA_PTR(value)
			X      := &mat2x3[0]
			Y      := &mat2x3[1]
			O      := &mat2x3[2]
			print("Transform2D(","(",X.x,",",X.y,")",",","(",Y.x,",",Y.y,")",",","(",O.x,",",O.y,")",")")
		
		case .OBJ_VAL	            : println(" OBJECT VAL")
		case .OBJ_STRING   			: print(VAL_STRING_DATA_PTR(value))
		case .OBJ_ARRAY 			:

			arr  := VAL_AS_OBJ_ARRAY_PTR(value)
			data := &arr.data 
			len  := arr.len

			      recursion_count += 1
			defer recursion_count -= 1

			print("[")
			for &content,indx in data 
			{ 
				print_values(&content)
				if indx+1 != len do print(",")
				if recursion_count >= MaxPrinter { print("[...]"); break }
			}
			

			print("]")


		case .OBJ_FUNCTION 			: 
			id := AS_FUNCTION_BD_ID_PTR(value)
			print("'function' ",get_function_name_functionBD(id),".")

		case .OBJ_PACKAGE,.OBJ_NATIVE_CLASS		: print("'import' ",get_import_name(AS_IMPORT_BD_ID_PTR(value)))
		case .OBJ_CLASS			 				: print("'class' ",get_class_name_classBD(AS_CLASS_BD_ID_PTR(value)))
		case .OBJ_CLASS_INSTANCE 	: 

			instance := VAL_AS_OBJ_CLASS_INSTANCE_PTR(value)
			print("instance of '",get_class_name_classBD(instance.klass_ID),"' class")
		
		// case .OBJ_NATIVE_CLASS     	: print("'import' ",get_import_name(AS_IMPORT_BD_ID_PTR(value)))


		case : print("bad print")		
	}

}
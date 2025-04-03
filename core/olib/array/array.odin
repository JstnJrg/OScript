#+private

package OscriptArray


_len 			:: proc(arr: ^$T/[dynamic]$E) -> Int { return len(arr) }
_cap 			:: proc(arr: ^$T/[dynamic]$E) -> Int { return cap(arr) }
_append 		:: proc(arr: ^$T/[dynamic]$E, what: []E) { append(arr,..what)  }


_shuffle     	:: proc(arr: ^$T/[dynamic]$E) {
	rand.shuffle(arr[:])
}

_choice     	:: proc (arr: ^$T/[dynamic]$E, result: ^Value) {
	result^ = rand.choice(arr[:])
}

_resize        :: proc (arr: ^$T/[dynamic]$E, n: Int) -> bool {
	return true if resize(arr,n) == nil else false
} 

_equal_count   :: proc(arr: ^$T/[dynamic]$E, value_p : ^Value,call_error : ^ObjectCallError) -> (amount: int ) {

	r  : Value
	ok : bool

	for &value in arr
	{
		callee := get_operator_evaluator(.OP_EQUAL,value_p.type,value.type)
		if callee == nil do continue

		//Nota(jstn): presumimos que o CallError não será usado
		#force_inline callee(&value,value_p,&r,&ok,call_error)
		if AS_BOOL_PTR(&r) do amount += 1
	}

	return
}

_reverse  :: proc "contextless" (arr: ^$T/[dynamic]$E, len : int ) {

	i := 0; end := len-1

	for i < end
	{
		temp    := arr[i]
		arr[i]   = arr[end]
		arr[end] = temp

		i   += 1
		end -= 1
	}
	
} 



__clear        :: proc (arr: ^$T/[dynamic]$E) { clear(arr) } 

_quick_short   :: proc (arr: ^$T/[dynamic]Value,r: ^Value,left,right : Int,call_error : ^ObjectCallError)
{
	
	i := left
	j := right
	m := (left+right)/2
	x := arr[m]

	ok: bool 

	for i <= j
	{

		l1 : for 
		{
			type_a := arr[i].type
			type_b := x.type

			callee := get_operator_evaluator(.OP_LESS,type_a,type_b)
			if callee == nil do break l1

			callee(&arr[i],&x,r,&ok,call_error)
			if   AS_BOOL_PTR(r) && i < right do i += 1
			else  do break l1					
		}

		l2 : for 
		{
			type_a := x.type
			type_b := arr[j].type
			
			callee := get_operator_evaluator(.OP_LESS,type_a,type_b)
			if callee == nil do break l2

			callee(&x,&arr[j],r,&ok,call_error)
			if       AS_BOOL_PTR(r) && j > left do j -= 1
			else  do break l2					
		}

		if i <= j 
		{
			y := arr[i]
			arr[i] = arr[j]
			arr[j] = y
			i += 1; j -= 1
		}       

	}

	if left < j     do _quick_short(arr,r,left,j,call_error)
	if i    < right do _quick_short(arr,r,i,right,call_error)
}

_shell_short   :: proc (arr: ^$T/[dynamic]Value,r: ^Value,call_error: ^ObjectCallError)
{
	
	gap : Int
	x   : Value
	a   := [?]Int{9,5,3,2,1}
	n   := len(arr)
	m   := len(a)
	j,i   : Int

	ok: bool 


	for k in 0..<m
	{
		gap = a[k]

		for i = gap ; i < n; i += 1
		{
			x = arr[i]
			
			l3: for j = i-gap; j >= 0 ;
			{
				type_a := x.type
				type_b := arr[j].type

				callee := get_operator_evaluator(.OP_LESS,type_a,type_b)
				if callee == nil do break l3

				#force_inline callee(&x,&arr[j],r,&ok,call_error)

				if  AS_BOOL_PTR(r) {
					arr[j+gap] = arr[j]
					j -= gap
				}
				else  do break l3	
			}


			arr[j+gap] = x
		}
	}
}


_binary :: proc (arr: ^$T/[dynamic]Value,key: Value ,r: ^Value,call_error: ^ObjectCallError) -> Int
{
	low,high,mid : Int
	key := key

	low = 0; high = len(arr)-1
	ok : bool

	for low <= high
	{
		mid = (low+high)/2

		type_a := key.type
		type_b := arr[mid].type

		if true 
		{
			callee := get_operator_evaluator(.OP_LESS,type_a,type_b)
			if callee == nil { high = mid-1; continue }

			#force_inline callee(&key,&arr[mid],r,&ok,call_error)
			if AS_BOOL_PTR(r) { high = mid-1; continue }
		}
		if true 
		{
			callee := get_operator_evaluator(.OP_GREATER,type_a,type_b)
			if callee == nil { low = mid+1; continue }
			
			#force_inline callee(&key,&arr[mid],r,&ok,call_error)
			if AS_BOOL_PTR(r) { low = mid+1; continue }
		}

		return mid
	}


	// Nota(jstn): via mais dificil, mais pesada
	for &v,indx in arr 
	{
		type_a := key.type
		type_b := v.type

		callee := get_operator_evaluator(.OP_EQUAL,type_a,type_b)
		if callee == nil do continue

		#force_inline callee(&key,&v,r,&ok,call_error)
		if AS_BOOL_PTR(r) do return indx
	}

	return -1
}



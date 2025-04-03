
import Math

fn costum_qsort(arr,left,right)
{
	set i = left
	set j = right
	set x = arr[(left+right)/2]
	
	while i <= j
	{
		while arr[i] < x and i < right { i += 1 }
		while x < arr[j] and j > left  { j -= 1 }
		
		if  i <= j
		{
			set y  = arr[i]
			arr[i] = arr[j]
			arr[j] = y
			i += 1
			j -= 1
		}
	}
	
	if left < j     { costum_qsort(arr,left,j) }
	if    i < right { costum_qsort(arr,i,right) }
	

	
	
	
	
	


}
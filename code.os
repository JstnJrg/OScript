
import Time 
import Math
import other_code from "other_code.os" 

#Isto é um comentario

class Player 
{
	set life     = 0
	set position = Vector2(10,10)
	set trans    = Transform2D(Vector2(1,0),Vector2(0,1),Vector2(0,0))
	set color    = Color(255,0,0,255)
	set name     = "MyPlayer"
	
	fn init(name,life)
	{
	  self.name = name
	  self.life = life
	}
	
	fn get_name_centered ()
	{
	  return self.name.center_justify("***",20)
	}
	
	fn get_position_len()
	{
	  return  self.position.length()
	}

}


fn for_loop_example (start,end,step)
{
	print "--- for loop start ---"
	
	#Nota: poderia ser '<','>','<=','>='
	for u < start,end,step 
	{ 
		if   u%(end-1) == 0 { break }
		elif u%200 == 0 { continue }
		print u
	}
	
	print "--- for loop end ---"
}

fn match_case_example (a,end)
{
	print "--- Match case start ---"
	match a
	{
		case "a":
			for u < 0,end,1
			{
			 print a.right_justify(a,u)
			}
		case "e":
			for u < 0,end,1
			{
			 print a.right_justify(a,u)
			}
			
		case "i":
			for u < 0,end,1
			{
			 print a.right_justify(a,u)
			}
			
		case "o":
			for u < 0,end,1
			{
			 print a.right_justify(a,u)
			}
		case "u":
			for u < 0,end,1
			{
			 print a.right_justify(a,u)
			}
		case _  :
			for u < 0,end,1
			{
			 print "OScript".right_justify(a,u)
			}
	}
	
	print "--- Match case end ---"
}


fn if_else_example(number)
{
	print "--- if else start ---"
	if   number > 10 { print "great than 10" }
	elif number < 10 { print "less than  10" }
	else             { print "equal 10"      }
	print "--- if else end ---"
}


fn fibonacci(number)
{
	if number <= 0 { return 1 }
	return fibonacci(number-2)+fibonacci(number-1)
}

fn fact(number)
{
	if number <= 0 { return 1 }
	return number*fact(number-1)
}


fn create_player_instance ()
{

	print "--- Player instance ---"
	set player = Player.new("PlayerName",100)
	
	print player.get_name_centered()
	print player.get_position_len()

	player.position.x = -100
	player.position.y = -400
	
	print player.trans.xform(player.position)
	print "--- Player end ----"
	
}


fn math_function ()
{
	print Math.sin(7)
	print Math.cos(7)
	
	print 123 & 12
	print 122 >> 7
	print 122 << 8
	print 122 | 8
	print 123**2 # pow(123,2)
	print 123 ^ 8
	
	print Math.pow(12,13)

}


fn main ()
{
	Time.start()
	
	#for_loop_example(1,1000,1)
	#create_player_instance()
	#match_case_example("a",10)
	#if_else_example(12)
	math_function()
	
	set start = Time.get_tick_ms()
	print fibonacci(15)
	print "fibonacci function takes ",(Time.get_tick_ms()-start),"ms"

	start = Time.get_tick_ms()
	print fact(5)
	print "factorial function takes ",(Time.get_tick_ms()-start),"ms"	
	
	
	#my array
	set my_arr  = []
	set my_arr2 = []
	
	for u < 0,1_00,1 
	{ 
		set value = Math.randi()%1_000
		my_arr.append(value) 
		my_arr2.append(value) 
	}
	
	
	#test my costum quick_sort
	
	
	print "\n\n--- init my costum sort ---"
	print my_arr
	start = Time.get_tick_ms()
	other_code.costum_qsort(my_arr,0,my_arr.size()-1)
	print "--- end my costum sort --- takes > ", (Time.get_tick_ms()-start),"ms	\n"
	print my_arr
	
	print "\n\n--- init bultin sort ---"
	print my_arr2
	start = Time.get_tick_ms()
	my_arr2.qsort()
	print "--- end bultin ---",(Time.get_tick_ms()-start),"ms\n"
	print my_arr2
	
	
	
}
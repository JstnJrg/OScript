
import Math
import Time
import Oscript

fn main()
{
	set start = Time.get_tick_ms()
	
	for u < 0,1_00_000,1
	{
		set s = Math.sin(u)
		set c = Math.cos(u)
		set i = Math.hypot(s,s)
		print i
	}
	
	print "for-loop tok ",(Time.get_tick_ms()-start)*0.001
}
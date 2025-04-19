import Math
import Time
import FileAcess 
import Oscript


fn main ()
{

	set t = Transform2D(Vector2(1,2),Vector2(3,4),Vector2(320,320))
	set u = Transform2D(Vector2(1,3),Vector2(0,1),Vector2(0,-10))
	set p = Vector2(100,100)


    set a = Rect2(Vector2(10,10),Vector2(64,64))
    set b = Rect2(Vector2(20,30),Vector2(100,100))
  
      #print t*u
      #print u*t
      #print t.xform_rect(v)

    sum()


}


fn sum()
{
	set u = C.new()
	set v = B.new()

	u.name = mum
	u.name()

	print u.a()
	print v.a()
} 


class A           { set r = Math.randi()%100; fn a()  { return 1+1 } }

class B extends A { fn a() { return 2+2 } }

class C extends B { set name = "kkkk"; fn c() { return 3+3} }


fn mum () { print 1,2,3,4,5,6 }


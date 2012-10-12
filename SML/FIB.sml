fun fib2(n,a,b) : IntInf.int =
      if n = 0 then a+b
      else fib2(n-1,b,a+b);

fun fib n : IntInf.int =
      if n = 0 then 0
      else if n = 1 then 1
      else fib2(n-2,0,1);
	  
	  
	  fun fib n : IntInf.int = 
	  in n = 0 then 0
class TranslationTesting < ArduinoSketch

 def one
   delay 1
 end
 
 def two
   delay 1
   @foo = 1
 end
 
 def three
   @foo = 1
   bar = 2
   baz = wha
 end
 
 def four
   @foo = 1
   bar = 2
   wiggle = wha
 end
 
 def five
   @foo = 1
   f = KOOL
 end
 
 def six
   a = ZAK
   
 end
 
 def seven(int)
   # coerce int to long int
   a = int * 2
 end
 
 def eight(str)
   # coerce str to string
   a = ZAK + str
 end
 
 def nine
   @my_array.each do |a|
     delay a
   end
 end
 

end

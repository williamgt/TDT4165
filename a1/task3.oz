%a)
local X Y=300 Z=30 in %declaring variable
  X = Y * Z %assign variable
  {Show X}
end

%b)
local X Y in
  X = "This is a string"
  thread {System.showInfo Y} end
  Y = X
end
/*
  When a thread executes code, it will be suspended until the value that is sent into it is assigned some value ref http://mozart2.org/mozart-v1/doc-1.4.0/tutorial/node8.html
  This can be useful to mitigate errors related to assignment order: if all threads wait for the values they are dependent on, behaviour will often be defined! No uncertainty what value they are operating with.
  The statement Y = X assigns the value of X to Y
*/
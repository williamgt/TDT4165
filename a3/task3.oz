%a) and b)
declare fun {RightFold List Op U} 
  
  /**RightFold recursively loops through List and 
  performs an operation Op on the Head element and 
  the rest of the list and then returns the neutral 
  element U when at the end  */

  case List of nil then %At the end of list
    U %Return the neutral element
  [] Head|Tail then %All other cases
    {Op Head {RightFold Tail Op U}} %Execute the operation on the head and the rest of whatever the general funciton is deinfed to
  end
end

%c)
declare fun {Length List}
  {RightFold List fun {$ X Y} 1 + Y end 0} %Length, Op should just return 1 for each element
end

declare fun {Sum List}
  {RightFold List fun {$ X Y} X + Y end 0} %Sum, Op should return the value of the head for each element
end  

{System.showInfo "The length and then sum of [1 2 3 4] is:"}
{System.showInfo {Length [1 2 3 4]}} %Length
{System.showInfo {Sum [1 2 3 4]}} %Sum
  

/**
d)
A LeftFold function could not give a different result than RightFold
for Sum because the sum operation is commutative and in particular associative
as per https://en.wikipedia.org/wiki/Summation . Had a Subtract function
been implemented, it would've mattered, though. That is because subtraction
is non-associative as per https://en.wikipedia.org/wiki/Subtraction ,
and would give different result for e.g. ((5-3)-2)=0 and (5-(3-2))=-4.

Because the Length function only sums up the amount of elements in the list,
it does not matter if it goes from right to left or left to right, meaning
a LeftFold function would not give any different result than a RightFold one.
*/

/**
e)
An appropriate value for U when using RightFold for the product operation,
is 1. That value will ensure that the final product is not affected,
because multiplying some value x with 1 will result in the same value x
being the output.
*/
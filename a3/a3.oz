/* TASK 1 */
%a)
declare proc {QuadraticEquation A B C ?RealSol ?X1 ?X2}
    %No real solutions
    if (4.0 * A * C) > (B * B) then
      RealSol = false
    %One real solution
    elseif (4.0 * A * C) == (B * B) then 
      RealSol = true
      X1 = (~B) / (2.0 * A)
      X2 = X1
    %Two real solutions
    else
      local Sqrt in
        RealSol = true
        {Float.sqrt (B * B - 4.0 * A * C) Sqrt}
        X1 = (~B + Sqrt) / (2.0 * A)
        X2 = (~B - Sqrt) / (2.0 * A)
      end
    end
  end
  
  %b)
  
  %No real solutions
  local RealSol X1 X2 in
    {QuadraticEquation 2.0 1.0 2.0 RealSol X1 X2}
    if RealSol then
      {System.showInfo "A = 2.0 B = 1.0 C = 2.0 has real solutions"}
    else
      {System.showInfo "A = 2.0 B = 1.0 C = 2.0 has no real solutions"}
    end
  end
  
  %2 real solutions
  local RealSol X1 X2 in
    {QuadraticEquation 2.0 1.0 ~1.0 RealSol X1 X2}
    if RealSol then
      {System.showInfo "A = 2.0 B = 1.0 C = -1.0 has real solutions:"}
      {Show X1}
      {Show X2}
    else
      {System.showInfo "A = 2.0 B = 1.0 C = -1.0 has no real solutions"}
    end
  end
  
  /**
  c)
  Procedural abstractions are useful because they are all about
  generalizing doing some action, which makes it useful in a plethera 
  of cases. Because they are general and appliy to a lot of situations,
  it makes the program shorter and easier to understand compared to having
  many similar implementations. This also helps for debugging considering
  the function is only defined one place and utilized many places which
  makes it easy to go back and change what is needed. The information was
  found on http://www.eecs.qmul.ac.uk/~mmh/AMCM048/abstraction/procedural.html.
  */
  
  /**
  d)
  The differences between a procedure and a function
  is that a procedure is a block of code that is called
  to perform a task, and a function is a block of code that
  is called to perform a task and will return one or more
  values, as stated here https://isaaccomputerscience.org/concepts/prog_sub_proc_fun?examBoard=all&stage=all.
  */ 

/* TASK 2 */
declare fun {Sum List} 
    case List of nil then %At the end of list
        0
    [] Head|Tail then %All other cases
        Head + {Sum Tail}
    end
end
  
{System.showInfo 'The sum is:'}
{System.showInfo {Sum [1 2 3]}}

/* TASK 3 */
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


/* TASK 4 */
declare fun {Quadratic A B C} %The A B and C values for a quadratic polynomial
    fun {$ X} %The value for the X variable
      A * X * X + B * X + C 
    end
end
  
{System.showInfo {{Quadratic 3 2 1} 2}}

/* TASK 5 */
%a)
declare fun {LazyNumberGenerator StartValue} 
    StartValue # (fun {$}{LazyNumberGenerator (StartValue + 1)} end) %Is a record(, or tuple without name)
end

{System.showInfo {LazyNumberGenerator 0}.1} %Returns 0
{System.showInfo {{LazyNumberGenerator 0}.2}.1} %Returns 1
{System.showInfo {{{{{{LazyNumberGenerator 0}.2}.2}.2}.2}.2}.1} %Returns 5

/**
b)
The function takes a start value and returns a tuple, as seen by the infix operator #, 
that has the elements StartValue and LazyNumberGenerator function as the next with
an incremented StartValue. That means calling the second element will return 
a function which can be called and outputs the next number in the series.

One limitation is that the funciton is essence is an infinite series due to
it not being terminated in any way. That can cause resource issues
if it's not used carefully. It is also not very flexible in its use: it
serves only as an incrementer and is not applicable to any other series.
This could be remedied by also passing a function to LazyNumberGenerator 
which could manipulate the next number in some specific way.
*/

/* TASK 6 */
/**
a)
The Sum function implemented for task 2 is not tail recursive due to what
what can be seen on line 5 (where it says 'Head + {Sum Tail}'),
because what is returned is not only the recursive call, but also adds Head.
Had it been tail recursive, it would only have a recursive call as the return value. 
*/

declare fun {SumOptimized List Acc} 
  
    /**
    Tail recursive Sum function
    */
  
    case List of nil then %At the end of list
      Acc %Return the accumulated value when at end of list
    [] Head|Tail then %All other cases
      {SumOptimized Tail (Acc+Head)} %Tail recursive call
    end
end

{System.showInfo "The sum of [1 2 3 4] is"}
{System.showInfo {SumOptimized [1 2 3 4] 0}}

/**
b)
The benefit of tail recursive functions in Oz is that
it automatically gets optimized via the 'last call optimization'.
This means that instead of going through a sequence of 
stacked calls for each recursive call of a tail recursive function,
it returns immediately. The stack size is therefore kept constant for
such optimized recursions instead of linear.

Non-optimized:                 Optimized:
SUM([1 2 3 4])                 SUM([1 2 3 4])
(1 + SUM([2 3 4]))             SUM([2 3 4] 1)
(1 + (2 + SUM([3 4])))         SUM([3 4] 3)
(1 + (2 + (3 + SUM([4]))))     SUM([4] 6)
(1 + (2 + (3 + 4)))            SUM([] 10)
(1 + (2 + 7))                  10
(1 + 9)
10

This illustrates that the stack has to keep track of more
values for the non-optimized case, while the stack is constant
for the optimized case.
*/

/**
c)
Not all programming languages allow for recursive functions 
to benefit from last call optimization. E.g. C allows for it if
specific sompilers are utilized, but Java does not allow for it at all.
Due to their nature, functional programming languages generally 
support last call optimization considering they often utilize recursion.
Languages that use a call stack for function calls, like Java, make
the implementation of such an optimization hard due to how the 
stack is utilized and what is responsible for popping the stack.
If the caller is responsible for freeing the stack when finished, 
the computed values will be removed before the next recursive iteration
as per https://www.drdobbs.com/tackling-c-tail-calls/184401756 . 
*/
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
    {SumOptimized Tail (Acc + Head)} %Tail recursive call
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
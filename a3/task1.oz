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
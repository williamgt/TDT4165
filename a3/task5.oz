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
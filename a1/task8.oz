%a)
declare
fun {Push List Element}
  Element | List
end

{System.showInfo 'Pushing 0 to list [1 2 3]'}
{Show {Push [1 2 3] 0}}

%b)
declare 
fun {Peek List}
  case List of Head|_ then
    Head
  [] nil then
    nil
  end
end

{System.showInfo 'Peeking at [1 2 3]'}
{Show {Peek [10 2 3]}}

%c)
declare
fun {Pop List}
  case List of _|Tail then
    Tail
  end
end

{System.showInfo 'Popping [1 2 3]'}
{Show {Pop [1 2 3]}}
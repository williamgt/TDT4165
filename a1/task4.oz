%a)
declare Max %Imortant!!! declare variables with declare or local, includes function names

fun {Max X Y} %Functions return the last value stated
  if X > Y then
    X
  else
    Y
  end
end

{System.showInfo {Max 1 10}}

%b)
declare PrintGreater

proc {PrintGreater Number1 Number2} %Procedures have no return value
  if Number1 > Number2 then
    {System.showInfo Number1}
  else
    {System.showInfo Number2}
  end
end

{PrintGreater 10 100}
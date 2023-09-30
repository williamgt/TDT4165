%a)
declare fun {Length List}
  case List of nil then %At the end of list
    0
  [] Head|Tail then %All other cases
    1 + {Length Tail}
  end
end

/* {System.showInfo 'The length is:'}
{System.showInfo {Length [1 2 3]}} */

%b)
declare Take 
fun {Take List Count} Size={Length List} NewCount=Count-1 in
  %Return entire list if want to return more than its size
  if Count > Size then
    List

  %Else, return only the specified amount of elements
  else
    if Count > 0 then
      List.1|{Take List.2 NewCount}
    else
      nil
    end
  end
end

/* {System.showInfo 'The new list after taking is:'}
{Show {Take [1 2 3] 4}} %NB! Can't print lists in System.showInfo */


%c)
declare Drop 
fun {Drop List Count} Size={Length List} in
  %Return nil if Count is larger then size of List
  if Count > Size then
    nil
  else
    if Count > 0 then
      {Drop List.2 Count-1}
    else
      List
    end
  end
end

/* {System.showInfo 'The new list after dropping is:'}
{Show {Drop [1 2 3] 2}}  */

%d)
declare
fun {Append List1 List2}
   case List1 of Head|Tail then
      Head | {Append Tail List2} %Recursively append the Head of rest of List1 to List2
   [] nil then
      List2 %Return List2 when List1 is empty
   end
end

/* {System.showInfo 'Appending [1 2] and [3 4]:'}
{Show {Append [1 2] [3 4]}}  */

%e)
declare
fun {Member List Element}
  case List of Head|Tail then
    if Head == Element then %If the current Head is equal to the Element, true
      true
    else
      {Member Tail Element} %No match, continue searching
    end  
  [] nil then %When at end, know no members are alike
    false
  end
end

/* {System.showInfo 'Element 3 is in [1 2 3]?'}
{Show {Member [1 2 3] 3}}
{System.showInfo 'Element 3 is in [1 2 0]?'}
{Show {Member [1 2 0] 3}} */

%f)
declare 
fun {Position List Element}
  %Declaring a local functino that keepds track of current position
  local 
    fun {Pos List Element CurrPos}
      %Not found, return -1
      case List of nil then
        ~1
      %Check all elements
      [] Head|Tail then
        if Head == Element then %Return current position if value is Head to Element
          CurrPos
        else
          {Pos Tail Element CurrPos+1} %Continue searching the rest and increment position
        end
      end
    end
  in

  {Pos List Element 0}
  end
end

/* {System.showInfo 'Index of 3 in [1 2 3 4 3] is'}
{System.showInfo {Position [1 2 3 4 3] 3}} */

%From task 8:
%a)
declare
fun {Push List Element}
  Element | List
end

/* {System.showInfo 'Pushing 0 to list [1 2 3]'}
{Show {Push [1 2 3] 0}} */

%b)
declare 
fun {Peek List}
  case List of Head|_ then
    Head
  [] nil then
    nil
  end
end

/* {System.showInfo 'Peeking at [1 2 3]'}
{Show {Peek [10 2 3]}}
 */
 
%c)
declare
fun {Pop List}
  case List of _|Tail then
    Tail
/*   [] nil then
    nil */
  end
end

/* {System.showInfo 'Popping [1 2 3]'}
local List=[1 2 3] in
  {Show {Pop List}}
  {Show {Pop {Pop List}}}
end */
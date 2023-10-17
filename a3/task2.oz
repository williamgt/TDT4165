declare fun {Sum List} 
  case List of nil then %At the end of list
    0
  [] Head|Tail then %All other cases
    Head + {Sum Tail}
  end
end

{System.showInfo 'The sum is:'}
{System.showInfo {Sum [1 2 3]}}
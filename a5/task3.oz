\insert 'C:/Datateknologi/s1/prog/TDT4165/a5/task2.oz'
\insert 'C:/Datateknologi/s1/prog/TDT4165/a1/List.oz'


declare ListDivisorsOf ListPrimesUntil 

%a
fun {ListDivisorsOf Number} ListDivisorsOfHelper Enums in 
    Enums = {Enumerate 1 Number} %Getting stream of numbers from specified range

    ListDivisorsOfHelper = fun {$ Next List}  %Helper function for finding list of divisors of Number
        case List of nil then
            nil
        [] H|T then 
            if Number mod H == 0 then
                H | {ListDivisorsOfHelper (Next+1) T}
            else
                {ListDivisorsOfHelper (Next+1) T}
            end
        end
    end
    thread {ListDivisorsOfHelper 1 Enums} end %Wrapping helper func call in thread for stream properties
end

{System.show {List.take {ListDivisorsOf 5} 2}}

%b
fun {ListPrimesUntil N} ListPrimesUntilHelper Enums in 
    Enums = {Enumerate 1 N}  %Getting stream of numbers from specified range
    
    ListPrimesUntilHelper = fun {$ List} Divisors in %Helper function for finding list of primes up to N
        case List of nil then
            nil
        [] H|T then
            Divisors = {ListDivisorsOf H}
            if {Length Divisors} == 2 then %Hacky way, but kind of works: only two elements should be in list: 1 and itself
                H | {ListPrimesUntilHelper T}
            else 
                {ListPrimesUntilHelper T}
            end
        end
    end
    thread {ListPrimesUntilHelper Enums} end %Wrapping helper func call in thread for stream properties
end

{System.show {List.take {ListPrimesUntil 10} 4}}
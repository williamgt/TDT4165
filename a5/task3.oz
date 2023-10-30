\insert 'C:/Datateknologi/s1/prog/TDT4165/a5/task2.oz'
\insert 'C:/Datateknologi/s1/prog/TDT4165/a1/List.oz'


declare ListDivisorsOf ListPrimesUntil 

%a
fun {ListDivisorsOf Number} ListDivisorsOfHelper Enums in 
    thread Enums = {Enumerate 1 Number} end %Getting numbers from specified range
    ListDivisorsOfHelper = fun {$ Next List} CalcNext in %Helper function for finding list of divisors of Number
        thread CalcNext = Next + 1 end %Calling thread to calculate next to check, this makes it a stream??????????
        case List of nil then
            nil
        [] H|T then 
            if Number mod H == 0 then
                H | {ListDivisorsOfHelper CalcNext T}
            else
                {ListDivisorsOfHelper CalcNext T}
            end
        end
    end
    {ListDivisorsOfHelper 1 Enums}
end

{System.show {ListDivisorsOf 5}}

%b
fun {ListPrimesUntil N} ListPrimesUntilHelper Enums in 
    thread Enums = {Enumerate 1 N} end %Getting numbers from specified range
    ListPrimesUntilHelper = fun {$ List} Divisors in
        case List of nil then
            nil
        [] H|T then
            thread Divisors = {ListDivisorsOf H} end
            if {Length Divisors} == 2 then %Hacky way, but kind of works: only two elements should be in list: 1 and itself
                H | {ListPrimesUntilHelper T}
            else 
                {ListPrimesUntilHelper T}
            end
        end
    end
    {ListPrimesUntilHelper Enums}
end

{System.show {ListPrimesUntil 10}}
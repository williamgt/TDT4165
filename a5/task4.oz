\insert 'C:/Datateknologi/s1/prog/TDT4165/a5/task3.oz'
\insert 'C:/Datateknologi/s1/prog/TDT4165/a1/List.oz'

declare EnumerateLazy PrimesLazy

%a
fun lazy {EnumerateLazy} EnumerateLazyHelper in
    EnumerateLazyHelper = fun lazy {$ Current} %Does helper need to be lazy too????
        Current | {EnumerateLazyHelper Current+1}
    end
    {EnumerateLazyHelper 1}
end

{System.show {List.take {EnumerateLazy} 10}}

%b
fun lazy {PrimesLazy} PrimesLazyHelper Enums in
    Enums = {EnumerateLazy}
    PrimesLazyHelper = fun lazy {$ Numbers} Divisors in
        case Numbers of H|T then %This will always be the pattern, since EnumerateLazy is never terminated by nil
            Divisors = {ListDivisorsOf H}
            if {Length Divisors} == 2 then %Same as before
                H | {PrimesLazyHelper T}
            else 
                {PrimesLazyHelper T}
            end
        end
    end
    {PrimesLazyHelper Enums}
end

{System.show {List.take {PrimesLazy} 10}}

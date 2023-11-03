\insert 'C:/Datateknologi/s1/prog/TDT4165/a1/List.oz'

/* TASK 1*/
%a
local A=10 B=20 C=30 in
    {System.show C}
    thread
        {System.show A}
        {Delay 100}
        {System.show A * 10}
    end
    thread
        {System.show B}
        {Delay 100}
        {System.show B * 10}
    end
    {System.show C * 100}
end
/*
The sequence of numbers that are printed are 30, 3000, 10, 20, 200, 100 on my pc 
*/  

%b
/*
First, the main thread is instantiated and prints C. Then two new threads are created.
From here its a matter of the scheduler for which thread is executed next.
That means which values are printed after the first print statement is hard to predict,
unless one has direct access to how the scheduler is implemented. And the printing sequence
is therefore nondeterministic after the first print, making predicting the output arbitrary.
*/

%c
local A B C in
    thread
        A = 2
        {System.show A}
    end
    thread
        B = A * 10
        {System.show B}
    end
    C = A + B
    {System.show C}
end
    
/*
The sequence of numbers that are printed are 2, 20, 22
*/

%d
/*
Due to how Mozart Oz threads waits for variables to be bound to some values, 
the main thread will suspend execution when it comes to the expression
    C = A + B
and execute the threads that are defined in the local scope. The thread that
binds A must be executed before the one that binds B due to B being dependent
on A. Therefore, the executed code must first print A, then B and lastly C.
This also makes it impossible for any other order of execution.
*/

/* TASK 2*/
declare Enumerate GenerateOdd 

%a
fun {Enumerate Start End} EnumerateHelper in

    EnumerateHelper = fun {$ Start End} %Helper func pattern for creating stream
        if Start > End then
            nil
        else
            Start | thread {EnumerateHelper (Start+1) End} end %Wrapping next iteration in thread for stream properties
        end
    end

    thread {EnumerateHelper Start End} end %Starting computation in new thread to initiate stream
end

/*Since this is a stream, it would be impossible to get 
the output stated in the task description and I've opted to show the output in another matter.
This is true for all the other tasks because they all ask us to implement streams. 
{System.show {Enumerate 1 5}} 
*/
{System.show {List.take {Enumerate 1 5} 5}}

%b
fun {GenerateOdd Start End} Enums GenerateOddHelper in
    if Start > End then nil else %If start is larger than end, return nil
    Enums = {Enumerate Start End}  %Getting stream of numbers from specified range

    GenerateOddHelper = fun {$ List}
        case List of nil then
            nil
        [] H|T then
            if {Int.isOdd H} then
                H | {GenerateOddHelper T} %Though no wrapping in thread here, it acts as a stream likely due to being a stream consumer. This same reasoning is used for all other funcs, though not explicitly stated
            else
                {GenerateOddHelper T}
            end
        end
    end
    thread {GenerateOddHelper Enums} end end %Put helper func call in thread to make it a stream
end

{System.show {List.take {GenerateOdd 1 5} 3}}
{System.show {List.take {GenerateOdd 4 4} 1}}

%Uncomment under to see that GenerateOdd is actually a steram in that it prints _<optimized>
%unless wrapped with List.take
/* 
{System.show {GenerateOdd 1 5}}
{System.show {GenerateOdd 4 4}}
 */

/* TASK 3*/
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

/* TASK 4*/
declare EnumerateLazy PrimesLazy

%a
fun lazy {EnumerateLazy} EnumerateLazyHelper in
    EnumerateLazyHelper = fun lazy {$ Current} %Helper lazy too just in case
        Current | {EnumerateLazyHelper Current+1} %Just keep creating infinite tuple
    end
    {EnumerateLazyHelper 1} %Call helper to create the infinite enums
end

{System.show {List.take {EnumerateLazy} 10}}

%b
fun lazy {PrimesLazy} PrimesLazyHelper Enums in
    Enums = {EnumerateLazy} %Getting the lazy numbers

    PrimesLazyHelper = fun lazy {$ Numbers} Divisors in
        case Numbers of H|T then %This will always be the pattern, since EnumerateLazy is never terminated by nil
            Divisors = {ListDivisorsOf H}
            if {Length Divisors} == 2 then %Same reasoning as previous Prime function
                H | {PrimesLazyHelper T}
            else 
                {PrimesLazyHelper T}
            end
        end
    end
    {PrimesLazyHelper Enums} %Call helper to create infinite primes
end

{System.show {List.take {PrimesLazy} 10}}
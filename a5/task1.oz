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
The sequence of numbers that are printed are 30, 3000, 10, 20, 200, 100
*/  

%b
/*
TODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODOTODO
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
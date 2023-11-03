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
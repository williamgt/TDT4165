declare Enumerate GenerateOdd 

%a
fun {Enumerate Start End} Next in
    if Start > End then
        nil
    else
        thread Next = Start + 1 end %Generates the next element in this thread, don't know if right
        Start | {Enumerate Next End} 
    end
end

%{System.show {Enumerate 1 5}}

%b
fun {GenerateOdd Start End} Enums GenerateOddHelper in
    if Start > End then nil else %If start is larger than end, return nil
    thread Enums = {Enumerate Start End} end %Getting numbers from specified range

    GenerateOddHelper = fun {$ List}
        case List of nil then
            nil
        [] H|T then
            if {Int.isOdd H} then
                H | {GenerateOddHelper T}
            else
                {GenerateOddHelper T}
            end
        end
    end
    /* thread */ {GenerateOddHelper Enums} /* end */ end
end

%{System.show {GenerateOdd 1 5}}
%{System.show {GenerateOdd 4 4}}
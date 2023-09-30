\insert 'C:/Datateknologi/s1/prog/TDT4165/a1/List.oz'

%Takes a string as input and outputs an array of lexemes represented as ASCII values
declare fun {Lex Input}
    {String.tokens Input & } %Create tokens of the input split on space
end

{System.showInfo 'The string "1 2 + 3 *" gets split to:'}
{Show {Lex "1 2 + 3 *"}}


%Puts each lexeme into a record
declare fun {Tokenize Lexemes}
    case Lexemes of Head|Tail then
       /*  if {Char.isDigit Head.1} then
            % Handle multi-digit numbers
            local MultiDigitLexeme in
                MultiDigitLexeme = {CollectMultiDigitLexeme Head Tail}
                number(MultiDigitLexeme) | {Tokenize Tail}
            end */
        if {Char.isDigit Head.1} then
            number(Head.1 - 48) | {Tokenize Tail} %Ez conversion from char to number by subtracting 48
        elseif Head.1 == 47 then %ASCII for '/' is 47
            operator(type:divide) | {Tokenize Tail}
        elseif Head.1 == 43 then %ASCII for '+' is 43
            operator(type:plus) | {Tokenize Tail}
        elseif Head.1 == 45 then %ASCII for '-' is 45
            operator(type:minus) | {Tokenize Tail}
        elseif Head.1 == 42 then %ASCII for '*' is 42
            operator(type:multiply) | {Tokenize Tail}
        else
            {System.showInfo "Invalid value!!!"}
        end
     [] nil then
        nil
     end
end

/* % Helper function to collect multi-digit lexemes
fun {CollectMultiDigitLexeme Head Tail}
    case Tail of Digit|RestTail then
        if {Char.isDigit Digit.1} then
            {CollectMultiDigitLexeme Head|Digit RestTail}
        else
            Head
        end
    [] _ then
        Head
    end
end */

{Show {Tokenize {Lex "1 2 + 3 *"}}}


declare fun {Interpret Tokens}
      %Declaring a local functino that keepds track of current position
    local 
        fun {Interp Tokens Stack}
            %Matched on plus operator
            case Tokens of operator(type:plus)|Tail then
                local Num1 Num2 Ans PoppedStack={Pop Stack} in
                    Num1 = {Peek Stack}
                    Num2 = {Peek PoppedStack}
                    Ans = Num1 + Num2
                    {Interp {Pop Tokens} {Push {Pop PoppedStack} Ans}} %Remove the operator from Tokens and push the Ans to the dobbely popped Stack
                end
            %Matched on minus operator
            [] operator(type:minus) then
                local Num1 Num2 Ans PoppedStack={Pop Stack} in
                    Num1 = {Peek Stack}
                    Num2 = {Peek PoppedStack}
                    Ans = Num1 - Num2
                    {Interp {Pop Tokens} {Push {Pop PoppedStack} Ans}} %Remove the operator from Tokens and push the Ans to the dobbely popped Stack
                end
            %Matched on multiply operator
            [] operator(type:multiply) then
                local Num1 Num2 Ans PoppedStack={Pop Stack} in
                    Num1 = {Peek Stack}
                    Num2 = {Peek PoppedStack}
                    Ans = Num1 * Num2
                    {Interp {Pop Tokens} {Push {Pop PoppedStack} Ans}} %Remove the operator from Tokens and push the Ans to the dobbely popped Stack
                end
            %Matched on divide operator
            [] operator(type:divide) then
                local Num1 Num2 Ans PoppedStack={Pop Stack} in
                    Num1 = {Peek Stack}
                    Num2 = {Peek PoppedStack}
                    Ans = Num1 / Num2
                    {Interp {Pop Tokens} {Push {Pop PoppedStack} Ans}} %Remove the operator from Tokens and push the Ans to the dobbely popped Stack
                end
            %Could not get this to work
            /* [] number(N) then
                {System.showInfo "Matched number()"} 
                {Interp {Pop Tokens} {Push Stack N}} */ 
            %Matchin on Head|Tail, could either be a number or command
            [] Head|Tail then %Currently using this for number matching, is suboptimal, would like to use [] number(num) of some sorts
                {Show {GetValue number(N)}}
                {System.showInfo "Matched Heal|Tail"}
                {Interp {Pop Tokens} {Push Stack Head.1}} %Remove value from tokens and push it to the stack
            %End of list, return the current stack
            [] nil then 
                Stack
            end
        end
    in

    {Interp Tokens nil}
    end
end

{Show {Interpret {Tokenize {Lex "1 2 3 +"}}}}

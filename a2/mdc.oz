\insert 'C:/Datateknologi/s1/prog/TDT4165/a1/List.oz'

/*** TASK 1 ***/

%Takes a string as input and outputs an array of lexemes represented as ASCII values
declare fun {Lex Input}
    {String.tokens Input & } %Create tokens of the input split on space
end

{System.showInfo 'The string "10 2 + 3 *" gets split to:'}
{Show {Lex "10 2 + 3 *"}}


%Puts each lexeme into a record
declare fun {Tokenize Lexemes}
    case Lexemes of Head|Tail then
        if {String.isInt Head} then
            local Num in
                {String.toInt Head Num} 
                number(Num) | {Tokenize Tail} %Ez conversion from char to number by subtracting 48
            end
        elseif Head.1 == 47 then %ASCII for '/' is 47
            operator(type:divide) | {Tokenize Tail}
        elseif Head.1 == 43 then %ASCII for '+' is 43
            operator(type:plus) | {Tokenize Tail}
        elseif Head.1 == 45 then %ASCII for '-' is 45
            operator(type:minus) | {Tokenize Tail}
        elseif Head.1 == 42 then %ASCII for '*' is 42
            operator(type:multiply) | {Tokenize Tail}
        elseif Head.1 == 112 then %ASCII for 'p' is 112
            command(print) | {Tokenize Tail}
        elseif Head.1 == 100 then %ASCII for 'd' is 100
            command(duplicate) | {Tokenize Tail}
        elseif Head.1 == 105 then %ASCII for 'i' is 105
            command(invert) | {Tokenize Tail}
        elseif Head.1 == 99 then %ASCII for 'c' is 99
            command(clear) | {Tokenize Tail}
        else
            {System.showInfo "Invalid value!!!"}
        end
     [] nil then
        nil
     end
end

{Show {Tokenize {Lex "10 2 + 3 *"}}}

%The interpreting part of the calculator, manipulates a stack that is ultimately returned
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
            [] Head|Tail then %Currently using this for number and command matching, is suboptimal, would like to use [] tuple(value) of some sorts

                %The next command was a print, show the stack and continue calculating
                if Head.1 == print then
                    {Show Stack}
                    {Interp {Pop Tokens} Stack}
                %Dupliacte the top element of the stack
                elseif Head.1 == duplicate then
                    {Interp {Pop Tokens} {Push Stack Stack.1}}
                %Inverts the top element of the stack
                elseif Head.1 == invert then
                    local ToBeInverted NewStack in
                        ToBeInverted = ~ {Peek Stack}
                        NewStack = {Push {Pop Stack} ToBeInverted}
                        {Interp {Pop Tokens} NewStack}
                    end
                %Clears the stack 
                elseif Head.1 == clear then
                    {Interp {Pop Tokens} nil}
                %The next command was a number, handle correctly
                else
                    {Interp {Pop Tokens} {Push Stack Head.1}} %Remove value from tokens and push it to the stack
                end
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
{Show {Interpret {Tokenize {Lex "1 2 p 3 +"}}}}
{Show {Interpret {Tokenize {Lex "1 2 3 + d"}}}}
{Show {Interpret {Tokenize {Lex "1 2 3 + i"}}}}
{Show {Interpret {Tokenize {Lex "1 2 3 + c"}}}}


/*** TASK 2 ***/
%Converts postfix notation into an expression tree, assumes valid Tokens and no commands other than arithmetic ones 
declare fun {ExpressionTree Tokens}
    local 
        fun {ExpressionTreeInternal Tokens ExpressionStack}
            %Got a number, Push it to ExpressionStack and remove Token
            case Tokens of number(N)|Tail then
                {ExpressionTreeInternal {Pop Tokens} {Push ExpressionStack N}}
            %Got an operator, Pop two numbers from the Expression stack and Push the currect operation and numbers to ExpressionStack and remove Token
            %The other tokens that are subsequently found will wrap the ones preceeding it with a number
            [] operator(type:Op)|Tail then
                local Num1 Num2 DoublePoppedStack in
                    Num1 = {Peek ExpressionStack}
                    Num2 = {Peek {Pop ExpressionStack}}
                    DoublePoppedStack = {Pop {Pop ExpressionStack}}
                    
                    {ExpressionTreeInternal {Pop Tokens} {Push DoublePoppedStack Op(Num1 Num2)}} %An expression of type Exp(Num Num) is created first, then Exp(Num Exp) subsequently
                end
            %At the end of Tokens, return the only element that should be left in ExpressionStack 
            [] nil then
                ExpressionStack.1
            end
        end
    in
        {ExpressionTreeInternal Tokens nil}
    end
end

%{Show {ExpressionTree [number(2) number(3) operator(type:plus) number(5) operator(type:divide)]}}
{Show {ExpressionTree {Tokenize {Lex "3 10 9 * - 7 +"}}}}
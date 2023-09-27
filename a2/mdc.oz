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

{Show {Tokenize {Lex "1 2 + 3 *"}}}
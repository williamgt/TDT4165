%Takes a string as input and outputs an array of lexemes represented as ASCII values
declare fun {Lex Input}
    {String.tokens Input & } %Create tokens of the input split on space
end

{System.showInfo 'The string "1 2 + 3 *" gets split to:'}
{Show {Lex "1 2 + 3 *"}}



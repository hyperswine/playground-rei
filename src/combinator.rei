// every parser is a parser combinator
// a parser combinator is a function that takes another function and returns a function

// parser: (f: Parser) -> Parser
// parser: (f: Parser) -> (Parser, Token)

Parser: (f: Parser) -> (Parser, Token) => _

// that means the API

let a = choice(a, b)
let b = maybe(c)
let c = choice(a, b)

maybe(c)

// thats basically how you have to do it

/*
    keywords?
*/

Keyword: enum {
    Do ("do")
    While ("while")
    _
}

Keyword: extend Self {
    // another way?
    match: (input) => match {
        "do" => Do
    }
}

keyword: (input) => Keyword::match (input)

// as a "parser"

// what about "tokeniser"?
// "declarative"

/*
    megaparsec version
*/

Keyword: Do | While | _

keyword: (input: String) -> Parser[Keyword?] => match {
    "do" => Do
    "while" => While
    _ => ()
}

// every parser is a parser combinator
// a parser combinator is a function that takes another function and returns a function

// parser: (f: Parser) -> Parser
// parser: (f: Parser) -> (Parser, Token)

Parser: (f: Parser) -> (Parser, Token) => _

// that means the API

// a: 1
// this would conflict with the let binding, and would usually raise an error in meta 2
// but in meta 1, the latest definition wins
// with rei scripting, you use meta 1

let a = choice(a, b)
let b = maybe(c)
let c = choice(a, b)

maybe(c)

// thats basically how you have to do it

/*
    keywords?
*/

Keyword: enum
  Do ("do")
  While ("while")
  _


Keyword: extend Self
  // another way?
  match: (input) => match
    "do" => Do

keyword: (input) => Keyword::match (input)

// as a "parser"

// what about "tokeniser"?
// "declarative"

/*
    megaparsec version
*/

Keyword: Do | While | _

keyword: (input: String) -> Parser[Keyword?] => match
  "do" => Do
  "while" => While
  _ => ()

Grammar:
  Expr : FnExpr | LetExpr
  FnExpr : Grammar(_: "fn" ident: Ident "(" params: Param* ")")

/*
    evaluating hierarchical structures
*/

Expr: NodeType1 | NodeType2 | NodeType3

// extend Expr with another variant
NodeType4: variant Expr
  impl Extract() => true

// custom logic to match for nodes at specific conditions
// use all(a1, a2, a3)

NodeType1: impl Extract(a1, a2, a3) => a1 & a2 & a3
NodeType2: impl Extract(a2) => a2 = 0

// decompose an expr
let expr = NodeType1(NodeType2(), NodeType3([1, 2, 3]))

decompose: (expr: Expr) => match
  NodeType1


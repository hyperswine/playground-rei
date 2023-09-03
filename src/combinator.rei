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

// each term is its own variant
// either newline or space or |


// doing this would tie data to data
// Keyword: enum
//   Do ("do")
//   While ("while")
//   _

// doing this is better for loose coupling
Keyword: enum
  Do
  While

Keyword: extend Self
  // another way? Cannot match without type annotations
  match: (input: String)
    .match
      "do" => Do

keyword: (input) => Keyword.match input
// can use this too, but must provide type annotation
// keyword: (input: Keyword) => match input


// as a "parser"

// what about "tokeniser"?
// "declarative"

/*
    megaparsec version
*/

// Keyword: Do | While | _
// Note: Keyword? is interpreted by meta 0 as an optional type .......

// keyword: (input: String) -> Parser Keyword? => match
//   "do" => Do
//   "while" => While
//   _ => ()

// Grammar:
//   Expr : FnExpr | LetExpr
//   FnExpr : Grammar(_: "fn" ident: Ident "(" params: Param* ")")

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

Token: enum
  HashStart
  HashEnd
  BackTickStart
  BackTickEnd

  Identifier
  Number
  Operator // quote as well?

Refine: trait Tokens -> Tokens

// insta functions

handle_comments: impl Refine(tokens: Tokens) -> Tokens
  tokens.extract_chunks_delimited_by Token.HashStart Token.HashEnd

// remove/2 for remove: Sequence ApplyFn -> Sequence

// ignore: false
// until: x y -> bool => x == y

/*
"
a b c d e f
  afsasf

"

note you encountered a ". Then you can turn on flag
during on, consume and ignore
until find "
then filter

maybe

extract_chunks_delimited_by
*/

// when find start_element
extract_chunks_delimited_by: (sequence start_element end_element) -> (Seq, Seq Seq)
  res: Seq
  res2: Seq Seq
  flag: false

  seq
    loop i elem in sequence
      elem = start_element ?:
        set flag true
        res2.push []
      flag = true and elem = end_element ?: set flag false
      flag ?
        res.push elem :
        res2.last.push elem

    (res, res2)

// if you want seq loop, just use seq_loop pls
// or (seq loop) ?

// parse prolog

// rei syntax 1. With regex"" strings or Regex ""
Token: enum
  LParen: '('
  RParen: ')'
  LBracket: '['
  RBracket: ']'
  RBrace: '}'
  Comma: ','
  Semicolon: ';'
  Period: '.'
  Definition: ':-'

  // keywords: none because prolog
  // but there are identifiers
  Identifier: r"[a-zA-Z_][a-zA-Z0-9_]*"

  // literals
  Integer: regex "[0-9]+"
  Float: regex "[0-9]+\.[0-9]+"
  String: regex "'[^']*'"

  // operators
  Operator: regex "[\+\-\*\/\%\=\>\<\!\&\|]+"

  // comments
  Comment: regex "%[^\n]*"

  // whitespace
  Whitespace: regex "[ \t\n]+"

  Indent
  DeIndent

// to generate a lexer, convert each regex to a DFA, then combine them into a single DFA
// also need to handle conflicts where one regex is a prefix of another. Just take the longest match

// now parse clauses and such

// in rei, the "=" means unification, not assignment per se, but can be used as assignment in some cases
// the "let x = ..." means binding
// the "=>" means evaluation
// the ":" means assignment and definition
// mutation of data is usually done in a controlled way, e.g. with a "set" function

// in hprolog, a dialect of prolog, there are some modern syntax
// x(T) :- t(T).
// can also be represented as
// x T <- t T or x T :- t T

// program = clause*

// clause = head Definition body Period

// head = Identifier args

// args = LParen RParen | LParen arglist RParen

// arglist = arg | arg Comma arglist

// arg = Identifier | Integer | Float | String

// things like scientific notation, e.g. 10e10 can be treated as an operator expression

// main syntax of prolog, not including syntax enhancements

Structure: enum
  Program: [Clause]
  Clause: Head Body
  Head: ??
  Body: [Form]

  Atom: Identifier | Integer | Float | String | Operator
  Form: Atom | ParenForm | BracketForm | BraceForm
  ParenForm: LParen Form RParen

program: clause*

seq-parse: ?? -> Structure
// basically, it takes a list of metaobjects and tries to find the <$> X to map or maybe the =>
// or just considers the last expression to be the return value

// i think its illegal to use head: and body: outside of the scope
// so use a mapper
// or return the Structure at the end of seq-parse using fmap
/*
clause: String -> Structure
  seq-parse
    head: head
    Definition
    body: body
    Period
    <$> Structure.Clause head body
*/

clause: String -> Structure
  seq-parse
    head: head
    Definition
    body: body
    Period
  Structure.Clause head body

head: String -> Structure
  seq-parse
    Identifier
    args: args
  Structure.Head Identifier args

body: String -> Structure
  forms |> Structure.Body

form: String -> Structure => atom | parenform | bracketform | braceform

forms_sep_by_comma: String -> [Structure]
  sep_by Comma form

// custom operators and heads could look like
// x([H|T]) :- x(T).
// x([]) :- true.
// xyz(y(x), [], (x;y), y/z) :- true.
// so args and stuff contained within parens arent exactly as simple as just a list of args

// almost anything. Basically a form I think
arg: String -> Structure => form

args: String -> [Structure]
  seq-parse
    LParen
    args: args_sep_by_comma
    RParen
  Args args

args_sep_by_comma: String -> [Structure]
  sep_by Comma arg

parenform: String -> Structure
  seq-parse
    LParen
    form: form
    RParen
  Structure.ParenForm form

// how much granularity and imposition do we want?
// probably forms as the body and args

// includes literals, identifiers, operators
atom: String -> Structure => Identifier | Integer | Float | String | Operator

atoms: String -> [Structure] => map (many atom) Atom

// now we have a pretty abstract structure we can interpret


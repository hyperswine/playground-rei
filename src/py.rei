// maybe use std.parse
use std.parse

# maybe keyword basically allows us to not include or compile if we dont have to

# list sequence vs application sequence

Token: enum
  // Def: const "def"
  Def: "def"
  Return: "return"
  Identifier: String
  Literal: String | Numeric
  Operators: String

Rest: Class | Function | Assignment | Atom

Class: Class, Identifier ident, Operators ":", Function...

Atom: Identifier | Literal

Function: Def, Identifier ident, Params, (Operators ":"), Body

Params: (Operators "("), Args, (Operators ")")

Args: Atom...

Body: Rest...

# uhh
// X: "x"
# can mean X: String "x"
# or X: const "x"
# or X: (const String "x")
# without a String "..."
# for "defaults", can use =? or X: default "x"
# maybe =? or ?=
# X: ?="x"
# ?: is elvis unfornatuately.. so mayube ?; instead for elvis
# then ?: for default?

# or ?? for evlis
# x ?? 2
# if x is Some or true, then x, else 2
# in core or std only defined on those two...

# (x : Int ?: 2)
# x ?: 2
# or :?
# x :? 2

# and : for regular keyword args

# f(x:3333333)

# will get converted to implicit (Numeric 555555)

X: implicit 555555

let
  x: +

# will return ??
# yes thats right, the + function itself

# unless you specify that it should be int
# then it will use the implicit

let
  x: (+: Numeric)

# it sees if its satisfiable. If it is, it will satisfy
# note, this can potentially lead to a lot of unexpected behavior if you are not careful
# rei is meant to be a highly careful language

# use implicit then default ...?
# need to be very careful. Many have default constructors that take no params
# and you will be warned

# otherwise it should be partial...
# no default constructors... unless you use the Default trait or function or method

X.default

default X

# can be overrided perhaps ...

X: String "X"

// what does this mean?

// it means exactly what it is I guess

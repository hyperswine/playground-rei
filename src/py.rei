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

# (x : Int ?: 2)
# x ?: 2
# or :?
# x :? 2

# and : for regular keyword args

# f(x:3333333)

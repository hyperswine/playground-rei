# Playground for Rei

Notebooks and scripts.

How to model the concept of metaprogramming and metacomputing?

Build from standard models and interactions. So standard nodes and edges??

A node that represents a CFG. Which represents the base grammar or syntactical structure. An edge that leads to a node that represents a meta language which BUILDS or uses the CFG in a higher order manner.

Instead of being quantified over just things like... Idk Variables and stuff. We have more "things". That can be ambigious. And we need "context" to clarify the ambiguity. If we cant clarify, we can either choose to error or just return that and refuse to evaluate further ....

```rust
meta a:
	ident: a
	type: function
```

You can match on strings in some interesting ways.

```rust
match a.ident
    [Capital(x)..] => ...
    _ => _

match a.ident
    r"[A-Z].*" => ...
    // warning, non exhaustive, if no matches found, nothing will happen and the entire expression will early terminate. It will auto log as well by default...
```

How about matching on the structure of the expression? Uhh maybe not?
You can match on the semantics kinda.

Like

```rust
match a.fields
    0 => Empty
    1 => One
    _ => Multiple
```

If it cant find an identifier, it will also do the same thing. Log an unidentified identifier and early terminate. And possibly highlight them too.

NOTE. Some things can be "erased" or "compile time" evaluated if you include a "pre-evaluate" pass.

```rust
Format: trait
    format_type: Type
    // sugar for (): () = ?
    apply: () -> String

FormatType: Pretty | Debug

A: impl Format
    format_type: Debug
    apply: () -> String = String::from_fields(self.fields)
```

QUICKER WAY:

```rust
FormatType: Pretty | Debug
Format: trait (Type) -> String
A: impl Format (Type) -> String = match
    Debug => String::from_fields(self.fields)
```

OR

```rust
Format: trait
    apply: (format_type: FormatType) -> String

FormatType: Debug | Pretty

A: {}

A: impl Format
    apply: (format_type: FormatType) -> String = match format_type
        Debug => String::from_fields(self.fields)

print(A()) // prints the debug version

// extend the base sum type with another variant
FormatType: extend
    All
```

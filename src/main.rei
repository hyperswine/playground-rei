main: () => ()

// node based execution

Node: Compute | Data

Compute: [Instruction]

Compute: extend {
    (self) => self.map(ins => ins())
}

Instruction: Dest

Instruction: enum {
    Binary: std::ops::Add | std::ops::Sub
    Push = storage.push
}

Binary: Op, SrcAddress1, SrcAddress2, DestAddress
Push: ValAddress, StackAddress
Copy: SrcAddress, DestAddress

Instruction: extend {
    // op: (self) => self
}

ComputeUnit: {
    memory: Memory
    queue_writer: QueueWriter
    queue: Queue

    // attempt to call (). Only possible when enum variant is of type ()
    (self, instruction) => match instruction {
        // notice you are directly doing self.memory[dest] instead of using queuewriter
        // 3 args of that specific type is inferrable. Now there is varargs too but...
        Binary (op, src1, src2, dest) => self.queue(op, self.memory(src1), self.memory(src2))
        Push (val_addr, stack_addr) => self.queue(self.memory[val_addr])
    }

    // now a way to optimise is to assign different NUMA domains to each queue and run each in a map
    clock: () => queue_writer(self.queue, self.memory)
}

Queue: [(Op, Lhs, Rhs, Dest)]

// generally, a queue writer exists for a certain NUMA node
QueueWriter: {
    (queue: Queue, memory_zone: Memory) => memory_zone[index] = compute(queue.pop())

    compute: (op, lhs, rhs) => op(lhs, rhs)
}

/*
    when in doubt, do everything in one go
*/

// how to make parallelism work?

/*
    Model B
*/

ExecutionContext: Compute

// try to run everything

Main: Compute

run: (main: Main) => main()

/*
    Glyphs
*/

// for all identifiers, convert to a single glyph from the function

get_glyph: (ident: Ident) => glyphs[ident] ?: glyphs.generate(ident)

// what about {} braces? umm, depends. If it can be reduced to a single thing, like (), then reduce it completely to nothing

// what about () parens? and => and certain things like ?:
// I guess you can tokenise and convert them into a single glyph that represents it to keep the logic
// (params) can also be kept but shrunk, : can be kept

/*
    VC Parser
*/

// HERE, all whitespaces including newlines, tabs, spaces, carriages are ignored
// each time a parser is called, we ignore the next set of ws

// basically calls trim_next_ws
// which skips to the next non ws CHAR!!!!!

Token: enum {
    Ident
    Literal
}

alphanumeric: (input: String) -> Parser => choice(letter, digit)

parse_ident: (input: String) -> Parser {
    letter(input).then(zero_or_more(alphanumeric))
}

// how do you know what the behavior of then and or is?
// then should die / everything should return before that
// or only works if prev is Some
// so it should be Fn[String, Parser[Res])]
// and dont implement Parser[None] for or?, yea just return None

// 1. choice() -> Parser[None]

ParserRes: Parser | Error

ParserRes: impl Parse {
    choice: (self, parsers: Fn[String, Parser]...) -> ParserRes {
        parsers.find(p => p())
    }
}

// then().then().is().or()
// choice(is())

Parser: {
    choice: (Fn[String, Parser]) -> Parser => _
    zero_or_more: (Fn[String, Parser]) -> Parser => _

    then: (Fn[String, Parser]) -> Parser => _
    choice: (parsers: Fn[String, Parser]...) -> Parser {
        parsers.find(p => p())
    }
}

Parser[r: Res]: {
    choice[r: Res]: (Fn[String, Parser]) -> Parser => _
    zero_or_more[r: Res]: (Fn[String, Parser]) -> Parser => _

    then[r: Res]: (Fn[String, Parser]) -> Parser => _
    choice[r: Res]: (parsers: Fn[String, Parser]...) -> Parser => match r {
        Ok => Self()
        None => f
        Error => error()
    }
}

// so early return is a thing on my end I guess
// we either have a dependent type or a type parameter and a param of that lOL!
// then we can use that as a match
// or something idk

// Parser: ()
Parser: Fn[String, Self]

// how do we call .zero_or_more()?


// its (String) -> Parser
// to be able to "chain"
// maybe return a Fn??
// uhh

// so then should be implicit. But or shouldnt

/*
* -> zero_or_more
+ -> one_or_more
? -> maybe
[] (|) -> choice
*/

// should input be at the first or last? should it even exist

Fn[T, R]: trait(T) -> R

/*
    Lowering
*/

Node: Compute | Data

Rhs: Integer | Ident | Call

Rhs: extend {
    in: (self, s: String) -> bool {
        match self {
            Integer _ => false
            Ident i => s == i
            Call (name, args) => {
                // assume no higher order functions for now

                args.iter(i => s in i)
            }

        }
    }

    do: (self, s: String) => match self {
        Integer _ => false
        Ident i => s == i
        Call (name, args) => {
            args.map(i => s.do(i))
        }
    }
}

Ident: String

Call: {
    name: String
    args: [Rhs]
}

// name: (params*) => rhs*
lower_fn_def: (node_list: _, name: String, params: [String], rhs: Rhs) -> Node {
    match rhs {
        Integer (i) => Data(i)
        // assume ident always integer for now
        // wait this could also be used as the final thing for processing arg though
        // yea dont find maybe? if name == i, otherwise find
        Ident (i) => {
            Data(symbols.find(i))
        }
        Call (name, args) {
            // params.filter(p in args)
            params.map(p => args.do(p))
        }
    }
}

primitive_node_list: [
    Node("add"),
    Node("sub")
]

eval: (node_list: _, expr: _) -> Int {
    match expr {
        Call (name, args) {
            node_list.find(name).compute(args)
        }
    }
}

exprs: () -> Parser[[Symbol]] => expr().repeated()

expr: () -> Parser[Symbol] {
    fn_def().or(call).or(ident).or(integer)
}

// rhs is also a symbol for fn def

params: () => ident.separated_by(Comma)

fn_def: () => ident
                .then(Colon)
                .then(params)
                .then(call().or(ident).or(integer))
                .map((name, _params, _rhs) => Symbol::Fn(name, _params, _rhs))

call: () => ident
                .then(call().or(ident).or(integer))
                .separated_by(Comma)
                .delimited_by(LParen, RParen)
                .map((name, args) => Symbol::Call(name, args))

Parser: {
    parse: (self, String) => _
}

lower: (Symbol) -> Node => match {
    Fn (name, params, rhs) => Node::Compute(name, ?)
    Call (name, args) => ?
    // so one of the things was if it matches, then link, or else find
    Ident (name) => Node::Data(resolve_ident(name))
    Integer (int) => Node::Data(int)
}

resolve_ident: (String) -> Integer => symbols.first(symbol => match {
    Ident (i) => true
    _ => false
})

// rhs is of type Symbol

SymbolList: [(String, Symbol)]

create_node: (symbol: Symbol, symbol_list: SymbolList, call_args: [Symbol]?) -> Node {
    match symbol {
        Call (fn_name, args) => {
            let fn_def: Fn = symbol_list.find_symbol(fn_name)
            Node::Compute(fn_name, create_node(fn_def, symbol_list, call_args))
        }
        Fn (fn_name, params, rhs) => {
            let lowered_rhs = create_node(rhs, symbol_list)
            // implement me, if call_args is not empty, use it instead of params

            Node::Compute(fn_name, params.map(param => create_node(param, symbol_list)).append(lowered_rhs))
        }
        Ident (name) => create_node(symbol_list.find_symbol(name), symbol_list)
        Integer (int) => Node::Data(int)
    }
}

Node: enum {
    Data: Int
    Compute: (String, Vec<Node>)
}

NodeList: [(String, Node)]

NodeList: extend {
    find_node: (self, name: String) -> Node {
        self.find((_name, node) => name == _name)[1]
    }
}

Env: {
    symbol_list: SymbolList,
    node_list: NodeList
}

execute: (node: Node, env: Env) -> Node {
    match node {
        Compute (fn_name, args) => {
            let fn_node = env.node_list.find_node(fn_name)
            match fn_node {
                Compute (fn_name, params_and_rhs) => {
                    // implement me
                }
                _ => panic("Function name not found.")
            }
        }
        Data (data) => Node::Data(data)
    }
}

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

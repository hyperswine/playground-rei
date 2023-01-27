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

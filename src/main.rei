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

    // attempt to call (). Only possible when enum variant is of type ()
    (self, instruction) => match instruction {
        Binary (op, src1, src2, dest) => self.memory[dest] = op(self.memory(src1), self.memory(src2))
        Push (val_addr, stack_addr) => self.memory[stack_addr].push(self.memory[val_addr])
    }
}

Queue: [Op Lhs Rhs]

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

// try to run everything

Main: Compute

run: (main: Main) => main()

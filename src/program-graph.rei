# everything is a program and can be run as a lightweight thread...
# so its thing is a thing?
Program:
  inputs: Input
  primitive: Primitive
  // always do a copy of each to each program outnode...
  out_links: [Program]

# the primitive might decide to spawn a new program, causing a new subgraph...
# otherwise, we just do the out_links
# once no more out_links, just stop there at that thread

// : is strongly bound
# so we have 3 bind groups P (...), (...) R (...), (...) W
// problem is if Read is already defined, then this will shadow it, kinda
// you still need to do Primitive.Read and stuff
// if you have conflicting... just highlight and press a button to auto parenthesise...
// control p
Primitive: (Read: Memory) | (Write: Memory)

// so a big thing is the concept of conflicting names
// when a conflicting name is brought up in meta 1, the most recent is chosen
// when in meta 2, it just errors and tells you about the different ones available that you have to do...

// how to run??
// note, the () is not needed because of the strong binding within a subsequence
// in the main sequence, it is weakly binding?
// wait idk, maybe not
run: (program: Program) -> ()
  # very common thing, see if something actually computes to a value rather than throw an effect or return None or Error
  # in meta 2, this should prob be used in this specific way
  result: execute program.primitive
    map run program.out_links


// there might be issues with use...
// or multiple thingys like
// x: (A) -> _               not ??, but _. In this case you can only call with x(A) and give you a warning
// A: {x}

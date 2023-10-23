So one of the things I noticed is that

the x in ... thing is very usefu;

so like the Exists or Error/Extinct/None ...

PATTERN.

```
x: some_stuff
    // if exists
    // do stuff
// otherwise, nothing happens
```

we can also do the effect matcher before hand

```
f: (throws Eff1, Eff2) (gg) -> Stuff
    println("hi") // performs a GlobalMemoryWrite Effect ..., handled from base... and attached before hand kind of...

```

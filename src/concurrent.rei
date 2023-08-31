X: autoimpl(Copy) => ()

# = is the set or mutate operator
# everything is backed by metaobjects
y: 1

f: transact seq ()
    x = 2 + y # will read
    y = x + 1 # will write. Will compare y with old value like 1, if it has changed, then someone else messed with it
              # in that case, will basically retry and might send a signal to the signaller system

g: transact seq ()
    y = y + 1
    y = y + 2

f()
g()

// doesnt exist, will simply evaluate to "Doesn't Exist" and signal the signaller
// signaller may then decide to look at identifiers close to h that are functions and SUGGEST da stuff
h()

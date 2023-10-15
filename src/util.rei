ExecutionTask:
  Ret: Type
  value: Ret?
  name: String
  task: [Any] -> Ret

execute: (args, task: ExecutionTask) => task.task args
// value-dependent type, execute.
execute: (args, task: ExecutionTask {Ret:String}) => task.task args

// how to do default arguments? use =
f: (a: String="hi") -> ...
// in this context, rei can actually figure out your not trying to check equivalence...


// when you make this, it becomes
/*
  GraphicsData:
    width: Numeric 0
    height: Numeric 0
    title: String ""
*/
GraphicsData:
  width: Numeric
  height: Numeric
  title: String

// Layout: Box Box Box
// this basically means, return a "_" or slot?
// Flex: (direction, children...) -> Element => _
Flex: (direction, children...) -> Element

// now the issue with that Flex: (direction, children...) -> Element is that you can actually overload it too
// and rei wont complain
Flex: (direction) -> Element

// now you have to match either one...

// like map maybe
// instead of setting a variable you could just pass a _ that does something

// how to do dataflow pass?

Layout: Flex
  Column
  Text "Lorem..."

FlexRow: Flex (direction =Row)

# in meta 2, (text: String) is a parameter pack?
# maybe, if you want to use it like that
Layout: (text: String) -> FlexRow
  Text text

// what about up? uhh
// dont
// or use a function

Element: (on_click, ...) => _

// Text(on_click = set_state(x))

// when the text changes or is clicked, this function is called
// then you can do things with it I guess
layout_text: () -> Text "Changed!!"

Layout: (text: String) -> FlexRow
  Text layout_text
  Text text (on_click:layout_text)

# the = binds hard?

// maybe force some stuff like keyword args to be used with keywords
// so no position when you have a default
// maybe FRP
// the equals just returns ()?
// maybe in cells you can also echo or have on the sidebar

// it never copies, always passes by ownership

change_text: (text) -> () => (text: "Changed!!")

change_text: () -> Text => yield Text "Changed!!"

change_text: () -> Text => yield "Changed!!"

LayoutText: "Click Me"

Layout: FlexRow
  Text LayoutText (on_click:change_text)

// the effect fn should be placed from the parent
// so it could resume the parent
Element (on_click: EffectFn)

LayoutText: "Click Me"

// the yield keyword identifies the function as a generator
// so you can resume
// ... prob like
// a circular edge?
// change_text: () => yield Text "Changed!!"

Layout: FlexRow
  Text LayoutText (on_click:change_text)

// it actually works with functions too, cause you are copying the local vars, kind lazily...
change_then_resume:
  res: change_text
  resume res

// problem is, how do things work? when you call, does that clone the caller function? but not the args
// if you want, maybe copy semantics works too
// or the clone command like

x: y -> ??
  x: clone y

// so you have to explicitly clone
// or define your own "cloner"

Cloner: trait (T: Type) (var: T) -> T

// when you do, in meta 2 std, it actually works
// Y: impl Cloner (var: T) -> T

impl Cloner (T: Y) (var: T) -> T
  res: Y ((clone var.v) + 1) ...
  res.v += 2
  res

// the ... syntax can probably be used this way...

// hyper types

// (+=): trait Infix 10 (arg1, arg2) -> T
(+=): trait (Infix 10) (T: Type, arg1, arg2) -> ()

// note -> is weak binding
// which can create some issues lol, but not as weak as application prob

// maybe if no type is specified, dont matter
// Numeric: impl (+=) (arg1, arg2) -> T
// just sugar... lol !!!  fuck

// this will just work
Numeric: impl (+=) (Self, arg1, arg2) -> ()
  arg1: arg1 + arg2

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
Flex (direction, children...) -> Element: _

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
change_text () -> yield Text: "Changed!!"

Layout: FlexRow
  Text LayoutText (on_click:change_text)


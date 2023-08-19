# THIS FILE DEFINES A LIBRARY TARGET

// Get started: Add a module with name api with mkdir src/api
// And add a mod.rei file to it. Watch it Rein

ExecutionTask: {
    Ret: Type
    value: Ret?
    name: String
    task: [Any] -> Ret
}

execute (args, task: ExecutionTask): task.task(args)

GraphicsData: {
    width: Int
    height: Int
    title: String
}

// Layout: Box Box Box
Flex (direction, children...) -> Element: _

Layout: Flex(
    Column,
    Text("Lorem..."),
)

FlexRow: Flex(Row)

Layout (text: String): FlexRow(
    Text(text)
)

// what about up? uhh
// dont
// or use a function

Element (on_click, ...): _

// Text(on_click = set_state(x))

// when the text changes or is clicked, this function is called
// then you can do things with it I guess
layout_text () -> Text: "Changed!!"

Layout (text: String): FlexRow(
    Text(layout_text)

    Text(text, on_click=layout_text)
)

// maybe force some stuff like keyword args to be used with keywords
// so no position when you have a default
// maybe FRP
// the equals just returns ()?
// maybe in cells you can also echo or have on the sidebar

change_text (text) -> Text: text = "Changed!!"

change_text () -> yield Text: "Changed!!"

change_text () -> Text: yield "Changed!!"

LayoutText: "Click Me"

Layout: FlexRow(
    Text(LayoutText, on_click=change_text)
)

// the effect fn should be placed from the parent
// so it could resume the parent
Element (on_click: EffectFn)

LayoutText: "Click Me"

// the yield keyword identifies the function as a generator
change_text () -> yield Text: "Changed!!"

Layout: FlexRow(
    Text(LayoutText, on_click=change_text)
)

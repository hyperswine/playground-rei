use web

// relation def
// main init update subscriptions view <- init, update, subscriptions, view
// function def
main => init, update, subscriptions, view

// schemas, not types
// Model: Failure | Loading | Success Quote
model: failure | loading | success Quote

// means model should be of the schema Model
// expect (model: Model)

quote: {Quote: str, Source: str, Author: str, Year: int}

// init <- Loading getrandomquote

init => <loading, getrandomquote>

update moreplease Model => <loading, getrandomquote>
update gotquote (ok Result) => <quote, none>
update gotquote err => <failure, none>

subscriptions Model => none

// can use newlines as , separators in rei
// if there is not already a , before it. Function calls must be on the same line like map f g.
// if you want different lines you can do map f\\n g
view Model =>
  div []\
    [ h2 [] [ text "Random Quotes" ]
      viewquote Model ]

// so thing to get used to is that some funcs can return divs or coarser things
// and can be composed with things above
viewquote failure => div []\
  [ text "I could not load a quote"
    button [onclick moreplease] [ text "Try Again" ]]
viewquote loading => text "Loading....."
success quote => div []\
  [ button [onclick moreplease, style display.block] [text "More Please!"]
    blockquote [] [text quote.quote]
    p $ style text-align.right $ text "- ", cite [] [text quote.source], text (" by" + quote.author + " (" + fromint quote.year ++ ")")
  ]

getrandomquote => web.get "example.com/quotes"

quotedecoder => map4 $ quote ("quote" string) ("source" string) ("author" string) ("year" int)

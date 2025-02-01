use Web

// relation def
// main init update subscriptions view <- init, update, subscriptions, view
// function def
main => init, update, subscriptions, view

// schemas, not types
Model: Failure | Loading | Success Quote

// means model should be of the schema Model
// expect (model: Model)

Quote: {quote: String, source: String, author: String, year: Int}

// init <- Loading getrandomquote

init => <Loading, getrandomquote>

update MorePlease model => <Loading, getrandomquote>
update GotQuote (Ok result) => <quote, none>
update GotQuote Err => <Failure, none>

subscriptions model => none

view model =>
  div []
    [ h2 [] []]
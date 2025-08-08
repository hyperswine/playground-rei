Note:

# can use type or name
title = name.
content = name.
tags = name.

# one way to define examples
examples =
 [[title, "hi"], [content, "this some content"], [tags, "hi", "bye"],
  # notice how we are not using an outer list if not necessary to wrap each note. We know there is exactly 3, so stride = 3
  [title, "my note"], [content, "to do tommorow"], [tags, "todo"]].

Examples:
# but this is the preferred way

titles = [title, "hi", title, "my note"].
contents = [content, "this some content", content, "to do tommorow"].
tags = [tag, "hi", "bye", tag, "todo"].

title = extract-seq Note.title.
content = extract-seq Note.content.
tags = extract-seq Note.tags.

notes = zip [titles, contents, tags].

UI:

use Examples.[title, content, tags].
use std.UI.box.

box₂ = box [].

vstack = stack vertical.
// stack = combine [title, content, tags] |> rest.
stack = box₂ [(title |> text [bg white, textcolor black]), (content |> text [size.horizontal full]), (tags |> map text [textcolor red] |> fold box₂)].

# notes = zip Examples.titles Examples.contents Examples.tags

main = vstack Examples.notes.

# renders it in wahtever context, like in an IDE, will show simple PNG, if in terminal shows simple TUI or ascii art
>> render main.

// greater than is defined as greaterthan x y = y > x. If you want you can do swap greaterthan to do x > y
> = greaterthan.

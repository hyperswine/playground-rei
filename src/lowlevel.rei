Mod1:

# button : Stream Bool
button = read "/dev/button" |> debounce (ms 300).

# solenoid : ()
solenoid = button |> cache |> write "/dev/solenoid".

Mod2:

strings/0 : List ??.
strings = read "/dev/guitar/strings".

# stride length is 2, expected data like <strength> (1-100), <string>, <fret>
# play 3 notes, then one note. Timing depends on the actual guitar so it happens on demand
example-data = [[100, E4, 1, 20, E4, 1, 50, F4, 2], [100, E4, 1]].

transform = std.dac.transform.

play-sound = transform example-data |> write "/dev/speakers".

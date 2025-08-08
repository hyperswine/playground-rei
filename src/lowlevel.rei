# button : Stream Bool
button = read "/dev/button" |> debounce (ms 300).

# solenoid : ()
solenoid = button |> cache |> write "/dev/solenoid".

Mod1:

base = ["a", "b", "c"].

Spk = Spikey.
Shv = Shoveler.
Car = Carrier.
Hcr = Hatcher.

# +/1 actually works
+ a = + a _.

Upgrades:

[Spk, Shv, Car] = Mod1.[Spk, Shv, Car].

up Spk = [+ 1, + 2, + 4, + 1].
up Shv = [+ 1, + 3, + 6, + 6].
up Car = [+ 1, + 5, + 10, + 10].

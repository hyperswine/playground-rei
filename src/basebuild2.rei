mod Buildings:

# short for Hatcher = "Hatcher".
# Hatcher.
# Spiker.
# Shiver.
# Carrier.

Spk = Spikey.
Shv = Shoveler.
Car = Carrier.
Hcr = Hatcher.

mod Base:

# building-names = ["Hatcher", "Spiker", "Shiver", "Carrier"].
# bs = building-names.

/*
  Bases, Monsters / Units, Upgrades, Models and Animations
  Player upgrade units, place buildings, research upgrades, attack bases
*/

# up = upgrade.

# upgrade Spk = {Spk, lvl + 1, spd + 2, atk + 4, hp + 1}.

mod Upgrade:

up1 = Spk ?> [+ 1, + 2, + 4, + 1].
up2 = Shv ?> [+ 1, + 3, + 6, + 6].
up3 = Car ?> [+ 1, + 5, + 10, + 10].

mod Upgrades:

up = try all Upgrade.

mod Main:

>> up Spk [1, 1, 2, 3].

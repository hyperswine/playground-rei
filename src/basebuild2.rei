mod Buildings:

# short for Hatcher = "Hatcher".
Hatcher.
Spiker.
Shiver.
Carrier.

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

up = upgrade.

upgrade Spk = {Spk, lvl + 1, spd + 2, atk + 4, hp + 1}.

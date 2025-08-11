Faction:

# prelude.name is like an identifier monadic safe function

FederationVI = name. # do what you want, put effort into one methodology
SilverAngels = name. # elv-ish human
InsectoidPrime = name. # insectoid, battle a lot
Anguards = name. # robo and human
SouthernEmpire = name. # conquer hard, battle a lot
Junkers = name. # explore hard

Resource:

# universal, used to trade and buy units and buildings outright
Gold = name.
# universal, crucial to anguards, power buildings and tech research
Electricity = name.
# universal, for feeding pop and maintaining happiness
Food = name.
# universal, for construction of buildings
Steel = name.
# universal, for powering early vehicles and producing some energy (hidden)
Oil = name.

Building:

# the main headquarters
HQ = name.
# access the map
MapHall = name.
# outpost HQ
Outpost = name.

# can build multiple of the following

# train and house units in a settlement, or outpost
# works for outposts too
Barracks = name.

# things like steel and food extraction, gold elec extraction
# ResourceExtractor = name.

# early energy generation
Windmill = name.

# if placed on land, will be typical. If placed on water with Oil Rig tech then becomes oil rig
OilDriller = name.

# most factions have a wall. It is continuous, like from (x,y) to (x', y')
# can be upgraded into better stronger walls, crucial for settlements and mid game where people will creep up on you
Wall = name.

# keep knowledge and research, early research insitution and makes and keeps citizens skilled
Library = name.

# heavy research institute, requires a lot of energy, primary research institution for new things
Institute = name.

SilverAngels.Building:

# psi point generaion
Psilon = name.

Map:

Setting = Name.

Turn = name.
turn x = [Turn, x].
normal = name.

default = [map normal, turn 1000, players 6].

generate-map (settings : List Setting) = process settings |> rand climate |> rand areas |> rand spawnpoints.

new faction (settings <- default) = generate-map settings |> setup-player faction |> ??.

Intro:

# play plays then returns true
# proj: is the url of the project
show-intro-scene = play $ proj "/vid/intro.mp4".

main = show-intro-scene |> opening.

opening = WithAdvisor intro-game-scene.

show-advisor = ??.

intro-game-scene = Map.new (player <- FederationVI) *.

# create a new scene with the advisor helping out
WithAdvisor scene = Scene.new (scene <- show-advisor scene).

Advisor:

# Event-driven reactions
on intro-scene-complete = show advisor-panel |> speak "Welcome to Terra II, Commander".
on first-hq-built = speak "Excellent! Now let's establish our first outpost".
on first-combat = speak "Enemy contact! Remember to use cover effectively".
on weather-warning = speak "Dust storm incoming - recall exposed units".

# Contextual positioning
when dialog-open = position advisor left-side.
when menu-open = position advisor right-side.
when map-view = position advisor bottom-right.

# State-aware suggestions
when low-resources = suggest "Consider establishing mining outposts".
when enemy-nearby = suggest "Fortify your borders or prepare for battle".
when uv-high-approaching = suggest "Research UV protection or prepare shelters".

FederationVI.Advisor = diplomatic-tone |> suggests-balanced-approach.
SouthernEmpire.Advisor = military-tone |> suggests-aggressive-tactics.

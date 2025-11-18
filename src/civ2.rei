Units:

??

Logic:

move Unit Place = ??

attack Unit Unit = ??

UILogic:

# if attempt to get unit to interact with a tile, can move if empty. otherwise if not empty but has enemy, attack
interact = ??

Logic.2:

# declare as meaningful tags
food.
iron.

Units.2:

barbarian.
coilgunner.
railgunner.
driver.

UILogic.2:

interact Unit Tile Game =
  U = unit-on-tile Tile Game,
  match U with
    I? -> attack Unit I,
    none -> move Unit Tile
  end.

Logic.3:

game.
spec game = [player-id, ??].

spec build = [builder, building, tile, game] -> game.

# build Builder hq Tile Game | tile-empty Tile Tiles = tile-replace [hp, player-id, hq] Tile Game.
# build Builder farm Tile Game | tile-empty Tile Tiles = tile-replace [hp, player-id, farm] Tile Game.

# farms can only be built on grassland
build Builder farm Tile Game | tile-empty Tile Tiles, tile-thing Tile ≡ grassland = Ok $ tile-replace [hp, player-id, farm] Tile Game.
                             | otherwise = none.

# for standard buildings
build Builder Building Tile Game | tile-empty Tile Tiles = tile-replace [hp, player-id, Building] Tile Game.

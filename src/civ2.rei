Units:

??

Logic:

move Unit Place = ??

attack Unit Unit = ??

UILogic:

# if attempt to get unit to interact with a tile, can move if empty. otherwise if not empty but has enemy, attack
interact = ??

Logic.2:

food.
iron.

Units.2:

barbarian.
coilgunner.
railgunner.
driver.

UILogic.2:

interact [unit, Unit] [tile, Tile] =
  U = unit-on-tile tile,
  match U with
    I? -> attack Unit I,
    none -> move Unit Tile.

Logic.3:

# build [builder, Builder] hq [tile, Tile] [tiles, Tiles] | tile-empty Tile Tiles = insert [hq, player-id, Tile] Tiles.

game.
spec game = [player-id, ??].

spec build = [builder, hq, tile, game] -> game.
build Builder hq Tile Game | tile-empty Tile Tiles = replace [hp, player-id, Tile] Game.

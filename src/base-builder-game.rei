/*
  FRP
  module based
  and so on
*/

InputPhysics:

  key : Key → Int

  key W = listen 'W' ? 1 ; 0
  key S = listen 'S' ? 1 ; 0

  accel = key W - key S
  vel = integrate accel
  pos = integrate vel

  integrate dt val dval = val + dt × dval

Entity:

  Hostility: Player | Enemy | AI

  Building: Hatcher | ResearchFacility | Barracks | MapRoom | Wall | Headquarters

  HQ = Headquarters
  B = Barracks
  H = Hatcher
  RF = ResearchFacility

  Unit: Spikey | Car | Shoveler

  Spk = Spikey
  Shv = Shoveler

  // selection function for raycasts, what happens when you click on them
  select (BaseScene scene) (Hatcher available-units) = available-units
  select (BaseScene scene) (ResearchFacility available-upgrades) = available-upgrades
  ...

  // upgrade {unit: Spikey, level: lvl, speed: spd, attack: atk, hitpoints: hp} = {unit: Spikey, level: lvl+1, spd + 2, atk +4}
  upgrade {Spk, lvl, spd, atk, hitpoints: hp} = {Spk, lvl+1, spd + 2, atk + 4, hp + 1}
  upgrade {Shv, lvl, spd, atk, hitpoints: hp} = {Shv, lvl+1, spd + 10, atk + 5, hp + 100}
  upgrade {Car, lvl, spd, atk, hitpoints: hp} = {Car, lvl+1, spd + 50, atk + 10, hp + 200}

Graphic:
  use std.graphics.raycast
  use std.Id

  Animation: ??

  Mesh: (List Vertex) (List Texture)
  Entity: { id: Id, mesh: Mesh }

  raycast-select : Scene → List Entity
  raycast-select scene = raycast scene

  view : Model → Frame
  view {BaseScene, buildings@[Hatcher posx posy ...], Camera rot pos} =
    map-m_ render buildings empty-frame |> render-frustum Camera rot pos

UnitBehavior:

  dtv = direction-to-vector

  move unit@(Spk | Shv | Car) dir =
    let accel = dtv $ dir × unit.speed
        vel = integrate accel
        pos = integrate vel
    in { unit with pos }

  attack unit@(Spk | Shv | Car) target = inrange unit target ? Cmd.Attack target.id ; Cmd.MoveTo target.pos

Upgrades:

  can-upgrade {unit, lvl} = lvl < max-level unit
  max-level Spk = 5
  max-level Shv = 4
  max-level Car = 3

  upgrade-available u = can-upgrade u ? Some (upgrade u) ; None

Animation:
  use gltf.load

  animation Spk = play "spike-pulse" loop
  animation Shv = play "dig" loop
  animation Car = play "roll" loop
  animation Tree = clip "leaf-wind" scaled by wind-strength

  wind-strength = sin (time × 2π / 10)

  animate = animation

SceneView:

  view (BaseScene scene) =
    map-m_ draw-entity scene.units empty-frame
    |> map-m_ draw-building scene.buildings
    |> render-frustum scene.camera.rot scene.camera.pos

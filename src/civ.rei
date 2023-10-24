use meta2 # everything within this context this will be in meta2, can be done anywhere, and subcontexes will inherit...
use std.3d

/*
  meta 2 includes an ECS by default. If you dont want it, use meta 2-s

  quering:
    any thing can be queried. Any type basically, and instantiation of types
    everything is a "object", but not necessarily the way you think
    basically everything is reified into a core.Object

  problem with highly optimised... is reversibility
  ...
  lol just have to use original one... and write over or de-ref it ...

  use the in keyword

  X: attacker in Attacker

  Z: extend Y
  X: extend Y
  Y: X | Z
  depends where you want to extend and if you want to add more later...
  ...


  exists and forall are available as FOL quantification ...

  matching vs default argument
  default args must be =
  matching is ("")

  x: exists a. a => b
  exists: replace (seqs: Seq+, (Operator "."), formula) -> Bool => ??

  if x is true, then we can implement our logic
  x: exists a. a => b
    println x + "hi"

  y: forall (a: Attacker). a.hp == 5
    println "for some reason everyone's hp is 5"

  otherwise, reference an identifier directly
  x
    ...

  this means, if x Exists, then do the body. Otherwise skip
  x: x
    ...

  this could be a problem if x is used later
  in meta 2 std it does not actually keep going and will probably short circuit either on that
  or right before someone is done
  based on whether someone is there...

  Result: Exists | Error
  Result: Exists | Extinct

  in meta 2 or 0, idents are auto played in contexts
  like

  Result: Exists | Error
  Error: ...
  that means Result.Error refers to the outer Error. Otherwise Error is just an "anonymous" variant...


*/

Agent:
  model: Model

// either building or attacker perhaps
// extend it elsewhere for more flexibility...
Unit: extend Entity

Unit:
  name: String?
  hp: Numeric 100
  Pos2D # cool thing with rei is that you can directly reference it

// = could also be overloaded right? and have priorities?

// either use := or just specify it directly...
// what if refinement??
f: (x: Int 20) -> Int
String2: String where !"String"
f: (y: String != "String") -> ??

Attacker: extend Unit

Building: extend Unit
  pillaged: Bool

# a farm is a certain type of building, but doesnt have to be its own type, just an instance
# you could also like... just do extend...
Farm: Improvement "farm"

Improvement: ??

Farm: extend Model

Builder: Unit "builder"

BuilderActions: enum
  Build: Improvement

println Farm // should print (Object : Building, Model)

// how does , work? in a very ehh kinda way
Pos2D: Numeric, Numeric

// Farm: Model // will give an error! Farm/1 already has a base type of Type, cannot overload

// farm action

Farm: _ _ => ()

// _ y => map y
// is how you do slotting...

# to make it more obvious. Should already be 100
Barbarian: Unit with Attacker (hp=100)

Map: ()

CurrentGameMap: Map

# optimise where possible scheme... lol


// ACTIONS

Action: enum
  Pillage
  Move
  Attack
  Fortify: Numeric | Fn/1 // unary fn
  Delete

# (T: Type) is a meta parameter...
# set: (T: Type) (x_old: T, x_new: T) -> ()

# note, can either define separately like in haskl or in the same context...
// attack: ? -> ?
// single or double? double kinda like ehehhhh
attack: (attacker: Attacker, defender: Unit) -> ??
  // if killed, then try to move to new tile if possible
  defender.hp -= attacker.damage
  // can either do ... : ... or something else
  defender.hp: 0 ?: move attacker defender.Pos2D

move: (unit: Unit, new_position: Pos2D) -> ??
    # problem with the . operator is that it checks for both fields and methods that take in things
    # so if you have overlapping definitions, will be error'd
    set unit.Pos2D new_position

## SHOULD BE DONE IN A MODULE WHERE get_unit and get_building are defined on CurrentGameMap

// actions can be of different types
act: (unit: Unit, action: Action) -> ??
  match unit
    Pillage
      # check current tile, is pillageable
      # if nothing, will just go on
      building: get_building unit.Pos2D
      in
        set building.hp 0
        set building.pillaged true

    Move new_position
      // check if obstructed. `match` style checks are good if you want to extend or modify easily
      match get_unit new_position
        None
          move unit new_position
          attacker: unit as Attacker
          in
            act unit RemoveFortify

    // ensure unit is an attacker through match semantics ...??
    // Fortify attacker
    // amount can be a function or numeric
    Fortify amount
      // remember, type info is always available if you make it available through this kind of stuff
      attacker: unit as Attacker
      // if you just did set attacker, then that wont do anything cause attacker is None? or entire statement is ditched
      // yea all the dependencies are ditched if you do that, it will set up a dependency
      in
        match amount
          Numeric n => set attacker.fortify n
          Fn/1 f => set attacker.fortify (f attacker.fortify)

    FortifyOnce
      act unit (Fortify +1)

    RemoveFortify
      act unit (Fortify 0)

// GRAPHIC

Model: ??


/*
  so i just had this thought thing...

  like you dont have toi couple it directly
  with a certain type of component, but
  just a component, like a list
  or map

  maybe a hypothetical programming language with a builtin ECS might look something similar to python with dynamic types but also have a way to auto compose components

  component Velocity: int, int, int
  component Hp: int
  component Attack: int

  component Attacker: Attack + Velocity + Hp

  component PendingInput
  component PendingDamage: PendingInput

  component PlayerAttacker: Attacker
  component AIAttacker: Attacker

  system Player: PlayerAttacker
    for entity: PlayerAttacker
      match process input
        Attack enemy => attack enemy (entity.attack)

  system AI: AIAttacker
    for entity: AIAttacker
      if found enemy: Enemy
        attack enemy (entity.attack)

  system DamageCalculation: Attacker
    for entity: Attacker
      entity.Hp -= PendingDamage entity

  let p1 = new PlayerAttacker
  let p2 = new AIAttacker
*/

// GAME OBJECTS HAVE A POSITION ON THE SCREEEEEEEN!!!

GameObject: ??

// how to run game? well might be good if there is an entry point specified ...

// basically runs the Start
Start: GameStart

GameStart: LoadingScreen
LoadingScreen:
  Animation
  Menu

// done!!

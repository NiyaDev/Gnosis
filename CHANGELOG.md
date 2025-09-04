
#### [7/11/25]
- Changed everything over to importing Ennoia.

#### [7/22/25]
- Removed utilities loading texture from bulk.
- Commented out Keybindings loading. (for now)

#### [7/23/25]
- Changed over to new Keybinds and Options loading.

#### [7/27/25]
- Commented out render.c3 and camera.c3.
- Commented out localization.
- Converted raylib::get_Frame_time() to ennoia::deltaTime.

#### [7/31/25]
- Replaced raylibs boundingbox checking and deltatime in units.c3
- Started changing resource loading over to new bulk format, but now going to finish after v3.0 of bulk.

#### [8/6/25]
- More resource loading.

#### [8/8/25]
- Even more resource loading.

#### [8/26/25]
- Commented out everything in gamestate to test.

#### [8/27/25]
- More conversion work. But gonna just restart.

#### [8/28/25]
- Added Tile structure and basic functions.
- Added Chunk structure.
- Added basic World structure.

#### [8/29/25]
- Tried to fix folding, but ended up screwing up my entire Nvim setup and having to redo it.
  - It still isn't back to 100%.
- Added logic for basic chunk generation.

#### [8/30/25]
- Continued chunk work.

#### [9/1/25]
- Changed Chunks from an aliased hashmap to a structure containing a hashmap.
- Added ability to get tiles from world level and removed chunk level.
- Added ability to draw world, including checking for visibility.
- Changed Tile type variable froms fucntion with switches to just enum associated values.

#### [9/2/25]
- Fixed Tile drawing.
- Re-Created basic Unit, Player, and Skill structures.

#### [9/3/25]
- Added UI textures bulk.
- Created plan for all skills, for now.
- Added create_unit and Update_stats functions.
- Created basic HP/Mana/Hunger bars.
- Added basic HP/Mana regen and Hunger.
- Added framework to give skill experience.

#### [9/4/25]
- Cleaned up chunk, world, tile, and skills.
- Removed already replaced functions from chunk, world, skill, and unit in old.
- Removed tiles in old.


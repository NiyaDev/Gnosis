
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

#### [9/11/25]
- Updated to new Ennoia format.
- Started applying new renderpipeline calls.

#### [9/23/25]
- Changed world drawing from just checking every tile in radius and drawing if visible to sending out "rays" from player and drawing based on that.

#### [9/24/25]
- Changed camera zoom to stay 4m away from player at all zoom levels.

#### [9/25/25]
- Added vision going downward.
  - Not perfect, but can be fixed.
- Removed old/system/camera.c3
- Removed old/system/debug.c3
- Created basic main menu with Start, Options, and Quit buttons
  - All work, but start logic isn't in.
- Started working on Menu system, starting with option.
  - Ran into issues with new priority system that I need to fix.

#### [9/27/25]
- Re-did all of old/system/gamestate.c3.

#### [9/28/25]
- Removed old/system/settings.c3.
- Started working on new UI system but now I'm rethinking it all.

#### [9/29/25]
- How the f*** did i miss that tile and chunk where in the ennoia module?
- Started re-adding Collision.
  - Finished basic version of gravity.
  - Started on, but didn't finish, movement collision.
- Removed old/units/body.c3.
- Removed old/units/player.c3.
- Removed old/units/skills.c3.
- removed old/units/species.c3.
- Cleaned up main.c3.

#### [10/1/25]
- Fixed collision.
- Re-added chunk saving and loading.
- Re-added world saving.
- Re-organized gamestate structure.
- Cleaned up error checking.
- Removed old/units/units.c3.
- Removed old/world/world.c3.
- Removed old/world/chunk.c3.
- Removed old/main.c3.
  - Finished moving to new engine!


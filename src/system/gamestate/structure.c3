
module gnosis::system;
import gnosis;
import ennoia;


Gamestate gamestate @builtin;
struct Gamestate {
  CurrentState state;

  World world;
}

enum CurrentState {
  TITLE,
  GAME_START,

  OVERWORLD,
  COMBAT,
}

<**>
fn void worldstate_init() @init {
  
}

<**>
fn void worldstate_loop() {
  switch (gamestate.state) {
    case TITLE:
      titlescreen_ui();
      ennoia::drawing();
    case OVERWORLD:
      // Camera
      camera::main.target = gamestate.world.player.position;
      camera::update();

      // Update and draw world
      gamestate.world.update();
      gamestate.world.draw();

      // Draw player
      render::draw_mesh(
        nameMesh:    "cube",
        position:    gamestate.world.player.position,
      );

      menus::draw();

      ennoia::drawing();
    default:
  }
  menus::draw();
}



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
      // New game
      if (imm::button(
        //text: "@{MM_NEW}",
        text: "New Game",
        textScale: {0.9,0.9},
        texture: "texture",
        bounds: {20,400,200,64},
        textureScale: {5,5},
        priority: 2,
      )) {
        gamestate.state = OVERWORLD;
        gamestate.world = world::new("test_2");
        gamestate.world.player.position = {0,8,0};
      }
      // Load Game
      if (imm::button(
        //text: "@{MM_LOAD}",
        text: "Load Game",
        textScale: {0.9,0.9},
        texture: "texture",
        bounds: {20,470,200,64},
        textureScale: {5,5},
        priority: 2,
      )) {
        gamestate.state = OVERWORLD;
      }
      if (imm::button(
        //text: "@{MM_OPTIONS}",
        text: "Options",
        texture: "texture",
        bounds: {20,540,200,64},
        textureScale: {5,5},
        priority: 2,
      )) menus::options.open = true;
      if (imm::button(
        //text: "@{MM_QUIT}",
        text: "Quit",
        texture: "texture",
        bounds: {20,610,200,64},
        textureScale: {5,5},
        priority: 2,
      )) ennoia::forceClose = true;
      
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


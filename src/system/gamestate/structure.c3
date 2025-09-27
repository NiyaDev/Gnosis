
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
        text: "@{MM_NEW}",
        texture: "texture",
        bounds: {20,400,192,64},
        textureScale: {5,5},
        priority: 2,
      )) {
        gamestate.state = OVERWORLD;
        //gamestate.world = mem::new(World);
        gamestate.world = world::new("test_2");
        gamestate.world.player.position = {0,8,0};
      }
      // Load Game
      if (imm::button(
        text: "@{MM_LOAD}",
        texture: "texture",
        bounds: {20,470,192,64},
        textureScale: {5,5},
        priority: 2,
      )) {
        gamestate.state = OVERWORLD;
      }
      if (imm::button(
        text: "@{MM_OPTIONS}",
        texture: "texture",
        bounds: {20,540,192,64},
        textureScale: {5,5},
        priority: 2,
      )) menus::options.open = true;
      if (imm::button(
        text: "@{MM_QUIT}",
        texture: "texture",
        bounds: {20,610,192,64},
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

      // Draw Bars
      float barOffset = 1;
      imm::bar(
        textureBg:   "bar_bg",
        textureFg:   "bar_fill",
        textureTint: color::RED,
        bounds: {
          16, barOffset++ * 18,
          (float)gamestate.world.player.hpMax * 2,
          16,
        },
      );
      if (gamestate.world.player.skills.has_key(MANA)) {
        imm::bar(
          textureBg:   "bar_bg",
          textureFg:   "bar_fill",
          textureTint: color::BLUE,
          bounds: {
            16, barOffset++ * 18,
            (float)gamestate.world.player.mnMax * 2,
            16,
          },
        );
      }
      imm::bar(
        textureBg:   "bar_bg",
        textureFg:   "bar_fill",
        textureTint: color::GREEN,
        bounds: {
          16, barOffset++ * 18,
          (float)gamestate.world.player.hnMax * 2,
          16,
        },
      );


      // Game version text
      imm::label(
        text: gnosis::GAME_VERSION,
        position: {5,(float)ennoia::renHeight-12-5},
        scale: {0.5,0.5},
      );

      ennoia::drawing();
    default:
  }
  menus::draw();
}


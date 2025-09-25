
module gnosis::system;
import gnosis::world;
import ennoia::ui;


Gamestate gamestate @builtin;
struct Gamestate {
  CurrentState state;

  World* world;
}

enum CurrentState {
  TITLE,

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
      if (imm::button(
        text: "@{MM_START}",
        texture: "texture",
        bounds: {20,500,192,64},
        textureScale: {5,5},
        priority: 2,
      )) gamestate.state = OVERWORLD;
      if (imm::button(
        text: "@{MM_OPTIONS}",
        texture: "texture",
        bounds: {20,568,192,64},
        textureScale: {5,5},
        priority: 2,
      )) menus::options.open = true;
      if (imm::button(
        text: "@{MM_QUIT}",
        texture: "texture",
        bounds: {20,636,192,64},
        textureScale: {5,5},
        priority: 2,
      )) ennoia::forceClose = true;
      
      ennoia::drawing();
      break;
    default:
  }
  menus::draw();
}


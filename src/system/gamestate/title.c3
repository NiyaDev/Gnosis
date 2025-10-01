
module gnosis::system;
import gnosis::world;
import ennoia::ui;


<**>
fn void titlescreen_ui() {
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

  // Options button
  if (imm::button(
    //text: "@{MM_OPTIONS}",
    text: "Options",
    texture: "texture",
    bounds: {20,540,200,64},
    textureScale: {5,5},
    priority: 2,
  )) menus::options.open = !menus::options.open;

  // Quit button
  if (imm::button(
    //text: "@{MM_QUIT}",
    text: "Quit",
    texture: "texture",
    bounds: {20,610,200,64},
    textureScale: {5,5},
    priority: 2,
  )) ennoia::forceClose = true;

}


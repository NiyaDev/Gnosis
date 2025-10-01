
module gnosis;
import std::io;
import ennoia;


const String GAME_VERSION = "0.0.0 - There was nothing";

fn int main(String[] args) {
  // Initialize
  ennoia::init(
    title: "Gnosis",
  );
  defer ennoia::clean();

  // Loading
  bulk::load_all("resources/010"); // Tile textures
  bulk::load_all("resources/030"); // UI textures

  while (!ennoia::window_should_close()) {
    switch (gamestate.state) {
      case TITLE:
        system::titlescreen_ui();
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
          nameMesh: "cube",
          position: gamestate.world.player.position,
          scale:    {0.8,0.8,0.8},
        );

        menus::draw();

        ennoia::drawing();
      default:
    }
    menus::draw();
  }
  
  return 0;
}

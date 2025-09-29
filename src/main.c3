
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
  bulk::load_all("resources/010");
  bulk::load_all("resources/030"); // UI textures

  while (!ennoia::window_should_close()) {
    system::worldstate_loop();
  }
  
  return 0;
}

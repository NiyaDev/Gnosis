
module gnosis;
import std::io;
import ennoia;


World test;

fn int main(String[] args) {
  // Initialize
  ennoia::init(
    title: "Gnosis",
  );
  defer ennoia::clean();

  test = world::new("test");

  //io::printfn("%d bytes", Tile.sizeof);
  //io::printfn("%d bytes per chunk", Tile.sizeof * (16*16*16));

  while (!ennoia::window_should_close()) {
    ennoia::start_drawing();

    test.draw();

    ennoia::end_drawing();
  }
  
  return 0;
}

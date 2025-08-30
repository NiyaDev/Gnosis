
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
  io::printfn("%s",test.chunks.get({0,0,0})!!.get({0,4,5}).type);

  //io::printfn("%d bytes", Tile.sizeof);
  //io::printfn("%d bytes per chunk", Tile.sizeof * (16*16*16));

  while (!ennoia::window_should_close()) {
    ennoia::start_drawing();

    ennoia::end_drawing();
  }
  
  return 0;
}

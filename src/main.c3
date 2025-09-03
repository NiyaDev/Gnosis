
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

  // Temp
  bulk::load_all("resources/010");
  ennoia::models.set("cube",mesh::gen_cube().to_model());
  test.player.position = {0,8,0};
  test.player.skills.set(PERCEPTION,{});

  //io::printfn("%d bytes", Tile.sizeof);
  //io::printfn("%d bytes per chunk", Tile.sizeof * (16*16*16));

  while (!ennoia::window_should_close()) {
    if (keybinds::down("move_up"))         test.player.position.z -= 4 * (float)ennoia::deltaTime;
    if (keybinds::down("move_down"))       test.player.position.z += 4 * (float)ennoia::deltaTime;
    if (keybinds::down("move_right"))      test.player.position.x += 4 * (float)ennoia::deltaTime;
    if (keybinds::down("move_left"))       test.player.position.x -= 4 * (float)ennoia::deltaTime;
    if (keybinds::down("ascend"))          test.player.position.y += 4 * (float)ennoia::deltaTime;
    if (keybinds::down("descend"))         test.player.position.y -= 4 * (float)ennoia::deltaTime;
    if (keybinds::down("rotate_left")  && !camera::is_rotating()) camera::rotate(90);
    if (keybinds::down("rotate_right") && !camera::is_rotating()) camera::rotate(-90);
    if (ennoia::scrollwheel != 0) {
      camera::main.distance -= (Vector3){0, ennoia::scrollwheel, ennoia::scrollwheel} * 0.2;
      camera::main.distance = camera::main.distance.clamp({0,1,1},{0,8,8});
    }
    if (keybinds::pressed("debug")) {
      SkillNode* sn = test.player.skills.get_ref(PERCEPTION)!!;
      sn.level++;
    }

    camera::main.target = test.player.position;
    camera::update();

    ennoia::start_drawing();

    test.draw();
    ennoia::models["cube"]!!.draw(position:test.player.position);

    ennoia::end_drawing();
  }
  
  return 0;
}

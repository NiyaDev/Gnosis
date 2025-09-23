
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

  test = world::new("test_2");

  // Temp
  bulk::load_all("resources/010");
  test.player.position = {0,8,0};
  io::printfn("%d/%d",test.player.hpCur,test.player.hpMax);

  //bulk::load_all("resources/030"); // UI textures

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
      //SkillNode* sn = test.player.skills.get_ref(PERCEPTION)!!;
      //sn.level++;
      //test.player.hpCur--;
      //io::printfn("%d-%d/%d",test.player.hpTick, test.player.hpCur, test.player.hpMax);
    }

    camera::main.target = test.player.position;
    camera::update();
    test.update();

    ennoia::start_drawing();

    test.draw();
    render::draw_mesh(
      nameMesh:    "cube",
      position:    test.player.position,
    );
    //render::draw_texture("dirt",{10,10,640,640});
    /*
    ennoia::models["cube"]!!.draw(position:test.player.position);

    ennoia::textures["bar_bg"]!!.draw_tiled(  dest:{10,10,128,16},layout:THREE_ONE,color:color::RED);
    ennoia::textures["bar_fill"]!!.draw_tiled(dest:{10,10,128 * ((float)test.player.hpCur / (float)test.player.hpMax),16},layout:THREE_ONE,color:color::RED);

    ennoia::textures["bar_bg"]!!.draw_tiled(  dest:{10,30,128,16},layout:THREE_ONE,color:color::BLUE);
    ennoia::textures["bar_fill"]!!.draw_tiled(dest:{10,30,128 * ((float)test.player.mnCur / (float)test.player.mnMax),16},layout:THREE_ONE,color:color::BLUE);
    
    ennoia::textures["bar_bg"]!!.draw_tiled(  dest:{10,50,128,16},layout:THREE_ONE,color:color::GREEN);
    ennoia::textures["bar_fill"]!!.draw_tiled(dest:{10,50,128 * ((float)test.player.hnCur / (float)test.player.hnMax),16},layout:THREE_ONE,color:color::GREEN);
    */

    ennoia::end_drawing();
  }
  
  return 0;
}

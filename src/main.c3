
module gnosis;
import std::io;
import ennoia;


//World test;
const String GAME_VERSION = "0.0.0 - There was nothing";

fn int main(String[] args) {
  // Initialize
  ennoia::init(
    title: "Gnosis",
  );
  defer ennoia::clean();

  // Temp
  bulk::load_all("resources/010");
  //test.player.position = {0,8,0};
  //io::printfn("%d/%d",test.player.hpCur,test.player.hpMax);

  bulk::load_all("resources/030"); // UI textures

  while (!ennoia::window_should_close()) {
    if (keybinds::down("move_up"))         gamestate.world.player.position.z -= 4 * (float)ennoia::deltaTime;
    if (keybinds::down("move_down"))       gamestate.world.player.position.z += 4 * (float)ennoia::deltaTime;
    if (keybinds::down("move_right"))      gamestate.world.player.position.x += 4 * (float)ennoia::deltaTime;
    if (keybinds::down("move_left"))       gamestate.world.player.position.x -= 4 * (float)ennoia::deltaTime;
    if (keybinds::down("ascend"))          gamestate.world.player.position.y += 4 * (float)ennoia::deltaTime;
    if (keybinds::down("descend"))         gamestate.world.player.position.y -= 4 * (float)ennoia::deltaTime;
    if (keybinds::down("rotate_left")  && !camera::is_rotating()) camera::rotate(90);
    if (keybinds::down("rotate_right") && !camera::is_rotating()) camera::rotate(-90);
    if (ennoia::scrollwheel != 0) {
      camera::main.distance = {0,camera::main.distance.y - (ennoia::scrollwheel * 0.6), 4};
      camera::main.distance = camera::main.distance.clamp({0,2,4},{0,16,4});
    }
    if (keybinds::pressed("debug")) {
      menus::skills.open = !menus::skills.open;
      //SkillNode* sn = test.player.skills.get_ref(PERCEPTION)!!;
      //sn.level++;
      //test.player.hpCur--;
      //io::printfn("%d-%d/%d",test.player.hpTick, test.player.hpCur, test.player.hpMax);
    }

    

    system::worldstate_loop();
    //

    //ennoia::start_drawing();

    //test.draw();
    
    //imm::bar(
    //  bounds:{10,10,128,16},
    //);
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

    //ennoia::end_drawing();
    //ennoia::drawing();
  }
  
  return 0;
}


module gnosis::unit;
import gnosis::system;
import ennoia::camera;
import ennoia::keybinds;
import ennoia::vector;


struct Player {
  inline Unit unit;
}


<* Creates a new player *>
fn Player new_player(
  Vec3f position = {0,16,0},
  String species = "human",
) {
  Player output = {
    { // Unit
      position,
      {0,0,0}, // Momentum
      1,     // Size
      false, // Grounded
      false, // Hidden
      0,0,0, // HP
      0,0,0, // Mana
      0,0,0, // Hunger
      species,
      {},    // Skills
    },
  };

  // Set skills
  output.skills.set(HEALTH, {5,20,0});
  output.skills.set(HEALTH_REGEN, {2,20,0});
  output.skills.set(MANA, {5,20,0});
  output.skills.set(MANA_REGEN, {2,20,0});
  output.skills.set(HUNGER, {5,20,0});
  output.skills.set(PERCEPTION, {5,20,0});

  output.update_stats();

  output.hpCur = output.hpMax;
  output.mnCur = output.mnMax;
  output.hnCur = output.hnMax;
  
  return output;
}

<* Player update *>
fn void Player.update(&self) {
  if (keybinds::down("move_up"))    gamestate.world.player.momentum.z -= 4;// * (float)ennoia::deltaTime;
  if (keybinds::down("move_down"))  gamestate.world.player.momentum.z += 4;// * (float)ennoia::deltaTime;
  if (keybinds::down("move_right")) gamestate.world.player.momentum.x += 4;// * (float)ennoia::deltaTime;
  if (keybinds::down("move_left"))  gamestate.world.player.momentum.x -= 4;// * (float)ennoia::deltaTime;
  if (keybinds::down("rotate_right") && !camera::is_rotating()) camera::rotate(-90);
  if (keybinds::down("rotate_left")  && !camera::is_rotating()) camera::rotate( 90);
  if (ennoia::scrollwheel != 0) {
    camera::main.distance = {0,camera::main.distance.y - (ennoia::scrollwheel * 0.6), 4};
    camera::main.distance = camera::main.distance.clamp({0,2,4},{0,16,4});
  }
  if (keybinds::pressed("debug")) {
    menus::skills.open = !menus::skills.open;
  }

  self.unit.update();
}


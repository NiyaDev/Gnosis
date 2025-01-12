
module gnosis::unit::player;
import std::io;
import gnosis::system::camera;
import gnosis::unit;
import raylib;


struct Player {
  inline Unit u;
}


/** Creates and initializes a player
 **/
fn Player* init() {
  Player* output = mem::new(Player);
  output.skills = mem::new_array(SkillData, skills::NUMBER_OF_SKILLS);

  //* TEST
  output.set_species(HUMAN);
  //for (int i; i<(int)Skill.COUNT; i++) {
  //  io::printfn("%s: %d", (Skill)i, output.skills[i].value);
  //}

  return output;
}
/** Updates player based on input
 **/
fn void Player.update(&self) {
  Vector3 movement;
  float dt = rl::getFrameTime();

  if (rl::isKeyDown(rl::KEY_W)) movement.add({-5, 0, -5});
  if (rl::isKeyDown(rl::KEY_S)) movement.add({ 5, 0,  5});
  if (rl::isKeyDown(rl::KEY_D)) movement.add({ 5, 0, -5});
  if (rl::isKeyDown(rl::KEY_A)) movement.add({-5, 0,  5});

  movement = movement.clamp({7,0,7}, {-7,0,-7});
  movement.mul_f(dt);

  self.move(camera::ZERO.rotate(movement, camera::main.rotation));
}


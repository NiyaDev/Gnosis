
module gnosis::unit::player;
import gnosis::system::camera;
import raylib5::rl;


struct Player {
  inline Unit u;
}


/** 
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
/**
 **/
fn void Player.move(&self, Vector3 movement) {
  self.position.x += movement.x;
  self.position.y += movement.y;
  self.position.z += movement.z;
}


module gnosis::unit::player;
import std::io;
import gnosis;
import pleroma;


struct Player {
  inline Unit unit;
}


<* Creates and initializes a player *>
fn Player* new() {
  Player* output = mem::new(Player);
  output.init(RAT);
  return output;
}
<* Updates player *>
fn void Player.update(&self) {
  Vector3 movement;
  float dt = raylib::get_frame_time();

  // Movement
  if (keybinds.is_down("move_up"))    movement.add({ 0, 0, -5});
  if (keybinds.is_down("move_down"))  movement.add({ 0, 0,  5});
  if (keybinds.is_down("move_left"))  movement.add({-5, 0,  0});
  if (keybinds.is_down("move_right")) movement.add({ 5, 0,  0});
  // TODO: diagonal movement

  //* Camera rotation
  if (keybinds.is_pressed("rotate_right")) camera::rotate( 90);
  if (keybinds.is_pressed("rotate_left"))  camera::rotate(-90);

  //* Camera zoom
	float zoom = raylib::get_mouse_wheel_move();
	if (zoom != 0) {
	  camera::zoom(-zoom / 20);
	}

  movement = movement.clamp({-7,0,-7}, {7,0,7});
  movement.y -= self.gravity;
  movement.mul_f(dt);

  self.move(vector3::ZERO.rotate(movement, camera::main.rotation));
}



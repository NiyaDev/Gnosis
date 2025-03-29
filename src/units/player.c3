
module gnosis::unit::player;
import std::io;
import gnosis::system::camera;
import gnosis::unit;
import gnosis::world;
import gnosis::resources;
import pleroma;
//import raylib;
//import keybind;


struct Player {
  inline Unit unit;
}


<* Creates and initializes a player *>
fn Player* new() {
  Player* output = mem::new(Player);
  output.init("human");
  return output;
}
<* Updates player *>
fn void Player.update(&self) {
  Vector3 movement;
  float dt = raylib::get_frame_time();

  //* Movement
  if (keybind::is_down("move_up"))    movement.add({-5, 0, -5});
  if (keybind::is_down("move_down"))  movement.add({ 5, 0,  5});
  if (keybind::is_down("move_left"))  movement.add({-5, 0,  5});
  if (keybind::is_down("move_right")) movement.add({ 5, 0, -5});

  //* Camera rotation
  if (keybind::is_pressed("rotate_right")) camera::rotate( 90);
  if (keybind::is_pressed("rotate_left"))  camera::rotate(-90);

  //* Camera zoom
	float zoom = raylib::get_mouse_wheel_move();
	if (zoom != 0) {
	  camera::zoom(-zoom / 20);
	  //g_shader.curvature.as_float += (-zoom/20);
	}

  movement = movement.clamp({-7,0,-7}, {7,0,7});
  movement.mul_f(dt);

  self.move(camera::ZERO.rotate(movement, camera::main.rotation));
}



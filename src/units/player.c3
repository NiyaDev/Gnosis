
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
  output.init(HUMAN);
  output.personality = EMPTY;
  return output;
}
<* Updates player *>
fn void Player.p_update(&self) {
  //Vector3 movement;
  float dt = raylib::get_frame_time();

  if (!gamestate.combat) {
    // Movement
    if (keybinds.is_down("move_up"))    self.momentum += { 0, 0, -5};
    if (keybinds.is_down("move_down"))  self.momentum += { 0, 0,  5};
    if (keybinds.is_down("move_left"))  self.momentum += {-5, 0,  0};
    if (keybinds.is_down("move_right")) self.momentum += { 5, 0,  0};
  } else {}
  if (keybinds.is_down("stealth")) {
    self.stealthed = true;
  } else { self.stealthed = false; }

  //* Camera rotation
  if (keybinds.is_pressed("rotate_right")) camera::rotate( 90);
  if (keybinds.is_pressed("rotate_left"))  camera::rotate(-90);

  //* Camera zoom
	float zoom = raylib::get_mouse_wheel_move();
	if (zoom != 0) {
	camera::zoom(-zoom / 20);
	}

	self.update(true);
}



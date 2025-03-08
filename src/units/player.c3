
module gnosis::unit::player;
import std::io;
import gnosis::system::camera;
import gnosis::unit;
import gnosis::world;
import gnosis::resources;
import raylib;
import keybind;


struct Player {
  inline Unit u;
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

  if (keybind::is_down("move_up")!!)    movement.add({-5, 0, -5});
  if (keybind::is_down("move_down")!!)  movement.add({ 5, 0,  5});
  if (keybind::is_down("move_left")!!)  movement.add({-5, 0,  5});
  if (keybind::is_down("move_right")!!) movement.add({ 5, 0, -5}); 

  movement = movement.clamp({-7,0,-7}, {7,0,7});
  movement.mul_f(dt);

  self.move(camera::ZERO.rotate(movement, camera::main.rotation));
  
  if (self.hn_cur > 0) {
    //* Health regeneration
    if ((self.hp_cur < self.hp_max) && self.hp_tick <= 0) {
      self.hp_tick = (float)self.skills["regeneration"]!!.value / 0.01;
      self.hp_cur++;
      self.hn_cur -= 0.2;
    } else if (self.hp_tick > 0) { self.hp_tick--; }
    if (self.hp_cur > self.hp_max) self.hp_cur = self.hp_max;
    //* Stamina regeneration
    if ((self.st_cur < self.st_max) && self.st_tick <= 0) {
      self.st_tick = (float)self.skills["endurance"]!!.value / 0.1;
      self.st_cur++;
    } else if (self.st_tick > 0) { self.st_tick--; }
    if (self.st_cur > self.st_max) self.st_cur = self.st_max;
    //* Mana regeneration
    if ((self.mn_cur < self.mn_max) && self.mn_tick <= 0) {
      self.mn_tick = (float)self.skills["current"]!!.value / 0.1;
      self.mn_cur++;
    } else if (self.st_tick > 0) { self.st_tick--; }
    if (self.mn_cur > self.mn_max) self.mn_cur = self.mn_max;
    //* Natural hunger tick
    if (self.hn_tick <= 0) {
      self.hn_tick = (float)self.skills["metabolism"]!!.value * 100;
      self.hn_cur -= 0.1;
    } else { self.hn_tick--; }
  } else {
    //* Tick Health down from hunger 
    if (self.hn_tick <= 0) {
      self.hn_tick = (float)self.skills["metabolism"]!!.value * 100;
      self.hp_cur--;
    } else if (self.hn_tick > 0) { self.hn_tick--; }
  }
}



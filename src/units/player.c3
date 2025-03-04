
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
  //  //* Health regeneration
  //  if ((self.hp_cur < self.hp_max) && self.hp_tick <= 0) {
  //    self.hp_tick = (float)self.skills[Skill.REGENERATION.ordinal].value / 0.01;
  //    self.hp_cur++;
  //    self.hn_cur -= 0.2;
  //    if (self.hp_cur > self.hp_max) self.hp_cur = self.hp_max;
  //  } else if (self.hp_tick > 0) { self.hp_tick--; }
  //  //* Stamina regeneration
  //  if ((self.st_cur < self.st_max) && self.st_tick <= 0) {
  //    self.st_tick = (float)self.skills[Skill.ENDURANCE.ordinal].value / 0.1;
  //    self.st_cur++;
  //    if (self.st_cur > self.st_max) self.st_cur = self.st_max;
  //  } else if (self.st_tick > 0) { self.st_tick--; }
  //  //* Natural hunger tick
  //  if (self.hn_tick <= 0) {
  //    self.hn_tick = (float)self.skills[Skill.METABOLISM.ordinal].value * 100;
  //    self.hn_cur -= 0.1;
  //  } else { self.hn_tick--; }
  //} else {
  //  //* Tick Health down from hunger 
  //  if (self.hn_tick <= 0) {
  //    self.hn_tick = (float)self.skills[Skill.METABOLISM.ordinal].value * 100;
  //    self.hp_cur--;
  //  } else if (self.hn_tick > 0) { self.hn_tick--; }
  }
}

<* Draws player UI elements *>
fn void Player.draw_ui(&self) {
  //gnosis::bar_bg.draw_npatch({{0,0,24,8},8,8,8,8,THREE_PATCH_HORIZONTAL}, {10,10,64,8}, {0,0}, 0, raylib::RED);
  //gnosis::bar_fl.draw_npatch({{0,0,24,8},8,8,8,8,THREE_PATCH_HORIZONTAL}, {10,10,64,8}, {0,0}, 0, raylib::RED);
  //resources::textures["bar_bg"]!!.draw_npatch({{0,0,24,8},8,8,8,8,THREE_PATCH_HORIZONTAL}, {10,10,64,8}, {0,0}, 0, raylib::RED);
  //resources::textures["bar_fl"]!!.draw_npatch({{0,0,24,8},8,8,8,8,THREE_PATCH_HORIZONTAL}, {10,10,64,8}, {0,0}, 0, raylib::RED);

  /*
  if (self.skills[Skill.HEALTH.ordinal].discovered) {
    float hp_per = self.hp_cur / self.hp_max;
    gnosis::bar_bg.draw_npatch({{0,0,24,8},8,8,8,8,THREE_PATCH_HORIZONTAL}, {10,10,64,8}, {0,0}, 0, raylib::RED);
	  gnosis::bar_fl.draw_npatch({{0,0,24,8},8,8,8,8,THREE_PATCH_HORIZONTAL}, {10,10,64 * hp_per,8}, {0,0}, 0, raylib::RED);
	}
  if (self.skills[Skill.STAMINA.ordinal].discovered) {
    float st_per = self.st_cur / self.st_max;
	  gnosis::bar_bg.draw_npatch({{0,0,24,8},8,8,8,8,THREE_PATCH_HORIZONTAL}, {10,20,64,8}, {0,0}, 0, raylib::GREEN);
	  gnosis::bar_fl.draw_npatch({{0,0,24,8},8,8,8,8,THREE_PATCH_HORIZONTAL}, {10,20,64 * st_per,8}, {0,0}, 0, raylib::GREEN);
	}
  if (self.skills[Skill.MANA.ordinal].discovered) {
    float mn_per = self.mn_cur / self.mn_max;
  	gnosis::bar_bg.draw_npatch({{0,0,24,8},8,8,8,8,THREE_PATCH_HORIZONTAL}, {10,30,64,8}, {0,0}, 0, raylib::BLUE);
  	gnosis::bar_fl.draw_npatch({{0,0,24,8},8,8,8,8,THREE_PATCH_HORIZONTAL}, {10,30,64 * mn_per,8}, {0,0}, 0, raylib::BLUE);
  }
  if (self.skills[Skill.BELLY.ordinal].discovered) {
    float hn_per = self.hn_cur / self.hn_max;
  	gnosis::bar_bg.draw_npatch({{0,0,24,8},8,8,8,8,THREE_PATCH_HORIZONTAL}, {10,40,64,8}, {0,0}, 0, raylib::PURPLE);
  	gnosis::bar_fl.draw_npatch({{0,0,24,8},8,8,8,8,THREE_PATCH_HORIZONTAL}, {10,40,64 * hn_per,8}, {0,0}, 0, raylib::PURPLE);
  }
  */

	//String text = string::tformat("FPS: %d\nTiles Rendered: %d", raylib::get_fps(), chunks::tiles_rendered);
	//raylib::draw_text((ZString)text, 0, 100, 8, raylib::BLACK);
	//String text = string::format(
	//  "FPS: %d\nTiles Rendered: %d\nHP: %d/%d - %d\nST: %d/%d - %d\nMN: %d/%d - %d\nHN: %d/%d - %d\0",
	//  raylib::get_fps(), chunks::tiles_rendered,
	//  self.hp_cur, self.hp_max, self.hp_tick,
	//  self.st_cur, self.st_max, self.st_tick,
	//  self.mn_cur, self.mn_max, self.mn_tick,
	//  self.hn_cur, self.hn_max, self.hn_tick,
	//  allocator: allocator::heap(),
	//);
	//raylib::draw_text((ZString)text, 0, 100, 8, raylib::BLACK);
  //text.free(); 
}


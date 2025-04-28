
module gnosis::unit;
import std::io;
import std::math;
import std::collections;
import pleroma;
import gnosis::world;
import gnosis::system;


struct Unit {
  Vector3 position;
  Texture* sprite;

  //* General
  float hp_cur, hp_max, hp_tick;
  float st_cur, st_max, st_tick;
  float mn_cur, mn_max, mn_tick;
  float hn_cur, hn_max, hn_tick;

  //* Data
  Species species;
  SkillList skills;

  // data
  float gravity;
}


<* Initialize a unit to base values *>
fn void Unit.init(&self, Species spec = HUMAN) {
  self.species = spec;
  self.skills  = skills::get(spec);

  // Calculate status skills
  float size_mod = spec.get_size();

  // Health
  self.hp_max = (float)self.skills[Skills.HEALTH].value * (skills::HEALTH_MOD * size_mod);
  self.hp_cur = self.hp_max;

  // Stamina
  self.st_max = (float)self.skills[Skills.STAMINA].value * (skills::STAMINA_MOD * size_mod);
  self.st_cur = self.st_max;

  // Mana
  self.mn_max = (float)self.skills[Skills.MANA].value * (skills::MANA_MOD * size_mod);
  self.mn_cur = self.mn_max;

  // Hunger
  self.hn_max = (float)self.skills[Skills.BELLY].value * (skills::BELLY_MOD * size_mod);
  self.hn_cur = self.hn_max;
}
<* Move unit in space 
  @param movement "Amount to move"
 *>
fn void Unit.move(&self, Vector3 movement) {
  self.position.x += movement.x;
  self.position.y += movement.y;
  self.position.z += movement.z;
}
<* General unit logic *>
fn void Unit.tick(&self) {
  // Gravity
  BoundingBox f_bounds = self.unit_bounds();
  BoundingBox g_bounds = self.ground_bounds();
  Vector3 tile_pos = {
    self.position.x,
    $$floor(self.position.y),
    self.position.z,
  };
  int[3] tile_position = {
    (int)self.position.x,
    (int)$$floor(self.position.y),
    (int)self.position.z,
  };
  Tile* tile = gamestate.world.tile(tile_pos.to_int_array());
  if (tile != null) {
    BoundingBox t_bounds = tile.bounds(tile_pos);
    io::printfn("%s",raylib::check_collision_boxes(g_bounds,t_bounds));
    if (!raylib::check_collision_boxes(g_bounds,t_bounds)) {
      self.gravity += 0.75;
      self.gravity = self.gravity.clamp(0.0, 9.0);
    } else { self.gravity = 0; }
  }

  // Regeneration logic
  if (self.hn_cur > 0) {
    //* Health regeneration
    if ((self.hp_cur < self.hp_max) && self.hp_tick <= 0) {
      self.hp_tick = (float)self.skills[Skills.REGENERATION].value / 0.05;
      self.hp_cur++;
      self.hn_cur -= 0.2;
    } else if (self.hp_tick > 0) { self.hp_tick--; }
    if (self.hp_cur > self.hp_max) self.hp_cur = self.hp_max;
    //* Stamina regeneration
    if ((self.st_cur < self.st_max) && self.st_tick <= 0) {
      self.st_tick = (float)self.skills[Skills.ENDURANCE].value / 0.1;
      self.st_cur++;
    } else if (self.st_tick > 0) { self.st_tick--; }
    if (self.st_cur > self.st_max) self.st_cur = self.st_max;
    //* Mana regeneration
    if ((self.mn_cur < self.mn_max) && self.mn_tick <= 0) {
      self.mn_tick = (float)self.skills[Skills.CURRENT].value / 0.025;
      self.mn_cur++;
    } else if (self.mn_tick > 0) { self.mn_tick--; }
    if (self.mn_cur > self.mn_max) self.mn_cur = self.mn_max;
    //* Natural hunger tick
    if (self.hn_tick <= 0) {
      self.hn_tick = (float)self.skills[Skills.METABOLISM].value * 50;
      self.hn_cur -= 0.1;
    } else { self.hn_tick--; }
  } else {
    //* Tick Health down from hunger 
    if (self.hn_tick <= 0) {
      self.hn_tick = (float)self.skills[Skills.METABOLISM].value * 50;
      self.hp_cur--;
    } else if (self.hn_tick > 0) { self.hn_tick--; }
  } 
}

<* Get bounding box for unit based on position and size *>
fn BoundingBox Unit.unit_bounds(&self) {
  float modifier = 0.25; // TODO: Size modifier
  Vector3 pos = self.position;
  return {
    {pos.x - modifier, pos.y, pos.z - modifier},
    {pos.x + modifier, pos.y + (modifier * 2), pos.z + modifier},
  };
}

<**>
fn BoundingBox Unit.ground_bounds(&self) {
  float modifier = 0.23; // TODO: Size modifier
  Vector3 pos = self.position;
  return {
    {pos.x - modifier, pos.y - (modifier / 4), pos.z - modifier},
    {pos.x + modifier, pos.y + (modifier / 2), pos.z + modifier},
  };
}


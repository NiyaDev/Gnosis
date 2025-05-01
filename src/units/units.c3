
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
  Vector3 momentum;
  bool[4] collisions;
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
  Vector3 mv = movement;
  if (self.collisions[0] && mv.z > 0) mv.z = 0;
  if (self.collisions[2] && mv.z < 0) mv.z = 0;
  if (self.collisions[1] && mv.x > 0) mv.x = 0;
  if (self.collisions[3] && mv.x < 0) mv.x = 0;
  
  self.position.x += mv.x;
  self.position.y += mv.y;
  self.position.z += mv.z;
}
<* General unit logic *>
fn void Unit.tick(&self) {
  // Gravity
  BoundingBox g_bounds = self.ground_bounds();
  Vector3 tile_pos = {
    self.position.x,
    self.position.y.floor(),
    self.position.z,
  };
  Tile* tile = gamestate.world.tile(tile_pos.to_int_array());
  if (tile != null) {
    BoundingBox t_bounds = tile.bounds(tile_pos);
    if (!raylib::check_collision_boxes(g_bounds,t_bounds)) {
      self.momentum.y -= 0.75;
      self.momentum.y = self.momentum.y.clamp(-9.0, 0.0);
    } else { self.momentum.y = 0; }
  }

  // Collision
  BoundingBox f_bounds = self.unit_bounds();

  Vector3 north_dir = self.position;
  north_dir.y++;
  north_dir.z--;
  Tile* north = gamestate.world.tile(north_dir.get_tile_pos().to_int_array());
  if (north != null || !north.solid) {
    BoundingBox t_bounds = north.bounds(north_dir.get_tile_pos());
    self.collisions[0] = raylib::check_collision_boxes(f_bounds, t_bounds);
  } else { self.collisions[0] = false; }

  Vector3 south_dir = self.position;
  south_dir.y++;
  south_dir.z++;
  Tile* south = gamestate.world.tile(south_dir.get_tile_pos().to_int_array());
  if (south != null || !south.solid) {
    BoundingBox t_bounds = south.bounds(south_dir.get_tile_pos());
    self.collisions[2] = raylib::check_collision_boxes(f_bounds, t_bounds);
  } else { self.collisions[2] = false; }

  Vector3 east_dir = self.position;
  east_dir.y++;
  east_dir.z++;
  Tile* east = gamestate.world.tile(east_dir.get_tile_pos().to_int_array());
  if (east != null || !east.solid) {
    BoundingBox t_bounds = east.bounds(east_dir.get_tile_pos());
    self.collisions[1] = raylib::check_collision_boxes(f_bounds, t_bounds);
  } else { self.collisions[1] = false; }

  Vector3 west_dir = self.position;
  west_dir.y++;
  west_dir.z++;
  Tile* west = gamestate.world.tile(west_dir.get_tile_pos().to_int_array());
  if (west != null || !west.solid) {
    BoundingBox t_bounds = west.bounds(west_dir.get_tile_pos());
    self.collisions[3] = raylib::check_collision_boxes(f_bounds, t_bounds);
  } else { self.collisions[3] = false; }
  io::printfn("%s",self.collisions);

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

<**>
fn Vector3 Vector3.get_tile_pos(&self) {
  return {
    (int)((self.x + 0.5).floor()),
    (int)((self.y + 0.5).floor()),
    (int)((self.z + 0.5).floor()),
  };
}


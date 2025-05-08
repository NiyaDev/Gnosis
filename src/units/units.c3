
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
  Personality personality;
  Vector3 momentum;
  bool grounded;
}

enum Personality {
  EMPTY,
  PASSIVE,
  HOSTILE,
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
  self.position += movement;
}
<* Unit update *>
fn void Unit.update(&self, bool is_player = false) {
  float dt = raylib::get_frame_time();

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
      self.grounded = false;
      self.momentum.y -= 0.75;
      self.momentum.y = self.momentum.y.clamp(-3.5, 0.0);
    } else {
      self.grounded = true;
      self.momentum.y = 0;
      self.position.y = (float)((int)self.position.y) + 0.5;
    }
  } else {
    self.grounded = false;
    self.momentum.y -= 0.75;
    self.momentum.y = self.momentum.y.clamp(-3.5, 0.0);
  }

  self.momentum = self.momentum * dt;
  self.momentum.y *= 10;

  if (self.momentum.x != 0 && self.momentum.z != 0) {
    self.momentum.x *= 0.8;
    self.momentum.z *= 0.8;
  }

  Vector3 rotated_dir = vector3::ZERO.rotate(self.momentum, camera::main.rotation);

  // Personality
  switch (self.personality) {
    case PASSIVE:
    case HOSTILE:
      // Perception check against player
      // TODO:
      //io::printfn("SQUEEEEEEEE");
      (self.position.move_towards(gamestate.world.player.position, 1) - self.position).print();
      if (self.grounded && gamestate.world.player.position.distance(self.position) < 5 + (self.skills[Skills.PERCEPTION].value * 0.2)) {
        Vector3 movement = self.position.move_towards(gamestate.world.player.position, 0.05);
        if (movement != {0,0,0}) { movement -= self.position; }
        movement.x = movement.x.clamp(-1,1);
        movement.y = 0;
        movement.z = movement.z.clamp(-1,1);
        rotated_dir = movement;
        //self.momentum.y = 0;
      }
    default:
  }
  
  // Collision
  BoundingBox f_bounds = self.unit_bounds();

  // North
  BoundingBox north = {
    (gamestate.world.player.position + {0,0,-1}).get_tile_pos() - {0.5,0.5,0.5},
    (gamestate.world.player.position + {0,0,-1}).get_tile_pos() + {0.5,0.5,0.5},
  };
  bool north_s = tile::is_solid(gamestate.world.tile((gamestate.world.player.position + {0,0,-1}).get_tile_pos().to_int_array()));
  if ((north_s && raylib::check_collision_boxes(f_bounds, north))) {
    if (rotated_dir.z < 0) rotated_dir.z = 0;
  }

  // South
  Tile* south_t = gamestate.world.tile((gamestate.world.player.position + {0,0,-1}).get_tile_pos().to_int_array());
  BoundingBox south = {
    (gamestate.world.player.position + {0,0,1}).get_tile_pos() - {0.5,0.5,0.5},
    (gamestate.world.player.position + {0,0,1}).get_tile_pos() + {0.5,0.5,0.5},
  };
  bool south_s = tile::is_solid(gamestate.world.tile((gamestate.world.player.position + {0,0,1}).get_tile_pos().to_int_array()));
  if (south_s && raylib::check_collision_boxes(f_bounds, south)) {
    if (rotated_dir.z > 0) rotated_dir.z = 0;
  }

  // East
  Tile* east_t = gamestate.world.tile((gamestate.world.player.position + {-1,0,0}).get_tile_pos().to_int_array());
  BoundingBox east = {
    (gamestate.world.player.position + {-1,0,0}).get_tile_pos() - {0.5,0.5,0.5},
    (gamestate.world.player.position + {-1,0,0}).get_tile_pos() + {0.5,0.5,0.5},
  };
  bool east_s = tile::is_solid(gamestate.world.tile((gamestate.world.player.position + {-1,0,0}).get_tile_pos().to_int_array()));
  if (east_s && raylib::check_collision_boxes(f_bounds, east)) {
    if (rotated_dir.x < 0) rotated_dir.x = 0;
  }

  // West
  Tile* west_t = gamestate.world.tile((gamestate.world.player.position + {1,0,0}).get_tile_pos().to_int_array());
  BoundingBox west = {
    (gamestate.world.player.position + {1,0,0}).get_tile_pos() - {0.5,0.5,0.5},
    (gamestate.world.player.position + {1,0,0}).get_tile_pos() + {0.5,0.5,0.5},
  };
  bool west_s = tile::is_solid(gamestate.world.tile((gamestate.world.player.position + {1,0,0}).get_tile_pos().to_int_array()));
  if (west_s && raylib::check_collision_boxes(f_bounds, west)) {
    if (rotated_dir.x > 0) rotated_dir.x = 0;
  }

  self.move(rotated_dir);
}
<* General unit logic *>
fn void Unit.tick(&self) {
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

  //
  switch (self.personality) {
    case HOSTILE:
    default:
  }
}

<**>
fn bool contested_roll(Unit* attacker, Unit* defender, Skills skill) {
  switch (skill) {
    case STEALTH:
      int atk_roll = random::rand(20) + (attacker.skills[Skills.PERCEPTION].value / 10);
      int def_roll = random::rand(20) + (defender.skills[Skills.STEALTH].value / 10);

      bool result = (atk_roll >= def_roll);
      if (result) {
        SkillNode* node = &attacker.skills[Skills.PERCEPTION];
        node.exp += 1;
      } else {
        SkillNode* node = &defender.skills[Skills.STEALTH];
        node.exp += 1;
      }

      return result;
    default:
      return false;
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


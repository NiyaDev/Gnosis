
module gnosis::unit;
import std::io;
import std::math;
import std::collections;
import pleroma;
import gnosis::world;
import gnosis::system;


struct Unit {
  Vector3 position;
  Vector3 momentum;
  Texture* sprite;
  bool grounded;
  bool stealthed;

  //* General
  float hp_cur, hp_max, hp_tick;
  float st_cur, st_max, st_tick;
  float mn_cur, mn_max, mn_tick;
  float hn_cur, hn_max, hn_tick;

  //* Information
  Species species;
  SkillList skills;

  // Personality
  Personality personality;
  Memories memories;
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
  self.hp_cur = self.hp_max / 2;

  // Stamina
  self.st_max = (float)self.skills[Skills.STAMINA].value * (skills::STAMINA_MOD * size_mod);
  self.st_cur = self.st_max;

  // Mana
  self.mn_max = (float)self.skills[Skills.MANA].value * (skills::MANA_MOD * size_mod);
  self.mn_cur = self.mn_max;

  // Hunger
  self.hn_max = (float)self.skills[Skills.BELLY].value * (skills::BELLY_MOD * size_mod);
  self.hn_cur = self.hn_max / 5;
}
<* Move unit in space *>
fn void Unit.move(&self, Vector3 movement) {
  self.position += movement;
}
<* Unit update *>
fn void Unit.update(&self, bool is_player = false) {
  float dt = raylib::get_frame_time();

  // Gravity
  BoundingBox g_bounds = self.ground_bounds();
  Vector3 tile_pos = self.position;
  //tile_pos.y.floor();
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
      if (self.grounded && gamestate.world.player.position.distance(self.position) < 5 + (self.skills[Skills.PERCEPTION].value * 0.2)) {
        if (!gamestate.world.player.stealthed || (gamestate.world.player.stealthed && contested_roll(self, gamestate.world.player, STEALTH))) {
          Vector3 movement = self.position.move_towards(gamestate.world.player.position, 0.05);
          if (movement != {0,0,0}) { movement -= self.position; }
          movement.x = movement.x.clamp(-1,1);
          movement.y = 0;
          movement.z = movement.z.clamp(-1,1);
          rotated_dir = movement;
        }
      }
    default:
  }
  
  // Collision
  self.collision(&rotated_dir);

  self.move(rotated_dir);
}
<* General unit logic *>
fn void Unit.tick(&self) {
  // Regeneration logic
  if (self.hn_cur > 0) {
    //* Health regeneration
    if ((self.hp_cur < self.hp_max) && self.hp_tick <= 0) {
      self.hp_tick = self.use_skill(Skills.REGENERATION) / skills::REGENERATION_MOD;
      self.hp_cur++;
      self.hn_cur -= skills::METABOLISM_TICK;
    } else if (self.hp_tick > 0) { self.hp_tick--; }
    if (self.hp_cur > self.hp_max) self.hp_cur = self.hp_max;
    //* Stamina regeneration
    if ((self.st_cur < self.st_max) && self.st_tick <= 0) {
      self.st_tick = self.use_skill(Skills.ENDURANCE) / skills::ENDURANCE_MOD;
      self.st_cur++;
      self.hn_cur -= skills::METABOLISM_TICK;
    } else if (self.st_tick > 0) { self.st_tick--; }
    if (self.st_cur > self.st_max) self.st_cur = self.st_max;
    //* Mana regeneration
    if ((self.mn_cur < self.mn_max) && self.mn_tick <= 0) {
      self.mn_tick = self.use_skill(Skills.CURRENT) / skills::CURRENT_MOD;
      self.mn_cur++;
      self.hn_cur -= skills::METABOLISM_TICK;
    } else if (self.mn_tick > 0) { self.mn_tick--; }
    if (self.mn_cur > self.mn_max) self.mn_cur = self.mn_max;
    //* Natural hunger tick
    if (self.hn_tick <= 0) {
      self.hn_tick = self.use_skill(Skills.METABOLISM) / skills::METABOLISM_MOD;
      self.hn_cur -= skills::METABOLISM_TICK / 10;
    } else { self.hn_tick--; }
  } else {
    //* Tick Health down from hunger 
    if (self.hn_tick <= 0) {
      self.hn_tick = self.skills[Skills.METABOLISM].value / skills::METABOLISM_MOD;
      self.hp_cur -= skills::METABOLISM_TICK / 10;
    } else if (self.hn_tick > 0) { self.hn_tick--; }
  }

  // Personaility
  switch (self.personality) {
    case HOSTILE:
    default:
  }

  // Memories
  for (int i; i < self.memories.len(); i++) {
    self.memories[i].timer--;

    if (self.memories[i].timer <= 0) {
      io::printfn("Forgot %s",self.memories[i].type);
      self.memories.remove_at(i);
      i--;
    }
  }
}
<* Collision checking *>
fn void Unit.collision(&self, Vector3* rotated_dir) {
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
}

<* Rolls a contested skill check depending on the inputted skill *>
fn bool contested_roll(Unit* attacker, Unit* defender, Skills skill) {
  switch (skill) {
    case STEALTH:
      Memory mem_seen = {
        TARGET_SEEN,
        (void*)defender,
        (int)(gamestate.world.ticks_per_second() * 10), // Ticks per second * seconds
      };
      Memory mem_hidden = {
        TARGET_HIDDEN,
        (void*)defender,
        (int)(gamestate.world.ticks_per_second() * 10), // Ticks per second * seconds
      };
      if (attacker.memories.has_memory(mem_seen))   return true;
      if (attacker.memories.has_memory(mem_hidden)) return false;

      int atk_roll = random::rand(20) + (attacker.skills[PERCEPTION].value / 10);
      int def_roll = random::rand(20) + (defender.skills[STEALTH].value / 10);

      bool result = (atk_roll >= def_roll);
      if (result) {
        attacker.memories.push(mem_seen);
        attacker.use_skill(PERCEPTION);
        io::printfn("Remembered TARGET_SEEN");
      } else {
        attacker.memories.push(mem_hidden);
        defender.use_skill(STEALTH);
        io::printfn("Remembered TARGET_HIDDEN");
      }

      return result;
    default:
      return false;
  }
}
<* Use a skill, increasing experience and returning current value *>
fn int Unit.use_skill(&self, Skills skill, int amount = 1) {
  SkillNode* node = &self.skills[skill];
  node.exp += amount;

  // Level up based on individual skill
  switch (skill) {
    // Regeneration stats
    case REGENERATION:
      if (node.exp >= 100) {
        node.exp -= 100;
        node.value++;
      }
      return node.value;
    case ENDURANCE:
      if (node.exp >= 100) {
        node.exp -= 100;
        node.value++;
      }
      return node.value;
    case CURRENT:
      if (node.exp >= 100) {
        node.exp -= 100;
        node.value++;
      }
      return node.value;
    case METABOLISM:
      if (node.exp >= 500) {
        node.exp -= 500;
        node.value++;
      }
      return node.value;
    // Perception / Stealth
    case PERCEPTION:
      if (node.exp >= 10) {
        node.exp -= 10;
        node.value++;
      }
      return node.value;
    case STEALTH:
      if (node.exp >= 10) {
        node.exp -= 10;
        node.value++;
      }
      return node.value;
    default: return node.value;
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
<* Get grounding bounding box for unit based on position and size *>
fn BoundingBox Unit.ground_bounds(&self) {
  float modifier = 0.23; // TODO: Size modifier
  Vector3 pos = self.position;
  return {
    {pos.x - modifier, pos.y - (modifier / 4), pos.z - modifier},
    {pos.x + modifier, pos.y + (modifier / 2), pos.z + modifier},
  };
}

<* Returns Unit position in whole tiles *>
fn Vector3 Vector3.get_tile_pos(&self) {
  return {
    (int)((self.x + 0.5).floor()),
    (int)((self.y + 0.5).floor()),
    (int)((self.z + 0.5).floor()),
  };
}


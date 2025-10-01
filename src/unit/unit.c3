
module gnosis::unit;
import gnosis::world;
import gnosis::system;
import ennoia;
import std::io;


struct Unit {
  Vector3 position;
  Vector3 momentum;
  float size;
  bool grounded;
  bool hidden;

  // Stats
  int hpCur, hpMax, hpTick;
  int mnCur, mnMax, mnTick;
  int hnCur, hnMax, hnTick;

  // Information
  String species;
  SkillList skills;
}

<* Create new Unit *>
fn Unit new(
  Vector3 position = {0,0,0},
  String species = "human",
) {
  Unit output = {
    position,
    {0,0,0}, // Momentum
    0.75,     // Size
    false, // Grounded
    false, // Hidden
    0,0,0, // HP
    0,0,0, // Mana
    0,0,0, // Hunger
    species,
    {},
  };

  // Species stuff
  // TODO:
  output.skills.set(HEALTH, {5,20,0});
  output.skills.set(HEALTH_REGEN, {2,20,0});
  output.skills.set(MANA, {5,20,0});
  output.skills.set(MANA_REGEN, {2,20,0});
  output.skills.set(HUNGER, {5,20,0});
  output.skills.set(PERCEPTION, {5,20,0});

  output.update_stats();

  output.hpCur = output.hpMax;
  output.mnCur = output.mnMax;
  output.hnCur = output.hnMax;

  return output;
}

<* Move Unit *>
fn void Unit.move(&self, Vector3 move) {
  self.position += move;
}

<* Update stats *>
fn void Unit.update_stats(&self) {
  self.hpMax = self.skills[HEALTH]!!.level * Skill.HEALTH.modifier;
  self.mnMax = self.skills[MANA]!!.level   * Skill.MANA.modifier;
  self.hnMax = self.skills[HUNGER]!!.level * Skill.HUNGER.modifier;
}

<* Unit Update *>
fn void Unit.update(&self) {
  // Gravity
  BoundingBox gBounds = self.ground_bounds();
  Vector3 tilePos = (self.position - {0,1,0}).get_whole_tile();
  Tile? tile = gamestate.world.get_tile(tilePos);
  if (try tile && tile.type.solid) {
    BoundingBox tBounds = {tile.type.bounds.min + tilePos, tile.type.bounds.max + tilePos};
    if (!bounds::check_boxes(gBounds, tBounds)) {
      self.grounded = false;
      self.momentum.y -= 0.75;
      self.momentum.y = self.momentum.y.clamp(-3.5,10);
    } else {
      self.grounded = true;
      self.momentum.y = 0;
      //self.position.y = self.position.y + 0.01;
    }
  } else {
    self.grounded = false;
    self.momentum.y -= 0.75;
    self.momentum.y = self.momentum.y.clamp(-3.5,10);
  }

  self.momentum = self.momentum * (float)ennoia::deltaTime;
  self.momentum.y *= 10;

  if (self.momentum.x != 0 && self.momentum.z != 0) {
    self.momentum *= {0.8, 1, 0.8};
  }

  Vector3 rotatedDirection = (Vector3){0,0,0}.rotate(self.momentum, camera::main.rotation);

  // Check Collision
  self.collision(&rotatedDirection);
  self.move(rotatedDirection);
}
<* Unit tick *>
fn void Unit.tick(&self) {
  int hpRegen = self.skills[HEALTH_REGEN]!!.level;
  int hpTickAmount = ((hpRegen > 10) ? (hpRegen - 10) / 5 :  1);
  int hpTickCount  = ((hpRegen < 11) ? 30 - (hpRegen * 2) : 10);
  if (self.hpTick >= hpTickCount) {
    if (self.hnCur > 0) self.hpCur += hpTickAmount;
    if (self.hpCur > self.hpMax) self.hpCur = self.hpMax;
    self.hpTick = 0;
    self.hnTick += 5;
  } else { self.hpTick++; }
  
  int mnRegen = self.skills[MANA_REGEN]!!.level;
  int mnTickAmount = ((mnRegen > 10) ? (mnRegen - 10) / 5 :  1);
  int mnTickCount  = ((mnRegen < 11) ? 30 - (mnRegen * 2) : 10);
  if (self.mnTick >= mnTickCount) {
    if (self.hnCur > 0) self.mnCur += mnTickAmount;
    if (self.mnCur > self.mnMax) self.mnCur = self.mnMax;
    self.mnTick = 0;
    self.hnTick += 5;
  } else { self.mnTick++; }

  if (self.hnTick >= 60) {
    if (self.hnCur <= 0) {
      self.hpCur--;
    } else {
      self.hnCur--;
    }
    self.hnTick = 0;
  } else { self.hnTick++; }
}

<* Collision checking *>
fn void Unit.collision(&self, Vector3* rotatedDirection) {
  BoundingBox fBounds = self.unit_bounds();
  Vector3 pos = self.position.get_whole_tile();
  BoundingBox tBounds;

  // North
  Tile? north = gamestate.world.get_tile(pos + {0,0,-1});
  if (try north && north.type.solid) {
    tBounds = {north.type.bounds.min + pos + {0,0,-1}, north.type.bounds.max + pos + {0,0,-1}};
    if (bounds::check_boxes(fBounds, tBounds)) {
      if (rotatedDirection.z < 0) rotatedDirection.z = 0;
    }
  }
  // South
  Tile? south = gamestate.world.get_tile(pos + {0,0,1});
  if (try south && south.type.solid) {
    tBounds = {south.type.bounds.min + pos + {0,0,1}, south.type.bounds.max + pos + {0,0,1}};
    if (bounds::check_boxes(fBounds, tBounds)) {
      if (rotatedDirection.z > 0) rotatedDirection.z = 0;
    }
  }
  // East
  Tile? east = gamestate.world.get_tile(pos + {-1,0,0});
  if (try east && east.type.solid) {
    tBounds = {east.type.bounds.min + pos + {-1,0,0}, east.type.bounds.max + pos + {-1,0,0}};
    if (bounds::check_boxes(fBounds, tBounds)) {
      if (rotatedDirection.x < 0) rotatedDirection.x = 0;
    }
  }
  // West
  Tile? west = gamestate.world.get_tile(pos + {1,0,0});
  if (try west && west.type.solid) {
    tBounds = {west.type.bounds.min + pos + {1,0,0}, west.type.bounds.max + pos + {1,0,0}};
    if (bounds::check_boxes(fBounds, tBounds)) {
      if (rotatedDirection.x > 0) rotatedDirection.x = 0;
    }
  }
}

<* Creates a bounding box for the unit *>
fn BoundingBox Unit.unit_bounds(&self) {
  return {
    {self.position.x - (0.5 * self.size), self.position.y,                   self.position.z - (0.5 * self.size)},
    {self.position.x + (0.5 * self.size), self.position.y + (1 * self.size), self.position.z + (0.5 * self.size)},
  };
}
<* Creates a bounding box for units feet *>
fn BoundingBox Unit.ground_bounds(&self) {
  return {
    {self.position.x - (0.5 * self.size), self.position.y - (0.5 * self.size), self.position.z - (0.5 * self.size)},
    {self.position.x + (0.5 * self.size), self.position.y + (0.5 * self.size), self.position.z + (0.5 * self.size)},
  };
}


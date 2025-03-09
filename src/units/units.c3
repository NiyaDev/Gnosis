
module gnosis::unit;
import std::io;
import std::collections;
import raylib;


struct Unit {
  Vector3 position;
  Texture* sprite;

  //* General
  float hp_cur, hp_max, hp_tick;
  float st_cur, st_max, st_tick;
  float mn_cur, mn_max, mn_tick;
  float hn_cur, hn_max, hn_tick;

  //* Data
  Species* species;
  HashMap(<String, SkillNode>) skills;
}

<* Create a new Unit - Deprecated? *>
fn Unit* new(String spec = "") {
  Unit* output = mem::new(Unit);
  
  if (spec != "") {
    output.species = species::get(spec)!!;
  }

  return output;
}
<* Initialize a unit to base values *>
fn void Unit.init(&self, String spec = "") {
  if (spec != "") {
    self.species = species::get(spec)!!;

    //* Copy skill values
    skills::data.@each(; String key, Skill val) {
      SkillNode node;
      node.skill = &val;
      int! skill_start = self.species.skill_start[node.skill.id_name];
      if (try skill_start) {
        node.value = skill_start;
        node.discovered = false;
      }
      
      // TODO: Have yaml store whether the skill is discovered

      self.skills.set(key.copy(), node);
    };

    //* Calculate status skills
    // Health
    self.hp_max = (float)self.skills["health"]!!.value * skills::HEALTH_MOD;
    self.hp_cur = self.hp_max/ 2;

    // Stamina
    self.st_max = (float)self.skills["stamina"]!!.value * skills::STAMINA_MOD;
    self.st_cur = self.st_max;

    // Mana
    self.mn_max = (float)self.skills["mana"]!!.value * skills::MANA_MOD;
    self.mn_cur = self.mn_max;

    // Hunger
    self.hn_max = (float)self.skills["belly"]!!.value * skills::BELLY_MOD;
    self.hn_cur = self.hn_max;
  }
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
fn void Unit.update(&self) {

  //* Regeneration logic
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



module gnosis::unit;
import ennoia::vector;
import std::io;


struct Unit {
  Vector3 position;
  bool grounded;

  // Stats
  int hpCur, hpMax, hpTick;
  int mnCur, mnMax, mnTick;
  int hnCur, hnMax, hnTick;

  // Information
  //Species species;
  SkillList skills;
}

<* Create new Unit *>
fn Unit new() {
  Unit output;

  // Species stuff
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

<* Update stats *>
fn void Unit.update_stats(&self) {
  self.hpMax = self.skills[HEALTH]!!.level * Skill.HEALTH.modifier;
  self.mnMax = self.skills[MANA]!!.level   * Skill.MANA.modifier;
  self.hnMax = self.skills[HUNGER]!!.level * Skill.HUNGER.modifier;
}
<**>
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


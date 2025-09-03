
module gnosis::unit;
import std::collections;



enum Skill : int (int modifier, String local) {
  HEALTH       = {10, "HEALTH"},
  HEALTH_REGEN = { 0, "REGEN"},
  MANA         = {10, "MANA"},
  MANA_REGEN   = { 0, "CUURENT"},

  PERCEPTION   = {10, "PERCEPTION"},
}

struct SkillNode {
  int level, max;
  uint exp;
}

alias SkillList = HashMap{Skill, SkillNode};

fn uint Skill.hash(self) {
  return self.ordinal.hash();
}


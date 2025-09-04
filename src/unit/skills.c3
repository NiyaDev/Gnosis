
module gnosis::unit;
import std::collections;



alias SkillList = HashMap{Skill, SkillNode};

enum Skill : int (int modifier, String local) {
  HEALTH       = { 5, "HEALTH"},
  HEALTH_REGEN = { 0, "REGEN"},
  MANA         = { 5, "MANA"},
  MANA_REGEN   = { 0, "CURRENT"},
  HUNGER       = { 5, "HUNGER"},

  SOMNOLENCE   = {12, "SOMNOLENCE"},
  PERCEPTION   = { 5, "PERCEPTION"},
}

struct SkillNode {
  int level, max;
  uint exp;
}


<* Give experience to skill and check for level up *>
fn void SkillList.give_exp(&self, Skill skill, int amount) {
  SkillNode* node = self.get_ref(skill)!!;
  node.exp += amount;
  if (node.exp >= 100) {
    node.exp = 0;
    node.level++;
  }
}

fn uint Skill.hash(self) {
  return self.ordinal.hash();
}


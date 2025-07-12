
module gnosis::unit::skills;
import gnosis::unit::species;
import std::io;
import std::collections;
import ennoia;


typedef SkillList = SkillNode[];

struct SkillNode {
  int value, max;
  uint exp;
  uint discovery;
}

enum Skills {
  HEALTH,
  REGENERATION,
  STAMINA,
  ENDURANCE,
  MANA,
  CURRENT,
  BELLY,
  METABOLISM,
  SOMNOLENCE,

  PERCEPTION,

  STEALTH,
}


const float HEALTH_MOD = 10;
const float REGENERATION_MOD = 0.05;

const float STAMINA_MOD = 10;
const float ENDURANCE_MOD = 0.1;

const float MANA_MOD = 10;
const float CURRENT_MOD = 0.025;

const float BELLY_MOD = 5;
const float METABOLISM_MOD = 50;
const float METABOLISM_TICK = 0.2;

const float SOMNOLENCE_BASE = 12;


<* Get base skills, levels, and max by species *>
fn SkillList get(Species species) {
  SkillList output = (SkillList)mem::new_array(SkillNode, Skills.len);

  switch (species) {
    case HUMAN:
      output[Skills.HEALTH]       = { 5, 20, 0, 1};
      output[Skills.REGENERATION] = { 2, 10, 0, 0};

      output[Skills.STAMINA]      = { 5, 20, 0, 1};
      output[Skills.ENDURANCE]    = { 2, 20, 0, 0};

      output[Skills.MANA]         = { 5, 20, 0, 0};
      output[Skills.CURRENT]      = { 2, 10, 0, 0};

      output[Skills.BELLY]        = { 5, 20, 0, 1};
      output[Skills.METABOLISM]   = { 5, 20, 0, 0};

      output[Skills.SOMNOLENCE]   = { 2, 60, 0, 0};

      output[Skills.PERCEPTION]   = {15, 30, 0, 1};

      output[Skills.STEALTH]      = { 0, 20, 0, 0};
    case ELF:
      output[Skills.HEALTH]       = { 4, 16, 0, 1};
      output[Skills.REGENERATION] = { 2,  8, 0, 0};

      output[Skills.STAMINA]      = { 5, 20, 0, 1};
      output[Skills.ENDURANCE]    = { 2, 20, 0, 0};

      output[Skills.MANA]         = { 8, 25, 0, 1};
      output[Skills.CURRENT]      = { 3, 20, 0, 0};

      output[Skills.BELLY]        = { 4, 14, 0, 1};
      output[Skills.METABOLISM]   = { 5, 20, 0, 0};

      output[Skills.SOMNOLENCE]   = { 4, 80, 0, 0};

      output[Skills.PERCEPTION]   = {20, 40, 0, 1};

      output[Skills.STEALTH]      = { 0, 30, 0, 0};
    case DWARF:
      output[Skills.HEALTH]       = { 8, 24, 0, 1};
      output[Skills.REGENERATION] = { 4, 12, 0, 0};

      output[Skills.STAMINA]      = { 8, 22, 0, 1};
      output[Skills.ENDURANCE]    = { 4, 30, 0, 0};

      output[Skills.MANA]         = { 3,  6, 0, 0};
      output[Skills.CURRENT]      = { 1,  8, 0, 0};

      output[Skills.BELLY]        = { 4, 14, 0, 1};
      output[Skills.METABOLISM]   = { 5, 20, 0, 0};

      output[Skills.SOMNOLENCE]   = { 3, 80, 0, 0};

      output[Skills.PERCEPTION]   = {10, 20, 0, 1};

      output[Skills.STEALTH]      = { 0, 10, 0, 0};
    case ORC:
      output[Skills.HEALTH]       = {10, 30, 0, 1};
      output[Skills.REGENERATION] = { 5, 15, 0, 0};

      output[Skills.STAMINA]      = { 8, 22, 0, 1};
      output[Skills.ENDURANCE]    = { 4, 30, 0, 0};

      output[Skills.MANA]         = { 2,  8, 0, 0};
      output[Skills.CURRENT]      = { 1,  8, 0, 0};

      output[Skills.BELLY]        = { 5, 20, 0, 1};
      output[Skills.METABOLISM]   = { 5, 20, 0, 0};

      output[Skills.SOMNOLENCE]   = { 0,  0, 0, 0};

      output[Skills.PERCEPTION]   = {20, 40, 0, 1};

      output[Skills.STEALTH]      = { 0, 20, 0, 0};
    case GOBLIN:
      output[Skills.HEALTH]       = { 5, 18, 0, 1};
      output[Skills.REGENERATION] = { 2, 10, 0, 0};

      output[Skills.STAMINA]      = { 5, 24, 0, 1};
      output[Skills.ENDURANCE]    = { 2, 18, 0, 0};

      output[Skills.MANA]         = { 5, 10, 0, 0};
      output[Skills.CURRENT]      = { 2, 12, 0, 0};

      output[Skills.BELLY]        = { 6, 20, 0, 1};
      output[Skills.METABOLISM]   = { 1, 10, 0, 0};

      output[Skills.SOMNOLENCE]   = { 1, 70, 0, 0};

      output[Skills.PERCEPTION]   = {15, 30, 0, 1};

      output[Skills.STEALTH]      = { 0, 40, 0, 0};
    case KOBOLD:
      output[Skills.HEALTH]       = { 5, 18, 0, 1};
      output[Skills.REGENERATION] = { 2, 10, 0, 0};

      output[Skills.STAMINA]      = { 5, 24, 0, 1};
      output[Skills.ENDURANCE]    = { 2, 18, 0, 0};

      output[Skills.MANA]         = { 5, 10, 0, 0};
      output[Skills.CURRENT]      = { 2, 12, 0, 0};

      output[Skills.BELLY]        = { 6, 20, 0, 1};
      output[Skills.METABOLISM]   = { 1, 10, 0, 0};

      output[Skills.SOMNOLENCE]   = { 1, 70, 0, 0};

      output[Skills.PERCEPTION]   = {10, 20, 0, 1};

      output[Skills.STEALTH]      = { 0, 40, 0, 0};
    case SKELETON:
      output[Skills.HEALTH]       = { 5, 10, 0, 1};
      output[Skills.REGENERATION] = { 0,  0, 0, 0};

      output[Skills.STAMINA]      = { 1, 10, 0, 1};
      output[Skills.ENDURANCE]    = { 1, 10, 0, 0};

      output[Skills.MANA]         = { 1, 10, 0, 0};
      output[Skills.CURRENT]      = { 1, 10, 0, 0};

      output[Skills.BELLY]        = { 0,  0, 0, 1};
      output[Skills.METABOLISM]   = { 0,  0, 0, 0};

      output[Skills.SOMNOLENCE]   = { 0,  0, 0, 0};

      output[Skills.PERCEPTION]   = {15, 20, 0, 1};

      output[Skills.STEALTH]      = { 0, 20, 0, 0};
    case SLIME:
      output[Skills.HEALTH]       = { 5, 20, 0, 1};
      output[Skills.REGENERATION] = { 5, 40, 0, 0};

      output[Skills.STAMINA]      = { 5, 20, 0, 1};
      output[Skills.ENDURANCE]    = { 5, 40, 0, 0};

      output[Skills.MANA]         = { 5, 20, 0, 0};
      output[Skills.CURRENT]      = { 5, 40, 0, 0};

      output[Skills.BELLY]        = { 8, 30, 0, 1};
      output[Skills.METABOLISM]   = { 1,  8, 0, 0};

      output[Skills.SOMNOLENCE]   = { 0,  0, 0, 0};

      output[Skills.PERCEPTION]   = { 5, 10, 0, 1};

      output[Skills.STEALTH]      = { 0, 10, 0, 0};
    case RAT:
      output[Skills.HEALTH]       = { 1,  2, 0, 1};
      output[Skills.REGENERATION] = { 2, 10, 0, 0};

      output[Skills.STAMINA]      = { 1,  2, 0, 1};
      output[Skills.ENDURANCE]    = { 1, 10, 0, 0};

      output[Skills.MANA]         = { 1,  4, 0, 0};
      output[Skills.CURRENT]      = { 1, 10, 0, 0};

      output[Skills.BELLY]        = { 2,  4, 0, 1};
      output[Skills.METABOLISM]   = { 3, 20, 0, 0};

      output[Skills.SOMNOLENCE]   = { 2, 20, 0, 0};

      output[Skills.PERCEPTION]   = { 5, 10, 0, 1};

      output[Skills.STEALTH]      = { 0, 50, 0, 0};
  }

  return output;
}

<* Get whole Skillnode from array *>
fn SkillNode SkillList.get(&self, Skills skill) @operator([]) {
  SkillNode[]* array = (SkillNode[]*)self;
  return (*array)[skill.ordinal];
}
<* Get reference to Skillnode in array *>
fn SkillNode* SkillList.get_ref(&self, Skills skill) @operator(&[]) {
  SkillNode[]* array = (SkillNode[]*)self;
  return &(*array)[skill.ordinal];
}
<* Set Skillnode in array *>
fn void SkillList.set(&self, Skills skill, SkillNode node) @operator([]=) {
  SkillNode[]* array = (SkillNode[]*)self;
  (*array)[skill.ordinal] = node;
}


module gnosis::unit::skills;
import gnosis::unit::species;
import std::io;
import std::collections;
import pleroma;


HashMap{String, Skill} skillslocal @builtin;
struct Skill {
  String id_name;
  Localization name;
  Localization description;
  Localization indepth;
}

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
}


const float HEALTH_MOD = 10;
const float REGENERATION_MOD = -0.01;

const float STAMINA_MOD = 10;
const float ENDURANCE_MOD = -0.1;

const float MANA_MOD = 10;
const float CURRENT_MOD = -0.01;

const float BELLY_MOD = 5;
const float METABOLISM_MOD = 1;

const float SOMNOLENCE_BASE = 12;


<**>
fn SkillNode[] get(Species species) {
  SkillNode[] output = mem::new_array(SkillNode, Skills.len);

  switch (species) {
    case HUMAN:
      output[Skills.HEALTH.ordinal]       = { 5, 20, 0, 1};
      output[Skills.REGENERATION.ordinal] = { 2, 10, 0, 0};

      output[Skills.STAMINA.ordinal]      = { 5, 20, 0, 1};
      output[Skills.ENDURANCE.ordinal]    = { 2, 20, 0, 0};

      output[Skills.MANA.ordinal]         = { 5, 20, 0, 0};
      output[Skills.CURRENT.ordinal]      = { 2, 10, 0, 0};

      output[Skills.BELLY.ordinal]        = { 5, 20, 0, 1};
      output[Skills.METABOLISM.ordinal]   = { 5, 20, 0, 0};

      output[Skills.SOMNOLENCE.ordinal]   = { 2, 60, 0, 0};

      output[Skills.PERCEPTION.ordinal]   = {15, 30, 0, 1};
    case ELF:
      output[Skills.HEALTH.ordinal]       = { 4, 16, 0, 1};
      output[Skills.REGENERATION.ordinal] = { 2,  8, 0, 0};

      output[Skills.STAMINA.ordinal]      = { 5, 20, 0, 1};
      output[Skills.ENDURANCE.ordinal]    = { 2, 20, 0, 0};

      output[Skills.MANA.ordinal]         = { 8, 25, 0, 1};
      output[Skills.CURRENT.ordinal]      = { 3, 20, 0, 0};

      output[Skills.BELLY.ordinal]        = { 4, 14, 0, 1};
      output[Skills.METABOLISM.ordinal]   = { 5, 20, 0, 0};

      output[Skills.SOMNOLENCE.ordinal]   = { 4, 80, 0, 0};

      output[Skills.PERCEPTION.ordinal]   = {20, 40, 0, 1};
    case DWARF:
      output[Skills.HEALTH.ordinal]       = { 8, 24, 0, 1};
      output[Skills.REGENERATION.ordinal] = { 4, 12, 0, 0};

      output[Skills.STAMINA.ordinal]      = { 8, 22, 0, 1};
      output[Skills.ENDURANCE.ordinal]    = { 4, 30, 0, 0};

      output[Skills.MANA.ordinal]         = { 3,  6, 0, 0};
      output[Skills.CURRENT.ordinal]      = { 1,  8, 0, 0};

      output[Skills.BELLY.ordinal]        = { 4, 14, 0, 1};
      output[Skills.METABOLISM.ordinal]   = { 5, 20, 0, 0};

      output[Skills.SOMNOLENCE.ordinal]   = { 3, 80, 0, 0};

      output[Skills.PERCEPTION.ordinal]   = {10, 20, 0, 1};
    case ORC:
      output[Skills.HEALTH.ordinal]       = {10, 30, 0, 1};
      output[Skills.REGENERATION.ordinal] = { 5, 15, 0, 0};

      output[Skills.STAMINA.ordinal]      = { 8, 22, 0, 1};
      output[Skills.ENDURANCE.ordinal]    = { 4, 30, 0, 0};

      output[Skills.MANA.ordinal]         = { 2,  8, 0, 0};
      output[Skills.CURRENT.ordinal]      = { 1,  8, 0, 0};

      output[Skills.BELLY.ordinal]        = { 5, 20, 0, 1};
      output[Skills.METABOLISM.ordinal]   = { 5, 20, 0, 0};

      output[Skills.SOMNOLENCE.ordinal]   = { 0,  0, 0, 0};

      output[Skills.PERCEPTION.ordinal]   = {20, 40, 0, 1};
    case GOBLIN:
      output[Skills.HEALTH.ordinal]       = { 5, 18, 0, 1};
      output[Skills.REGENERATION.ordinal] = { 2, 10, 0, 0};

      output[Skills.STAMINA.ordinal]      = { 5, 24, 0, 1};
      output[Skills.ENDURANCE.ordinal]    = { 2, 18, 0, 0};

      output[Skills.MANA.ordinal]         = { 5, 10, 0, 0};
      output[Skills.CURRENT.ordinal]      = { 2, 12, 0, 0};

      output[Skills.BELLY.ordinal]        = { 6, 20, 0, 1};
      output[Skills.METABOLISM.ordinal]   = { 1, 10, 0, 0};

      output[Skills.SOMNOLENCE.ordinal]   = { 1, 70, 0, 0};

      output[Skills.PERCEPTION.ordinal]   = {15, 30, 0, 1};
    case KOBOLD:
      output[Skills.HEALTH.ordinal]       = { 5, 18, 0, 1};
      output[Skills.REGENERATION.ordinal] = { 2, 10, 0, 0};

      output[Skills.STAMINA.ordinal]      = { 5, 24, 0, 1};
      output[Skills.ENDURANCE.ordinal]    = { 2, 18, 0, 0};

      output[Skills.MANA.ordinal]         = { 5, 10, 0, 0};
      output[Skills.CURRENT.ordinal]      = { 2, 12, 0, 0};

      output[Skills.BELLY.ordinal]        = { 6, 20, 0, 1};
      output[Skills.METABOLISM.ordinal]   = { 1, 10, 0, 0};

      output[Skills.SOMNOLENCE.ordinal]   = { 1, 70, 0, 0};

      output[Skills.PERCEPTION.ordinal]   = {10, 20, 0, 1};
    case SKELETON:
      output[Skills.HEALTH.ordinal]       = { 5, 10, 0, 1};
      output[Skills.REGENERATION.ordinal] = { 0,  0, 0, 0};

      output[Skills.STAMINA.ordinal]      = { 1, 10, 0, 1};
      output[Skills.ENDURANCE.ordinal]    = { 1, 10, 0, 0};

      output[Skills.MANA.ordinal]         = { 1, 10, 0, 0};
      output[Skills.CURRENT.ordinal]      = { 1, 10, 0, 0};

      output[Skills.BELLY.ordinal]        = { 0,  0, 0, 1};
      output[Skills.METABOLISM.ordinal]   = { 0,  0, 0, 0};

      output[Skills.SOMNOLENCE.ordinal]   = { 0,  0, 0, 0};

      output[Skills.PERCEPTION.ordinal]   = {15, 20, 0, 1};
    case SLIME:
      output[Skills.HEALTH.ordinal]       = { 5, 20, 0, 1};
      output[Skills.REGENERATION.ordinal] = { 5, 40, 0, 0};

      output[Skills.STAMINA.ordinal]      = { 5, 20, 0, 1};
      output[Skills.ENDURANCE.ordinal]    = { 5, 40, 0, 0};

      output[Skills.MANA.ordinal]         = { 5, 20, 0, 0};
      output[Skills.CURRENT.ordinal]      = { 5, 40, 0, 0};

      output[Skills.BELLY.ordinal]        = { 8, 30, 0, 1};
      output[Skills.METABOLISM.ordinal]   = { 1,  8, 0, 0};

      output[Skills.SOMNOLENCE.ordinal]   = { 0,  0, 0, 0};

      output[Skills.PERCEPTION.ordinal]   = { 5, 10, 0, 1};
    case RAT:
      output[Skills.HEALTH.ordinal]       = { 1,  2, 0, 1};
      output[Skills.REGENERATION.ordinal] = { 2, 10, 0, 0};

      output[Skills.STAMINA.ordinal]      = { 1,  2, 0, 1};
      output[Skills.ENDURANCE.ordinal]    = { 1, 10, 0, 0};

      output[Skills.MANA.ordinal]         = { 1,  4, 0, 0};
      output[Skills.CURRENT.ordinal]      = { 1, 10, 0, 0};

      output[Skills.BELLY.ordinal]        = { 2,  4, 0, 1};
      output[Skills.METABOLISM.ordinal]   = { 3, 20, 0, 0};

      output[Skills.SOMNOLENCE.ordinal]   = { 2, 20, 0, 0};

      output[Skills.PERCEPTION.ordinal]   = { 5, 10, 0, 1};
  }

  return output;
}


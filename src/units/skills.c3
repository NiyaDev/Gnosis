
module gnosis::unit::skills;


Skill[] data;
struct Skill {
  // TODO: Localization
  int id;
  String name;
  String description;
  String indepth;
}

struct SkillNode {
  Skill* skill;
  int value;
  bool discovered;
}


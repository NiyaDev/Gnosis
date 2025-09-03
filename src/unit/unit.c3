
module gnosis::unit;
import ennoia::vector;


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



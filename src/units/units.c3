
module gnosis::unit;
import std::io;
import raylib;


struct Unit {
  Vector3 position;
  Texture* sprite;

  //* General
  float hp_cur, hp_max;
  float st_cur, st_max;
  float mn_cur, mn_max;
  float hn_cur, hn_max;

  //* Data
  Species* species;
  SkillNode[] skills;
}

<**>
fn Unit* new(String spec = "") {
  Unit* output = mem::new(Unit);

  output.skills = mem::new_array(SkillNode, skills::data.len);
  
  if (spec != "") {
    output.species = species::get(spec)!!;
  }

  return output;
}
<**>
fn void Unit.init(&self, String spec = "") {
  self.skills = mem::new_array(SkillNode, skills::data.len);

  if (spec != "") {
    self.species = species::get(spec)!!;

    //* Copy skill values
    for (int i; i < skills::data.len; i++) {
      SkillNode node;
      node.skill = &skills::data[i];
      int! skill_start = self.species.skill_start[node.skill.id_name];
      if (try skill_start) {
        node.value = skill_start;
        node.discovered = false;
      }
      io::printfn("%s:%d",node.skill.id_name,node.value);
      
      // TODO: Have yaml store whether the skill is discovered
    }
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


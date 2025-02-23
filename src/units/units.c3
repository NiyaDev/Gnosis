
module gnosis::unit;
import std::io;
import raylib;


struct Unit {
  Vector3 position;
  Texture* sprite;

  //* Data
  Species* species;
  SkillNode[] skills;
}

<**>
fn Unit* new(String spec = "") {
  Unit* output = mem::new(Unit);
  
  if (spec != "") output.species = species::get(spec)!!;

  return output;
}
<**>
fn void Unit.init(&self, String spec = "") {
  if (spec != "") self.species = species::get(spec)!!;
}
<* Move unit in space 
  @param movement "Amount to move"
 *>
fn void Unit.move(&self, Vector3 movement) {
  self.position.x += movement.x;
  self.position.y += movement.y;
  self.position.z += movement.z;
}


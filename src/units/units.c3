
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

<* Move unit in space 
  @param movement "Amount to move"
 *>
fn void Unit.move(&self, Vector3 movement) {
  self.position.x += movement.x;
  self.position.y += movement.y;
  self.position.z += movement.z;
}


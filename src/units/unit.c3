
module gnosis::unit;
import std::io;
import raylib5::rl;



struct Unit {
  Vector3 position;
  Texture sprite;

  //* Data
  Species species;
  //Body body;
  SkillData[] skills;
}

/** Create new initialized unit
  @param species "Species to set unit as. If left empty, doesn't set"
 **/
fn Unit* init(Species species = NULL) {
  Unit* output = mem::new(Unit);
  output.skills = mem::new_array(SkillData, skills::NUMBER_OF_SKILLS);

  if (species != NULL) output.set_species(species);

  return output;
}
/** Set defaults for Species
  @param species "The species to set"
 **/
fn void Unit.set_species(&self, Species species) {
  self.species = species;

  //* Body

  //io::printfn("%s ",species.base);
  //* skills
  for (int i; i<skills::NUMBER_OF_SKILLS; i++) {
    switch (species) {
      case HUMAN:
        io::printfn("%s: %d", (Skill)i, species::HUMAN_BASE[i]);
        self.skills[i] = {
          .value = species::HUMAN_BASE[i],
          .discovered = false,
        };
      default:
    }
  }
  
}

/** Move unit in space
  @param movement "Amount to move"
 **/
fn void Unit.move(&self, Vector3 movement) {
  self.position.x += movement.x;
  self.position.y += movement.y;
  self.position.z += movement.z;
}


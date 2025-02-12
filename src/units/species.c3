
module gnosis::unit::species;
import gnosis::unit;
import yaml;


Species[] data;
struct Species {
  // TODO: Localization
  String name;
  String description;

  int[] skill_start;
  int[] skill_max;

  float core_temp;
  float base_min_temp;
  float base_max_temp;
}

<*  *>
fn void load(Yaml data) {
  //return mem::new_array(Species,0);
}


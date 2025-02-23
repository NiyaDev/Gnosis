
module gnosis::unit::species;
import std::io;
import std::collections;
import gnosis::unit;
import bulk;
import localization;
import yaml;


HashMap(<String,Species>) data;
struct Species {
  Localization name;
  Localization description;

  HashMap(<String,int>) skill_start;
  HashMap(<String,int>) skill_max;

  float core_temp;
  float base_min_temp;
  float base_max_temp;
}

<* Loads a pointer to a specific species *>
fn Species*! get(String name) {
  return data.get_ref(name)!!;
}

<* Loads species data from file *>
fn void init() {
  Bulk* bulk = bulk::load("resources/051")!!;
  Yaml yaml = yaml::parse((String)bulk.get("yaml")!!)!!;

  //* Iterate through each species
  yaml.@each(; String key, TypedValue val) {
    Species species;
    String species_name = key;

    //* Name localization
    TypedValue name = val.get_object("name")!!;
    ((yaml::Object*)name.value).@each(; String key_name, TypedValue val_name) {
      species.name.add(key_name.to_language(), val_name.v_string);
    };

    //* Description localization
    TypedValue desc = val.get_object("description")!!;
    ((yaml::Object*)desc.value).@each(; String key_desc, TypedValue val_desc) {
      species.description.add(key_desc.to_language(), val_desc.v_string);
    };

    //* Skills
    TypedValue skills = val.get_object("skill")!!;
    ((yaml::Object*)skills.value).@each(; String key_skill, TypedValue val_skill) {
      String skill_name = key_skill;

      //* Starting value
      species.skill_start.set(skill_name, val_skill.get_array(0).v_int)!!;

      //* Max level
      species.skill_max.set(skill_name, val_skill.get_array(1).v_int)!!;
    };

    //* Temperature values
    species.core_temp     = (float)val.get_object("core_temp")!!.v_double;
    species.base_min_temp = (float)val.get_object("base_min_temp")!!.v_double;
    species.base_max_temp = (float)val.get_object("base_max_temp")!!.v_double;

    data.set(species_name, species);
  };
}

<* Prints all species data *>
fn void Species.print(&self) {
  io::printfn("Species:");
  io::printfn("  Name:");
  self.name.@each(; String key, String val) {
    io::printfn("    %s: %s",key,val);
  };
  self.description.@each(; String key, String val) {
    io::printfn("    %s: %s",key,val);
  };
  self.skill_start.@each(; String key, int val) {
    io::printfn("      %s: %d-%d",key,val,self.skill_max.get(key)!!);
  };
}



module gnosis::unit::skills;
import std::io;
import std::collections;
import pleroma;
//import bulk;
//import localization;
//import yaml;


HashMap(<String, Skill>) data;
struct Skill {
  String id_name;
  Localization name;
  Localization description;
  Localization indepth;
}

struct SkillNode {
  Skill* skill;
  int value;
  bool discovered;
}


const float HEALTH_MOD = 10;
const float REGENERATION_MOD = -0.01;
const float STAMINA_MOD = 10;
const float ENDURANCE_MOD = -0.1;
const float MANA_MOD = 10;
const float CURRENT_MOD = -0.01;
const float BELLY_MOD = 5;
const float METABOLISM_MOD = 1;


<*  *>
fn void init() {
  Bulk bulk = bulk::load("resources/050");
  defer bulk.free();

  String raw_text = (String)bulk.get("yaml");

  Yaml yaml = yaml::parse(raw_text);
  defer yaml.free();

  //* Init data
  data.new_init();
  //data = mem::new_array(Skill, yaml.len() + 1)!!;

  yaml.@each(; String key, TypedValue val) {
    Skill sk;
    sk.id_name = key.copy();

    //* Name localization
    TypedValue name = val.get_object("name");
    ((yaml::Object*)name.value).@each(; String key_name, TypedValue val_name) {
      sk.name.add(key_name.to_language(), val_name.v_string);
    };

    //* Description localization
    TypedValue desc = val.get_object("description");
    ((yaml::Object*)desc.value).@each(; String key_name, TypedValue val_name) {
      sk.name.add(key_name.to_language(), val_name.v_string);
    };

    //* Indepth localization
    TypedValue indepth = val.get_object("indepth");
    ((yaml::Object*)indepth.value).@each(; String key_name, TypedValue val_name) {
      sk.name.add(key_name.to_language(), val_name.v_string);
    };

    //data[sk.id] = sk;
    data.set(key.copy(), sk);
  };

  //* Iterate through each skill and copy data into array
}

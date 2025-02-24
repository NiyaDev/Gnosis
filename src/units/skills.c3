
module gnosis::unit::skills;
import std::io;
import bulk;
import localization;
import yaml;


Skill[] data;
struct Skill {
  int id;
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

<*  *>
fn void init() {
  Bulk*! bulk = bulk::load("resources/050");
  assert(@ok(bulk), "Failed to load skills data from resource. (skills.c3)");
  defer bulk.free()!!;

  String! raw_text = (String)bulk.get("yaml");
  assert(@ok(raw_text), "Yaml text corrupted. (skills.c3)");

  Yaml! yaml = yaml::parse(raw_text);
  assert(@ok(yaml), "Yaml failed to parse. (skills.c3)");
  defer yaml.free()!!;

  //* Create array
  data = mem::new_array(Skill, yaml.len() + 1)!!;

  yaml.@each(; String key, TypedValue val) {
    Skill sk;
    sk.id = val.get_object("id")!!.v_int;
    sk.id_name = key.copy();

    //* Name localization
    TypedValue! name = val.get_object("name");
    assert(@ok(name), "Skill didn't have name. (skills.c3)");
    ((yaml::Object*)name.value)!!.@each(; String key_name, TypedValue val_name) {
      sk.name.add(key_name.to_language(), val_name.v_string);
    };

    //* Description localization
    TypedValue! desc = val.get_object("description");
    assert(@ok(name), "Skill didn't have name. (skills.c3)");
    ((yaml::Object*)desc.value)!!.@each(; String key_name, TypedValue val_name) {
      sk.name.add(key_name.to_language(), val_name.v_string);
    };

    //* Indepth localization
    TypedValue! indepth = val.get_object("indepth");
    if (try indepth) {
      ((yaml::Object*)indepth.value).@each(; String key_name, TypedValue val_name) {
        sk.name.add(key_name.to_language(), val_name.v_string);
      };
    }

    data[sk.id] = sk; 
  }!!;

  //* Iterate through each skill and copy data into array
}


module gnosis::resources;
import std::io;
import std::collections;
import ennoia;
import gnosis::unit;


HashMap{String, Font}     fonts     @builtin;
HashMap{String, Texture}  textures  @builtin;
//HashMap{String, Model}    models    @builtin;
HashMap{String, Mesh}     meshes    @builtin;
HashMap{String, Material} materials @builtin;
Keybindings  keybinds     @builtin;
Options      options      @builtin;
Localization localization @builtin;


<* Load all resources from file *>
fn void load() {
  //* Keybindings
  Bulk keybind_bulk = bulk::load("resources/002");
  keybinds = keybind::load(keybind_bulk.entries["default_kb"]!!.value);
  keybind_bulk.free();

  //* Settings
  Bulk settings_bulk = bulk::load("resources/003");
  options = options::load(settings_bulk.entries["default_options"]!!.value);
  settings_bulk.free();

  //* Fonts
  Bulk fonts_bulk = bulk::load("resources/009");
  fonts_bulk.entries.@each(; String key, BulkEntry val) {
    Font font = font::load_mem(".ttf", val.value, 320, {});
    fonts.set(key, font);
  };
  fonts_bulk.free();
  raygui::set_font(fonts["anakron"]!!);

  //* UI Textures
  Bulk ui_textures = bulk::load("resources/030");
  ui_textures.entries.@each(; String key, BulkEntry val) {
    Image img = image::load_mem(".png", val.value);
    textures.set(key, img.texture());
    img.unload();
  };
  ui_textures.free();

  //* Generate models
  Mesh simple_mesh = mesh::cube(1,1,1);
  meshes.set("simple_tile", simple_mesh);
  //models.set("simple_tile", simple_mesh.model());
  Mesh plane_mesh = mesh::plane(1,1,1,1);
  meshes.set("plane_tile", plane_mesh);

  //* Load models


  //* Model Textures
  Image def_tex = image::checked(4,4,2,2, color::PURPLE, color::BLACK);
  textures.set("default", def_tex.texture());
  def_tex.unload();

  Bulk tile_textures = bulk::load("resources/020");
  tile_textures.entries.@each(; String key, BulkEntry val) {
    Image img = image::load_mem(".png", val.value);
    textures.set(key, img.texture());
    img.unload();
  };
  tile_textures.free();

  //* Materials
  Material def_mat = material::load_default();
  def_mat.set_texture(textures["default"]!!);
  materials.set("default", def_mat);
  //models["simple_tile"]!!.materials[0] = def_mat;

  //* Textures
  Bulk other_textures = bulk::load("resources/010");
  other_textures.entries.@each(; String key, BulkEntry val) {
    Image img = image::load_mem(".png", val.value);
    textures.set(key, img.texture());
    img.unload();
  };
  other_textures.free();

  //* localization
  Bulk local_00 = bulk::load("resources/060");
  defer local_00.free();

  String ui = (String)local_00.get("ui");
  Yaml ui_yaml = yaml::parse(ui);
  defer ui_yaml.free();

  String skills = (String)local_00.get("skills");
  Yaml skills_yaml = yaml::parse(skills);
  defer skills_yaml.free();

  String species = (String)local_00.get("species");
  Yaml species_yaml = yaml::parse(species);
  defer species_yaml.free();

  localization.add(ui_yaml);
  localization.add(skills_yaml);
  localization.add(species_yaml);
}

<*  *>
fn void free() {
  
}

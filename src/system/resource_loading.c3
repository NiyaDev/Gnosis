
module gnosis::resources;
import std::io;
import std::collections;
import pleroma;
//import bulk;
//import keybind;
//import raylib;
import gnosis::unit;


HashMap{String, Font}     fonts;
HashMap{String, Texture}  textures;
HashMap{String, Model}    models;
HashMap{String, Mesh}     meshes;
HashMap{String, Material} materials;


<* Load all resources from file *>
fn void load() {
  //* Keybindings
  Bulk keybinds = bulk::load("resources/002");
  keybinds.free();

  //* Settings


  //* Fonts
  Bulk fonts_bulk = bulk::load("resources/009");
  fonts_bulk.entries.@each(; String key, BulkEntry val) {
    Font font = font::load_mem(".ttf", val.value, 200, {});
    fonts.set(key, font);
  };
  fonts_bulk.free();

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
  models.set("simple_tile", simple_mesh.model());

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
  models["simple_tile"]!!.materials[0] = def_mat;

  //* Textures
  Bulk other_textures = bulk::load("resources/010");
  other_textures.entries.@each(; String key, BulkEntry val) {
    Image img = image::load_mem(".png", val.value);
    textures.set(key, img.texture());
    img.unload();
  };
  other_textures.free();

  //* Species data
  species::init();

  //* Skill data
  skills::init();
}

<*  *>
fn void free() {
  
}


module gnosis::resources;
import std::io;
import std::collections;
import ennoia;
import gnosis::unit;


HashMap{String, Font}     fonts     @builtin;
HashMap{String, Texture}  textures  @builtin;
HashMap{String, Mesh}     meshes    @builtin;
//HashMap{String, Material} materials @builtin;


<* Load all resources from file *>
fn void load() {
  // Keybindings
  bulk::load_all_keybinds("resources/keybinds");
  // Settings
  bulk::load_all_options("resources/options");

  //* Fonts
  Bulk fonts_bulk = bulk::load("resources/009");
  fonts_bulk.entries.@each(; String key, BulkEntry val) {
    Font font = font::load_mem(".ttf", val.value, 320, {});
    fonts.set(key, font);
  };
  fonts_bulk.free();
  raygui::set_font(fonts["anakron"]!!);

  // UI Textures
  HashMap{String, Texture} uiTextures = bulk::load_all_textures("resoruces/030");
  //Bulk ui_textures = bulk::load("resources/030");
  //ui_textures.entries.@each(; String key, BulkEntry val) {
  //  Image img = image::load_mem(".png", val.value);
  //  textures.set(key, img.texture());
  //  img.unload();
  //};
  //ui_textures.free();

  //* Generate models
  Mesh simple_mesh = mesh::gen_cube();
  meshes.set("simple_tile", simple_mesh);
  //models.set("simple_tile", simple_mesh.model());
  //Mesh plane_mesh = mesh::plane(1,1,1,1);
  //meshes.set("plane_tile", plane_mesh);

  //* Load models


  // Model Textures
  HashMap{String, Texture} meshTextures = bulk::load_all_textures("resoruces/020");
  //Image def_tex = image::checked(4,4,2,2, color::PURPLE, color::BLACK);
  //textures.set("default", def_tex.texture());
  //def_tex.unload();

  //Bulk tile_textures = bulk::load("resources/020");
  //tile_textures.entries.@each(; String key, BulkEntry val) {
  //  Image img = image::load_mem(".png", val.value);
  //  textures.set(key, img.texture());
  //  img.unload();
  //};
  //tile_textures.free();

  //* Materials
  //Material def_mat = material::load_default();
  //def_mat.set_texture(textures["default"]!!);
  //materials.set("default", def_mat);
  //models["simple_tile"]!!.materials[0] = def_mat;

  // Textures
  HashMap{String, Texture} textures = bulk::load_all_textures("resoruces/030");
  //Bulk other_textures = bulk::load("resources/010");
  //other_textures.entries.@each(; String key, BulkEntry val) {
  //  Image img = image::load_mem(".png", val.value);
  //  textures.set(key, img.texture());
  //  img.unload();
  //};
  //other_textures.free();

  // localization
  bulk::load_all_localization("resources/060");
}

<*  *>
fn void free() {
  
}

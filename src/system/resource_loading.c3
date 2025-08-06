
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
  bulk::load_all("resources/009");

  // UI Textures
  //HashMap{String, Texture} uiTextures = bulk::load_all_textures("resoruces/030");
  bulk::load_all("resources/030");

  //* Generate models
  Mesh simple_mesh = mesh::gen_cube();
  meshes.set("simple_tile", simple_mesh);

  //* Load models


  // Model Textures
  //HashMap{String, Texture} meshTextures = bulk::load_all_textures("resoruces/020");
  bulk::load_all("resources/020");

  // Textures
  //HashMap{String, Texture} textures = bulk::load_all_textures("resoruces/030");
  //bulk::load_all("resources/020");

  // localization
  bulk::load_all("resources/060");
  //bulk::load_all_localization("resources/060");
}

<*  *>
fn void free() {
  
}

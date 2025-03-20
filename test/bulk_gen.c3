
import std::io;
import pleroma;


/* Table of contents
  * 001      - Shaders
  * 002      - Default Keybindings
  * 003      - Default Settings
  * 004->008 - Reserved
  * 009      - Fonts
  * 010->029 - Textures
  * 030->049 - UI Textures
  * 050      - Skills yaml
  * 051      - Species yaml
  * 052->069 - 
*/

<* 001 *>
fn void gen_shaders() @test {
  Bulk shader_bulk = bulk::new("001");

  //* Grab files
  char[] shader = file::load_new("resources/raw_files/shader.fs")!!;
  char[] fshader = file::load_new("resources/raw_files/shd_crt.fsh")!!;
  char[] vshader = file::load_new("resources/raw_files/shd_crt.vsh")!!;
  char[] testshader = file::load_new("resources/raw_files/shadertest.fsh")!!;

  shader_bulk.add("shader", shader);
  shader_bulk.add("frag_shader", fshader);
  shader_bulk.add("vert_shader", vshader);
  shader_bulk.add("shadertest", testshader);
  shader_bulk.save();
}
<* 002 *>
fn void gen_keybinds() @test {
  Bulk keybindings_bulk = bulk::new("002");

  //* Create bindings
  keybind::set("move_up", 	 {.type=KEYBOARD,.kb=raylib::KEY_W});
	keybind::set("move_down",	 {.type=KEYBOARD,.kb=raylib::KEY_S});
	keybind::set("move_left",	 {.type=KEYBOARD,.kb=raylib::KEY_A});
	keybind::set("move_right", {.type=KEYBOARD,.kb=raylib::KEY_D});

	keybind::set("rotate_right", {.type=KEYBOARD,.kb=raylib::KEY_Q});
	keybind::set("rotate_left",  {.type=KEYBOARD,.kb=raylib::KEY_E});

	char[] kb = keybind::save();

  keybindings_bulk.add("default_kb", kb);
  keybindings_bulk.save();
}

<* 009 *>
fn void gen_font() @test {
  raylib::set_trace_log_level(NONE);

  Bulk font_bulk = bulk::new("009");

  //* Grab fonts
  //usz size = file::get_size("resources/raw_files/ANAKRON.ttf")!!;
  //File file = file::open("resources/raw_files/ANAKRON.ttf", "rb")!!;
  //defer file.close();

  //char[] data = mem::new_array(char, size);
  //file.read(data);
  char[] data = file::load_new("resources/raw_files/ANAKRON.ttf")!!;

  font_bulk.add("anakron", data);
  font_bulk.save();
}
<* 010 *>
fn void gen_textures_units() @test {
  raylib::set_trace_log_level(NONE);

  Bulk unit_tex_bulk = bulk::new("010");

  //* Grab images
  Image img_player = image::load("resources/raw_files/spr_test_player.png");
  defer img_player.unload();

  unit_tex_bulk.add("player", img_player.to_mem(".png"));
  unit_tex_bulk.save();
}

<* 020 *>
fn void gen_textures_tiles() @test {
  raylib::set_trace_log_level(NONE);

  Bulk tile_tex_bulk = bulk::new("020");

  //* Grab images
  Image img_grass = image::load("resources/raw_files/tex_grass.png");
  defer img_grass.unload();

  tile_tex_bulk.add("grass_0", img_grass.to_mem(".png"));

  tile_tex_bulk.save();
}

<* 030 *>
fn void gen_uitextures() @test {
  raylib::set_trace_log_level(NONE);

  Bulk ui_texture_bulk = bulk::new("030");

  //* Grab images of all files needed
  Image img_bar_bg = image::load("resources/raw_files/spr_bar_bg.png");
  defer img_bar_bg.unload();
  Image img_bar_fl = image::load("resources/raw_files/spr_bar_fill.png");
  defer img_bar_fl.unload();
  Image img_textbox = image::load("resources/raw_files/spr_textbox.png");
  defer img_textbox.unload();

  ui_texture_bulk.add("bar_bg", img_bar_bg.to_mem(".png"));
  ui_texture_bulk.add("bar_fl", img_bar_fl.to_mem(".png"));
  ui_texture_bulk.add("textbox", img_textbox.to_mem(".png"));

  ui_texture_bulk.save();
}

<* 050 *>
fn void gen_skills_yaml() @test {
  Bulk skills_yaml_bulk = bulk::new("050");

  //* Load yaml as raw data
  usz size = file::get_size("resources/raw_files/skills.yaml")!!;
  File file = file::open("resources/raw_files/skills.yaml", "rb")!!;
  defer file.close()!!;

  char[] data = mem::new_array(char, size);
  file.read(data)!!;

  skills_yaml_bulk.add("yaml", data);
  skills_yaml_bulk.save();
}
<* 051 *>
fn void gen_species_yaml() @test {
  Bulk species_yaml_bulk = bulk::new("051");

  //* Load yaml as raw data
  usz size = file::get_size("resources/raw_files/species.yaml")!!;
  File file = file::open("resources/raw_files/species.yaml", "rb")!!;
  defer file.close()!!;

  char[] data = mem::new_array(char, size);
  file.read(data)!!;

  species_yaml_bulk.add("yaml", data);
  species_yaml_bulk.save();
}



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
  char[] shader = file::load_temp("resources/raw_files/shader.fs")!!;
  char[] fshader = file::load_temp("resources/raw_files/shd_crt.fsh")!!;
  char[] vshader = file::load_temp("resources/raw_files/shd_crt.vsh")!!;
  char[] testshader = file::load_temp("resources/raw_files/shadertest.fsh")!!;

  raylib::set_trace_log_level(NONE);

  char[] mask = file::load_temp("resources/raw_files/mask.png")!!;
  char[] slot = file::load_temp("resources/raw_files/slot.png")!!;

  shader_bulk.add("mask", mask);
  shader_bulk.add("slot", slot);
  shader_bulk.add("shader", shader);
  shader_bulk.add("frag_shader", fshader);
  shader_bulk.add("vert_shader", vshader);
  shader_bulk.add("shadertest", testshader);
  shader_bulk.save();
  shader_bulk.free();
}
<* 002 *>
fn void gen_keybinds() @test {
  Bulk keybindings_bulk = bulk::new("002");

  Keybindings keybinds;
  //* Create bindings
  keybinds.set("move_up", 	 {.type=KEYBOARD,.kb=raylib::KEY_W});
	keybinds.set("move_down",	 {.type=KEYBOARD,.kb=raylib::KEY_S});
	keybinds.set("move_left",	 {.type=KEYBOARD,.kb=raylib::KEY_A});
	keybinds.set("move_right", {.type=KEYBOARD,.kb=raylib::KEY_D});

	keybinds.set("rotate_right", {.type=KEYBOARD,.kb=raylib::KEY_Q});
	keybinds.set("rotate_left",  {.type=KEYBOARD,.kb=raylib::KEY_E});

	char[] kb = keybinds.save();

  keybindings_bulk.add("default_kb", kb);
  keybindings_bulk.save();
  free(kb);
  keybindings_bulk.free();
}

<* 009 *>
fn void gen_font() @test {
  raylib::set_trace_log_level(NONE);

  Bulk font_bulk = bulk::new("009");

  //* Grab fonts
  char[] anakron = file::load_temp("resources/raw_files/ANAKRON.ttf");

  font_bulk.add("anakron", anakron);
  font_bulk.save();
  free(data);
  font_bulk.free();
}
<* 010 *>
fn void gen_textures_units() @test {
  raylib::set_trace_log_level(NONE);

  Bulk unit_tex_bulk = bulk::new("010");

  //* Grab images
  char[] img_player = file::load_temp("resources/raw_files/spr_test_player.png")!!;

  unit_tex_bulk.add("player", img_player);
  unit_tex_bulk.save();
  unit_tex_bulk.free();
}

<* 020 *>
fn void gen_textures_tiles() @test {
  raylib::set_trace_log_level(NONE);

  Bulk tile_tex_bulk = bulk::new("020");

  //* Grab images
  char[] img_grass = file::load_temp("resources/raw_files/tex_grass.png")!!;

  tile_tex_bulk.add("grass_0", img_grass);
  tile_tex_bulk.save();
  tile_tex_bulk.free();
}

<* 030 *>
fn void gen_uitextures() @test {
  raylib::set_trace_log_level(NONE);

  Bulk ui_texture_bulk = bulk::new("030");

  //* Grab images
  char[] img_bar_bg  = file::load_temp("resources/raw_files/spr_bar_bg.png")!!;
  char[] img_bar_fl  = file::load_temp("resources/raw_files/spr_bar_fill.png")!!;
  char[] img_textbox = file::load_temp("resources/raw_files/spr_textbox.png")!!;

  ui_texture_bulk.add("bar_bg", img_bar_bg);
  ui_texture_bulk.add("bar_fl", img_bar_fl);
  ui_texture_bulk.add("textbox", img_textbox);

  ui_texture_bulk.save();
  ui_texture_bulk.free();
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
  free(data);
  skills_yaml_bulk.free();
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
  free(data);
  species_yaml_bulk.free();
}


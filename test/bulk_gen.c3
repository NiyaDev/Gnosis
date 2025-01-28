
import std::io;
import bulk;
import keybind;
import raylib;


/* Table of contents
  * 001      - Shaders
  * 002      - Default Keybindings
  * 003      - Default Settings
  * 004->009 - Reserved
  * 010->029 - Textures
  * 030->049 - UI Textures
  * 050->069 - 
*/

fn void gen_shaders() @test {
  Bulk* shader_bulk = bulk::new("001")!!;

  //* Grab files
  usz size = file::get_size("resources/raw_files/shader.fs")!!;
  File file = file::open("resources/raw_files/shader.fs", "r")!!;
  defer file.close()!!;

  char[] shader = mem::new_array(char, size);
  file.read(shader)!!;

  shader_bulk.add("screen_shader", shader)!!;
  shader_bulk.save()!!;
}
fn void gen_keybinds() @test {
  Bulk* keybindings_bulk = bulk::new("002")!!;

  //* Create bindings
  keybind::set("move_up", 	 {.type=KEYBOARD,.kb=raylib::KEY_W});
	keybind::set("move_down",	 {.type=KEYBOARD,.kb=raylib::KEY_S});
	keybind::set("move_left",	 {.type=KEYBOARD,.kb=raylib::KEY_A});
	keybind::set("move_right", {.type=KEYBOARD,.kb=raylib::KEY_D});

	char[] kb = keybind::save()!!;

  keybindings_bulk.add("default_kb", kb)!!;
  keybindings_bulk.save()!!;
}

fn void gen_textures_units() @test {
  raylib::set_trace_log_level(NONE);

  Bulk* unit_tex_bulk = bulk::new("010")!!;

  //* Grab images
  Image* img_player = image::load("resources/raw_files/spr_test_player.png")!!;
  defer img_player.unload();

  unit_tex_bulk.add("player", img_player.to_mem(".png"))!!;
  unit_tex_bulk.save()!!;
}
fn void gen_textures_tiles() @test {
  raylib::set_trace_log_level(NONE);

  Bulk* tile_tex_bulk = bulk::new("020")!!;

  //* Grab images
  Image* img_grass = image::load("resources/raw_files/tex_grass.png")!!;
  defer img_grass.unload();

  tile_tex_bulk.add("grass_0", img_grass.to_mem(".png"))!!;

  tile_tex_bulk.save()!!;
}

fn void gen_uitextures() @test {
  raylib::set_trace_log_level(NONE);

  Bulk* ui_texture_bulk = bulk::new("030")!!;

  //* Grab images of all files needed
  Image* img_bar_bg = image::load("resources/raw_files/spr_bar_bg.png")!!;
  defer img_bar_bg.unload();
  Image* img_bar_fl = image::load("resources/raw_files/spr_bar_fill.png")!!;
  defer img_bar_fl.unload();

  ui_texture_bulk.add("bar_bg", img_bar_bg.to_mem(".png"))!!;
  ui_texture_bulk.add("bar_fl", img_bar_fl.to_mem(".png"))!!;

  ui_texture_bulk.save()!!;
}

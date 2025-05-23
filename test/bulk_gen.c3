
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
  * 050      - Skills yaml - old
  * 051      - Species yaml - old
  * 052->069 - 
  * 060      - Localization
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
	keybinds.set("stealth",    {.type=KEYBOARD,.kb=raylib::KEY_LEFT_SHIFT});
	keybinds.set("skills",     {.type=KEYBOARD,.kb=raylib::KEY_K});

	keybinds.set("rotate_right", {.type=KEYBOARD,.kb=raylib::KEY_Q});
	keybinds.set("rotate_left",  {.type=KEYBOARD,.kb=raylib::KEY_E});

	char[] kb = keybinds.save();

	for (int i; i < kb.len; i++) io::printf("%d,",kb[i]);

  keybindings_bulk.add("default_kb", kb);
  keybindings_bulk.save();
  free(kb);
  keybindings_bulk.free();
}
<* 003 *>
fn void gen_options() @test {
  Bulk option_bulk = bulk::new("003");

  Options opts;

  // 0 = Window
  // 1 = Borderless Window
  // 2 = Fullscreen
  Option screen_mode = {.type=INT,.as_int=0};
  // Screen size
  Option screen_res = {.type=INT_ARRAY,.as_int_array={1920,1080}};
  // Field of view
  Option fovy = {.type=CHAR,.as_char=70};
  // Target frames per second
  Option fps = {.type=CHAR,.as_char=60};

  // Language
  Option language = {.type=STRING,.as_string="English"};
  // Master volume
  Option vol_master = {.type=FLOAT,.as_float=0.6};
  // Music volume
  Option vol_music = {.type=FLOAT,.as_float=0.6};
  // Ambient sounds volume
  Option vol_ambient = {.type=FLOAT,.as_float=0.6};
  // Sound effects volume
  Option vol_sfx = {.type=FLOAT,.as_float=0.6};

  opts.set("screen_mode", screen_mode);
  opts.set("screen_res", screen_res);
  opts.set("fovy", fovy);
  opts.set("fps", fps);
  opts.set("language", language);
  opts.set("vol_master", vol_master);
  opts.set("vol_music", vol_music);
  opts.set("vol_ambient", vol_ambient);
  opts.set("vol_sfx", vol_sfx);

  char[] opt = opts.save();

  option_bulk.add("default_options", opt);
  option_bulk.save();
  free(opt);
  option_bulk.free();
}

<* 009 *>
fn void gen_font() @test {
  raylib::set_trace_log_level(NONE);

  Bulk font_bulk = bulk::new("009");

  //* Grab fonts
  char[] anakron = file::load_temp("resources/raw_files/ANAKRON.ttf")!!;

  font_bulk.add("anakron", anakron);
  font_bulk.save();
  //free(anakron);
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


<* 060 *>
fn void gen_localization() @test {
  Bulk local_bulk = bulk::new("060");

  // Load Yaml as raw data
  char[] ui  = file::load_temp("resources/raw_files/localization/ui.yaml")!!;
  char[] skills  = file::load_temp("resources/raw_files/localization/skills.yaml")!!;
  char[] species = file::load_temp("resources/raw_files/localization/species.yaml")!!;

  local_bulk.add("ui", ui);
  local_bulk.add("skills", skills);
  local_bulk.add("species", species);
  local_bulk.save();
  local_bulk.free();
}


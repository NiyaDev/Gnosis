
import std::io;
import bulk;
import raylib;


fn void bulks_001_uitextures() @test {
  raylib::set_trace_log_level(NONE);

  //* UI textures  -  001
  Bulk* ui_texture_bulk = bulk::new("001")!!;

  //* Grab images of all files needed
  Image* img_health_bg = image::load("resources/raw_files/spr_health_bg.png")!!;
  defer img_health_bg.unload();
  Image* img_health_fl = image::load("resources/raw_files/spr_health_fill.png")!!;
  defer img_health_fl.unload();
  Image* img_stamin_bg = image::load("resources/raw_files/spr_stamina_bg.png")!!;
  defer img_stamin_bg.unload(); 
  Image* img_stamin_fl = image::load("resources/raw_files/spr_stamina_fill.png")!!;
  defer img_stamin_fl.unload(); 
  Image* img_mana_bg   = image::load("resources/raw_files/spr_mana_bg.png")!!;
  defer img_mana_bg.unload(); 
  Image* img_mana_fl   = image::load("resources/raw_files/spr_mana_fill.png")!!;
  defer img_mana_fl.unload(); 

  ui_texture_bulk.add("hp_bg", img_health_bg.to_mem(".png"))!!;
  ui_texture_bulk.add("hp_fl", img_health_fl.to_mem(".png"))!!;
  ui_texture_bulk.add("st_bg", img_stamin_bg.to_mem(".png"))!!;
  ui_texture_bulk.add("st_fl", img_stamin_fl.to_mem(".png"))!!;
  ui_texture_bulk.add("mn_bg", img_mana_bg.to_mem(".png"))!!;
  ui_texture_bulk.add("mn_fl", img_mana_fl.to_mem(".png"))!!;

  ui_texture_bulk.save()!!;

  
  //* Tile Textures  -  002
  Bulk* tile_tex_bulk = bulk::new("002")!!;

  //* Grab images
  Image* img_grass = image::load("resources/raw_files/tex_grass.png")!!;
  defer img_grass.unload();

  tile_tex_bulk.add("grass_0", img_grass.to_mem(".png"))!!;

  tile_tex_bulk.save()!!;


  //* Unit Textures  -  003
  Bulk* unit_tex_bulk = bulk::new("003")!!;

  //* Grab images
  Image* img_player = image::load("resources/raw_files/spr_test_player.png")!!;
  defer img_player.unload();

  unit_tex_bulk.add("player", img_player.to_mem(".png"))!!;

  unit_tex_bulk.save()!!;


  //* Shaders  -  004
  Bulk* shader_bulk = bulk::new("004")!!;

  //* Grab files
  usz size = file::get_size("resources/raw_files/shader.fs")!!;
  File file = file::open("resources/raw_files/shader.fs", "r")!!;
  defer file.close()!!;

  char[] shader = mem::new_array(char, size);
  file.read(shader)!!;

  shader_bulk.add("screen_shader", shader)!!;

  shader_bulk.save()!!;
}

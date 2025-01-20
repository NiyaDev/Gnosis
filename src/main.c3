
module gnosis;
import std::io;
import std::math::random;
import bulk;
import raylib;
import keybind;
import gnosis::system::render;
import gnosis::system::camera;
import gnosis::chunks;


bool[100] tiles;
Chunk chunk_01;

//Texture* hp_bg;
//Texture* hp_fl;
//Texture* st_bg;
//Texture* st_fl;
//Texture* mn_bg;
//Texture* mn_fl;
Texture* bar_bg;
Texture* bar_fl;

fn int main(String[] args) {
	//* Initialize systems
	render::init()!!;
	defer render::close()!!;
	camera::init()!!;

	//* Generate default keybinds
	keybind::data.set("move_up", 		{.type=KEYBOARD,.kb=raylib::KEY_W});
	keybind::data.set("move_down", 	{.type=KEYBOARD,.kb=raylib::KEY_S});
	keybind::data.set("move_left", 	{.type=KEYBOARD,.kb=raylib::KEY_A});
	keybind::data.set("move_right", {.type=KEYBOARD,.kb=raylib::KEY_D});

	//* Generate Test chunk
	chunk_01.init();

	// Generate basic tile
	Model* model = mesh::gen_cube(1,1,1).model();
	defer model.unload();

	//* Generate default material
	Bulk* tile_tex_bulk = bulk::load("resources/002.bulk")!!;
	Texture* grass = image::load_mem(".png", tile_tex_bulk.get("grass_0")!!).texture();
	defer grass.unload();

	Material* mat = material::load_default();
	mat.set_texture(*grass);
	model.set_material(mat);

	//* Load Textures
	Bulk* unit_tex_bulk = bulk::load("resources/003.bulk")!!;
	Texture* player = image::load_mem(".png", unit_tex_bulk.get("player")!!).texture();
	//Texture* player = texture::load("resources/spr_test_player.png")!!;

	//* Load UI textures
	Bulk* ui_bulk = bulk::load("resources/001.bulk")!!;
	bar_bg = image::load_mem(".png", ui_bulk.get("bar_bg")!!).texture();
	bar_fl = image::load_mem(".png", ui_bulk.get("bar_fl")!!).texture();
	//hp_bg = image::load_mem(".png", ui_bulk.get("hp_bg")!!).texture();
	//hp_fl = image::load_mem(".png", ui_bulk.get("hp_fl")!!).texture();
	//st_bg = image::load_mem(".png", ui_bulk.get("st_bg")!!).texture();
	//st_fl = image::load_mem(".png", ui_bulk.get("st_fl")!!).texture();
	//mn_bg = image::load_mem(".png", ui_bulk.get("mn_bg")!!).texture();
	//mn_fl = image::load_mem(".png", ui_bulk.get("mn_fl")!!).texture();

	//* Player
	Player* pl = player::init();
	pl.position = {8,9,8};
	pl.sprite = player;
	camera::main.unit = pl;


	for (int i = 0; i < 100; i++) { tiles[i] = true; }

	while (!raylib::window_should_close()) {
		float dt = raylib::get_frame_time();
		camera::update(dt)!!;

		// TODO: Move into player.c3
		pl.update();
		if (raylib::is_key_down(raylib::KEY_LEFT_SHIFT)) camera::move({0,-10 * dt, 0});
		if (raylib::is_key_down(raylib::KEY_SPACE)) camera::move({0,10 * dt, 0});
		if (raylib::is_key_pressed(raylib::KEY_Q)) camera::rotate(90);
		if (raylib::is_key_pressed(raylib::KEY_E)) camera::rotate(-90);
		float zoom = raylib::get_mouse_wheel_move();
		if (zoom != 0) camera::zoom(-zoom / 10);

		render::content();
			chunk_01.draw(*model);
			raylib::draw_billboard_pro(camera::main, *pl.sprite, {0,0,16,32}, camera::main.target, camera::ZERO.rotate({0,1,-1}, camera::main.rotation), {1,1}, {0.5,0.25}, 0, raylib::WHITE);

		render::ui();
			pl.draw_ui();
			
		render::end();
	}
	return 0;
}


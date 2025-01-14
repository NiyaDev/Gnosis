
module gnosis;
import std::io;
import std::math::random;
import raylib;
import gnosis::system::render;
import gnosis::system::camera;
import gnosis::chunks;


bool[100] tiles;
Chunk chunk_01;


fn int main(String[] args) {
	//* Initialize systems
	render::init()!!;
	defer render::close()!!;
	camera::init()!!;

	//* Generate Test chunk
	chunk_01.init();

	// Generate basic tile
	Mesh mesh = raylib::gen_mesh_cube(1,1,1);
	Model model = raylib::load_model_from_mesh(mesh);
	defer raylib::unload_model(model);

	//* Generate default material
	Material mat = raylib::load_material_default();
	mat.maps[0].texture = raylib::load_texture("resources/tex_grass.png");
	model.materials[0] = mat;

	//* Load Textures
	Texture player = raylib::load_texture("resources/spr_test_player.png");

	Texture hp_bg = raylib::load_texture("resources/spr_health_bg.png");
	Texture hp_fl = raylib::load_texture("resources/spr_health_fill.png");
	Texture st_bg = raylib::load_texture("resources/spr_stamina_bg.png");
	Texture st_fl = raylib::load_texture("resources/spr_stamina_fill.png");
	Texture mn_bg = raylib::load_texture("resources/spr_mana_bg.png");
	Texture mn_fl = raylib::load_texture("resources/spr_mana_fill.png");

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
			chunk_01.draw(model);
			raylib::draw_billboard_pro(camera::main, pl.sprite, {0,0,16,32}, camera::main.target, camera::ZERO.rotate({0,1,-1}, camera::main.rotation), {1,1}, {0.5,0.25}, 0, raylib::WHITE);

		render::ui();
			raylib::draw_texture_npatch(hp_bg, {{0,0,24,8},8,8,8,8,THREE_PATCH_HORIZONTAL}, {10,10,64,8}, {0,0}, 0, raylib::WHITE);
			raylib::draw_texture_npatch(hp_fl, {{0,0,24,8},8,8,8,8,THREE_PATCH_HORIZONTAL}, {10,10,64,8}, {0,0}, 0, raylib::WHITE);
			raylib::draw_texture_npatch(st_bg, {{0,0,24,8},8,8,8,8,THREE_PATCH_HORIZONTAL}, {10,20,64,8}, {0,0}, 0, raylib::WHITE);
			raylib::draw_texture_npatch(st_fl, {{0,0,24,8},8,8,8,8,THREE_PATCH_HORIZONTAL}, {10,20,64,8}, {0,0}, 0, raylib::WHITE);
			raylib::draw_texture_npatch(mn_bg, {{0,0,24,8},8,8,8,8,THREE_PATCH_HORIZONTAL}, {10,30,64,8}, {0,0}, 0, raylib::WHITE);
			raylib::draw_texture_npatch(mn_fl, {{0,0,24,8},8,8,8,8,THREE_PATCH_HORIZONTAL}, {10,30,64,8}, {0,0}, 0, raylib::WHITE);
			String text = string::tformat("FPS: %d\nTiles Rendered: %d", raylib::get_fps(), chunks::tiles_rendered);
			raylib::draw_text((ZString)text, 0, 100, 8, raylib::BLACK);

		render::end();
	}
	return 0;
}


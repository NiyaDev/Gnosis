
module gnosis;
import std::io;
import std::math::random;
import bulk;
import raylib;
import keybind;
import gnosis::system::render;
import gnosis::system::camera;
import gnosis::chunks;
import gnosis::resources;


bool[100] tiles;
Chunk chunk_01;

Texture* bar_bg;
Texture* bar_fl;

fn int main(String[] args) {
	//* Initialize systems
	render::init()!!;
	defer render::close()!!;
	camera::init()!!;

	//* Load resources
	resources::load()!!;

	//* Generate Test chunk
	chunk_01.init();

	//* Player
	Player* pl = player::new();
	pl.position = {8,9,8};
	pl.sprite = resources::textures["player"]!!;
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
			chunk_01.draw(resources::models.get("simple_tile")!!);
			raylib::draw_billboard_pro(camera::main, *pl.sprite, {0,0,16,32}, camera::main.target, camera::ZERO.rotate({0,1,-1}, camera::main.rotation), {1,1}, {0.5,0.25}, 0, raylib::WHITE);

		render::ui();
			pl.draw_ui();
			
		render::end();
	}
	return 0;
}


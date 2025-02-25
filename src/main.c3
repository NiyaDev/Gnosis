
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

	ui::new_bar("healthbar",raylib::RED,{10,10,64,8},"bar_bg","bar_fl",&pl.hp_cur,&pl.hp_max);
	ui::new_text("test_1",raylib::BLACK,{20,20},"anakron","THE QUICK BROWN FOX JUMPED OVER THE LAZY DOG\nthe quick brown fox jumped over the lazy dog\n!@#$%^&*()-_=+",12,1);

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
			ui::draw();
			
		render::end();
	}
	return 0;
}


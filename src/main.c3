
module gnosis;
import std::io;
import std::math::random;
import bulk;
import raylib;
import keybind;
import gnosis::system::render;
import gnosis::system::camera;
import gnosis::world;
import gnosis::resources;


//Chunk chunk_01;

Texture* bar_bg;
Texture* bar_fl;

fn int main(String[] args) {
	//* Initialize systems
	render::init()!!;
	defer render::close()!!;
	camera::init();

	//* Load resources
	resources::load()!!;

	//* Generate Test chunk
	world::generate();

	//* Player
	world::data.player = player::new();
	Player* pl = world::data.player;
	pl.position = {8,9,8};
	pl.sprite = resources::textures["player"]!!;
	camera::set_target(pl);

	UIElement player_status = verticalbox::new(padding:{10,10,0,0});
	player_status.add_element(bar::new(raylib::RED,{0,0,64,8},"bar_bg","bar_fl",&pl.hp_cur,&pl.hp_max));
	player_status.add_element(bar::new(raylib::GREEN,{0,0,64,8},"bar_bg","bar_fl",&pl.st_cur,&pl.st_max));
	player_status.add_element(bar::new(raylib::BLUE,{0,0,64,8},"bar_bg","bar_fl",&pl.mn_cur,&pl.mn_max));
	player_status.add_element(bar::new(raylib::YELLOW,{0,0,64,8},"bar_bg","bar_fl",&pl.hn_cur,&pl.hn_max));
	ui::push("status", player_status);
	/*
	UITextureNPatch* textbox_tex = npatch_texture::new(texture:"textbox");
	String textbox_text = "Testing";
	UIElement textbox = textbox::new(
		bg:textbox_tex,
		visible:true,
		rect:{20,(float)render::render[1] / 1.5,(float)render::render[0] - 40,((float)render::render[1] / 3) - 10},
		textspace:{16,16,0,0},
		font:"anakron",
	);
	textbox.set_text("testing this textbox shit.");
	ui::push("textbox", textbox);
	*/

	String uitext;
	ui::new_text("debug_text",raylib::WHITE,{10,80},"anakron",&uitext,12,-1);

	while (!raylib::window_should_close()) {
		float dt = raylib::get_frame_time();
		camera::update(dt)!!;
		world::update();
		if (raylib::is_key_pressed(raylib::KEY_LEFT_SHIFT)) pl.skills.get_ref("perception")!!.value++;

		float perc = pl.skills["perception"]!!.value;
		uitext = string::format(
		  "FPS: %d (%f)\nPos: %d,%d,%d\nTil: %d,%d,%d\nTiles Rendered: %d\nPerception: %d->%d\nZoom: %f\nHP: %d/%d - %d\nST: %d/%d - %d\nMN: %d/%d - %d\nHN: %d/%d - %d\0",
		  raylib::get_fps(),
		  world::data.framespertick / 60,
		  camera::main.target.x, camera::main.target.y, camera::main.target.z,
		  world::data.player.position.x, world::data.player.position.y, world::data.player.position.z,
		  world::tiles_rendered,
		  perc, 5 + (perc * 0.2),
		  camera::main.zoom,
		  pl.hp_cur, pl.hp_max, pl.hp_tick,
		  pl.st_cur, pl.st_max, pl.st_tick,
		  pl.mn_cur, pl.mn_max, pl.mn_tick,
		  pl.hn_cur, pl.hn_max, pl.hn_tick,
		  allocator: allocator::heap(),
		);
		defer uitext.free();

		// TODO: Move into player.c3
		pl.update();
		if (raylib::is_key_down(raylib::KEY_LEFT_SHIFT)) camera::move({0,-10 * dt, 0});
		if (raylib::is_key_down(raylib::KEY_SPACE)) camera::move({0,10 * dt, 0});
		if (raylib::is_key_pressed(raylib::KEY_Q)) camera::rotate(90);
		if (raylib::is_key_pressed(raylib::KEY_E)) camera::rotate(-90);
		float zoom = raylib::get_mouse_wheel_move();
		if (zoom != 0) camera::zoom(-zoom / 20);

		render::content();
			world::draw();
			raylib::draw_billboard_pro(camera::main, *pl.sprite, {0,0,16,32}, camera::main.target, camera::ZERO.rotate({0,1,-1}, camera::main.rotation), {1,1}, {0.5,0.25}, 0, raylib::WHITE);

		render::ui();
			ui::draw();
			
		render::end();
	}

	ui::free();

	return 0;
}


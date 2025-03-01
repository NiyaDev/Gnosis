
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
	camera::init();

	//* Load resources
	resources::load()!!;

	//* Generate Test chunk
	chunk_01.init();

	//* Player
	Player* pl = player::new();
	pl.position = {8,9,8};
	pl.sprite = resources::textures["player"]!!;
	//camera::set_target(pl);

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

		uitext = string::format(
		  "FPS: %d\nTiles Rendered: %d\nHP: %d/%d - %d\nST: %d/%d - %d\nMN: %d/%d - %d\nHN: %d/%d - %d\0",
		  raylib::get_fps(), chunks::tiles_rendered,
		  pl.hp_cur, pl.hp_max, pl.hp_tick,
		  pl.st_cur, pl.st_max, pl.st_tick,
		  pl.mn_cur, pl.mn_max, pl.mn_tick,
		  pl.hn_cur, pl.hn_max, pl.hn_tick,
		  allocator: allocator::heap(),
		); 

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
			ui::draw();
			
		render::end();
	}

	ui::free();

	return 0;
}


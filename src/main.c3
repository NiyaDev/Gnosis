
module gnosis;
import std::io;
import std::math::random;
import pleroma;
import gnosis::system;
import gnosis::resources;



fn int main(String[] args) {
	//* Initialize systems
	system::init_renderer();
	defer system::close();
	camera::init();

	//* Load resources
	resources::load();

	//* Generate Test chunk
	gamestate.world = world::generate();

	//* Player
	gamestate.world.player = player::new();
	gamestate.world.player.position = {8,9,8};
	gamestate.world.player.sprite = resources::textures.get_ref("player")!!;
	camera::set_target(gamestate.world.player);

	UIElement player_status = verticalbox::new({10,10,0,0},null);
	player_status.add_element(bar::new(color::RED,{0,0,64,8},"bar_bg","bar_fl",&gamestate.world.player.hp_cur,&gamestate.world.player.hp_max));
	//player_status.add_element(bar::new(color::GREEN,{0,0,64,8},"bar_bg","bar_fl",&gamestate.world.player.st_cur,&gamestate.world.player.st_max));
	player_status.add_element(bar::new(color::BLUE,{0,0,64,8},"bar_bg","bar_fl",&gamestate.world.player.mn_cur,&gamestate.world.player.mn_max));
	player_status.add_element(bar::new(color::YELLOW,{0,0,64,8},"bar_bg","bar_fl",&gamestate.world.player.hn_cur,&gamestate.world.player.hn_max));
	ui::push("status", player_status);
	/*
	UITextureNPatch* textbox_tex = npatch_texture::new(color::WHITE,{0,0,32,32},"textbox");
	String textbox_text = "Testing";
	UIElement textbox = textbox::new(
		{20,(float)system::render[1] / 1.5,(float)system::render[0] - 40,((float)system::render[1] / 3) - 10},
		{16,16,0,0},
		"anakron",
		true,
		16, 1, 1,
		textbox_tex,
	);
	textbox.set_text("testing this textbox shit.");
	ui::push("textbox", textbox);
	*/
	String uitext;
	ui::new_text("debug_text",color::WHITE,{10,80},"anakron",&uitext,12,-1);

	while (!raylib::window_should_close()) {
		float dt = raylib::get_frame_time();
		camera::update(dt);
		gamestate.world.update();
		if (raylib::is_key_pressed(raylib::KEY_LEFT_SHIFT)) gamestate.world.player.skills.get_ref("perception")!!.value++;

		// Update onscreen debug information string
		float perc = gamestate.world.player.skills["perception"]!!.value;
		uitext = string::format(
			allocator::heap(),
		  "FPS: %d (%f)\nPos: %d,%d,%d\nTil: %d,%d,%d\nTiles Rendered: %d\nPerception: %d->%d\nZoom: %f\nHP: %d/%d - %d\nST: %d/%d - %d\nMN: %d/%d - %d\nHN: %d/%d - %d\0",
		  raylib::get_fps(),
		  gamestate.world.framespertick / 60,
		  camera::main.target.x, camera::main.target.y, camera::main.target.z,
		  gamestate.world.player.position.x, gamestate.world.player.position.y, gamestate.world.player.position.z,
		  gamestate.tiles_rendered,
		  perc, 5 + (perc * 0.2),
		  camera::main.zoom,
		  gamestate.world.player.hp_cur, gamestate.world.player.hp_max, gamestate.world.player.hp_tick,
		  gamestate.world.player.st_cur, gamestate.world.player.st_max, gamestate.world.player.st_tick,
		  gamestate.world.player.mn_cur, gamestate.world.player.mn_max, gamestate.world.player.mn_tick,
		  gamestate.world.player.hn_cur, gamestate.world.player.hn_max, gamestate.world.player.hn_tick,
		);
		defer uitext.free(allocator::heap());

		// Player controls
		gamestate.world.player.update();

		system::content();
			gamestate.world.draw();
			Vector3 pos = camera::main.target;
			pos.y += 0.25;
			camera::main.draw_billboard_pro(*gamestate.world.player.sprite, {0,0,16,32}, pos, vector3::ZERO.rotate({0,1,-1}, camera::main.rotation), {1,1}, {0.5,0.25}, 0, color::WHITE);

		system::ui();
			ui::draw();
			
		system::end();
	}

	ui::free();

	return 0;
}


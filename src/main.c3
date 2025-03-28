
module gnosis;
import std::io;
import std::math::random;
import pleroma;
import gnosis::system;
import gnosis::world;
import gnosis::resources;


//Chunk chunk_01;

Texture* bar_bg;
Texture* bar_fl;

fn int main(String[] args) {
	//* Initialize systems
	system::init_renderer();
	defer system::close();
	camera::init();

	//* Load resources
	resources::load();

	//* Generate Test chunk
	world::generate();

	//* Player
	world::data.player = player::new();
	world::data.player.position = {8,9,8};
	world::data.player.sprite = resources::textures.get_ref("player")!!;
	camera::set_target(world::data.player);

	UIElement player_status = verticalbox::new(padding:{10,10,0,0});
	player_status.add_element(bar::new(color::RED,{0,0,64,8},"bar_bg","bar_fl",&world::data.player.hp_cur,&world::data.player.hp_max));
	player_status.add_element(bar::new(color::GREEN,{0,0,64,8},"bar_bg","bar_fl",&world::data.player.st_cur,&world::data.player.st_max));
	player_status.add_element(bar::new(color::BLUE,{0,0,64,8},"bar_bg","bar_fl",&world::data.player.mn_cur,&world::data.player.mn_max));
	player_status.add_element(bar::new(color::YELLOW,{0,0,64,8},"bar_bg","bar_fl",&world::data.player.hn_cur,&world::data.player.hn_max));
	ui::push("status", player_status);
	/*
	UITextureNPatch* textbox_tex = npatch_texture::new(texture:"textbox");
	String textbox_text = "Testing";
	UIElement textbox = textbox::new(
		bg:textbox_tex,
		visible:true,
		rect:{20,(float)system::render[1] / 1.5,(float)system::render[0] - 40,((float)system::render[1] / 3) - 10},
		textspace:{16,16,0,0},
		font:"anakron",
	);
	textbox.set_text("testing this textbox shit.");
	ui::push("textbox", textbox);
	*/
	String uitext;
	ui::new_text("debug_text",color::WHITE,{10,80},"anakron",&uitext,12,-1);

	while (!raylib::window_should_close()) {
		float dt = raylib::get_frame_time();
		camera::update(dt);
		world::update();
		if (raylib::is_key_pressed(raylib::KEY_LEFT_SHIFT)) world::data.player.skills.get_ref("perception")!!.value++;

		// Update onscreen debug information string
		float perc = world::data.player.skills["perception"]!!.value;
		uitext = string::format(
			allocator::heap(),
		  "FPS: %d (%f)\nPos: %d,%d,%d\nTil: %d,%d,%d\nTiles Rendered: %d\nPerception: %d->%d\nZoom: %f\nHP: %d/%d - %d\nST: %d/%d - %d\nMN: %d/%d - %d\nHN: %d/%d - %d\0",
		  raylib::get_fps(),
		  world::data.framespertick / 60,
		  camera::main.target.x, camera::main.target.y, camera::main.target.z,
		  world::data.player.position.x, world::data.player.position.y, world::data.player.position.z,
		  world::tiles_rendered,
		  perc, 5 + (perc * 0.2),
		  camera::main.zoom,
		  world::data.player.hp_cur, world::data.player.hp_max, world::data.player.hp_tick,
		  world::data.player.st_cur, world::data.player.st_max, world::data.player.st_tick,
		  world::data.player.mn_cur, world::data.player.mn_max, world::data.player.mn_tick,
		  world::data.player.hn_cur, world::data.player.hn_max, world::data.player.hn_tick,
		);
		defer uitext.free(allocator::heap());

		// Player controls
		world::data.player.update();

		system::content();
			world::draw();
			Vector3 pos = camera::main.target;
			pos.y += 0.25;
			camera::main.draw_billboard_pro(*world::data.player.sprite, {0,0,16,32}, pos, camera::ZERO.rotate({0,1,-1}, camera::main.rotation), {1,1}, {0.5,0.25}, 0, color::WHITE);

		system::ui();
			ui::draw();
			
		system::end();
	}

	ui::free();

	return 0;
}


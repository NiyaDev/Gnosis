
module gnosis;
import std::io;
import std::math::random;
import pleroma;
import gnosis::system;
import gnosis::resources;


// TEMP
Language lang @builtin = ENGLISH;

fn int main(String[] args) {
	//* Initialize systems
	system::init_renderer();
	defer system::close_renderer();
	camera::init();

	gamestate.debug_mode = true;
	//gamestate.state = OVERWORLD;

	//* Load resources
	resources::load();

	//* Generate Test chunk
	gamestate.world = world::generate();

	//* Player
	gamestate.world.player = player::new();
	gamestate.world.player.position = {8,9,8};
	gamestate.world.player.sprite = resources::textures.get_ref("player")!!;
	camera::set_target(gamestate.world.player);

	gamestate.world.save();

	// Titlescreen ui elements
	ui::open_titlescreen();
	ui::new_text( // Version
		name: "ts_version",
		tint: color::WHITE,
		position: {-45, -15},
		alignment: BOTTOMRIGHT,
		font: "anakron",
		text: localization["game_version"]!!.get_ref(lang)!!,
		size: 10,
	);
	
	/*
	UITextureNPatch* textbox_tex = npatch_texture::new(color::WHITE,{0,0,32,32},"textbox");
	String textbox_text = "Testing";
	UIElement textbox = textbox::new(
		rect: {0,-130,600,110},
		alignment: BOTTOM,
		font: "anakron",
		size: 16,
		spacing: 1,
		speed: 1,
		bg: textbox_tex,
	);
	textbox.set_text("testing this textbox shit.\ntest line.");
	ui::push("textbox", textbox);
	*/

	if (gamestate.debug_mode) ui::new_text("debug_text",color::WHITE,{10,80},TOPLEFT,"anakron",&debug::uitext,12,-1);

	while (!raylib::window_should_close() && !gamestate.end_game) {
		system::worldstate_loop();
	}

	ui::free();

	return 0;
}


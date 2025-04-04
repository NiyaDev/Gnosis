
module gnosis;
import std::io;
import std::math::random;
import pleroma;
import gnosis::system;
import gnosis::resources;


// TEMP
String game_title = "Gnosis";
String game_version = "0.1.0";
String play_option = "Play";
String options_option = "Options";
String quit_option = "Quit";

fn void test() => io::printfn("fug");

fn int main(String[] args) {
	//* Initialize systems
	system::init_renderer();
	defer system::close();
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

	// Titlescreen ui elements
	ui::new_text("ts_title", color::WHITE, {10,10}, "anakron", &game_title, 40, 1);
	ui::new_text("ts_version", color::WHITE, {((float)system::render[0])-45,((float)system::render[1])-15}, "anakron", &game_version, 10, 1);
	ui::new_button(
		name: "ts_play",
		text_color: color::WHITE,
		rect: {10, 260, 96, 32},
		text_padding: { 0,   0, 26,  8},
		background: "textbox",
		font: "anakron",
		text: &play_option,
		func: &system::ts_play_button,
	);
	ui::new_button(
		name: "ts_options",
		text_color: color::WHITE,
		rect: {10, 292, 96, 32},
		text_padding: { 0,   0,  8,  8},
		background: "textbox",
		font: "anakron",
		text: &options_option,
		func: &system::ts_options_button,
	);
	ui::new_button(
		name: "ts_quit",
		text_color: color::WHITE,
		rect: {10, 324, 96, 32},
		text_padding: { 0,   0, 26,  8},
		background: "textbox",
		font: "anakron",
		text: &quit_option,
		func: &system::ts_quit_button,
	);
	
	//UIElement player_status = verticalbox::new({10,10,0,0},null);
	//player_status.add_element(bar::new(color::RED,{0,0,64,8},"bar_bg","bar_fl",&gamestate.world.player.hp_cur,&gamestate.world.player.hp_max));
	//player_status.add_element(bar::new(color::GREEN,{0,0,64,8},"bar_bg","bar_fl",&gamestate.world.player.st_cur,&gamestate.world.player.st_max));
	//player_status.add_element(bar::new(color::BLUE,{0,0,64,8},"bar_bg","bar_fl",&gamestate.world.player.mn_cur,&gamestate.world.player.mn_max));
	//player_status.add_element(bar::new(color::YELLOW,{0,0,64,8},"bar_bg","bar_fl",&gamestate.world.player.hn_cur,&gamestate.world.player.hn_max));
	//ui::push("status", player_status);
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

	//if (gamestate.debug_mode) ui::new_text("debug_text",color::WHITE,{10,80},"anakron",&debug::uitext,12,-1);

	while (!raylib::window_should_close() && !gamestate.end_game) {
		system::worldstate_loop();
	}

	ui::free();

	return 0;
}


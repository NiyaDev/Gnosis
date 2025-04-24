
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

	while (!raylib::window_should_close() && !gamestate.end_game) {
		system::worldstate_loop();
	}

	ui::free();

	return 0;
}


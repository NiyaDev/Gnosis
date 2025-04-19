
module gnosis::system::debug;
import gnosis::system;
import gnosis::unit;
import pleroma;


String uitext;

<**>
fn void update_onscreen_text() {
  uitext.free(allocator::heap());

  float perc = gamestate.world.player.skills[Skills.PERCEPTION].value;
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
}


module gnosis::system;
import std::io;
import gnosis;
import pleroma;


<* Play button functionality *>
fn void ts_play_button() {
  gamestate.state = OVERWORLD;
  ui::remove("ts_title");
  ui::remove("ts_play");
  ui::remove("ts_options");
  ui::remove("ts_quit");

  UIElement player_status = verticalbox::new({10,10,0,0},null,TOPLEFT);
	player_status.add_element(bar::new(color::RED,{0,0,64,8},TOPLEFT,"bar_bg","bar_fl",&gamestate.world.player.hp_cur,&gamestate.world.player.hp_max));
	player_status.add_element(bar::new(color::GREEN,{0,0,64,8},TOPLEFT,"bar_bg","bar_fl",&gamestate.world.player.st_cur,&gamestate.world.player.st_max));
	player_status.add_element(bar::new(color::BLUE,{0,0,64,8},TOPLEFT,"bar_bg","bar_fl",&gamestate.world.player.mn_cur,&gamestate.world.player.mn_max));
	player_status.add_element(bar::new(color::YELLOW,{0,0,64,8},TOPLEFT,"bar_bg","bar_fl",&gamestate.world.player.hn_cur,&gamestate.world.player.hn_max));
	ui::push("status", player_status);

}

<* Options button functionality *>
fn void ts_options_button() {
  //io::printn("Options button pressed!");
  update_settings();
}

<* Quit button functionality *>
fn void ts_quit_button() {
  gamestate.end_game = true;
}



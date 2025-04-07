
module gnosis::system;
import std::io;
import gnosis;


<* Play button functionality *>
fn void ts_play_button() {
  gamestate.state = OVERWORLD;
  ui::remove("ts_title");
  ui::remove("ts_play");
  ui::remove("ts_options");
  ui::remove("ts_quit");
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



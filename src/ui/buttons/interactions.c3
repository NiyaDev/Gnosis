
module gnosis::ui;
import std::io;
import gnosis;
import pleroma;


uint options_tab = 0;
<**>
fn void open_titlescreen() {
  ui::new_text( // Title
		name: "ts_title",
		tint: color::WHITE,
		position: {10,10},
		font: "anakron",
		text: localization["game_name"]!!.get_ref(lang)!!,
		size: 40,
	);
	ui::new_button( // Play button
		name: "ts_play",
		text_color: color::WHITE,
		rect: {10, -128, 96, 32},
		text_padding: {0, 0, 26, 8},
		alignment: BOTTOMLEFT,
		background: "textbox",
		font: "anakron",
		text: localization["ts_play_option"]!!.get_ref(lang)!!,
		func: &ui::ts_play_button,
	);
	ui::new_button( // Options button
		name: "ts_options",
		text_color: color::WHITE,
		rect: {10, -96, 96, 32},
		text_padding: {0, 0, 8, 8},
		alignment: BOTTOMLEFT,
		background: "textbox",
		font: "anakron",
		text: localization["ts_options_option"]!!.get_ref(lang)!!,
		func: &ui::ts_options_button,
	);
	ui::new_button( // Quit button
		name: "ts_quit",
		text_color: color::WHITE,
		rect: {10, -64, 96, 32},
		text_padding: { 0,   0, 26,  8},
		alignment: BOTTOMLEFT,
		background: "textbox",
		font: "anakron",
		text: localization["ts_quit_option"]!!.get_ref(lang)!!,
		func: &ui::ts_quit_button,
	);
}
<**>
fn void remove_titlescreen() {
  ui::remove("ts_title");
  ui::remove("ts_play");
  ui::remove("ts_options");
  ui::remove("ts_quit");
}

<* Play button functionality *>
fn void ts_play_button() {
  gamestate.state = OVERWORLD;
  remove_titlescreen();

  UIElement player_status = verticalbox::new({10,10,0,0},null,TOPLEFT);
	player_status.add_element(bar::new(color::RED,{0,0,64,8},TOPLEFT,"bar_bg","bar_fl",&gamestate.world.player.hp_cur,&gamestate.world.player.hp_max));
	player_status.add_element(bar::new(color::GREEN,{0,0,64,8},TOPLEFT,"bar_bg","bar_fl",&gamestate.world.player.st_cur,&gamestate.world.player.st_max));
	player_status.add_element(bar::new(color::BLUE,{0,0,64,8},TOPLEFT,"bar_bg","bar_fl",&gamestate.world.player.mn_cur,&gamestate.world.player.mn_max));
	player_status.add_element(bar::new(color::YELLOW,{0,0,64,8},TOPLEFT,"bar_bg","bar_fl",&gamestate.world.player.hn_cur,&gamestate.world.player.hn_max));
	ui::push("status", player_status);

}

<* Options button functionality *>
fn void ts_options_button() {
  remove_titlescreen();
  ui::new_button( // Video tab
    name: "opts_video_tab",
    text_color: color::WHITE,
    rect: {-200, -155, 64, 32},
    text_padding: {0,0,10,10},
    alignment: CENTER,
    background: "textbox",
    font: "anakron",
    size: 12,
    text: localization["opts_video_tab"]!!.get_ref(lang)!!,
    func: &opts_video_button,
  );
  ui::new_button( // Audio tab
    name: "opts_audio_tab",
    text_color: color::WHITE,
    rect: {-138, -155, 64, 32},
    text_padding: {0,0,10,10},
    alignment: CENTER,
    background: "textbox",
    font: "anakron",
    size: 12,
    text: localization["opts_audio_tab"]!!.get_ref(lang)!!,
    func: &opts_audio_button,
  );
  ui::new_button( // Close button
    name: "opts_close_tab",
    text_color: color::WHITE,
    rect: {240, -140, 32, 32},
    text_padding: {0,0,11,8},
    alignment: CENTER,
    background: "textbox",
    font: "anakron",
    text: localization["opts_close_tab"]!!.get_ref(lang)!!,
    func: &opts_close_button,
  );
  ui::new_button( // Apply button
    name: "opts_apply_tab",
    text_color: color::WHITE,
    rect: {240, 140, 54, 32},
    text_padding: {0,0,11,8},
    alignment: CENTER,
    background: "textbox",
    font: "anakron",
    size: 12,
    text: localization["opts_apply_tab"]!!.get_ref(lang)!!,
    func: &opts_apply_button,
  );
  UITextureNPatch* background = npatch_texture::new(color::WHITE,{0,0,500,300},"textbox");
  ui::new_vertbox(
    name: "opts_display",
    rect: {0, 50, 500, 400},
    background: background,
    alignment: CENTER,
  );

  
}

<* Quit button functionality *>
fn void ts_quit_button() {
  gamestate.end_game = true;
}


<**>
fn void opts_video_button() {}
<**>
fn void opts_audio_button() {}
<**>
fn void opts_close_button() {
  ui::remove("opts_video_tab");
  ui::remove("opts_audio_tab");
  ui::remove("opts_close_tab");
  ui::remove("opts_apply_tab");
  ui::remove("opts_display");
  open_titlescreen();
}
<**>
fn void opts_apply_button() {
  system::update_settings();
}


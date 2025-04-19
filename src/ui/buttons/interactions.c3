
module gnosis::ui;
import std::io;
import gnosis;
import pleroma;


uint options_tab = 0;
<**>
fn void open_titlescreen() {

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
}
<**>
fn void remove_titlescreen() {
  ui::remove("ts_title");
  ui::remove("ts_play");
  ui::remove("ts_options");
  ui::remove("ts_quit");
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


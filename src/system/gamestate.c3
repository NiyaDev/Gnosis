
module gnosis::system;
import gnosis;
import pleroma;
import std::io;


Gamestate gamestate @builtin;
struct Gamestate {
  CurrentState state;

  World* world;
  bool combat;

  int tiles_rendered;

  bool debug_mode;
  bool end_game;
}

enum CurrentState {
  TITLE,
  OVERWORLD,
}

<**>
fn void worldstate_loop() {
  switch (gamestate.state) {
    case TITLE:
      system::content();
      system::ui();
        //ui::draw();
        //raygui::line({0,80,360,16},"fugandulu");
        raygui::enable();
        raygui::set_style(0, 16, 40);
        //raygui::set_style(0, 2, color::WHITE.to_int());
        raygui::label({9,14,360,32},(char*)localization["game_name"]!!.get(lang)!!);
        raygui::set_style(0, 16, 12);
        int play = raygui::button({9,250,96,32},(char*)localization["ts_play_option"]!![lang]!!);
        if (play != 0) io::printfn("fug");//ui::ts_play_button();
      system::end();
    case OVERWORLD:
      camera::update();
      gamestate.world.update();
      gamestate.world.player.update();

      if (gamestate.debug_mode) debug::update_onscreen_text();

      system::content();
        gamestate.world.draw();
        Vector3 pos = camera::main.target;
        pos.y += 0.25;
        camera::main.draw_billboard_pro(*gamestate.world.player.sprite, {0,0,16,32}, pos, vector3::ZERO.rotate({0,1,-1}, camera::main.rotation), {1,1}, {0.5,0.25}, 0, color::WHITE);

		  system::ui();
			  ui::draw();
			
		  system::end();
  }
}




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
        // General setup
        kenoma::set_font(fonts.get_ref("anakron")!!);
        kenoma::set_style(FONT_COLOR, color::WHITE.to_int());

        // Title
        kenoma::set_style(FONT_SIZE, 40);
        kenoma::label({9,14,360,32}, localization["game_name"]!![lang]!!);

        // Buttons
        kenoma::set_style(FONT_SIZE, 12);
        kenoma::button({9,250,96,32}, localization["ts_play_option"]!![lang]!!);

        // Version
        kenoma::label({(float)render[0] - 46, (float)render[1] - 16,0,0}, localization["game_version"]!![lang]!!);
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



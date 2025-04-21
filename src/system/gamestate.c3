
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
  bool options_menu;
  OptionsTabs options_tab;
}

enum CurrentState {
  TITLE,
  OVERWORLD,
}
enum OptionsTabs {
  VIDEO,
  AUDIO,
}

int res_kem;
int res_ray;
bool act_kem;
bool act_ray;

<**>
fn void worldstate_loop() {
  switch (gamestate.state) {
    case TITLE:
      system::content();
      system::ui();
        // General setup
        kenoma::set_font(fonts.get_ref("anakron")!!);
        kenoma::set_texture(TILED_BACKGROUND, textures.get_ref("textbox")!!);
        kenoma::set_texture(BAR_BACKGROUND, textures.get_ref("bar_bg")!!);
        kenoma::set_texture(BAR_FILL, textures.get_ref("bar_fl")!!);
        kenoma::set_style(FONT_COLOR, color::WHITE.to_int());
        kenoma::set_style(RENDER_RESOLUTION, 50);

        if (gamestate.options_menu) {
          // Options menu
          float render_w = (float)system::render[0] / 1.5;
          float render_h = (float)system::render[1] / 1.5;
          Rectangle opt_menu_rect = {
            ((float)system::render[0] / 2) - (render_w / 2),
            ((float)system::render[1] / 2) - (render_h / 2),
            render_w,
            render_h,
          };
          if (kenoma::button({opt_menu_rect.x + 10, opt_menu_rect.y - 24, 64, 32}, localization["opts_video_tab"]!![lang]!!, gamestate.options_tab != VIDEO)) gamestate.options_tab = VIDEO;
          if (kenoma::button({opt_menu_rect.x + 74, opt_menu_rect.y - 24, 64, 32}, localization["opts_audio_tab"]!![lang]!!, gamestate.options_tab != AUDIO)) gamestate.options_tab = AUDIO;
          kenoma::tiled_texture(opt_menu_rect, color::WHITE);
          if (kenoma::button({opt_menu_rect.width + opt_menu_rect.x - 16, opt_menu_rect.y - 16, 32, 32}, localization["opts_close_tab"]!![lang]!!, true)) gamestate.options_menu = false;
          if (kenoma::button({opt_menu_rect.width + opt_menu_rect.x - 48, opt_menu_rect.y + opt_menu_rect.height - 16, 64, 32}, localization["opts_apply_tab"]!![lang]!!, true)) {
            gamestate.options_menu = false;
            system::update_settings();
          }

          switch (gamestate.options_tab) {
            case VIDEO:
              kenoma::label({opt_menu_rect.x + 20, opt_menu_rect.y + 20,0,0}, localization["opts_screen_mode"]!![lang]!!);
              if (kenoma::dropdown({opt_menu_rect.x + 20, opt_menu_rect.y + 35,96,32}, "Window\nBorderless\nFullscreen", &options.get_ref("screen_mode")!!.as_int, act_kem)) act_kem = !act_kem;
            case AUDIO:
              kenoma::label({opt_menu_rect.x + 20, opt_menu_rect.y + 40, 0,0}, "Dulu");
          }
        } else {
          // TODO: Scale them on the screen
          // Title
          kenoma::set_style(FONT_SIZE, 40);
          kenoma::label({9,14,360,32}, localization["game_name"]!![lang]!!);

          // Buttons
          kenoma::set_style(FONT_SIZE, 12);
          if (kenoma::button({9,250,96,32}, localization["ts_play_option"]!![lang]!!, true))    gamestate.state = OVERWORLD;
          if (kenoma::button({9,284,96,32}, localization["ts_options_option"]!![lang]!!, true)) gamestate.options_menu = true;
          if (kenoma::button({9,318,96,32}, localization["ts_quit_option"]!![lang]!!, true))    gamestate.end_game = true;
          
        }

        // Version
        kenoma::label({(float)render[0] - 46, (float)render[1] - 16,0,0}, localization["game_version"]!![lang]!!);
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
		    // HP / Stamina / Mana / Hunger bars
		    // But only if the skills have been discovered
			  float offset = 1;
			  if (gamestate.world.player.skills[Skills.HEALTH].discovery > 0) {
			    kenoma::set_style(BAR_COLOR, color::RED.to_int());
			    kenoma::bar({10,offset++ * 10,64,8}, &gamestate.world.player.hp_cur,&gamestate.world.player.hp_max);
			  }
        if (gamestate.world.player.skills[Skills.STAMINA].discovery > 0) {
			    kenoma::set_style(BAR_COLOR, color::GREEN.to_int());
			    kenoma::bar({10,offset++ * 10,64,8}, &gamestate.world.player.st_cur,&gamestate.world.player.st_max);
			  }
			  if (gamestate.world.player.skills[Skills.MANA].discovery > 0) {
			    kenoma::set_style(BAR_COLOR, color::BLUE.to_int());
			    kenoma::bar({10,offset++ * 10,64,8}, &gamestate.world.player.mn_cur,&gamestate.world.player.mn_max);
			  }
			  if (gamestate.world.player.skills[Skills.BELLY].discovery > 0) {
			    kenoma::set_style(BAR_COLOR, color::YELLOW.to_int());
			    kenoma::bar({10,offset++ * 10,64,8}, &gamestate.world.player.hn_cur,&gamestate.world.player.hn_max);
			  }

			  // Version
        kenoma::label({(float)render[0] - 46, (float)render[1] - 16,0,0}, localization["game_version"]!![lang]!!);
  }

  system::end();
}



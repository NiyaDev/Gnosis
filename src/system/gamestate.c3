
module gnosis::system;
import gnosis;
import pleroma;


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
        ui::draw();
        //Font font = fonts.get("anakron")!!;
        //font.draw("GNOSIS",{10,10},40,1,color::WHITE);
        //font.draw("Play",{10,260},16,1,color::WHITE);
        //font.draw("Options",{10,276},16,1,color::WHITE);
        //font.draw("Quit",{10,292},16,1,color::WHITE);
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



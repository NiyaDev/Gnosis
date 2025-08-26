
module gnosis::system;
import gnosis;
import ennoia;


<* Updates all settings *>
fn void update_settings() {
  // Screen size
  //  Done first because it resets the window
 
  ennoia::set_size(options::get_int("screen_width"), option::get_int("screen_height"));

  // Screen mode
  char screen_mode = options["screen_mode"]!!.as_char;
  switch (screen_mode) {
    case 0: // Windowed
      //raylib::clear_window_state(0);
    case 1: // Windowed Fullscreen
      //raylib::clear_window_state(0);
      //raylib::toggle_borderless();
    case 2: // Fullscreen
      //raylib::clear_window_state(0);
      //raylib::toggle_fullscreen();
  }

  // Field of view
  // Target fps
  // Volume
}



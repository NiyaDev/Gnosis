
module gnosis::system;
import gnosis;
import ennoia;


<* Updates all settings *>
fn void update_settings() {
  // Screen size
  //  Done first because it resets the window
  int[] screen_size = options["screen_res"]!!.as_int_array;
  screen[0] = screen_size[0];
  screen[1] = screen_size[1];
  render[0] = screen[0] / 2;
  render[1] = screen[1] / 2;
  raylib::set_window_size(screen[0], screen[1]);
  reset_renderer();

  // Screen mode
  char screen_mode = options["screen_mode"]!!.as_char;
  switch (screen_mode) {
    case 0: // Windowed
      raylib::clear_window_state(0);
    case 1: // Windowed Fullscreen
      raylib::clear_window_state(0);
      raylib::toggle_borderless();
    case 2: // Fullscreen
      raylib::clear_window_state(0);
      raylib::toggle_fullscreen();
  }

  // Field of view
  // Target fps
  // Volume
}



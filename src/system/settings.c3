
module gnosis::system;
import gnosis;
import ennoia;


<* Updates all settings *>
fn void update_settings() {
  // Screen size
  //  Done first because it resets the window
  ennoia::set_size(options::get_int("screen_width"), options::get_int("screen_height"));

  // Screen mode
  switch (options::get_char("screen_mode")) {
    case 0: // Windowed
      ennoia::set_borderless(true);
      ennoia::set_fullscreen(false);
    case 1: // Windowed Fullscreen
      ennoia::set_borderless(true);
      int[2] newRes = ennoia::get_display_resolution();
      ennoia::set_size(newRes[0], newRes[1]);
    case 2: // Fullscreen
      ennoia::set_borderless(false);
      ennoia::set_fullscreen(true);
  }

  // Field of view
  ennoia::set_field_of_view((float)options::get_char("fov"));

  // Target fps
  // TODO: 

  // Volume
  // TODO:
}



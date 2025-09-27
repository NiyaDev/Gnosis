
module gnosis::system::menus;
import ennoia;



OptionsMenu options;
struct OptionsMenu {
  bool open;


}

<**>
fn void draw() {
  // Draw Option menu
  if (options.open) {
    // Background
    imm::texture_tiled(
      tint:    color::DARKGRAY,
      bounds:  {50,50,(float)ennoia::renWidth-100,(float)ennoia::renHeight-100},
      scale:   {10,10},
    );

    // Tabs
    imm::button(
      text:    "@{OPTIONS_VIDEO}",
      texture: "texture",
      bounds:  {75,25,200,50},
      textureScale:   {10,10},
    );
  }
}


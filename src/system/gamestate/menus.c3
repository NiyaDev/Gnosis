
module gnosis::system::menus;
import ennoia;



OptionsMenu options;
struct OptionsMenu {
  bool open;


}

<**>
fn void draw() {
  if (options.open) {
    // Draw Option menu
    //imm::label("test");
    imm::texture_tiled(
      //texture: "bg_bar",
      tint:    color::DARKGRAY,
      bounds:  {50,50,(float)ennoia::renWidth-100,(float)ennoia::renHeight-100},
      scale:   {10,10},
    );
  }
}


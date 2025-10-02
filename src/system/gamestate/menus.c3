
module gnosis::system::menus;
import ennoia;
import std::io;



OptionsMenu options;
struct OptionsMenu {
  bool open;
}

SkillsMenu skills;
struct SkillsMenu {
  bool open;
  Vec2f position;

  Vec2f lastPosition;
}

<**>
fn void draw() {
  if (gamestate.state == OVERWORLD || gamestate.state == COMBAT) draw_overworld_ui();
  if (options.open) draw_options();
  if (skills.open)  draw_skills();

  // Game version text
  imm::label(
    text: gnosis::GAME_VERSION,
    position: {5,(float)ennoia::renHeight-12-5},
    scale: {0.5,0.5},
  );
}

<* Draw Options menu *>
fn void draw_options() {
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
<* Draw Skills menu *>
fn void draw_skills() {
  // Background
  imm::texture_tiled(
    tint:    color::DARKGRAY,
    bounds:  {skills.position.x,skills.position.y,200,400},
    scale:   {10,10},
  );
}
<* Draw overworld UI *>
fn void draw_overworld_ui() {
  // Draw Bars
  float barOffset = 1;
  imm::bar(
    textureBg:   "bar_bg",
    textureFg:   "bar_fill",
    textureTint: color::RED,
    bounds: {
      16, barOffset++ * 18,
      (float)gamestate.world.player.hpMax * 2,
      16,
    },
  );
  if (gamestate.world.player.skills.has_key(MANA)) {
    imm::bar(
      textureBg:   "bar_bg",
      textureFg:   "bar_fill",
      textureTint: color::BLUE,
      bounds: {
        16, barOffset++ * 18,
        (float)gamestate.world.player.mnMax * 2,
        16,
      },
    );
  }
  imm::bar(
    textureBg:   "bar_bg",
    textureFg:   "bar_fill",
    textureTint: color::GREEN,
    bounds: {
      16, barOffset++ * 18,
      (float)gamestate.world.player.hnMax * 2,
      16,
    },
  );
}


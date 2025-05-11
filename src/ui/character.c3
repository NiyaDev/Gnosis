
module gnosis::ui;
import gnosis::system;
import gnosis::unit;
import pleroma::kenoma;
import pleroma::raylib;


WindowDetails skills_screen;

struct WindowDetails {
  bool inititated, open;
  Rectangle rect;
}

<* Initializes all windows *>
fn void init_windows() {
  skills_screen = { true, false, {100,100,200,200} };
}

<**>
fn void draw_skill_screen() {
  if (skills_screen.open) {
    kenoma::tiled_texture(skills_screen.rect, color::WHITE);

    Unit* player = gamestate.world.player;
    Rectangle text_rect = skills_screen.rect + {10,10,0,0};
    for (int i; i < player.skills.len; i++) {
      Skills skill_type = Skills.from_ordinal(i);
      String skill = string::format(allocator::heap(), "%s - lv %d (%d)", skill_type, player.skills[skill_type].value, player.skills[skill_type].exp);
      kenoma::label(text_rect, skill);
      skill.free(allocator::heap());
      text_rect += {0,20,0,0};
      //kenoma::label({(float)render[0] - 46, (float)render[1] - 16,0,0}, localization["game_version"]!![lang]!!);
    }
  }
}


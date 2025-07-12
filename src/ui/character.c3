
module gnosis::ui;
import gnosis::system;
import gnosis::unit;
import ennoia;


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
      if ((text_rect.y + 20) > skills_screen.rect.height + skills_screen.rect.y) continue;

      Skills skill_type = Skills.from_ordinal(i);
      String skill = string::format(allocator::heap(), "%s - lv %d (%d)", skill_type, player.skills[skill_type].value, player.skills[skill_type].exp);
      kenoma::label(text_rect, skill);
      skill.free(allocator::heap());
      text_rect += {0,20,0,0};
    }
  }
}


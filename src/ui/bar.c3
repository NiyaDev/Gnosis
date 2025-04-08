
module gnosis::ui;
import pleroma;

struct UIBarData {
  Color tint;
  Rectangle rect;
  Alignment alignment;

  String background, bar;
  float* value, max;
}

<* Pushes new bar to ui *>
fn void new_bar(
  String name,
  Color tint = color::WHITE,
  Rectangle rect = {0,0,16,16},
  Alignment alignment = TOPLEFT,
  String bg = "default",
  String bar = "default",
  float* value = null,
  float* max = null,
) {
  UIElement data = bar::new(tint, rect, alignment, bg, bar, value, max);
  uihandler.set(name, data);
}



module gnosis::ui::bar;
import pleroma;

<* Creates a new Bar element without pushing to UI *>
fn UIElement new(
  Color tint,
  Rectangle rect,
  Alignment alignment,
  String bg,
  String bar,
  float* value,
  float* max,
) {
  UIBarData* bardata = mem::new(UIBarData);
  *bardata = { tint, rect, alignment, bg, bar, value, max };
  return { BAR, (void*)bardata };
}


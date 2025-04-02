
module gnosis::ui;
import pleroma;

struct UIBarData {
  Color tint;
  Rectangle rect;

  String background, bar;
  float* value, max;
}

<* Pushes new bar to ui *>
fn void new_bar(
  String name,
  Color tint = color::WHITE,
  Rectangle rect = {0,0,16,16},
  String bg = "default",
  String bar = "default",
  float* value = null,
  float* max = null,
) {
  UIElement dat = bar::new(tint, rect, bg, bar, value, max);
  uihandler.set(name,dat);
}



module gnosis::ui::bar;
import pleroma;

<* Creates a new Bar element without pushing to UI *>
fn UIElement new(
  Color tint,
  Rectangle rect,
  String bg,
  String bar,
  float* value,
  float* max,
) {
  UIBarData* bardata = mem::new(UIBarData);
  *bardata = { tint, rect, bg, bar, value, max };
  return { BAR, (void*)bardata };
}


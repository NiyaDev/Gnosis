
module gnosis::ui;
import pleroma;

alias ButtonFunc = fn void();
struct UIButtonData {
  Color text_color;
  Color bg_color_default;
  Color bg_color_selected;
  Color bg_color_disabled;
  Rectangle rect;
  Rectangle text_padding;
  String background;
  String font;
  float size;
  float spacing;
  String* text;
  ButtonFunc func;
  bool active;
}

<* Pushes a new button to ui *>
fn void new_button(
  String name,
  Color text_color = color::BLACK,
  Color bg_color_default = color::WHITE,
  Color bg_color_selected = color::GRAY,
  Color bg_color_disabled = color::DARKGRAY,
  Rectangle rect = {0,0,32,32},
  Rectangle text_padding = {0,0,16,16},
  String background = "default",
  String font = "default",
  float size = 16,
  float spacing = 1,
  String* text = null,
  ButtonFunc func = null,
  bool active = true,
) {
  UIElement data = button::new(text_color, bg_color_default, bg_color_selected, bg_color_disabled, rect, text_padding, background, font, size, spacing, text, func, active);
  uihandler.set(name, data);
}


module gnosis::ui::button;
import pleroma;

<* Creates a new Button element without pushing it to UI *>
fn UIElement new(
  Color text_color,
  Color bg_color_default,
  Color bg_color_selected,
  Color bg_color_disabled,
  Rectangle rect,
  Rectangle text_padding,
  String background,
  String font,
  float size,
  float spacing,
  String* text,
  ButtonFunc func,
  bool active,
) {
  UIButtonData* buttondata = mem::new(UIButtonData);
  *buttondata = { text_color, bg_color_default, bg_color_selected, bg_color_disabled, rect, text_padding, background, font, size, spacing, text, func, active };
  return { BUTTON, (void*)buttondata };
}

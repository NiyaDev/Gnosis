
module gnosis::ui;
import pleroma;

struct UIDropdown {
  Color text_color;
  Color bg_color_default;
  Color bg_color_selected;
  Color bg_color_disabled;
  Rectangle rect;
  Rectangle text_padding;
  Alignment alignment;
  String background;
  String font;
  float size;
  float spacing;
  String* text;
  uint value;
bool active;
}

<* Pushes a new dropdown to ui *>
fn void new_dropdown(
  String name,
  Color text_color = color::BLACK,
  Color bg_color_default = color::WHITE,
  Color bg_color_selected = color::GRAY,
  Color bg_color_disabled = color::DRAKGRAY,
  Rectangle rect = {0,0,32,32},
  Rectangle text_padding = {0,0,16,16},
  Alignment alignment = TOPLEFT,
  String background = "default",
  String font = "default",
  float size = 16,
  float spacing = 1,
  String* text = null,
  uint value = 0,
  bool active = true,
) {
  UIElement data = dropdown::new(text_color, bg_color_default, bg_color_selected, bg_color_disabled, rect, text_padding, alignment, background, font, size, spacing, text, value, active);
  uihandler.set(name, data);
}


module gnosis::ui::dropdown;
import pleroma;

<* Creates a new Dropdown element without pushing it to UI *>
fn UIElement new(
  Color text_color,
  Color bg_color_default,
  Color bg_color_selected,
  Color bg_color_disabled,
  Rectangle rect,
  Rectangle text_padding,
  Alignment alignment,
  String background,
  String font,
  float size,
  float spacing,
  String* text,
  uint value,
  bool active,
) {
  UIDropdown* dropdowndata = mem::new(UIDropdown);
  *dropdowndata = { text_color, bg_color_default, bg_color_selected, bg_color_disabled, rect, text_padding, alignment, background, font, size, spacing, text, value, active };
  return { DROPDOWN, (void*)dropdowndata };
}


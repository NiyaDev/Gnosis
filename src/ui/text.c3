
module gnosis::ui;
import pleroma;

// TODO: Allow text to have multiple colors in a single string
struct UITextData {
  Color tint;
  Vector2 position;
  String font;
  String* text;
  float text_size, text_spacing;
}

<* Pushes new text to ui *>
fn void new_text(
  String name,
  Color tint = color::BLACK,
  Vector2 position = {0,0},
  String font = "default",
  String* text = null,
  float size = 20,
  float spacing = 1,
) {
  UIElement dat = text::new(tint, position, font, text, size, spacing);
  uihandler.set(name,dat);
}


module gnosis::ui::text;
import pleroma;

<* Create a new Text element without pushging to ui *>
fn UIElement new(
  Color tint,
  Vector2 position,
  String font,
  String* text,
  float size,
  float spacing,
) {
  UITextData* textdata = mem::new(UITextData);
  *textdata = { tint, position, font, text, size, spacing };
  return { TEXT, (void*)textdata };
}


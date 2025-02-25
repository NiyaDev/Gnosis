
module gnosis::ui;
import std::collections;
import raylib;
import gnosis::resources;



def UIHandler = HashMap(<String, UIElement>);
UIHandler data;

struct UIElement {
  UIType type;
  void* data;
}

enum UIType {
  BAR,
  TEXT,
  WINDOW,
  // TODO: Status screen
}

struct UIBarData {
  Color tint;
  Rectangle rect;
  //* Textures
  String background, bar;
  //* Data
  float* value, max;
}

// TODO: Allow text to have multiple colors in a single string
struct UITextData {
  Color tint;
  Vector2 position;
  String font;
  String text;
  float text_size, text_spacing;
}

<* Draw all elements *>
fn void draw() {
  data.@each(; String key, UIElement val) { val.draw(); };
}
<* Remove element *>
fn void remove(String name) {
  data.remove(name)!!;
}

<* Draw element *>
fn void UIElement.draw(&self) {
  switch (self.type) {
    case BAR:
      UIBarData* data = (UIBarData*)self.data;

      //* Background
      resources::textures[data.background]!!.draw_npatch(
        {{0,0,24,8},8,8,8,8,THREE_PATCH_HORIZONTAL},
        data.rect,
        {0,0}, 0,
        data.tint,
      );

      //* Bar
      float percent = *data.value / *data.max;
      Rectangle modified_rect = data.rect;
      modified_rect.width *= percent;
      resources::textures[data.bar]!!.draw_npatch(
        {{0,0,24,8},8,8,8,8,THREE_PATCH_HORIZONTAL},
        modified_rect,
        {0,0}, 0,
        data.tint,
      );
    case TEXT:
      UITextData* data = (UITextData*)self.data;

      resources::fonts[data.font]!!.draw_pro(
        data.text,
        data.position,
        {0,0}, 0,
        data.text_size,
        data.text_spacing,
        data.tint,
      );
    default:
  }
}


//* Bar
<* Create new Bar element
  @require name != ""
  @require bg != ""
  @require bar != ""
  @require value != null
  @require max != null
 *>
fn void new_bar(String name, Color tint, Rectangle rect, String bg, String bar, float* value, float* max) {
  UIBarData* bardata = mem::new(UIBarData);
  *bardata = { tint, rect, bg, bar, value, max };
  UIElement element = { BAR, (void*)bardata };
  data.set(name, element);
}

//* Text
<**>
fn void new_text(String name, Color tint, Vector2 position, String font, String text, float size, float spacing) {
  UITextData* textdata = mem::new(UITextData);
  *textdata = { tint, position, font, text, size, spacing };
  UIElement element = { TEXT, (void*)textdata };
  data.set(name, element);
}

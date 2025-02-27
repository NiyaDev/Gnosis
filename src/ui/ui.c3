
module gnosis::ui;
import std::io;
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
  VERT_BOX,
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
  String font, text;
  float text_size, text_spacing;
}

struct UITextureNPatch {
  Color tint;
  Rectangle rect;
  NPatchInfo npatch;
  String texture;
}

struct UIVerticalBox {
  UITextureNPatch* background;
  Rectangle padding;
  List(<UIElement>) elements;
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
fn void UIElement.draw(&self, Rectangle offset = {0,0,0,0}) {
  switch (self.type) {
    case BAR:
      UIBarData* uidata = (UIBarData*)self.data;
      
      Rectangle rectoff = {
        uidata.rect.x + offset.x,
        uidata.rect.y + offset.y,
        uidata.rect.width + offset.width,
        uidata.rect.height + offset.height, 
      };
      //* Background
      resources::textures[uidata.background]!!.draw_npatch(
        {{0,0,24,8},8,8,8,8,THREE_PATCH_HORIZONTAL},
        rectoff,
        {0,0}, 0,
        uidata.tint,
      );

      //* Bar
      float percent = *uidata.value / *uidata.max;
      //Rectangle modified_rect = uidata.rect;
      //modified_rect.width *= percent;
      rectoff.width *= percent;
      resources::textures[uidata.bar]!!.draw_npatch(
        {{0,0,24,8},8,8,8,8,THREE_PATCH_HORIZONTAL},
        rectoff,
        {0,0}, 0,
        uidata.tint,
      );
    case TEXT:
      UITextData* uidata = (UITextData*)self.data;

      resources::fonts[uidata.font]!!.draw_pro(
        uidata.text,
        uidata.position,
        {0,0}, 0,
        uidata.text_size,
        uidata.text_spacing,
        uidata.tint,
      );
    case VERT_BOX:
      UIVerticalBox* uidata = (UIVerticalBox*)self.data;

      if (uidata.background != null) {
        resources::textures[uidata.background.texture]!!.draw_npatch(
          uidata.background.npatch,
          uidata.background.rect,
          {0,0}, 0,
          uidata.background.tint,
        );
      }
      for (int i; i < uidata.elements.len(); i++) {
        Rectangle rect = uidata.padding;
        rect.y *= (float)i;
        rect.y += uidata.padding.y;
        uidata.elements[i].draw(rect);
      }
    default:
  }
}

<* Pushes already created element to ui *>
fn void push(String name, UIElement element) {
  data.set(name, element);
}
<* Pushes new bar to ui *>
fn void new_bar(String name, Color tint, Rectangle rect, String bg, String bar, float* value, float* max) {
  UIElement dat = bar::new(tint, rect, bg, bar, value, max);
  data.set(name,dat);
}
<* Pushes new text to ui *>
fn void new_text(String name, Color tint, Vector2 position, String font, String text, float size, float spacing) {
  UIElement dat = text::new(tint, position, font, text, size, spacing);
  data.set(name,dat);
}


//* Bar
module gnosis::ui::bar;
import raylib;


<* Creates a new Bar element without pushing to UI
  @require bg != ""
  @require bar != ""
  @require value != null
  @require max != null
 *>
fn UIElement new(Color tint, Rectangle rect, String bg, String bar, float* value, float* max) {
  UIBarData* bardata = mem::new(UIBarData);
  *bardata = { tint, rect, bg, bar, value, max };
  return { BAR, (void*)bardata };
}


//* Text
module gnosis::ui::text;
import raylib;


<* Create a new Text element without pushging to ui
  @require font != ""
  @require text != ""
 *>
fn UIElement new(Color tint, Vector2 position, String font, String text, float size, float spacing) {
  UITextData* textdata = mem::new(UITextData);
  *textdata = { tint, position, font, text, size, spacing };
  return { TEXT, (void*)textdata }; 
}


//* Vertical box
module gnosis::ui::verticalbox;
import raylib;


<* Create new Vertical box without pushing to ui *>
fn UIElement new(UITextureNPatch* background = null, Rectangle padding = {0,0,0,0}) {
  UIVerticalBox* vertdata = mem::new(UIVerticalBox);
  vertdata.background = background;
  vertdata.padding = padding;
  vertdata.elements.new_init();
  return { VERT_BOX, (void*)vertdata };
}

<* Add new element to Vertical box
  @require self.type == VERT_BOX
 *>
fn void UIElement.add_element(&self, UIElement element) {
  UIVerticalBox* vertdata = (UIVerticalBox*)self.data;
  vertdata.elements.push(element);
}
<* Remove element from Vertical box
  @require self.type == VERT_BOX
 *>
fn void UIElement.remove_element(&self, usz index) {
  UIVerticalBox* vertdata = (UIVerticalBox*)self.data;
  vertdata.elements.remove_at(index);
}
<* Get the length of the elements *>
fn usz UIElement.len(&self) {
  UIVerticalBox* vertdata = (UIVerticalBox*)self.data;
  return vertdata.elements.len(); 
}


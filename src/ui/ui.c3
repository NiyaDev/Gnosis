
module gnosis::ui;
import std::io;
import std::collections;
import pleroma;
//import raylib;
import gnosis::resources;



alias UIHandler = HashMap{String, UIElement};
UIHandler data;

struct UIElement {
  UIType type;
  void* data;
}

enum UIType {
  BAR,
  TEXT,
  VERT_BOX,
  HORI_BOX,
  TEXTBOX,
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
  String* text;
  float text_size, text_spacing;
}

struct UITextureNPatch {
  Color tint;
  Rectangle rect;
  NPatchInfo npatch;
  String texture;
}

struct UIVerticalBox {
  List{UIElement} elements; 
  UITextureNPatch* background;
  Rectangle padding;
}

struct UIHorizontalBox {
  List{UIElement} elements; 
  UITextureNPatch* background;
  Rectangle padding;
}

struct UITextbox {
  bool visible;
  Rectangle rect;
  UITextureNPatch* background;
  String font;
  int timer;

  float text_size;
  float text_spacing;
  int text_speed;

  Rectangle textspace;
  String text;
  char[] display;
  usz index;
}

<* Draw all elements *>
fn void draw() {
  data.@each(; String key, UIElement val) { val.draw(); };
}
<* Remove element *>
fn void remove(String name) {
  data.remove(name)!!;
}
<* Frees all ui data *>
fn void free() {
  data.@each(; String key, UIElement val) {
    val.free();
  };
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
        *uidata.text,
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
    case HORI_BOX:
      UIHorizontalBox* uidata = (UIHorizontalBox*)self.data;

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
        rect.x *= (float)i;
        rect.x += uidata.padding.y;
        uidata.elements[i].draw(rect);
      }
    case TEXTBOX:
      UITextbox* tbdata = (UITextbox*)self.data;
      if (tbdata.visible) {
        //* Background 
        resources::textures[tbdata.background.texture]!!.draw_npatch(
          tbdata.background.npatch,
          tbdata.rect,
          {0,0}, 0,
          tbdata.background.tint,
        );

        //* Draw text one character at a time
        Font font = resources::fonts[tbdata.font]!!;
        for (int i; i < tbdata.display.len - 1; i++) {
          if (tbdata.display[i] != 0) {
            // TODO: Allow for rich text formatting
            String str = string::format(allocator::heap(), "%c\0",((String)tbdata.display)[i],);
            font.draw_pro(
              str,
              {
                tbdata.textspace.x + (float)((float)i * ((tbdata.text_size * 0.6) + tbdata.text_spacing)),
                tbdata.textspace.y,
              },
              {0,0}, 0,
              tbdata.text_size,
              tbdata.text_spacing,
              color::WHITE,
            );
            str.free(allocator::heap());
          }
        }

        tbdata.timer++;
        if (tbdata.timer >= tbdata.text_speed && tbdata.index < tbdata.display.len-1) {
          tbdata.timer = 0;
          tbdata.display[tbdata.index] = tbdata.text[tbdata.index];
          tbdata.index++;
        }
      }
    default:
  }
}
<* Free element *>
fn void UIElement.free(&self) {
  switch (self.type) {
    case VERT_BOX: nextcase;
    case HORI_BOX:
      List{UIElement}* list = ((List{UIElement}*)self.data);
      for (int i; i < list.len(); i++) {
        list[i].free();
      }
    case BAR: nextcase;
    case TEXT:
      mem::free(self.data);
    default:
  }
  data.clear();
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
fn void new_text(String name, Color tint, Vector2 position, String font, String* text, float size, float spacing) {
  UIElement dat = text::new(tint, position, font, text, size, spacing);
  data.set(name,dat);
}

<* Add new element to Vertical box
  @require self.type == VERT_BOX || self.type == HORI_BOX
 *>
fn void UIElement.add_element(&self, UIElement element) {
  List{UIElement}* uidata = (List{UIElement}*)self.data;
  uidata.push(element);
}
<* Remove element from Vertical box
  @require self.type == VERT_BOX || self.type == HORI_BOX
 *>
fn void UIElement.remove_element(&self, usz index) {
  List{UIElement}* uidata = (List{UIElement}*)self.data;
  uidata.remove_at(index);
}
<* Get the length of the elements *>
fn usz UIElement.len(&self) {
  List{UIElement}* uidata = (List{UIElement}*)self.data;
  return uidata.len(); 
}



//* Bar
module gnosis::ui::bar;
import pleroma;
//import raylib;


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
import pleroma;
//import raylib;


<* Create a new Text element without pushging to ui
  @require font != ""
  @require text != null
 *>
fn UIElement new(Color tint, Vector2 position, String font, String* text, float size, float spacing) {
  UITextData* textdata = mem::new(UITextData);
  *textdata = { tint, position, font, text, size, spacing };
  return { TEXT, (void*)textdata }; 
}


//* NPatch Texture
module gnosis::ui::npatch_texture;
import pleroma;
//import raylib;
import gnosis::resources;


<* Create new NPatch texture without pushing it *>
fn UITextureNPatch* new(Color tint = raylib::WHITE, Rectangle rect = {0,0,0,0}, String texture) {
  UITextureNPatch* npdata = mem::new(UITextureNPatch);
  npdata.tint = tint;
  npdata.rect = rect;
  npdata.npatch = resources::textures[texture].npatch()!!;
  npdata.texture = texture;

  return npdata;
}


//* Vertical box
module gnosis::ui::verticalbox;
import pleroma;
//import raylib;


<* Create new Vertical box without pushing to ui *>
fn UIElement new(UITextureNPatch* background = null, Rectangle padding = {0,0,0,0}) {
  UIVerticalBox* vertdata = mem::new(UIVerticalBox);
  vertdata.background = background;
  vertdata.padding = padding;
  //vertdata.elements.new_init();
  return { VERT_BOX, (void*)vertdata };
}


//* Horizontal box
module gnosis::ui::horizontalbox;
import pleroma;
//import raylib;


<* Create new Vertical box without pushing to ui *>
fn UIElement new(UITextureNPatch* background = null, Rectangle padding = {0,0,0,0}) {
  UIHorizontalBox* hordata = mem::new(UIHorizontalBox);
  hordata.background = background;
  hordata.padding = padding;
  //hordata.elements.new_init();
  return { VERT_BOX, (void*)hordata };
}


//* Textbox
module gnosis::ui::textbox;
import pleroma;
//import raylib;


<* Create new textbox without pushing *>
fn UIElement new(UITextureNPatch* bg = null, bool visible = false, Rectangle rect = {0,0,0,0}, Rectangle textspace = {0,0,0,0}, String font = "", float text_size = 12, float text_spacing = 0, int text_speed = 1) {
  UITextbox* tbdata = mem::new(UITextbox);
  tbdata.visible = visible;
  tbdata.background = bg;
  tbdata.rect = rect;
  tbdata.font = font;
  Rectangle offset_textspace = {
    rect.x + textspace.x,
    rect.y + textspace.y,
    rect.width + textspace.width,
    rect.height + textspace.height,
  };
  tbdata.textspace = offset_textspace;
  tbdata.text_size = text_size;
  tbdata.text_spacing = text_spacing;
  tbdata.text_speed = text_speed;
  return { TEXTBOX, (void*)tbdata };
}

<* Sets the current target text
  @require self.type == TEXTBOX
 *>
fn void UIElement.set_text(&self, String text) {
  UITextbox* tbdata = self.data;
  tbdata.text = text;
  tbdata.display = mem::new_array(char,text.len+1);
  tbdata.timer = 0;
  tbdata.index = 0;
}
<* Returns whether the textbox is done drawing text
  @require self.type == TEXTBOX
 *>
fn bool UIElement.finished(&self) {
  UITextbox* tbdata = self.data;
  if (tbdata.index == tbdata.display.len-1) return true;
  return false;
}

<**>
fn usz String.text_length(&self) {
  return 0;
}

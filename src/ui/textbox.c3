
module gnosis::ui;
import pleroma;

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

<*  *>
fn void new_textbox(
  String name,
  Rectangle rect = {0,0,32,32},
  Rectangle textspace = {8,8,16,16},
  String font = "default",
  bool visible = false,
  float size = 20,
  float spacing = 1,
  int speed = 1,
  UITextureNPatch* bg = null,
) {
  UIElement dat = textbox::new(rect,textspace,font,visible,size,spacing,speed,bg);
  uihandler.set(name, dat);
}


module gnosis::ui::textbox;
import pleroma;

<* Create new textbox without pushing *>
fn UIElement new(
  Rectangle rect,
  Rectangle textspace,
  String font,
  bool visible,
  float size,
  float spacing,
  int speed,
  UITextureNPatch* bg,
) {
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
  tbdata.text_size = size;
  tbdata.text_spacing = spacing;
  tbdata.text_speed = speed;
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

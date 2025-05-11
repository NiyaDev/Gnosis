
module gnosis::ui;
import std::collections;
import pleroma;

struct UIHorizontalBox {
  List{UIElement} elements; 
  UITextureNPatch* background;
  Rectangle padding;
  Alignment alignment;
}

<* Pushes new Vertical bax to UI *>
fn void new_horibox(
  String name,
  Rectangle rect = {0,0,32,16},
  UITextureNPatch* background = null,
  Alignment alignment = TOPLEFT,
) {
  UIElement dat = horizontalbox::new(rect, background, alignment);
  uihandler.set(name, dat);
}


module gnosis::ui::horizontalbox;
import pleroma;

<* Create new Horizontal box without pushing to ui *>
fn UIElement new(
  Rectangle padding,
  UITextureNPatch* background,
  Alignment alignment,
) {
  UIHorizontalBox* hordata = mem::new(UIHorizontalBox);
  hordata.background = background;
  hordata.padding = padding;
  hordata.alignment = alignment;
  return { VERT_BOX, (void*)hordata };
}


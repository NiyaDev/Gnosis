
module gnosis::ui;
import std::collections;
import pleroma;

struct UIHorizontalBox {
  List{UIElement} elements; 
  UITextureNPatch* background;
  Rectangle padding;
}

<* Pushes new Vertical bax to UI *>
fn void new_horibox(
  String name,
  Rectangle rect = {0,0,32,16},
  UITextureNPatch* background = null,
) {
  UIElement dat = horizontalbox::new(rect, background);
  uihandler.set(name, dat);
}


module gnosis::ui::horizontalbox;
import pleroma;

<* Create new Horizontal box without pushing to ui *>
fn UIElement new(
  Rectangle padding,
  UITextureNPatch* background,
) {
  UIHorizontalBox* hordata = mem::new(UIHorizontalBox);
  hordata.background = background;
  hordata.padding = padding;
  return { VERT_BOX, (void*)hordata };
}


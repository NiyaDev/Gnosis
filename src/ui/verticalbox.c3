
module gnosis::ui;
import std::collections;
import pleroma;

struct UIVerticalBox {
  List{UIElement} elements; 
  UITextureNPatch* background;
  Rectangle padding;
  Alignment alignment;
}

<* Pushes new Vertical bax to UI *>
fn void new_vertbox(
  String name,
  Rectangle rect = {0,0,32,16},
  UITextureNPatch* background = null,
  Alignment alignment = TOPLEFT,
) {
  UIElement dat = verticalbox::new(rect, background, alignment);
  uihandler.set(name, dat);
}


module gnosis::ui::verticalbox;
import pleroma;

<* Create new Vertical box without pushing to ui *>
fn UIElement new(
  Rectangle padding,
  UITextureNPatch* background,
  Alignment alignment,
) {
  UIVerticalBox* vertdata = mem::new(UIVerticalBox);
  vertdata.background = background;
  vertdata.padding = padding;
  vertdata.alignment = alignment;
  return { VERT_BOX, (void*)vertdata };
}


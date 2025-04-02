
module gnosis::ui;
import pleroma;
import gnosis::resources;

struct UITextureNPatch {
  Color tint;
  Rectangle rect;
  NPatchInfo npatch;
  String texture;
}

<* Push new texture to ui handler *>
fn void new_npatch_texture(
  String name,
  Color tint = color::WHITE,
  Rectangle rect = {0,0,32,32},
  String texture = "default",
) {
  UIElement dat = npatch_texture::new(tint, rect, texture);
  uihandler.set(name, dat);
}


module gnosis::ui::npatch_texture;
import pleroma;
import gnosis::resources;

<* Create new NPatch texture without pushing it *>
fn UIElement new(
  Color tint,
  Rectangle rect,
  String texture,
) {
  UITextureNPatch* npdata = mem::new(UITextureNPatch);
  npdata.tint = tint;
  npdata.rect = rect;
  npdata.npatch = textures[texture].npatch()!!;
  npdata.texture = texture;
  return { TEXT, (void*)npdata };
}

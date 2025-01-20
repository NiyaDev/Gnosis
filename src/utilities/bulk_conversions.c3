
module gnosis;
import std::io;
import bulk;
import raylib;


<* Load Texture from bulk *>
fn Texture* Bulk.get_texture(&self, String name) {
  Image* image = image::load_mem(".png", self.get(name)!!);
  defer image.unload();

  Texture* output = image.texture();

  return output;
}



module gnosis;
import std::io;
import ennoia;


<* Load Texture from bulk *>
fn Texture Bulk.get_texture(&self, String name) {
  Image image = image::load_mem(".png", self.get(name));
  defer image.unload();

  return image.texture();
}


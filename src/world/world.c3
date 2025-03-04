
module gnosis::world;
import std::collections;
import gnosis::unit;
import gnosis::resources;
import raylib;


struct World {
  Player* player;

  HashMap(<int[3],Chunk>) chunks;
}

int tiles_rendered;
World data;

fn void new_chunk(int[3] position) {
  Chunk chunk;
  chunk.init();
  data.chunks.set(position,chunk);
}
fn void draw() {
  tiles_rendered = 0;
  data.chunks.@each(; int[3] position_raw, Chunk chunk) {
    chunk.draw();
    for (int x = 0; x < 16; x++) {
      for (int z = 0; z < 16; z++) {
        for (int y = 0; y < 16; y++) {
          Tile* t = &(chunk.tiles[x][y][z]);
          if (chunk.tile_visible({(float)x,(float)y,(float)z})) {
            Vector3 pos = {
              (float)(x + (position_raw[0] * 16)) - (float)(z + (position_raw[2] * 16)),
              (float)(y + (position_raw[1] * 16)),
              (float)(x + (position_raw[0] * 16)) + (float)(z + (position_raw[2] * 16)),
            };
            Model* model = resources::models[t.model]!!;
            Material* mat = resources::materials[t.material]!!;
            mat.set_texture(*resources::textures[t.texture]!!);
            model.set_material(mat);
            model.draw_ex(pos, {0,1,0}, 45, {1.45,1.45,1.45}, raylib::WHITE);
            tiles_rendered++;
          }
        }
      }
    }
  };
}

fn uint int[3].hash(self) {
  return (uint)(10000 + (self[0] * 2) + (self[1] * 4) + (self[2] * 3));
}


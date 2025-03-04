
module gnosis::world;
import std::collections;
import std::io;
import gnosis::unit;
import gnosis::resources;
import raylib;


struct World {
  Player* player;

  HashMap(<int[3],Chunk>) chunks;
}

struct MeshIntance {
  String model;
  String material;
  String texture;
  List(<Matrix>) matrices;
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
    for (int x = 0; x < 16; x++) {
      for (int z = 0; z < 16; z++) {
        for (int y = 0; y < 16; y++) {
          Tile* t = &(chunk.tiles[x][y][z]);
          float visibility = tile_visible(position_raw, {x, y, z});
          if (visibility != 0) {
            Vector3 pos = {
              (float)(x + (position_raw[0] * 16)) - (float)(z + (position_raw[2] * 16)),
              (float)(y + (position_raw[1] * 16)),
              (float)(x + (position_raw[0] * 16)) + (float)(z + (position_raw[2] * 16)),
            };
            Model* model = resources::models[t.model]!!;
            Material* mat = resources::materials[t.material]!!;
            mat.set_texture(*resources::textures[t.texture]!!);
            Matrix matr = matrix::translate(pos);
            model.set_material(mat);
            //model.meshes[0].draw(*mat,matr.add(matrix::rotate_y(1.6)));
            Color col = {
              (char)(255 * visibility),
              (char)(255 * visibility),
              (char)(255 * visibility),
              255,
            };
            model.draw_ex(pos, {0,1,0}, 45, {1.4,1.4,1.4}, col);
            tiles_rendered++;
          }
        }
      }
    }
  };
}

//<**>
<**>
fn float tile_visible(int[3] chunk_position, int[3] tile) {
  Chunk* chunk = data.chunks.get_ref(chunk_position)!!;

  //* False if tile isn't visible
  if (!chunk.tiles[tile[0]][tile[1]][tile[2]].visible) return 0;

  //* False if outside of player vision
  Vector3 position = {
    (float)((chunk_position[0] * 16) + tile[0]),
    (float)((chunk_position[1] * 16) + tile[1]),
    (float)((chunk_position[2] * 16) + tile[2]), 
  };
  if (data.player.position.distance(position) > 5 + (data.player.skills["perception"]!!.value * 0.2)) return 0;

  //* If there's any visible tiles around it
  

  //* Multiplier for vision
  float vision_multi = 0;
  if (data.player.position.distance(position) > 4 + (data.player.skills["perception"]!!.value * 0.2)) vision_multi = 0.4;
  if (data.player.position.distance(position) > 3 + (data.player.skills["perception"]!!.value * 0.2)) vision_multi = 0.6;
  if (data.player.position.distance(position) > 2 + (data.player.skills["perception"]!!.value * 0.2)) vision_multi = 0.8; 
  //bool above = !chunk.tiles[tile[0]][tile[1]+1][tile[2]].visible;
  if (chunk.tiles[tile[0]][tile[1]+1][tile[2]].visible) return 0;

  return 1;
}

fn uint int[3].hash(self) {
  return (uint)(10000 + (self[0] * 2) + (self[1] * 4) + (self[2] * 3));
}


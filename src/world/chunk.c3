
module gnosis::world::chunk;
import std::io;
import gnosis::world::tile;
import gnosis::resources;
import raylib;


struct Chunk {
  Tile[16][16][16] tiles;
}

<* Initialize chunk with basic data *>
fn void Chunk.init(&self) {
  for (int x = 0; x < 16; x++) {
    for (int z = 0; z < 16; z++) {
      for (int y = 0; y < 8; y++) {
        //self.tiles[x][y][z] = {.chunk = self, .type = DUST};
        if (x == 15) { self.tiles[x][y][z] = tile::new(self, GRASS); }
        else { self.tiles[x][y][z] = tile::new(self, DUST); }
      }
    }
  }
  //self.update();
}
<**>
fn void Chunk.draw(&self) {
  
}

<**>
fn bool Chunk.tile_visible(&self, Vector3 position) {
  usz x = (usz)position.x;
  usz y = (usz)position.y;
  usz z = (usz)position.z;
  if (!self.tiles[x][y][z].visible) return false;

  bool above = !self.tiles[x][y+1][z].visible;

  return above;
}

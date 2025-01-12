
module gnosis::chunks;
import std::io;
import raylib;
import gnosis::system::camera;


int tiles_rendered;
struct Chunk {
  Tile[16][16][16] tiles;
}


<* Initialize chunk with basic data *>
fn void Chunk.init(&self) {
  for (int x = 0; x < 16; x++) {
    for (int z = 0; z < 16; z++) {
      for (int y = 0; y < 8; y++) {
        self.tiles[x][y][z] = {.chunk = self, .type = DUST};
      }
    }
  }
  self.update();
}

<* Update chunk *>
fn void Chunk.update(&self) {}

<* Draw chunk *>
fn void Chunk.draw(&self, Model model) {
  tiles_rendered = 0;
  for (int x = 0; x < 16; x++) {
    for (int z = 0; z < 16; z++) {
      for (int y = 0; y < 16; y++) {
        Tile* t = &(self.tiles[x][y][z]);
        if (t.type != EMPTY && (y == 15 || self.tiles[x][y+1][z].type == EMPTY)) {
          Vector3 pos = {
            (float)x - (float)z,
            (float)y,
            (float)x + (float)z,
          };
          model.draw_ex(pos, {0,1,0}, 45, {1.45,1.45,1.45}, raylib::WHITE);
          tiles_rendered++;
        }
      }
    }
  }
}

fn bool test_x() { return false; }

<* Get camera rotation *>
fn bool get_rotation_x(float x) {
  switch (camera::main.rotation) {
    case   0: return x == 15;
    case  90: return x == 15;
    case 180: return x ==  0;
    case 270: return x ==  0;
    default: return false;
  }
}

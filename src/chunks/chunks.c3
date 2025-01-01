
module gnosis::chunks;
import std::io;
import raylib5::rl;
import gnosis::system::camera;


int tiles_rendered;
struct Chunk {
  Tile[16][16][16] tiles;
}


/** Initialize chunk with basic data
 **/
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

/**
 **/
fn void Chunk.update(&self) {}

/** Draw chunk 
 **/
fn void Chunk.draw(&self, Model model) {
  tiles_rendered = 0;
  for (int x = 0; x < 16; x++) {
    for (int z = 0; z < 16; z++) {
      for (int y = 0; y < 16; y++) {
        Tile* t = &(self.tiles[x][y][z]);
        if (t.type != EMPTY && (y == 15 || self.tiles[x][y+1][z].type == EMPTY)) {
          float pos_x = (float)x - (float)z;
          float pos_y = (float)y;
          float pos_z = (float)x + (float)z;
          rl::drawModelEx(model, {pos_x,pos_y,pos_z}, {0,1,0}, 45, {1.45,1.45,1.45}, rl::WHITE);
          tiles_rendered++;
        }
      }
    }
  }
}

fn bool test_x() { return false; }

fn bool get_rotation_x(float x) {
  switch (camera::main.rotation) {
    case   0: return x == 15;
    case  90: return x == 15;
    case 180: return x ==  0;
    case 270: return x ==  0;
    default: return false;
  }
}

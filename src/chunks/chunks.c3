
module gnosis::chunks;
import std::io;
import raylib5::rl;


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

/** 
 **/
fn void Chunk.draw(&self, Model model) {
  tiles_rendered = 0;
  for (int x = 0; x < 16; x++) {
    for (int z = 0; z < 16; z++) {
      for (int y = 0; y < 16; y++) {
        Tile* t = &(self.tiles[x][y][z]);
        if (t.type != EMPTY && ((y == 15 || self.tiles[x][y+1][x].type == EMPTY) || (x == 15 || self.tiles[x+1][y][z].type == EMPTY) || (z == 15 || self.tiles[x][y][z+1].type == EMPTY))) {
          float pos_x = (float)x - (float)z;
          float pos_y = (float)y / 2;
          float pos_z = (float)x + (float)z;
          rl::drawModelEx(model, {pos_x,pos_y,pos_z}, {0,1,0}, 45, {1.45,1,1.45}, rl::WHITE);
          tiles_rendered++;
        }
      }
    }
  }
}


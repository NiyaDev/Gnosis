
module gnosis::world::chunk;
import std::io;
import gnosis::world::tile;
import ennoia;


struct Chunk {
  int[3] position;
  Tile[16][16][16] tiles;
}

<* Initialize chunk with basic data *>
fn void Chunk.init(&self, int[3] position) {
  self.position = position;
  for (int x = 0; x < 16; x++) {
    for (int z = 0; z < 16; z++) {
      for (int y = 0; y < 9; y++) {
        if (y == 8) {
          if (x == 15) {
            self.tiles[x][y][z] = tile::new(self, GRASS);
          }
          continue;
        }
        if (x == 15) { self.tiles[x][y][z] = tile::new(self, GRASS); }
        else { self.tiles[x][y][z] = tile::new(self, DUST); }
      }
    }
  }
  self.tiles[4][8][10] = tile::new(self, OAK_SAPLING);
  self.tiles[3][7][2] = tile::new(self, AIR);
  //self.update();
}
<* Save chunk to file *>
fn void Chunk.save(&self, String savename) {
  String path = string::format(allocator::heap(), "saves/%s/data/%d_%d_%d.dat", savename, self.position[0], self.position[1], self.position[2]);
  File file = file::open(path, "wb")!!;
  defer file.close()!!;

  for (int x; x < 16; x++) {
    for (int y; y < 16; y++) {
      for (int z; z < 16; z++) {
        Tile* tile = &self.tiles[x][y][z];
        file.write_int(tile.type.ordinal);
        file.write_int(tile.growthtick);
      }
    }
  }
}
<* Load chunk from file *>
fn Chunk load(String savename, int[3] position) {
  String path = string::format(allocator::heap(), "saves/%s/data/%d_%d_%d.dat", savename, position[0], position[1], position[2]);
  File file = file::open(path, "rb")!!;
  defer file.close()!!;

  Chunk output;

  for (int x; x < 16; x++) {
    for (int y; y < 16; y++) {
      for (int z; z < 16; z++) {
        TileType type = TileType.from_ordinal(file.read_int());
        Tile tile = tile::new(&output, type);
        tile.growthtick = file.read_int();
        output.tiles[x][y][z] = tile;
      }
    }
  }

  return output;
}



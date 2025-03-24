
module gnosis::world::chunk;
import std::io;
import gnosis::world::tile;
import gnosis::resources;
import pleroma;
//import raylib;


struct Chunk {
  int[3] position;
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
<* Save chunk to file *>
fn void Chunk.save(&self, String savename) {
  char[] chunkdata = mem::new_array(char, (16*16*16) * (TileType.sizeof + int.sizeof));
  defer free(chunkdata);
  usz head;

  for (int x; x < 16; x++) {
    for (int y; y < 16; y++) {
      for (int z; z < 16; z++) {
        Tile* tile = &self.tiles[x][y][z];
        //* Type
        chunkdata[head++] = (char)(tile.type.ordinal >>  0);
        chunkdata[head++] = (char)(tile.type.ordinal >>  8);
        chunkdata[head++] = (char)(tile.type.ordinal >> 16);
        chunkdata[head++] = (char)(tile.type.ordinal >> 24);

        //* Growth tick
        chunkdata[head++] = (char)(tile.growthtick >>  0);
        chunkdata[head++] = (char)(tile.growthtick >>  8);
        chunkdata[head++] = (char)(tile.growthtick >> 16);
        chunkdata[head++] = (char)(tile.growthtick >> 24);
      }
    }
  }

  //* Open file
  String path = string::format(allocator::heap(), "saves/%s/data/%d_%d_%d.dat", savename, self.position[0], self.position[1], self.position[2]);
  File? file = file::open(path, "wb");
  assert(@ok(file), "Failed to open file to write to.");
  file.write(chunkdata)!!;
  file.close()!!;
}
<* Load chunk from file *>
fn Chunk load(String savename, int[3] position) {
  char[]? chunkdata;
  usz head;
  String path = string::format(allocator::heap(), "saves/%s/data/%d_%d_%d.dat", savename, position[0], position[1], position[2]); 
  chunkdata = file::load_temp(path);
  assert(@ok(chunkdata), "Failed to open file to read.");

  Chunk new_chunk;

  for (int x; x < 16; x++) {
    for (int y; y < 16; y++) {
      for (int z; z < 16; z++) {
        TileType type = TileType.from_ordinal(chunkdata[head++]!! + (chunkdata[head++]!! << 8) + (chunkdata[head++]!! << 16) + (chunkdata[head++]!! << 24));
        Tile tile = tile::new(&new_chunk,type);
        
        tile.growthtick = chunkdata[head++]!! + (chunkdata[head++]!! << 8) + (chunkdata[head++]!! << 16) + (chunkdata[head++]!! << 24);
        new_chunk.tiles[x][y][z] = tile;
      }
    }
  }

  return new_chunk;
}


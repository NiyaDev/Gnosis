
module gnosis::world;
import ennoia;
import ennoia::vector;
import std::io;



struct Chunk {
  Tile[16][16][16] tiles;
}

<* Save chunk to file *>
fn void Chunk.save(&self, String savename, int[3] position) {
  String path = string::tformat("saves/%s/data/%d_%d_%d.dat", savename, position[0], position[1], position[2]);
  
  File? file = file::open(path, "wb");
  if (catch file) {
    debug::warning("Failed to open chunk file.");
    return;
  }

  for (int x; x < 16; x++) {
    for (int y; y < 16; y++) {
      for (int z; z < 16; z++) {
        Tile* tile = &self.tiles[x][y][z];
        file.write_int(tile.type.ordinal);
        file.write_int(tile.growthTick);
      }
    }
  }

  if (catch file.close()) {
    debug::warning("Failed to close chunk file.");
    return;
  }
}



module gnosis::world::chunk;
import gnosis::world;
import ennoia::debug;
import std::io;


faultdef FAILED_LOAD;

<* Loads chunk from file *>
fn Chunk*? load(String savename, int[3] position) {
  String path = string::tformat("saves/%s/data/%d_%d_%d.dat", savename, position[0], position[1], position[2]);

  // Open file
  File? file = file::open(path, "rb");
  if (catch file) {
    debug::warning("Failed to open chunk file.");
    return FAILED_LOAD?;
  }

  // Read file
  Chunk* output = mem::new(Chunk);
  for (int x; x < 16; x++) {
    for (int y; y < 16; y++) {
      for (int z; z < 16; z++) {
        Tile tile = {
          TileType.from_ordinal(file.read_int()),
          output,
          file.read_int(),
        };
        output.tiles[x][y][z] = tile;
      }
    }
  }

  // Close file
  if (catch file.close()) {
    debug::warning("Failed to close chunk file.");
    return FAILED_LOAD?;
  }

  return output;
}


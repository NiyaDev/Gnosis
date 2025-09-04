
module gnosis::world;
import std::io;
import std::collections;
import ennoia;
import gnosis::unit;


struct World {
  String name;
  Clock clock;

  Player player;

  HashMap{int[3], Chunk*} chunks;
  //HashMap{int, Unit} units;
}

struct Clock {
  float framesPerTick;
  float ticks;
}


<* Initialize new blank world *>
fn World new(String name) {
  World output;
  output.name = name;
  output.clock = {6, 0};

  output.player.unit = unit::new();

  output.new_chunk({0,0,0});

  return output;
}

<* Generate a new chunk
  @param position: "Position to generate at"
  @return "Whether new chunk was actually generated"
 *>
fn bool World.new_chunk(&self, Vector3 position) {
  int[3] newPos = position.to_int_array();

  // Check for false conditions
  if (self.chunks.has_key(newPos)) {
    io::printfn("[WARNING] - GNOSIS::WORLD::NEW_CHUNK [Attempted to generate a new chunk over old one.]");
    return false;
  }
  // NOTE: Maybe load it instead of just throwing an error?
  String path = string::tformat("saves/%s/data/%d_%d_%d.dat", self.name, newPos[0], newPos[1], newPos[2]);
  if (file::exists(path)) {
    io::printfn("[WARNING] - GNOSIS::WORLD::NEW_CHUNK [Attempted to generate new chunk when one already exists on file]");
    return false;
  }

  Chunk* chunk = mem::new(Chunk);
  for (int y; y < 8; y++) {
    for (int x; x < 16; x++) {
      for (int z; z < 16; z++) {
        chunk.tiles[x][y][z] = tile::new(chunk, DIRT);
      }
    }
  }
  self.chunks.set(newPos, chunk);

  return true;
}

faultdef NO_TILE;
<* Gets tile in world *>
fn Tile? World.get_tile(&self, Vector3 position) {
  Vector3 chunkPosition = {
    (float)((int)((position.x < 0) ? position.x - 16 : position.x) / 16),
    (float)((int)((position.y < 0) ? position.y - 16 : position.y) / 16),
    (float)((int)((position.z < 0) ? position.z - 16 : position.z) / 16),
  };
  Vector3 tilePosition = {
    (float)(((position.x < 0) ? (16 + (int)position.x) % 16 : (int)position.x % 16)),
    (float)(((position.y < 0) ? (16 + (int)position.y) % 16 : (int)position.y % 16)),
    (float)(((position.z < 0) ? (16 + (int)position.z) % 16 : (int)position.z % 16)),
  };

  Chunk*? chunk = self.chunks[chunkPosition.to_int_array()];
  if (try chunk) {
    return chunk.tiles[(int)tilePosition.x][(int)tilePosition.y][(int)tilePosition.z];
  }

  return NO_TILE?;
}

<* Save world to file *>
fn void World.save(&self) {}
<* Load world from file *>
fn World load() { return {}; }

<* Update World *>
fn void World.update(&self) {
  // Ticks
  if (self.clock.ticks >= self.clock.framesPerTick) {
    // Player tick
    self.player.tick();
    // Units tick
    self.clock.ticks = 0;
  } else {self.clock.ticks++; }

  // Update
}
<* Draw world *>
fn int World.draw(&self) {
  int tilesRendered;

  self.chunks.@each(; int[3] chunkPosition, Chunk* chunk) {
    for (int x; x < 16; x++) {
      for (int z; z < 16; z++) {
        for (int y; y < 16; y++) {
          Tile* t = &(chunk.tiles[x][y][z]);
          Vector3 position = (Vector3){(float)x,(float)y,(float)z} + (chunkPosition.from_int_array() * 16);
          float visibility = self.tile_visible(position);
          if (visibility > 0) {
            ennoia::models[t.type.model]!!.draw(position:position,texture:ennoia::textures.get_ref(t.type.texture)!!);
            tilesRendered++;
          }
        }
      }
    }
  };
  
  //io::printfn("%d", tilesRendered);

  return tilesRendered;
}

<**>
fn float World.tile_visible(&self, Vector3 position) {
  int[3] chunkPosition = (position / 16).to_int_array();
  Vector3 tilePosition = position % 16;

  Chunk* chunk = self.chunks[chunkPosition]!!;

  // Check if tile isn't even visible
  if (!chunk.tiles[(usz)tilePosition.x][(usz)tilePosition.y][(usz)tilePosition.z].type.visible) return 0;

  // Check if outside of player vision
  // TODO: come back to this once the player and units are made
  if (self.player.position.distance(position) > 5 + (self.player.skills.get(PERCEPTION)!!.level * 0.2)) return 0;
  
  // Check if surrounded
  float visibleMod = 1;

  bool? top   = !self.get_tile(position + { 0, 1, 0}).type.visible;
  if (catch top) top = true;
  bool? bot   = !self.get_tile(position + { 0,-1, 0}).type.visible;
  if (catch bot) bot = true;
  bool? north = !self.get_tile(position + { 0, 0,-1}).type.visible;
  if (catch north) north = true;
  bool? south = !self.get_tile(position + { 0, 0, 1}).type.visible;
  if (catch south) south = true;
  bool? east  = !self.get_tile(position + { 1, 0, 0}).type.visible;
  if (catch east) east = true;
  bool? west  = !self.get_tile(position + {-1, 0, 0}).type.visible;
  if (catch west) west = true;

  if (!top!! && !bot!! && !north!! && !south!! && !east!! && !west!!) return 0;

  // Multiplier for vision
  // TODO: come back to this once the player and units are made
  float visionMultiplier = 1;
  //if (self.player.position.distance(position) > 3 + (self.player.skills[Skills.PERCEPTION].value * 0.2)) vision_multi = 0.8;
  //if (self.player.position.distance(position) > 4 + (self.player.skills[Skills.PERCEPTION].value * 0.2)) vision_multi = 0.4;
  
  return visibleMod * visionMultiplier;
}



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

  output.player = unit::new_player();

  output.new_chunk({0,0,0});
  output.new_chunk({1,0,0});
  output.new_chunk({2,0,0});
  output.new_chunk({0,0,1});
  output.new_chunk({1,0,1});
  output.new_chunk({2,0,1});

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
  chunk.tiles[4][8][0] = tile::new(chunk, DIRT);
  chunk.tiles[4][8][1] = tile::new(chunk, DIRT);
  chunk.tiles[4][8][3] = tile::new(chunk, DIRT);
  chunk.tiles[4][8][4] = tile::new(chunk, DIRT);
  chunk.tiles[3][8][4] = tile::new(chunk, DIRT);
  chunk.tiles[2][8][4] = tile::new(chunk, DIRT);
  chunk.tiles[1][8][4] = tile::new(chunk, DIRT);
  chunk.tiles[0][8][4] = tile::new(chunk, DIRT);

  chunk.tiles[6][7][10] = tile::new(chunk, EMPTY);
  chunk.tiles[7][7][10] = tile::new(chunk, EMPTY);
  chunk.tiles[8][7][10] = tile::new(chunk, EMPTY);
  chunk.tiles[6][7][11] = tile::new(chunk, EMPTY);
  chunk.tiles[7][7][11] = tile::new(chunk, EMPTY);
  chunk.tiles[8][7][11] = tile::new(chunk, EMPTY);
  chunk.tiles[6][7][12] = tile::new(chunk, EMPTY);
  chunk.tiles[7][7][12] = tile::new(chunk, EMPTY);
  chunk.tiles[8][7][12] = tile::new(chunk, EMPTY);
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
  self.player.update();
}
<* Draw world *>
fn int World.draw(&self) {
  int tilesRendered;

  Vector3 pos = self.player.position.get_whole_tile();

  // Draw below player
  Tile? t = self.get_tile(pos-{0,1,0});
  if (try t) {
    if (t.type.visible) {
      render::draw_mesh(
        nameMesh:    t.type.model,
        nameTexture: t.type.texture,
        position:    pos-{0,1,0},
      );
    }
  }

  // Send rays in most directions
  int rays = 80;
  for (int i; i < rays; i++) {
    Vector3 dir = (Vector3){0,0,0}.rotate({0,0,1}, (360 / (float)rays) * (float)i);
    self.check_direction(pos, dir, 10 + (float)(self.player.skills.get(PERCEPTION)!!.level * 0.2));
  }
  for (float y; y > -1; y -= 0.1) {
    for (int i; i < rays; i++) {
      Vector3 dir = (Vector3){0,0,0}.rotate({0,y,1+y}, (360 / (float)rays) * (float)i);
      self.check_direction(pos, dir, 10 + (float)(self.player.skills.get(PERCEPTION)!!.level * 0.2));
    }
  }

  return tilesRendered;
}

<**>
fn void World.check_direction(&self, Vector3 start, Vector3 direction, float length) {
  Vector3 currentPos = start;
  for (int i; i < length; i++) {
    currentPos += direction;
    Vector3 temp = currentPos.get_whole_tile();

    Tile? far = self.get_tile(temp);
    if (try far) {
      if (far.type.visible) {
        render::draw_mesh(
          nameMesh:    far.type.model,
          nameTexture: far.type.texture,
          position:    temp,
        );
        return;
      }
    }

    Tile? below = self.get_tile(temp-{0,1,0});
    if (try below) {
      if (below.type.visible) {
        render::draw_mesh(
          nameMesh:    below.type.model,
          nameTexture: below.type.texture,
          position:    temp-{0,1,0},
        );
      }
    }
  }
}

<**>
fn Vector3 Vector3.get_whole_tile(&self) {
  return {
    (int)((self.x + 0.5).floor()),
    (int)((self.y + 0.5).floor()),
    (int)((self.z + 0.5).floor()),
  };
}


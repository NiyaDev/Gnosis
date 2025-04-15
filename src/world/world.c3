
module gnosis::world;
import std::collections;
import std::io;
import gnosis::unit;
import gnosis::resources;
import pleroma;


struct World {
  String name;

  Player* player;

  //* Clock
  float framespertick;
  float ticks;

  //* Map
  HashMap{int[3],Chunk} chunks;
}

<* Saves world data to file *>
fn void World.save(&self) {
  // World data
  Logos file = logos::new(comp:DEFLATE);
  // Player
  file.write({.type=FLOAT_ARRAY,.as_float_array=self.player.position.to_array()});
  file.write({.type=FLOAT,.as_float=self.player.hp_cur});
  file.write({.type=FLOAT,.as_float=self.player.st_cur});
  file.write({.type=FLOAT,.as_float=self.player.mn_cur});
  file.write({.type=FLOAT,.as_float=self.player.hn_cur});
  file.write({.type=INT,.as_int=self.player.species.ordinal});
  file.write({.type=INT,.as_int=self.player.skills.len});
  for (int i; i < self.player.skills.len; i++) {
    file.write({.type=INT,.as_int=self.player.skills[i].value});
    file.write({.type=INT,.as_int=(int)self.player.skills[i].exp});
    file.write({.type=INT,.as_int=(int)self.player.skills[i].discovery});
  }
  String path = string::format(allocator::heap(), "saves/%s/worlddata.dat", self.name);
  file.save(path);

  // Chunks
  self.chunks.@each(; int[3] pos, Chunk chunk) {
    //chunk.save(self.name);
    self.chunks.get_ref(pos)!!.save(self.name);
  };
}
//<* Loads world data from file *>
//fn World load(String name) {}

<* Create a new chunk in the world *>
fn void World.new_chunk(&self, int[3] position) {
  Chunk chunk;
  chunk.init(position);
  self.chunks.set(position,chunk);
}
<* Generate world *>
fn World* generate(float framespertick = 3) {
  World* output = mem::new(World);
  output.name = "test";

  output.framespertick = framespertick;
	output.new_chunk({0,0,0});
	//output.chunks.set({0,0,0}, chunk::load("test",{0,0,0}));
	output.new_chunk({1,0,0});
	output.new_chunk({2,0,0});
	output.new_chunk({0,0,1});
	output.new_chunk({1,0,1});
	output.new_chunk({2,0,1});
	output.new_chunk({0,0,2});
	output.new_chunk({1,0,2});
	output.new_chunk({2,0,2});
	//output.chunks[{0,0,0}]!!.save("test");

	return output;
}

<* Update world *>
fn void World.update(&self) {
  //* Tick
  if (self.ticks >= self.framespertick / 60) {
    self.player.tick();
    self.ticks -= (self.framespertick / 60);
  } else {
    self.ticks += raylib::get_frame_time();
  }
}
<* Draw world to screen *>
fn int World.draw(&self) {
  int tiles_rendered = 0;
  self.chunks.@each(; int[3] position_raw, Chunk chunk) {
    for (int x = 0; x < 16; x++) {
      for (int z = 0; z < 16; z++) {
        for (int y = 0; y < 16; y++) {
          Tile* t = &(chunk.tiles[x][y][z]);
          float visibility = self.tile_visible(position_raw, {x, y, z});
          if (visibility != 0) {
            Vector3 pos = {
              (float)(x + (position_raw[0] * 16)) - (float)(z + (position_raw[2] * 16)),
              (float)(y + (position_raw[1] * 16)),
              (float)(x + (position_raw[0] * 16)) + (float)(z + (position_raw[2] * 16)),
            };
            Mesh mesh = resources::meshes[t.model]!!;
            Material mat = resources::materials[t.material]!!;
            mat.set_texture(resources::textures[t.texture]!!);
            Matrix matr = matrix::translate(pos);
            mat.maps[0].color = color::WHITE.multiply(visibility);
            mesh.draw(mat,matr.add(matrix::rotate_y(1.6)));
            tiles_rendered++;
          }
        }
      }
    }
  };
  return tiles_rendered;
}

<**>
fn float World.tile_visible(&self, int[3] chunk_position, int[3] tile) {
  Chunk* chunk = self.chunks.get_ref(chunk_position)!!;

  //* False if tile isn't visible
  if (!chunk.tiles[tile[0]][tile[1]][tile[2]].visible) return 0;

  //* False if outside of player vision
  Vector3 position = {
    (float)((chunk_position[0] * 16) + tile[0]),
    (float)((chunk_position[1] * 16) + tile[1]),
    (float)((chunk_position[2] * 16) + tile[2]), 
  };
  if (self.player.position.distance(position) > 5 + (self.player.skills[Skills.PERCEPTION.ordinal].value * 0.2)) return 0;

  //* If it's surrounded by visible
  float visible_mod = 1;
  //* Top
  bool top;
  if (tile[1] == 15) {
    int[3] newchunk = chunk_position;
    newchunk[1]++;
    Chunk*? chunkptr = self.chunks.get_ref(newchunk);
    if (try chunkptr) {
      top = (chunkptr.tiles[tile[0]][0][tile[2]].visible);
    } else { visible_mod = 1; }
  } else {
    top = (chunk.tiles[tile[0]][tile[1]+1][tile[2]].visible);
  }
  //* Bottom
  bool bottom;
  if (tile[1] == 0) {
    int[3] newchunk = chunk_position;
    newchunk[1]--;
    Chunk*? chunkptr = self.chunks.get_ref(newchunk);
    if (try chunkptr) {
      bottom = (chunkptr.tiles[tile[0]][15][tile[2]].visible);
    } else { visible_mod = 1; }
  } else {
    bottom = (chunk.tiles[tile[0]][tile[1]-1][tile[2]].visible);
  }
  //* North
  bool north;
  if (tile[2] == 0) {
    int[3] newchunk = chunk_position;
    newchunk[2]--;
    Chunk*? chunkptr = self.chunks.get_ref(newchunk);
    if (try chunkptr) {
      north = (chunkptr.tiles[tile[0]][tile[1]][15].visible);
    } else { visible_mod = 1; }
  } else {
    north = (chunk.tiles[tile[0]][tile[1]][tile[2]-1].visible);
  }
  //* South
  bool south;
  if (tile[2] == 15) {
    int[3] newchunk = chunk_position;
    newchunk[2]++;
    Chunk*? chunkptr = self.chunks.get_ref(newchunk);
    if (try chunkptr) {
      south = (chunkptr.tiles[tile[0]][tile[1]][0].visible);
    } else { visible_mod = 1; }
  } else {
    south = (chunk.tiles[tile[0]][tile[1]][tile[2]+1].visible);
  }
  //* East
  bool east;
  if (tile[0] == 15) {
    int[3] newchunk = chunk_position;
    newchunk[0]++;
    Chunk*? chunkptr = self.chunks.get_ref(newchunk);
    if (try chunkptr) {
      east = (chunkptr.tiles[0][tile[1]][tile[2]].visible);
    } else { visible_mod = 1; }
  } else {
    east = (chunk.tiles[tile[0]+1][tile[1]][tile[2]].visible);
  }
  //* West
  bool west;
  if (tile[0] == 0) {
    int[3] newchunk = chunk_position;
    newchunk[0]--;
    Chunk*? chunkptr = self.chunks.get_ref(newchunk);
    if (try chunkptr) {
      west = (chunkptr.tiles[15][tile[1]][tile[2]].visible);
    } else { visible_mod = 1; }
  } else {
    west = (chunk.tiles[tile[0]-1][tile[1]][tile[2]].visible);
  }

  if (top && bottom && north && south && east && west) return 0;

  //* Multiplier for vision
  float vision_multi = 1;
  if (self.player.position.distance(position) > 3 + (self.player.skills[Skills.PERCEPTION.ordinal].value * 0.2)) vision_multi = 0.8;
  if (self.player.position.distance(position) > 4 + (self.player.skills[Skills.PERCEPTION.ordinal].value * 0.2)) vision_multi = 0.4;
  //bool above = !chunk.tiles[tile[0]][tile[1]+1][tile[2]].visible;
  //if (chunk.tiles[tile[0]][tile[1]+1][tile[2]].visible) return 0;

  return visible_mod * vision_multi;
}

fn uint int[3].hash(self) {
  return (uint)(10000 + (self[0] * 2) + (self[1] * 4) + (self[2] * 3));
}


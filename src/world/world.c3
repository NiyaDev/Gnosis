
module gnosis::world;
import std::collections;
import std::io;
import std::math;
import gnosis::unit;
import gnosis::resources;
import gnosis::system;
import pleroma;


struct World {
  String name;

  Player* player;

  //* Clock
  float framespertick;
  float ticks;

  //* Map
  HashMap{int[3],Chunk} chunks;
  List{Unit*} units;
}

enum Direction : char {
  TOP, BOTTOM,
  NORTH, SOUTH,
  EAST, WEST,
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
    file.write({.type=INT,.as_int=self.player.skills[Skills.from_ordinal(i)].value});
    file.write({.type=INT,.as_int=(int)self.player.skills[Skills.from_ordinal(i)].exp});
    file.write({.type=INT,.as_int=(int)self.player.skills[Skills.from_ordinal(i)].discovery});
  }
  String path = string::format(allocator::heap(), "saves/%s/worlddata.dat", self.name);
  file.save(path);

  // Chunks
  self.chunks.@each(; int[3] pos, Chunk chunk) {
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
fn World* generate(float framespertick = 6) {
  World* output = mem::new(World);
  output.name = "test";

  output.framespertick = framespertick;
	output.new_chunk({0,0,0});
	output.new_chunk({1,0,0});
	output.new_chunk({2,0,0});
	output.new_chunk({0,0,1});
	output.new_chunk({1,0,1});
	output.new_chunk({2,0,1});
	output.new_chunk({0,0,2});
	output.new_chunk({1,0,2});
	output.new_chunk({2,0,2});

	Unit* test = mem::new(Unit);
	test.init(RAT);
	test.position = {5,10,6};
	test.personality = HOSTILE;
	output.units.push(test);

	return output;
}

<* Update world *>
fn void World.update(&self) {
  // Tick
  if (self.ticks >= self.framespertick) {
    // Tick everything
    self.player.tick();
    for(int i; i < self.units.len(); i++) self.units[i].tick();

    self.ticks = 0;
  } else { self.ticks++; }

  // Update everything
  for (int i; i < self.units.len(); i++) { self.units[i].update(); }
  self.player.p_update();
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
              (float)(x + (position_raw[0] * 16)),
              (float)(y + (position_raw[1] * 16)),
              (float)(z + (position_raw[2] * 16)),
            };
            Mesh mesh = resources::meshes[t.model]!!;
            Material mat = resources::materials[t.material]!!;
            mat.set_texture(resources::textures[t.texture]!!);
            Matrix matr = matrix::translate(pos);
            mat.maps[0].color = color::WHITE.multiply(visibility);
            mesh.draw(mat,matr);
            tiles_rendered++;
          }
        }
      }
    }
  };
  
  // NPC Units
  // TODO: Maybe draw player with units?
  for (int i; i < self.units.len(); i++) {
    camera::main.draw_billboard_pro(
      *gamestate.world.player.sprite,
      {0,0,16,32},
      self.units[i].position + {0,0.2,0},
      vector3::ZERO.rotate({0,1,-1}, camera::main.rotation),
      {1,1},
      {0.5,0.25},
      0,
      color::WHITE,
    );
  }

  // Player
  Vector3 pos = camera::main.target;
  pos.y += 0.2;
  gamestate.world.player.unit_bounds().draw(color::PURPLE);
  gamestate.world.player.ground_bounds().draw(color::BROWN); 
  camera::main.draw_billboard_pro(*gamestate.world.player.sprite, {0,0,16,32}, pos, vector3::ZERO.rotate({0,1,-1}, camera::main.rotation), {1,1}, {0.5,0.25}, 0, color::WHITE);

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
  if (self.player.position.distance(position) > 5 + (self.player.skills[Skills.PERCEPTION].value * 0.2)) return 0;

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
    Tile t = chunk.tiles[tile[0]][tile[1]+1][tile[2]];
    top = (t.visible && t.solid);
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
    Tile t = chunk.tiles[tile[0]][tile[1]-1][tile[2]];
    bottom = (t.visible && t.solid);
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
    Tile t = chunk.tiles[tile[0]][tile[1]][tile[2]-1];
    north = (t.visible && t.solid);
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
    Tile t = chunk.tiles[tile[0]][tile[1]][tile[2]+1];
    south = (t.visible && t.solid);
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
    Tile t = chunk.tiles[tile[0]+1][tile[1]][tile[2]];
    east = (t.visible && t.solid);
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
    Tile t = chunk.tiles[tile[0]-1][tile[1]][tile[2]];
    west = (t.visible && t.solid);
  }

  if (top && bottom && north && south && east && west) return 0;

  //* Multiplier for vision
  float vision_multi = 1;
  if (self.player.position.distance(position) > 3 + (self.player.skills[Skills.PERCEPTION].value * 0.2)) vision_multi = 0.8;
  if (self.player.position.distance(position) > 4 + (self.player.skills[Skills.PERCEPTION].value * 0.2)) vision_multi = 0.4;
  //bool above = !chunk.tiles[tile[0]][tile[1]+1][tile[2]].visible;
  //if (chunk.tiles[tile[0]][tile[1]+1][tile[2]].visible) return 0;

  return visible_mod * vision_multi;
}

<**>
fn Tile* World.tile(&self, int[3] position) {
  int[3] chunk_pos = {
    (int)((float)position[0] / 16).floor(),
    (int)((float)position[1] / 16).floor(),
    (int)((float)position[2] / 16).floor(),
  };
  int[3] tile_pos = {
    $$abs(position[0]) % 16,
    $$abs(position[1]) % 16,
    $$abs(position[2]) % 16,
  };
  Chunk*? chunk = self.chunks.get_ref(chunk_pos);
  if (catch chunk) return null;
  return chunk.tile(tile_pos);
}

<**>
fn float World.ticks_per_second(&self) {
  char framerate = options["fps"].as_char!!;
  return ((float)framerate / self.framespertick);
}

fn uint int[3].hash(self) {
  return (uint)(10000 + (self[0] * 2) + (self[1] * 4) + (self[2] * 3));
}


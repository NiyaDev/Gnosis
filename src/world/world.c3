
module gnosis::world;
import std::collections;
import std::io;
import gnosis::unit;
import gnosis::resources;
import pleroma;
//import raylib;


struct World {
  Player* player;

  //* Clock
  float framespertick;
  float ticks;

  //* Map
  HashMap(<int[3],Chunk>) chunks;
}

int tiles_rendered;
World data;

<* Create a new chunk in the world *>
fn void new_chunk(int[3] position) {
  Chunk chunk;
  chunk.init();
  data.chunks.set(position,chunk);
}
<* Generate world *>
fn void generate(float framespertick = 3) {
  data.framespertick = framespertick;

	//world::new_chunk({0,0,0});
	data.chunks.set({0,0,0}, chunk::load("test",{0,0,0}));
	world::new_chunk({1,0,0});
	world::new_chunk({2,0,0});
	world::new_chunk({0,0,1});
	world::new_chunk({1,0,1});
	world::new_chunk({2,0,1});
	world::new_chunk({0,0,2});
	world::new_chunk({1,0,2});
	world::new_chunk({2,0,2});
	data.chunks[{0,0,0}]!!.save("test");
}

<* Update world *>
fn void update() {
  //* Tick
  if (data.ticks >= data.framespertick / 60) {
    data.player.tick();
    data.ticks -= (data.framespertick / 60);
  } else {
    data.ticks += raylib::get_frame_time();
  }
}
<* Draw world to screen *>
fn void draw() {
  tiles_rendered = 0;
  data.chunks.@each(; int[3] position_raw, Chunk chunk) {
    for (int x = 0; x < 16; x++) {
      for (int z = 0; z < 16; z++) {
        for (int y = 0; y < 16; y++) {
          Tile* t = &(chunk.tiles[x][y][z]);
          float visibility = tile_visible(position_raw, {x, y, z});
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
}

<**>
fn float tile_visible(int[3] chunk_position, int[3] tile) {
  Chunk* chunk = data.chunks.get_ref(chunk_position)!!;

  //* False if tile isn't visible
  if (!chunk.tiles[tile[0]][tile[1]][tile[2]].visible) return 0;

  //* False if outside of player vision
  Vector3 position = {
    (float)((chunk_position[0] * 16) + tile[0]),
    (float)((chunk_position[1] * 16) + tile[1]),
    (float)((chunk_position[2] * 16) + tile[2]), 
  };
  if (data.player.position.distance(position) > 5 + (data.player.skills["perception"]!!.value * 0.2)) return 0;

  //* If it's surrounded by visible
  float visible_mod = 1;
  //* Top
  bool top;
  if (tile[1] == 15) {
    int[3] newchunk = chunk_position;
    newchunk[1]++;
    Chunk*! chunkptr = data.chunks.get_ref(newchunk);
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
    Chunk*! chunkptr = data.chunks.get_ref(newchunk);
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
    Chunk*! chunkptr = data.chunks.get_ref(newchunk);
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
    Chunk*! chunkptr = data.chunks.get_ref(newchunk);
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
    Chunk*! chunkptr = data.chunks.get_ref(newchunk);
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
    Chunk*! chunkptr = data.chunks.get_ref(newchunk);
    if (try chunkptr) {
      west = (chunkptr.tiles[15][tile[1]][tile[2]].visible);
    } else { visible_mod = 1; }
  } else {
    west = (chunk.tiles[tile[0]-1][tile[1]][tile[2]].visible);
  }

  if (top && bottom && north && south && east && west) return 0;

  //* Multiplier for vision
  float vision_multi = 1;
  if (data.player.position.distance(position) > 3 + (data.player.skills["perception"]!!.value * 0.2)) vision_multi = 0.8;
  if (data.player.position.distance(position) > 4 + (data.player.skills["perception"]!!.value * 0.2)) vision_multi = 0.4;
  //bool above = !chunk.tiles[tile[0]][tile[1]+1][tile[2]].visible;
  //if (chunk.tiles[tile[0]][tile[1]+1][tile[2]].visible) return 0;

  return visible_mod * vision_multi;
}

fn uint int[3].hash(self) {
  return (uint)(10000 + (self[0] * 2) + (self[1] * 4) + (self[2] * 3));
}


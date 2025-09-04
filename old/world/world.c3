
module gnosis::world;
import std::collections;
import std::io;
import std::math;
import gnosis::unit;
import ennoia;




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
  //char framerate = options["fps"].as_char!!;
  char framerate = options::get_char("fps");
  return ((float)framerate / self.framespertick);
}



module gnosis::world;
import std::io;
import std::collections;
import ennoia;


struct World {
  String name;
  Clock clock;

  //Player player;

  HashMap{int[3], Chunk*} chunks;
  //HashMap{int, Unit} units;
}

struct Clock {
  float framesPerTick;
  float ticksPerSecond;
  float ticks;
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
  self.chunks.set(newPos, chunk);

  return true;
}

<* Save world to file *>
fn void World.save(&self) {}


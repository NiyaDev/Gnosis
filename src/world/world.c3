
module gnosis::world;
import std::collections;
import ennoia;


struct World {
  String worldName;
  Clock clock;

  //Player player;

  //HashMap{int[3], Chunk} chunks;
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
  


  return false;
}

<* Save world to file *>
fn void World.save(&self) {}


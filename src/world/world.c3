
module gnosis::world;
import std::collections;
import raylib;
import gnosis::unit::player;
import gnosis::chunks;



<*  *>
struct World {
  Player player;

  List(<Unit>) units;
  HashMap(<String,Chunk*>) chunks;
}

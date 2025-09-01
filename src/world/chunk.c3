
module ennoia::world;
import ennoia::vector;



struct Chunk {
  Tile[16][16][16] tiles;
}
//alias Chunk = Tile[16][16][16];


<* Gets reference to tile at position *>
fn Tile* Chunk.get(&self, Vector3 position) {
  int[3] newPos = position.to_int_array();

  //Tile[16][16]* ypos = &self[newPos[0]];
  //Tile[16]*     zpos = &ypos[newPos[1]];
  //Tile*         tile = &zpos[newPos[2]];

  //return &self[newPos[0]][newPos[1]][newPos[2]];
  return null;
}


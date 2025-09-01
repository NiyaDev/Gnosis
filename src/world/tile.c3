
module ennoia::world::tile;


struct Tile {
  TileType type;
  Chunk* chunk;

  //String model;
  //String material;

  int growthTick;
}

enum TileType : int (
      bool visible,
      bool gravity,
      bool solid,
      String texture,
      String model,
) {
  EMPTY = {false, false, false, "",""},

  DUST = {true,  true, true, "dust", "cube"},
  DIRT = {true, false, true, "dirt", "cube"},
  CLAY = {true, false, true, "clay", "cube"},
}

<**>
fn Tile new(Chunk* chunk, TileType type) {
  return {type, chunk, 0};
}





module ennoia::world::tile;


struct Tile {
  TileType type;
  Chunk* chunk;

  int growthTick;
}

enum TileType : int (
      bool visible,
      bool gravity,
      bool solid,
      String texture,
      String model,
      BoundingBox bounds,
) {
  EMPTY = {false, false, false, "", "", {{-0.5,-0.5,-0.5}, {0.5,0.5,0.5}}},

  DUST = {true,  true, true, "dust", "cube", {{-0.5,-0.5,-0.5}, {0.5,0.5,0.5}}},
  DIRT = {true, false, true, "dirt", "cube", {{-0.5,-0.5,-0.5}, {0.5,0.5,0.5}}},
  CLAY = {true, false, true, "clay", "cube", {{-0.5,-0.5,-0.5}, {0.5,0.5,0.5}}},
}

<**>
fn Tile new(Chunk* chunk, TileType type) {
  return {type, chunk, 0};
}





module ennoia::world;


struct Tile {
  TileType type;
  Chunk* chunk;

  //String model;
  //String material;

  int growthTick;
}

enum TileType {
  EMPTY,

  DUST,
  DIRT,
  CLAY,
}

// These functions exist to lower tile size
<* Returns if tile is visible *>
fn bool Tile.is_visible(&self) {
  switch (self.type) {
    case EMPTY: return false;
    
    case DUST: return true;
    case DIRT: return true;
    case CLAY: return true;
  }
}
<* Returns if tile has gravity *>
fn bool Tile.has_gravity(&self) {
  switch (self.type) {
    case EMPTY: return false;

    case DUST: return true;
    case DIRT: return false;
    case CLAY: return false;
  }
}
<* Returns if tile is solid *>
fn bool Tile.is_solid(&self) {
  switch (self.type) {
    case EMPTY: return false;
    
    case DUST: return true;
    case DIRT: return true;
    case CLAY: return true;
  }
}
<* Returns name of tile Texture *>
fn String Tile.texture(&self) {
  switch (self.type) {
    case EMPTY: return "";
    
    case DUST: return "dust";
    case DIRT: return "dirt";
    case CLAY: return "clay";
  }
}
<* Returns name of tile Model *>
fn String Tile.model(&self) {
  switch (self.type) {
    case EMPTY: return "";
    
    case DUST: return "cube";
    case DIRT: return "cube";
    case CLAY: return "cube";
  }
}


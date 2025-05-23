
module gnosis::world::tile;
import std::io;
import gnosis::world::chunk;
import pleroma;


struct Tile {
  TileType type;
  Chunk* chunk;

  //* Data tied to type
  bool visible;
  bool gravity;
  bool solid;

  String model;
  String material;
  String texture; 

  //* Data that can change
  int growthtick;
}

enum TileType {
  EMPTY,
  AIR,
  DUST,
  DIRT,
  GRASS,
  OAK_LOG,
  OAK_LEAVES,
  OAK_SAPLING,
}

<* Create new tile *>
fn Tile new(Chunk* chunk, TileType type) {
  Tile output;
  output.type = type;
  output.chunk = chunk;
  switch (type) {
    case DUST:
      output.visible = true;
      output.gravity = true;
      output.solid = true;
      output.model = "simple_tile";
      output.material = "default";
      output.texture = "default";
    case DIRT:
      output.visible = true;
      output.gravity = false;
      output.solid = true;
    case GRASS:
      output.visible = true;
      output.gravity = false;
      output.solid = true;
      output.model = "simple_tile";
      output.material = "default";
      output.texture = "grass_0"; 
    case OAK_LOG:
      output.visible = true;
      output.gravity = false;
      output.solid = true;
    case OAK_LEAVES:
      output.visible = true;
      output.gravity = false;
      output.solid = false;
    case OAK_SAPLING:
      output.visible = true;
      output.gravity = false;
      output.solid = false;
      output.model = "plane_tile";
      output.material = "default";
      output.texture = "grass_0";

    case AIR:
      output.visible = false;
      output.gravity = false;
      output.solid = false;

    default:
      output.visible = false;
      output.gravity = false;
      output.solid = false;
  }

  return output;
}
<* Get collision box of tile *>
fn BoundingBox Tile.bounds(&self, Vector3 position) {
  switch (self.type) {
    case DUST:
    case DIRT:
    case GRASS:
    case OAK_LOG:
    case OAK_LEAVES:
      return {{position.x - 0.5, position.y - 0.5, position.z - 0.5}, {position.x + 0.5, position.y + 0.5, position.z + 0.5}};
    default: return {};
  }
}
<* Checks if tile is solid or null *>
fn bool is_solid(Tile* self) {
  if (self == null) return true;

  return self.solid;
}

<* Prints tile data *>
fn void Tile.print(&self) {
  io::printfn("TYPE: %s SOLID: %s", self.type, self.solid);
}


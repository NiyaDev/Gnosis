
module gnosis::world::tile;
import gnosis::world::chunk;


struct Tile {
  TileType type;
  Chunk* chunk;

  bool visible;
  bool gravity;
  bool solid;
  int growth_tick;

  String model;
  String material;
  String texture;
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

<**>
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

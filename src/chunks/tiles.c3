
module gnosis::chunks::tiles;


struct Tile {
  Chunk* chunk;
  TileType type;
}

enum TileType {
  EMPTY,
  DUST,
}

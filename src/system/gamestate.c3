
module gnosis::system;
import gnosis::world;


Gamestate gamestate @builtin;
struct Gamestate {
  CurrentState state;

  World* world;
  int tiles_rendered;
}

enum CurrentState {
  TITLE,
  OVERWORLD,
  OVERWORLD_BATTLE,
}




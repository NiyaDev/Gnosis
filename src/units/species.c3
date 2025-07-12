
module gnosis::unit::species;
import std::io;
import std::collections;
import gnosis::unit;
import ennoia;


const float SIZE_MOD_TINY   = 0.25;
const float SIZE_MOD_SMALL  = 0.50;
const float SIZE_MOD_MEDIUM = 1.00;
const float SIZE_MOD_LARGE  = 1.50;
const float SIZE_MOD_HUGE   = 2.00;

enum Species {
  HUMAN,
  ELF,
  DWARF,
  ORC,
  GOBLIN,
  KOBOLD,

  SKELETON,
  SLIME,
  RAT,
}

<**>
fn float Species.get_size(self) {
  switch (self) {
    case HUMAN:
    case ELF:
    case DWARF:
    case ORC:
    case SKELETON:
      return SIZE_MOD_MEDIUM;
    case GOBLIN:
    case KOBOLD:
    case SLIME:
      return SIZE_MOD_SMALL;
    case RAT:
      return SIZE_MOD_TINY;
  }
}

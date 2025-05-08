
module gnosis::units::memories;
import std::collections;


alias Memories = HashMap{MemoryType,void*};

enum MemoryType : int {
  EMPTY,

  PLAYER_SEEN,
  PLAYER_UNSEEN,
}

struct TimerElement {
  int cur, max;
}

<* Converting type into int for hashing *>
fn uint MemoryType.hash(&self) {
  return self.ordinal.hash();
}



module gnosis::unit::memories;
import std::collections;


//alias Memories = HashMap{MemoryType,void*};
alias Memories = List{Memory};

enum MemoryType : uint {
  EMPTY,

  TARGET_SEEN,
  TARGET_HIDDEN,
}

struct Memory {
  MemoryType type;
  void* data;
  int timer; // In ticks
}

<**>
fn bool Memory.equals(&self, Memory rhs) @operator(==) {
  return (self.type == rhs.type && self.data == rhs.data);
}

<**>
fn bool Memories.has_memory(&self, Memory mem) {
  for (int i; i < self.len(); i++) {
    if (self.get(i) == mem) return true;
  }
  return false;
}
<* Converting type into int for hashing *>
fn uint MemoryType.hash(&self) {
  return self.ordinal.hash();
}


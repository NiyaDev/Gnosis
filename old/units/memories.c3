
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

<* Compares two memories *>
fn bool Memory.equals(&self, Memory rhs) @operator(==) {
  return (self.type == rhs.type && self.data == rhs.data);
}

<* Checks if a memory exists *>
fn bool Memories.has_memory(&self, Memory mem) {
  for (int i; i < self.len(); i++) {
    if (self.get(i) == mem) return true;
  }
  return false;
}


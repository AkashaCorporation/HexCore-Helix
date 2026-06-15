#include "helix/cast/CAstNode.h"

namespace helix::cast {

// CAstNode's constructor, getKind(), getAddress(), and setAddress() are all
// defined inline in the header. This translation unit exists to anchor the
// virtual destructor's vtable to a single object file, and to provide a home
// for any future base-class utility functions.

// Explicit destructor definition anchors the vtable here.
// (The defaulted virtual destructor in the header is sufficient for most
//  compilers, but having a .cpp ensures the vtable is emitted exactly once.)

} // namespace helix::cast

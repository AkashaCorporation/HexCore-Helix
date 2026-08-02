#!/usr/bin/env bash
# Re-vendor the FlatBuffers C++ headers that FlatBufSerializer.cpp (the C-AST -> HAST
# serializer HQL consumes) needs. Version v25.12.19 matches the Rust `flatbuffers` crate
# (crates/helix-core) so the binary format is identical across the C++ writer, the Rust
# reader, and the npm JS hydrator. Header-only (FlatBufferBuilder) -- no lib build.
#
# Idempotent: a no-op if the headers are already present. Run this if engine/deps was
# cleaned and the build reports "FlatBuffers not found -- stub HAST serialization".
set -e
DST="$(cd "$(dirname "$0")" && pwd)/deps/flatbuffers/include/flatbuffers"
if [ -f "$DST/flatbuffers.h" ]; then
  echo "flatbuffers headers already vendored ($(ls "$DST"/*.h | wc -l) files): $DST"
  exit 0
fi
TMP="$(mktemp -d)"
echo "fetching flatbuffers v25.12.19 headers ..."
git clone --depth 1 --branch v25.12.19 --single-branch https://github.com/google/flatbuffers.git "$TMP/fb"
mkdir -p "$DST"
cp "$TMP/fb/include/flatbuffers/"*.h "$DST/"
rm -rf "$TMP"
echo "vendored $(ls "$DST"/*.h | wc -l) flatbuffers headers -> $DST"
echo "now reconfigure the engine build so the C-AST serializer is enabled."

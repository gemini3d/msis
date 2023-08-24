# GEMINI3D MSIS

[![ci](https://github.com/gemini3d/msis/actions/workflows/ci.yml/badge.svg)](https://github.com/gemini3d/msis/actions/workflows/ci.yml)

High-level MSIS interface allowing selection of MSIS versions (default MSISE00 or optional MSIS 2.x).

## Build

Under directory "build/" provides

* executable: bin/msis_setup executable and
* library: lib/msis_ifc

```sh
cmake -B build --install-prefix=$HOME/mylibs
cmake --build build

# optional
ctest --test-dir build

cmake --install build
```

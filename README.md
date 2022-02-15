# GEMINI3D MSIS

[![ci](https://github.com/gemini3d/msis/actions/workflows/ci.yml/badge.svg)](https://github.com/gemini3d/msis/actions/workflows/ci.yml)

MSIS interface for GEMINI3D

This provides the bin/msis_setup executable and lib/msis_ifc library:

```sh
cmake -B build --install-prefix=$HOME/mylibs
cmake --build build

# optional
ctest --test-dir build

cmake --install build
```

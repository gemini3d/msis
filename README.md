# GEMINI3D MSIS

[![ci](https://github.com/gemini3d/msis/actions/workflows/ci.yml/badge.svg)](https://github.com/gemini3d/msis/actions/workflows/ci.yml)

High-level MSIS interface allowing selection of MSIS versions.
Default
[MSISE00](https://map.nrl.navy.mil/map/pub/nrl/NRLMSIS/NRLMSISE-00),
optional
[MSIS 2.x](https://map.nrl.navy.mil/map/pub/nrl/NRLMSIS/), which has its own
[license](./src/msis2/nrlmsis2.1_license.txt).

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

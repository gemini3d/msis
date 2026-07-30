# GEMINI3D MSIS

[![ci](https://github.com/gemini3d/msis/actions/workflows/ci.yml/badge.svg)](https://github.com/gemini3d/msis/actions/workflows/ci.yml)

High-level MSIS interface for Gemini3D, allowing selection of MSIS versions.
Default
[MSISE00](https://map.nrl.navy.mil/map/pub/nrl/NRLMSIS/NRLMSISE-00),
optional
[MSIS 2.1](https://map.nrl.navy.mil/map/pub/nrl/NRLMSIS/),
which has its own
[license](./src/msis2/nrlmsis2.1_license.txt).
Currently we use MSIS 2.1 release 4 APR 2022, which is the latest release.
MSIS 2.0 had bugs and licensing issues that made using it difficult, and which were fixed in MSIS 2.1.

## Build

Under directory "build/" provides

* executable: msis_setup
* library: msis_ifc

```sh
cmake -B build --install-prefix=$HOME/mylibs
cmake --build build

# optional
ctest --test-dir build

cmake --install build
```

By default the "msis_setup" executable is created.
msis_setup requires h5fortran + HDF5.
This is normally no issue since Gemini3D uses HDF5 and h5fortran everywhere in its file I/O.
To build just the MSIS library interface without msis_setup and therefore without using HDF5:

```sh
cmake -Bbuild -Dmsis_BUILD_UTILS=off

cmake --build build
```

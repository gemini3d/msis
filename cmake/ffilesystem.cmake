include(ExternalProject)

find_package(ffilesystem 4.0.1 CONFIG)
if(ffilesystem_FOUND)
  message(STATUS "Found ffilesystem ${ffilesystem_VERSION}: ${ffilesystem_DIR}")
  return()
endif()

if(WIN32)
  set(_l ${CMAKE_INSTALL_BINDIR})
else()
  set(_l ${CMAKE_INSTALL_LIBDIR})
endif()

set(ffilesystem_LIBRARIES ${CMAKE_INSTALL_PREFIX}/${_l}/${CMAKE_SHARED_LIBRARY_PREFIX}ffilesystem${CMAKE_SHARED_LIBRARY_SUFFIX})

set(ffilesystem_INCLUDE_DIRS ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_INCLUDEDIR})

set(ffilesystem_cmake_args
-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
-DBUILD_SHARED_LIBS:BOOL=true
-DCMAKE_BUILD_TYPE=Release
-DBUILD_TESTING:BOOL=false
-Dcpp:BOOL=false
)
# BUILD_SHARED_LIBS=true essential so that lib_dir() works
# cpp=false for robustness on systems with C++ ABI problems.

ExternalProject_Add(ffilesystem
GIT_REPOSITORY https://github.com/scivision/fortran-filesystem.git
GIT_TAG v4.0.1
CMAKE_ARGS ${ffilesystem_cmake_args}
BUILD_BYPRODUCTS ${ffilesystem_LIBRARIES}
GIT_SHALLOW true
CONFIGURE_HANDLED_BY_BUILD true
)

file(MAKE_DIRECTORY ${ffilesystem_INCLUDE_DIRS})
# avoid generate race condition

add_library(ffilesystem::filesystem INTERFACE IMPORTED)

target_link_libraries(ffilesystem::filesystem INTERFACE ${ffilesystem_LIBRARIES})
target_include_directories(ffilesystem::filesystem INTERFACE ${ffilesystem_INCLUDE_DIRS})
set_property(TARGET ffilesystem::filesystem PROPERTY IMPORTED_LINK_INTERFACE_LANGUAGES CXX)
# https://cmake.org/cmake/help/latest/prop_tgt/IMPORTED_LINK_INTERFACE_LANGUAGES.html
# imported targets use above instead of LINKER_LANGUAGE
# target_link_libraries(ffilesystem::filesystem INTERFACE stdc++)  # did not help

add_dependencies(ffilesystem::filesystem ffilesystem)

include(ExternalProject)
include(GNUInstallDirs)

set(h5fortran_INCLUDE_DIRS ${CMAKE_INSTALL_FULL_INCLUDEDIR})

if(BUILD_SHARED_LIBS)
  if(WIN32)
    set(h5fortran_LIBRARIES ${CMAKE_INSTALL_FULL_BINDIR}/${CMAKE_SHARED_LIBRARY_PREFIX}h5fortran${CMAKE_SHARED_LIBRARY_SUFFIX})
  else()
    set(h5fortran_LIBRARIES ${CMAKE_INSTALL_FULL_LIBDIR}/${CMAKE_SHARED_LIBRARY_PREFIX}h5fortran${CMAKE_SHARED_LIBRARY_SUFFIX})
  endif()
else()
  set(h5fortran_LIBRARIES ${CMAKE_INSTALL_FULL_LIBDIR}/${CMAKE_STATIC_LIBRARY_PREFIX}h5fortran${CMAKE_STATIC_LIBRARY_SUFFIX})
endif()

set(h5fortran_cmake_args
-DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
-DCMAKE_PREFIX_PATH:PATH=${CMAKE_INSTALL_PREFIX}
-DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
-DCMAKE_BUILD_TYPE=Release
-DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
-DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER}
-DBUILD_TESTING:BOOL=false
)
if(HDF5_ROOT)
  list(APPEND h5fortran_cmake_args -DHDF5_ROOT:PATH=${HDF5_ROOT})
endif()

file(READ ${CMAKE_CURRENT_LIST_DIR}/libraries.json json_meta)
string(JSON url GET ${json_meta} "h5fortran" "url")
string(JSON tag GET ${json_meta} "h5fortran" "tag")

ExternalProject_Add(h5fortran
GIT_REPOSITORY ${url}
GIT_TAG ${tag}
GIT_SHALLOW true
CMAKE_ARGS ${h5fortran_cmake_args}
BUILD_BYPRODUCTS ${h5fortran_LIBRARIES}
TLS_VERIFY ON
CONFIGURE_HANDLED_BY_BUILD ON
)

file(MAKE_DIRECTORY ${h5fortran_INCLUDE_DIRS})

add_library(h5fortran::h5fortran INTERFACE IMPORTED GLOBAL)
target_include_directories(h5fortran::h5fortran INTERFACE ${h5fortran_INCLUDE_DIRS})
target_link_libraries(h5fortran::h5fortran INTERFACE ${h5fortran_LIBRARIES} HDF5::HDF5)

# race condition for linking without this
add_dependencies(h5fortran::h5fortran h5fortran)

set(h5fortran_FOUND true)

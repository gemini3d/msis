option(autobuild "autobuild missing libraries" off)

option(msis2 "use MSIS 2.x neutral atmosphere model")

set(CMAKE_TLS_VERIFY true)  # for Git and Downloads

# to make Gemini3D more usable by external programs, put all Fortran .mod generated module files in a single directory.
set(CMAKE_Fortran_MODULE_DIRECTORY ${PROJECT_BINARY_DIR}/include)

if(dev)

else()
  set_directory_properties(PROPERTIES EP_UPDATE_DISCONNECTED true)
  set(FETCHCONTENT_UPDATES_DISCONNECTED_MSIS2 true)
endif()

# --- External project generator
if(CMAKE_GENERATOR STREQUAL "Ninja Multi-Config")
  set(EXTPROJ_GENERATOR "Ninja")
else()
  set(EXTPROJ_GENERATOR ${CMAKE_GENERATOR})
endif()

# --- auto-ignore build directory
if(NOT EXISTS ${PROJECT_BINARY_DIR}/.gitignore)
  file(WRITE ${PROJECT_BINARY_DIR}/.gitignore "*")
endif()

# --- default install directory under build/local
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  # will not take effect without FORCE
  set(CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR} CACHE PATH "Install top-level directory" FORCE)
endif()

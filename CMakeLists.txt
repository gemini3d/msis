cmake_minimum_required(VERSION 3.25...4.5)

get_property(is_multi_config GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
if(NOT is_multi_config AND NOT CMAKE_BUILD_TYPE AND NOT DEFINED ENV{CMAKE_BUILD_TYPE})
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Release default")
endif()

project(msis
LANGUAGES C Fortran
VERSION 2.1.0.5
)

enable_testing()

include(GNUInstallDirs)
include(FetchContent)

include(options.cmake)
include(cmake/compilers.cmake)

# to make more usable by external programs, put all Fortran .mod generated module files in a single directory.
set(CMAKE_Fortran_MODULE_DIRECTORY ${PROJECT_BINARY_DIR}/${CMAKE_INSTALL_INCLUDEDIR})
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})
# avoid parent project race

if(msis_BUILD_UTILS)
  file(READ cmake/libraries.json json)
  string(JSON h5fortran_url GET "${json}" "h5fortran")
  FetchContent_Declare(h5fortran URL ${h5fortran_url})
  FetchContent_MakeAvailable(h5fortran)
endif()

add_library(msis_ifc src/msis_interface.f90)
target_include_directories(msis_ifc
PUBLIC
"$<BUILD_INTERFACE:${CMAKE_Fortran_MODULE_DIRECTORY};${h5fortran_BINARY_DIR}/${CMAKE_INSTALL_INCLUDEDIR}>"
$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)
target_link_libraries(msis_ifc PRIVATE msis00mod)
target_sources(msis_ifc PRIVATE $<$<NOT:$<BOOL:${msis2}>>:${CMAKE_CURRENT_SOURCE_DIR}/src/msis2_dummy.f90>)

install(FILES ${CMAKE_Fortran_MODULE_DIRECTORY}/msis_interface.mod TYPE INCLUDE)

if(msis_BUILD_UTILS)
  add_executable(msis_setup app/main.f90)
  target_link_libraries(msis_setup PRIVATE msis_ifc h5fortran::h5fortran)
  set_target_properties(msis_setup PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}
  DEBUG_POSTFIX .debug
  RELWITHDEBINFO_POSTFIX .debug
  )

  install(TARGETS msis_setup EXPORT msis-targets)
endif()

if(msis2)
  add_library(msis2mod
  src/msis2/msis_calc.f90
  src/msis2/msis_constants.F90
  src/msis2/msis_dfn.f90
  src/msis2/msis_gfn.f90
  src/msis2/msis_gtd8d.f90
  src/msis2/msis_init.F90
  src/msis2/msis_tfn.f90
  src/msis2/msis_utils.f90
  )
  target_include_directories(msis2mod PRIVATE ${CMAKE_Fortran_MODULE_DIRECTORY})

  set_property(SOURCE src/msis2/msis_init.F90 PROPERTY
  COMPILE_OPTIONS $<$<Fortran_COMPILER_ID:GNU>:-ffree-line-length-none>
  )

  target_compile_definitions(msis2mod PRIVATE
  $<BUILD_INTERFACE:msis_datadir="${CMAKE_CURRENT_SOURCE_DIR}/src/msis2">
  $<INSTALL_INTERFACE:msis_datadir="${CMAKE_INSTALL_BINDIR}">
  )

  install(TARGETS msis2mod EXPORT msis-targets)

  target_link_libraries(msis_ifc PUBLIC msis2mod)

  # MSIS 2.x needs this parm file.
  set(msis2_parm_file ${CMAKE_CURRENT_SOURCE_DIR}/src/msis2/msis21.parm)

  install(FILES ${msis2_parm_file} TYPE BIN)
  install(FILES ${CMAKE_Fortran_MODULE_DIRECTORY}/msis_init.mod TYPE INCLUDE)
endif()

add_library(msis00mod src/msis00_gfortran.f src/msise00_data.f)
target_compile_options(msis00mod PRIVATE ${msis_legacy_flags})

install(TARGETS msis00mod msis_ifc EXPORT msis-targets)

add_library(msis::msis ALIAS msis_ifc)

if(msis_BUILD_TESTING)
  add_subdirectory(test)
endif()

include(cmake/install.cmake)

file(GENERATE OUTPUT .gitignore CONTENT "*")

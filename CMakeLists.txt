cmake_minimum_required(VERSION 3.11...3.25)

project(msis
LANGUAGES C Fortran
VERSION 2.1.0.4
)

enable_testing()

include(cmake/options.cmake)
include(cmake/compilers.cmake)

find_package(h5fortran CONFIG REQUIRED)
# HDF5 is used for input/output of data

add_library(msis_ifc src/msis_interface.f90)
target_include_directories(msis_ifc
PUBLIC
$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include>
$<INSTALL_INTERFACE:include>
)
target_link_libraries(msis_ifc PRIVATE msis00mod)
target_sources(msis_ifc PRIVATE $<$<NOT:$<BOOL:${msis2}>>:${CMAKE_CURRENT_SOURCE_DIR}/src/msis2_dummy.f90>)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/include/msis_interface.mod DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

add_executable(msis_setup app/main.f90)
target_link_libraries(msis_setup PRIVATE msis_ifc h5fortran::h5fortran)
set_property(TARGET msis_setup PROPERTY RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR})
set_property(TARGET msis_setup PROPERTY DEBUG_POSTFIX .debug)
set_property(TARGET msis_setup PROPERTY RELWITHDEBINFO_POSTFIX .debug)

if(msis2)
  add_subdirectory(src/msis2)

  target_link_libraries(msis_ifc PUBLIC msis2mod)

  # MSIS 2.x needs this parm file.
  set(msis2_parm_file ${CMAKE_CURRENT_SOURCE_DIR}/src/msis2/msis21.parm)

  add_custom_command(TARGET msis_setup POST_BUILD
  COMMAND ${CMAKE_COMMAND} -E copy_if_different ${msis2_parm_file} $<TARGET_FILE_DIR:msis_setup>
  COMMAND_EXPAND_LISTS
  COMMENT "Copied MSIS 2.x parameter file to $<TARGET_FILE_DIR:msis_setup>"
  )

  install(FILES ${msis2_parm_file} DESTINATION ${CMAKE_INSTALL_BINDIR})
endif()

add_library(msis00mod src/msis00_gfortran.f src/msise00_data.f)

install(TARGETS msis00mod msis_ifc msis_setup
EXPORT ${PROJECT_NAME}-targets
LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

if(BUILD_TESTING)
  include(cmake/DllTestPath.cmake)

  add_subdirectory(test)
endif()

include(cmake/install.cmake)

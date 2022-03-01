cmake_minimum_required(VERSION 3.20...3.23)

project(msis
LANGUAGES C Fortran
VERSION 1.0.4
)

include(CTest)
if(NOT DEFINED ${PROJECT_NAME}_BUILD_TESTING)
  set(${PROJECT_NAME}_BUILD_TESTING ${BUILD_TESTING})
endif()

include(cmake/options.cmake)

find_package(h5fortran CONFIG REQUIRED)

add_library(msis_ifc src/msis_interface.f90)
target_include_directories(msis_ifc
PUBLIC
$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include>
$<INSTALL_INTERFACE:include>
)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/include/msis_interface.mod TYPE INCLUDE)

add_executable(msis_setup src/msis_driver.f90)

if(msis2)
  include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/msis2.cmake)
endif()

add_subdirectory(src)

if(${PROJECT_NAME}_BUILD_TESTING)
  include(cmake/DllTestPath.cmake)

  add_subdirectory(tests)
endif()

include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/install.cmake)

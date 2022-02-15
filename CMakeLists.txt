cmake_minimum_required(VERSION 3.20...3.23)

project(msis
LANGUAGES C Fortran
VERSION 1.0.1
)

include(CTest)
if(NOT DEFINED ${PROJECT_NAME}_BUILD_TESTING)
  set(${PROJECT_NAME}_BUILD_TESTING ${BUILD_TESTING})
endif()

include(cmake/options.cmake)

find_package(h5fortran CONFIG REQUIRED)

add_executable(msis_setup src/msis_driver.f90)

if(msis2)
  include(${PROJECT_SOURCE_DIR}/cmake/msis2.cmake)
endif()

add_subdirectory(src)

if(${PROJECT_NAME}_BUILD_TESTING)
  add_subdirectory(tests)
endif()

include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/install.cmake)

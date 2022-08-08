cmake_minimum_required(VERSION 3.11...3.25)

project(msis
LANGUAGES C Fortran
VERSION 2.1.0.0
)

enable_testing()

if(DEFINED ${PROJECT_NAME}_BUILD_TESTING)
  set(${PROJECT_NAME}_BUILD_TESTING ${BUILD_TESTING})
else()
  set(${PROJECT_NAME}_BUILD_TESTING true)
endif()

include(cmake/options.cmake)
include(cmake/compilers.cmake)

find_package(h5fortran CONFIG REQUIRED)

add_library(msis_ifc src/msis_interface.f90)
target_include_directories(msis_ifc
PUBLIC
$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include>
$<INSTALL_INTERFACE:include>
)
target_link_libraries(msis_ifc PRIVATE msis00mod)


install(FILES ${CMAKE_CURRENT_BINARY_DIR}/include/msis_interface.mod DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

add_executable(msis_setup src/msis_driver.f90)
target_link_libraries(msis_setup PRIVATE msis_ifc h5fortran::h5fortran)


if(msis2)
  include(cmake/msis2.cmake)
endif()

add_library(msis00mod src/msis00_gfortran.f src/msise00_data.f)

add_subdirectory(src)

install(TARGETS msis00mod msis_ifc msis_setup
EXPORT ${PROJECT_NAME}-targets
LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

if(${PROJECT_NAME}_BUILD_TESTING)
  include(cmake/DllTestPath.cmake)

  add_subdirectory(test)
endif()

include(cmake/install.cmake)

message(STATUS "${PROJECT_NAME} ${PROJECT_VERSION} CMake ${CMAKE_VERSION} Toolchain ${CMAKE_TOOLCHAIN_FILE}")

# this is NECESSARY for CMake 3.21 -- project will error on CMake configure!
if(CMAKE_VERSION VERSION_LESS 3.21)
  get_property(not_top DIRECTORY PROPERTY PARENT_DIRECTORY)
  if(NOT not_top)
    set(PROJECT_IS_TOP_LEVEL true)
 endif()
endif()

option(${PROJECT_NAME}_BUILD_TESTING "build test programs" ${PROJECT_IS_TOP_LEVEL})

option(${PROJECT_NAME}_BUILD_UTILS "build msis_setup" on)

option(msis2 "use MSIS 2.x neutral atmosphere model" on)

# Necessary for shared library with Visual Studio / Windows oneAPI
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS true)

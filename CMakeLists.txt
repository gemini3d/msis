cmake_minimum_required(VERSION 3.20...3.22)

project(MSIS LANGUAGES C Fortran)

include(CTest)

include(cmake/options.cmake)
include(cmake/libraries.cmake)

include(cmake/h5fortran.cmake)

add_subdirectory(src)

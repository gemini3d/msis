if(CMAKE_Fortran_COMPILER_ID STREQUAL "GNU")
  add_compile_options($<$<COMPILE_LANGUAGE:Fortran>:-Werror=line-truncation>)
endif()

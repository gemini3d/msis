if(CMAKE_Fortran_COMPILER_ID STREQUAL "GNU")
  add_compile_options($<$<COMPILE_LANGUAGE:Fortran>:-Werror=line-truncation>)
  set(legacy_flags $<$<COMPILE_LANGUAGE:Fortran>:-std=legacy>)
endif()

add_executable(msis_generate test_gen_in.f90)
target_link_libraries(msis_generate PRIVATE h5fortran::h5fortran)

add_executable(msis_compare test_msis.f90 assert.f90)
target_link_libraries(msis_compare PRIVATE msis_ifc
h5fortran::h5fortran
)

# --- MSISE00 tests
set(msis00_in ${CMAKE_CURRENT_BINARY_DIR}/msis00_test_in.h5)
set(msis00_out ${CMAKE_CURRENT_BINARY_DIR}/msis00_test_out.h5)
set(msis00_ref ${CMAKE_CURRENT_SOURCE_DIR}/msis00_test_out.h5)

add_test(NAME msis00_generate
COMMAND msis_generate ${msis00_in} 0
)
set_property(TEST msis00_generate PROPERTY FIXTURES_SETUP msis00_gen_fxt)

add_test(NAME msis00_setup
COMMAND msis_setup ${msis00_in} ${msis00_out}
)
set_property(TEST msis00_setup PROPERTY FIXTURES_SETUP msis00_fxt)
set_property(TEST msis00_setup PROPERTY FIXTURES_REQUIRED msis00_gen_fxt)
set_property(TEST msis00_setup PROPERTY REQUIRED_FILES ${msis00_in})

add_test(NAME msis00_compare
COMMAND msis_compare ${msis00_out} ${msis00_ref}
)
set_property(TEST msis00_compare PROPERTY FIXTURES_REQUIRED msis00_fxt)
set_property(TEST msis00_compare PROPERTY REQUIRED_FILES "${msis00_out};${msis00_ref}")


# --- MSIS 2.x tests
if(msis2)
  add_executable(msis2test ${PROJECT_SOURCE_DIR}/src/msis2/msis2.1_test.f90)
  target_link_libraries(msis2test PRIVATE msis2mod)

  add_test(NAME MSIS2 COMMAND msis2test)
  set_property(TEST MSIS2 PROPERTY WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}/src/msis2)

  set(msis2_in ${CMAKE_CURRENT_BINARY_DIR}/msis2_test_in.h5)
  set(msis2_out ${CMAKE_CURRENT_BINARY_DIR}/msis2_test_out.h5)
  set(msis2_ref ${CMAKE_CURRENT_SOURCE_DIR}/msis2_test_out.h5)

  add_test(NAME msis2_generate
  COMMAND msis_generate ${msis2_in} 21
  )
  set_property(TEST msis2_generate PROPERTY FIXTURES_SETUP msis2_gen_fxt)

  add_test(NAME msis2_setup
  COMMAND msis_setup ${msis2_in} ${msis2_out}
  )
  set_property(TEST msis2_setup PROPERTY FIXTURES_SETUP msis2_fxt)
  set_property(TEST msis2_setup PROPERTY FIXTURES_REQUIRED msis2_gen_fxt)
  set_property(TEST msis2_setup PROPERTY REQUIRED_FILES ${msis2_in})

  add_test(NAME msis2_compare
  COMMAND msis_compare ${msis2_out} ${msis2_ref}
  )
  set_property(TEST msis2_compare PROPERTY FIXTURES_REQUIRED msis2_fxt)
  set_property(TEST msis2_compare PROPERTY REQUIRED_FILES "${msis2_out};${msis2_ref}")
endif(msis2)

get_property(_tests DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY TESTS)

dll_test_path("h5fortran::h5fortran;msis_ifc" "${_tests}")

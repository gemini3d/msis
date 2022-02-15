add_executable(msis_generate test_gen_in.f90)
target_link_libraries(msis_generate PRIVATE
h5fortran::h5fortran
$<$<BOOL:${HDF5_HAVE_PARALLEL}>:MPI::MPI_Fortran>
)

add_executable(msis_compare test_msis.f90 assert.f90)
target_link_libraries(msis_compare PRIVATE msis_ifc msis00mod
h5fortran::h5fortran
$<$<BOOL:${HDF5_HAVE_PARALLEL}>:MPI::MPI_Fortran>
)

# --- MSISE00 tests
set(msis00_in ${CMAKE_CURRENT_BINARY_DIR}/msis00_test_in.h5)
set(msis00_out ${CMAKE_CURRENT_BINARY_DIR}/msis00_test_out.h5)
set(msis00_ref ${CMAKE_CURRENT_SOURCE_DIR}/msis00_test_out.h5)

add_test(NAME unit:msis00_generate
COMMAND msis_generate ${msis00_in} 0
)
set_tests_properties(unit:msis00_generate PROPERTIES
FIXTURES_SETUP msis00_gen_fxt
LABELS unit
TIMEOUT 10
)

add_test(NAME unit:msis00_setup
COMMAND msis_setup ${msis00_in} ${msis00_out}
)
set_tests_properties(unit:msis00_setup PROPERTIES
FIXTURES_SETUP msis00_fxt
FIXTURES_REQUIRED msis00_gen_fxt
LABELS unit
REQUIRED_FILES ${msis00_in}
TIMEOUT 10
)

add_test(NAME unit:msis00_compare
COMMAND msis_compare ${msis00_out} ${msis00_ref}
)
set_tests_properties(unit:msis00_compare PROPERTIES
FIXTURES_REQUIRED msis00_fxt
LABELS unit
TIMEOUT 10
REQUIRED_FILES "${msis00_out};${msis00_ref}"
)


# --- MSIS 2.0 tests
if(NOT msis2)
  return()
endif()

add_executable(msis2test ${msis2_SOURCE_DIR}/msis2.0_test.F90)
target_link_libraries(msis2test PRIVATE msis2mod)

add_test(NAME MSIS2
COMMAND msis2test
WORKING_DIRECTORY ${msis2_SOURCE_DIR}
)

set(msis2_in ${CMAKE_CURRENT_BINARY_DIR}/msis2_test_in.h5)
set(msis2_out ${CMAKE_CURRENT_BINARY_DIR}/msis2_test_out.h5)
set(msis2_ref ${CMAKE_CURRENT_SOURCE_DIR}/msis2_test_out.h5)

add_test(NAME unit:msis2_generate
COMMAND msis_generate ${msis2_in} 20
)
set_tests_properties(unit:msis2_generate PROPERTIES
FIXTURES_SETUP msis2_gen_fxt
LABELS unit
TIMEOUT 10
)

add_test(NAME unit:msis2_setup
COMMAND msis_setup ${msis2_in} ${msis2_out}
WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
)
set_tests_properties(unit:msis2_setup PROPERTIES
FIXTURES_SETUP msis2_fxt
FIXTURES_REQUIRED msis2_gen_fxt
LABELS unit
REQUIRED_FILES ${msis2_in}
TIMEOUT 10
)

add_test(NAME unit:msis2_compare
COMMAND msis_compare ${msis2_out} ${msis2_ref}
WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
)
set_tests_properties(unit:msis2_compare PROPERTIES
FIXTURES_REQUIRED msis2_fxt
LABELS unit
TIMEOUT 10
REQUIRED_FILES "${msis2_out};${msis2_ref}"
)

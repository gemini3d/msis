set_directory_properties(PROPERTIES LABELS msis)

# --- MSISE00 and MSIS 2.0 require legacy workaround due to non-standard Fortran code

# Gfortran >= 8 need -Wno-pedantic to allow mismatched array size inhernet to MSIS.
# "-w" doesn't disable pedantic
set(msis00_gnu_flags -w -std=legacy -Wno-pedantic -fno-implicit-none -Wno-error=array-bounds -fcheck=no-all)
# msis2.0 will intermittantly fail with -std=legacy with all zero outputs, e.g. GCC 8.5.0
set(msis2_gnu_flags -w -Wno-error=array-bounds -fcheck=no-all)

set(msis_intel_flags -nowarn)

# --- MSISE00 is always available, but MSIS 2.0 might not be available.

add_library(msis00mod msis00_gfortran.f msise00_data.f)
target_compile_options(msis00mod PRIVATE
"$<$<Fortran_COMPILER_ID:GNU>:${msis00_gnu_flags}>"
"$<$<Fortran_COMPILER_ID:Intel,IntelLLVM>:${msis_intel_flags}>")

# --- build abstract MSIS interface

add_library(msis_ifc msis_interface.f90)
target_link_libraries(msis_ifc PRIVATE msis00mod)

if(msis2)
  target_link_libraries(msis_ifc PRIVATE msis2mod)
  target_compile_options(msis2mod PRIVATE
  "$<$<Fortran_COMPILER_ID:GNU>:${msis2_gnu_flags}>"
  "$<$<Fortran_COMPILER_ID:Intel,IntelLLVM>:${msis_intel_flags}>"
  )
else(msis2)
  target_sources(msis_ifc PRIVATE msis2_dummy.f90)
endif(msis2)

# --- Standalone MSIS runner

target_link_libraries(msis_setup PRIVATE msis_ifc h5fortran::h5fortran
$<$<BOOL:${HDF5_HAVE_PARALLEL}>:MPI::MPI_Fortran>
)
set_target_properties(msis_setup PROPERTIES
RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}
DEBUG_POSTFIX .debug
RELWITHDEBINFO_POSTFIX .debug
)

install(TARGETS msis00mod msis_ifc msis_setup
EXPORT ${PROJECT_NAME}-targets
)

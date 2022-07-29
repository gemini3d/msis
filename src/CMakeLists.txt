set_property(DIRECTORY PROPERTY LABELS msis)

add_library(msis00mod msis00_gfortran.f msise00_data.f)

# --- build abstract MSIS interface

target_link_libraries(msis_ifc PRIVATE msis00mod)

if(msis2)
  target_link_libraries(msis_ifc PUBLIC msis2mod)
else(msis2)
  target_sources(msis_ifc PRIVATE msis2_dummy.f90)
endif(msis2)

# --- Standalone MSIS runner

target_link_libraries(msis_setup PRIVATE msis_ifc h5fortran::h5fortran)

set_property(TARGET msis_setup PROPERTY RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR})
set_property(TARGET msis_setup PROPERTY DEBUG_POSTFIX .debug)
set_property(TARGET msis_setup PROPERTY RELWITHDEBINFO_POSTFIX .debug)

install(TARGETS msis00mod msis_ifc msis_setup
EXPORT ${PROJECT_NAME}-targets
)

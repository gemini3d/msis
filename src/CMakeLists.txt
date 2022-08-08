set_property(DIRECTORY PROPERTY LABELS msis)

# --- build abstract MSIS interface

if(msis2)
  target_link_libraries(msis_ifc PUBLIC msis2mod)
else(msis2)
  target_sources(msis_ifc PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/msis2_dummy.f90)
endif(msis2)


set_property(TARGET msis_setup PROPERTY RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR})
set_property(TARGET msis_setup PROPERTY DEBUG_POSTFIX .debug)
set_property(TARGET msis_setup PROPERTY RELWITHDEBINFO_POSTFIX .debug)

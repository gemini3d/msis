add_library(msis2mod
msis_calc.f90
msis_constants.F90
msis_dfn.f90
msis_gfn.f90
msis_gtd8d.f90
msis_init.F90
msis_tfn.f90
msis_utils.f90
)

target_compile_definitions(msis2mod PRIVATE
$<BUILD_INTERFACE:msis_datadir="${CMAKE_CURRENT_SOURCE_DIR}">
$<INSTALL_INTERFACE:msis_datadir="${CMAKE_INSTALL_BINDIR}">
)

install(TARGETS msis2mod EXPORT ${PROJECT_NAME}-targets
LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

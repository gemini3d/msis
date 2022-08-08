add_library(msis2mod
msis_calc.F90
msis_constants.F90
msis_dfn.F90
msis_gfn.F90
msis_gtd8d.F90
msis_init.F90
msis_tfn.F90
msis_utils.F90
)

# MSIS 2.x needs this parm file.
set(msis2_parm_file ${CMAKE_CURRENT_SOURCE_DIR}/msis21.parm PARENT_SCOPE)


install(TARGETS msis2mod EXPORT ${PROJECT_NAME}-targets
LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

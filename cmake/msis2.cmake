include(FetchContent)

file(READ ${CMAKE_CURRENT_LIST_DIR}/libraries.json _libj)
string(JSON msis2_url GET ${_libj} msis2 url)
string(JSON msis2_sha256 GET ${_libj} msis2 sha256)

FetchContent_Declare(MSIS2
URL ${msis2_url}
URL_HASH SHA256=${msis2_sha256}
INACTIVITY_TIMEOUT 15
)

FetchContent_Populate(MSIS2)

# convenience

# patching API MSIS
add_custom_command(
OUTPUT ${msis2_BINARY_DIR}/msis_calc.F90
COMMAND ${CMAKE_COMMAND}
  -Din_file:FILEPATH=${msis2_SOURCE_DIR}/msis_calc.F90
  -Dpatch_file:FILEPATH=${PROJECT_SOURCE_DIR}/src/msis_api.patch
  -Dout_file:FILEPATH=${msis2_BINARY_DIR}/msis_calc.F90
  -P ${PROJECT_SOURCE_DIR}/cmake/PatchFile.cmake
DEPENDS ${msis2_SOURCE_DIR}/msis_calc.F90
)

add_library(msis2mod
${msis2_SOURCE_DIR}/alt2gph.F90
${msis2_SOURCE_DIR}/msis_constants.F90
${msis2_SOURCE_DIR}/msis_init.F90
${msis2_SOURCE_DIR}/msis_gfn.F90
${msis2_SOURCE_DIR}/msis_tfn.F90
${msis2_SOURCE_DIR}/msis_dfn.F90
${msis2_SOURCE_DIR}/msis_gtd8d.F90
${msis2_BINARY_DIR}/msis_calc.F90
)

# MSIS 2.0 needs this parm file.
add_custom_command(TARGET msis_setup POST_BUILD
COMMAND ${CMAKE_COMMAND} -E copy_if_different ${msis2_SOURCE_DIR}/msis20.parm $<TARGET_FILE_DIR:msis_setup>
COMMAND_EXPAND_LISTS
COMMENT "Copied MSIS 2 parameter file to $<TARGET_FILE_DIR:msis_setup>"
)
install(FILES ${msis2_SOURCE_DIR}/msis20.parm TYPE BIN)

install(TARGETS msis2mod
EXPORT ${PROJECT_NAME}-targets
)

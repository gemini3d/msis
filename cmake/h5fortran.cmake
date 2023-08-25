include(FetchContent)
include(GNUInstallDirs)

file(READ ${CMAKE_CURRENT_LIST_DIR}/libraries.json json_meta)
string(JSON url GET ${json_meta} "h5fortran" "url")
string(JSON tag GET ${json_meta} "h5fortran" "tag")

set(h5fortran_BUILD_TESTING off)

FetchContent_Declare(h5fortran
GIT_REPOSITORY ${url}
GIT_TAG ${tag}
GIT_SHALLOW true
TLS_VERIFY ON
)

FetchContent_MakeAvailable(h5fortran)

set(h5fortran_FOUND true)

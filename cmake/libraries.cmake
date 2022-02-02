set(_names h5fortran msis2)

file(READ ${CMAKE_CURRENT_LIST_DIR}/libraries.json _libj)

foreach(n ${_names})
  foreach(t url git tag zip sha256)
    string(JSON m ERROR_VARIABLE e GET ${_libj} ${n} ${t})
    if(m)
      set(${n}_${t} ${m})
    endif()
  endforeach()
endforeach()

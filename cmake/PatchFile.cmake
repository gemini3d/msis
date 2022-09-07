# use GNU Patch from any platform

find_package(Patch REQUIRED)

execute_process(COMMAND ${Patch_EXECUTABLE} ${in_file} --input=${patch_file} --output=${out_file} --ignore-whitespace
COMMAND_ECHO STDOUT
RESULT_VARIABLE ret
)

if(NOT ret EQUAL 0)
  message(FATAL_ERROR "Failed to apply patch ${patch_file} to ${in_file} with ${Patch_EXECUTABLE}:
  ${ret}")
endif()

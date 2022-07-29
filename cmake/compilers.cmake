# --- MSISE00 and MSIS 2.0 require legacy workaround due to non-standard Fortran code

# Gfortran >= 8 need -Wno-pedantic to allow mismatched array size inhernet to MSIS.
# "-w" doesn't disable pedantic
#set(msis00_gnu_flags -w -std=legacy -Wno-pedantic -fno-implicit-none -Wno-error=array-bounds -fcheck=no-all)

# msis2.0 will intermittantly fail with -std=legacy with all zero outputs, e.g. GCC 8.5.0
#set(msis2_gnu_flags -w -Wno-error=array-bounds -fcheck=no-all)

#set(msis_intel_flags -nowarn)

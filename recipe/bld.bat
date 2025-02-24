REM Specifying the XEUS_PYTHONHOME_RELPATH to the general prefix.

mkdir build
cd build

cmake -G "NMake Makefiles" ^
  -D CMAKE_BUILD_TYPE=Release ^
  -D CMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
  -D XEUS_R_INSTALL_HERA=ON ^
  %SRC_DIR%
if errorlevel 1 exit 1

nmake
if errorlevel 1 exit 1

nmake install
if errorlevel 1 exit 1

REM Copying kernelspec to the general prefix for Jupyter to pick it up.

md %PREFIX%\share\jupyter\kernels\xr
xcopy %LIBRARY_PREFIX%\share\jupyter\kernels\xr %PREFIX%\share\jupyter\kernels\xr /F /Y

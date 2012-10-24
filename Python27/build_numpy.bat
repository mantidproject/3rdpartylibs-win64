@echo off
SETLOCAL
:: build_numpy.bat
:: 
:: This is a template for building python extensions that use distutils with MSVC. It should be copied
:: to the directory containing the setup.py file
:: Usage: 
::     build_ext amd64|x86 [debug]
::   where
::     amd64|x86 - denotes the architecture
::     debug - build in debug mode (optional, default = false)

:: Visual Studio version (the one in the directory path)
set MSVC_VER=10.0

:: Set the base of the third_party libraries
set THIRD_PARTY_BASE=C:\mantidproject\src\mantid\Code\Third_Party
set THIRD_PARTY_INCLUDE=%THIRD_PARTY_BASE%\include

:: Make sure the compiler tools are accessible
if "%1" == "x86" (
    set VCVARSALL="C:\Program Files\Microsoft Visual Studio %MSVC_VER%\VC\vcvarsall.bat"
    set THIRD_PARTY_PYLIB_DIR=%THIRD_PARTY_BASE%\lib\win32\Python27
) else if "%1" == "amd64" (
    set VCVARSALL="C:\Program Files (x86)\Microsoft Visual Studio %MSVC_VER%\VC\vcvarsall.bat"
    set THIRD_PARTY_PYLIB_DIR=%THIRD_PARTY_BASE%\lib\win64\Python27
) else (
  echo "Usage: build_ext.bat x86|amd64 [debug]
  goto failed
)
:: Set up MSVC compiler   
call %VCVARSALL% %1

:: Add library & include directories to Visual Studio variables
SET LIB=%THIRD_PARTY_PYLIB_DIR%;LIB%
SET INCLUDE=%THIRD_PARTY_INCLUDE%\Python27;%THIRD_PARTY%\Python27\Include;%INCLUDE%

:: Build
:: The final package will be installed to %CD%\package[_debug]\%THIRD_PARTY_BASE%\lib\[win32|win64]\Python27\Lib\site-packages
:: The --compile option after install refers to compiling the python scripts to pyc files
if "%2" == "debug" (
    %THIRD_PARTY_PYLIB_DIR%\python_d setup.py config --compiler=msvc build --compiler=msvc --debug install --compile --root=%CD%\package_debug
) else (
    %THIRD_PARTY_PYLIB_DIR%\python setup.py config --compiler=msvc build --compiler=msvc install --compile --root=%CD%\package
)


:failed
ENDLOCAL
exit /b 1
@echo off
setlocal EnableExtensions

set "SCRIPT_DIR=%~dp0"
set "PRESET=%~1"
if not defined PRESET set "PRESET=windows-release"

echo ========================================
echo   CrystalServer Windows Build (vcpkg)
echo ========================================
echo Preset: %PRESET%
echo.

if not defined VCPKG_ROOT (
    if exist "%SCRIPT_DIR%vcpkg\scripts\buildsystems\vcpkg.cmake" (
        set "VCPKG_ROOT=%SCRIPT_DIR%vcpkg"
    )
)

if not defined VCPKG_ROOT if exist "F:\vcpkg\scripts\buildsystems\vcpkg.cmake" (
    set "VCPKG_ROOT=F:\vcpkg"
)

if not defined VCPKG_ROOT if exist "C:\vcpkg\scripts\buildsystems\vcpkg.cmake" (
    set "VCPKG_ROOT=C:\vcpkg"
)

if not defined VCPKG_ROOT (
    echo ERRO: VCPKG_ROOT nao definido e nao foi encontrado automaticamente.
    echo Defina VCPKG_ROOT e rode novamente.
    echo Exemplo:
    echo   set VCPKG_ROOT=F:\vcpkg
    echo   build_windows_vcpkg.bat windows-release
    goto :result_error
)

if not exist "%VCPKG_ROOT%\scripts\buildsystems\vcpkg.cmake" (
    echo ERRO: Toolchain do vcpkg nao encontrado em:
    echo   %VCPKG_ROOT%\scripts\buildsystems\vcpkg.cmake
    goto :result_error
)

set "VCPKG_DEFAULT_TRIPLET=x64-windows-static"
set "VCPKG_BINARY_SOURCES=clear"
set "VCPKG_FEATURE_FLAGS=manifests"
echo VCPKG_ROOT: %VCPKG_ROOT%
echo VCPKG_DEFAULT_TRIPLET: %VCPKG_DEFAULT_TRIPLET%
echo VCPKG_BINARY_SOURCES: %VCPKG_BINARY_SOURCES%
echo.

set "CMAKE_EXE="
if exist "C:\Program Files\CMake\bin\cmake.exe" set "CMAKE_EXE=C:\Program Files\CMake\bin\cmake.exe"
if not defined CMAKE_EXE for /f "delims=" %%I in ('where cmake.exe 2^>nul') do if not defined CMAKE_EXE set "CMAKE_EXE=%%I"

if not defined CMAKE_EXE (
    echo ERRO: cmake.exe nao encontrado no sistema.
    goto :result_error
)

set "NINJA_EXE="
if exist "C:\Program Files\Ninja\ninja.exe" set "NINJA_EXE=C:\Program Files\Ninja\ninja.exe"
if not defined NINJA_EXE if exist "C:\ProgramData\chocolatey\bin\ninja.exe" set "NINJA_EXE=C:\ProgramData\chocolatey\bin\ninja.exe"
if not defined NINJA_EXE for /f "delims=" %%I in ('where ninja.exe 2^>nul') do if not defined NINJA_EXE set "NINJA_EXE=%%I"

if not defined NINJA_EXE (
    echo ERRO: ninja.exe nao encontrado no sistema.
    echo Instale o Ninja e rode novamente.
    echo Exemplo via winget:
    echo   winget install Ninja-build.Ninja
    goto :result_error
)

set "VS_VCVARSALL="
if exist "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" set "VS_VCVARSALL=C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat"
if not defined VS_VCVARSALL if exist "C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build\vcvarsall.bat" set "VS_VCVARSALL=C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build\vcvarsall.bat"
if not defined VS_VCVARSALL if exist "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvarsall.bat" set "VS_VCVARSALL=C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvarsall.bat"
if not defined VS_VCVARSALL if exist "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvarsall.bat" set "VS_VCVARSALL=C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvarsall.bat"

if not defined VS_VCVARSALL goto :no_vcvars
echo Preparando ambiente do Visual Studio (x64)...
call "%VS_VCVARSALL%" x64 >nul
goto :after_vcvars

:no_vcvars
echo AVISO: vcvarsall.bat nao encontrado. Tentando build com ambiente atual.

:after_vcvars

echo.
echo [1/2] Configurando CMake preset %PRESET%...
"%CMAKE_EXE%" --preset "%PRESET%"
if not "%ERRORLEVEL%"=="0" goto :result_error

echo.
echo [2/2] Compilando CMake build preset %PRESET%...
"%CMAKE_EXE%" --build --preset "%PRESET%" --parallel
if not "%ERRORLEVEL%"=="0" goto :result_error

set "OUTPUT_DIR=%SCRIPT_DIR%build\%PRESET%\bin"
set "EXE_NAME=crystalserver.exe"
if /I "%PRESET%"=="windows-debug" set "EXE_NAME=crystalserver-debug.exe"
if /I "%PRESET%"=="windows-Xdebug" set "EXE_NAME=crystalserver-debug.exe"

echo.
echo ========================================
echo   BUILD OK
echo ========================================
echo Binario esperado:
echo   %OUTPUT_DIR%\%EXE_NAME%
if not exist "%OUTPUT_DIR%\%EXE_NAME%" (
    echo AVISO: binario nao encontrado no caminho esperado.
    echo Confira o conteudo de:
    echo   %OUTPUT_DIR%
)
goto :result_end

:result_error
echo.
echo ========================================
echo   ERRO NA COMPILACAO
echo ========================================

:result_end
echo.
pause
endlocal

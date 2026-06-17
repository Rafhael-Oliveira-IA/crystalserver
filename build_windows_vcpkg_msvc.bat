@echo off
setlocal EnableExtensions

set "SCRIPT_DIR=%~dp0"
set "ROOT_DIR=%SCRIPT_DIR:~0,-1%"
set "SOLUTION=%SCRIPT_DIR%vcproj\crystalserver.sln"
set "CONFIG=%~1"
set "PLATFORM=%~2"
set "TRIPLET=%~3"
set "MSBUILD_EXE="
set "VS_VCVARSALL="

if not defined CONFIG set "CONFIG=Release"
if not defined PLATFORM set "PLATFORM=x64"
if not defined TRIPLET set "TRIPLET=x64-windows"

echo ========================================
echo   CrystalServer Build (MSBuild + vcpkg)
echo ========================================
echo Solution: %SOLUTION%
echo Configuration: %CONFIG%
echo Platform: %PLATFORM%
echo Triplet: %TRIPLET%
echo.

if not exist "%SOLUTION%" (
    echo ERRO: Solucao nao encontrada.
    echo   %SOLUTION%
    goto :result_error
)

if not defined VCPKG_ROOT (
    if exist "%SCRIPT_DIR%vcpkg\scripts\buildsystems\vcpkg.cmake" set "VCPKG_ROOT=%SCRIPT_DIR%vcpkg"
)
if not defined VCPKG_ROOT if exist "F:\vcpkg\scripts\buildsystems\vcpkg.cmake" set "VCPKG_ROOT=F:\vcpkg"
if not defined VCPKG_ROOT if exist "C:\vcpkg\scripts\buildsystems\vcpkg.cmake" set "VCPKG_ROOT=C:\vcpkg"

if not defined VCPKG_ROOT (
    echo ERRO: VCPKG_ROOT nao definido e nao foi encontrado automaticamente.
    echo Defina VCPKG_ROOT e rode novamente.
    goto :result_error
)

if not exist "%VCPKG_ROOT%\scripts\buildsystems\vcpkg.cmake" (
    echo ERRO: toolchain do vcpkg nao encontrado.
    echo   %VCPKG_ROOT%\scripts\buildsystems\vcpkg.cmake
    goto :result_error
)

set "VCPKG_DEFAULT_TRIPLET=%TRIPLET%"
set "VCPKG_DEFAULT_HOST_TRIPLET=%TRIPLET%"
set "VCPKG_BINARY_SOURCES=clear"

if exist "C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe" set "MSBUILD_EXE=C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe"
if not defined MSBUILD_EXE if exist "C:\Program Files\Microsoft Visual Studio\2022\Professional\MSBuild\Current\Bin\MSBuild.exe" set "MSBUILD_EXE=C:\Program Files\Microsoft Visual Studio\2022\Professional\MSBuild\Current\Bin\MSBuild.exe"
if not defined MSBUILD_EXE if exist "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\MSBuild.exe" set "MSBUILD_EXE=C:\Program Files\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\MSBuild.exe"
if not defined MSBUILD_EXE if exist "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\Bin\MSBuild.exe" set "MSBUILD_EXE=C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\Bin\MSBuild.exe"
if not defined MSBUILD_EXE for /f "delims=" %%I in ('where MSBuild.exe 2^>nul') do if not defined MSBUILD_EXE set "MSBUILD_EXE=%%I"

if not defined MSBUILD_EXE (
    echo ERRO: MSBuild.exe nao encontrado.
    goto :result_error
)

if exist "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" set "VS_VCVARSALL=C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat"
if not defined VS_VCVARSALL if exist "C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build\vcvarsall.bat" set "VS_VCVARSALL=C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build\vcvarsall.bat"
if not defined VS_VCVARSALL if exist "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvarsall.bat" set "VS_VCVARSALL=C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvarsall.bat"
if not defined VS_VCVARSALL if exist "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvarsall.bat" set "VS_VCVARSALL=C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvarsall.bat"

if not defined VS_VCVARSALL goto :no_vcvars
echo Preparando ambiente do Visual Studio (%PLATFORM%)...
call "%VS_VCVARSALL%" %PLATFORM% >nul
goto :after_vcvars

:no_vcvars
echo AVISO: vcvarsall.bat nao encontrado. Tentando com ambiente atual.

:after_vcvars
echo.
echo Usando MSBuild:
echo   %MSBUILD_EXE%
echo VCPKG_ROOT:
echo   %VCPKG_ROOT%
echo.

echo Instalando dependencias do vcpkg (manifest)...
"%VCPKG_ROOT%\vcpkg.exe" install --x-wait-for-lock --triplet "%TRIPLET%" --x-manifest-root="%ROOT_DIR%" --x-install-root="%ROOT_DIR%\vcproj\vcpkg_installed"
if not "%ERRORLEVEL%"=="0" goto :result_error

echo Compilando solucao com MSBuild...
"%MSBUILD_EXE%" "%SOLUTION%" /m /verbosity:minimal /t:Build /p:Configuration=%CONFIG% /p:Platform=%PLATFORM% /p:VcpkgEnableManifest=true /p:VcpkgManifestInstall=false /p:VcpkgTriplet=%TRIPLET% /p:VcpkgHostTriplet=%TRIPLET% /p:VcpkgConfiguration=Release /p:UseMultiToolTask=true
set "BUILD_EXIT=%ERRORLEVEL%"

if not "%BUILD_EXIT%"=="0" goto :result_error

echo.
echo ========================================
echo   BUILD OK
echo ========================================
echo Possiveis binarios na raiz do projeto:
echo   %SCRIPT_DIR%crystalserver-%PLATFORM%.exe
echo   %SCRIPT_DIR%crystalserver-%PLATFORM%-dbg.exe
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

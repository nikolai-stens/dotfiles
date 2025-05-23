@echo off

REM TODO - can we just build both with one exe? 

call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" x64 > nul
set path=w:\handmade\misc;%path%

REM glew stuff
set INCLUDE=C:\vcpkg\installed\x64-windows\include;%INCLUDE%
set LIB=C:\vcpkg\installed\x64-windows\lib;%LIB% 

REM glfw3 stuff
set INCLUDE=C:\vcpkg\installed\x64-windows-static\include;%INCLUDE%
set LIB=C:\vcpkg\installed\x64-windows-static\lib;%LIB% 
REM set PATH=C:\vcpkg\installed\x64-windows-static\bin;%PATH%

REM uuid.lib
set LIB=%LIB%;"c:\Program Files (x86)\Windows Kits\10\Lib\10.0.20348.0\um\x64"


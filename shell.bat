@echo off

REM Legg til i "target" i properies til cmd (win10) eller i Settings->command line->command line (win11)
REM %windir%\system32\cmd.exe /k w:\dotfiles\shell.bat

REM å kjøre vcvarsall/vcvars64 tar sykt lang tid, bedre å bare lagre env som man faktisk trenger, og så kun laste inn det

 if not exist W:\cl_env.txt (
     REM call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" x64 > nul
     call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat" > nul
     set > W:\cl_env.txt
 )
 
 for /f "tokens=1,* delims==" %%A in (W:\cl_env.txt) do (
     set "%%A=%%B")

if exist w:\dotfiles set PATH=%PATH%;w:\dotfiles
if exist w:\opengl\include set INCLUDE=%INCLUDE%;w:\opengl\include
if exist w:\opengl\lib set LIB=%LIB%;w:\opengl\lib

REM REM glew stuff
REM set INCLUDE=C:\vcpkg\installed\x64-windows\include;%INCLUDE%
REM set LIB=C:\vcpkg\installed\x64-windows\lib;%LIB% 
REM 
REM REM glfw3 stuff
REM set INCLUDE=C:\vcpkg\installed\x64-windows-static\include;%INCLUDE%
REM set LIB=C:\vcpkg\installed\x64-windows-static\lib;%LIB% 
REM REM set PATH=C:\vcpkg\installed\x64-windows-static\bin;%PATH%
REM 
REM REM uuid.lib
REM set LIB=%LIB%;"c:\Program Files (x86)\Windows Kits\10\Lib\10.0.20348.0\um\x64"
REM 

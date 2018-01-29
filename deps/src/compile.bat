@echo off

echo %~dp0VC

set VCPOS=%USERPROFILE%\AppData\Local\Programs\Common\Microsoft\Visual C++ for Python\9.0
set VCINSTALLDIR=%VCPOS%\VC\
set WindowsSdkDir=%VCPOS%\WinSDK\
if not exist "%VCINSTALLDIR%Bin\amd64\cl.exe" goto missing
set PATH=%VCINSTALLDIR%Bin\amd64;%WindowsSdkDir%Bin\x64;%WindowsSdkDir%Bin;%PATH%
set INCLUDE=%VCINSTALLDIR%Include;%WindowsSdkDir%Include;%INCLUDE%
set LIB=%VCINSTALLDIR%Lib\amd64;%WindowsSdkDir%Lib\x64;%LIB%
set LIBPATH=%VCINSTALLDIR%Lib\amd64;%WindowsSdkDir%Lib\x64;%LIBPATH%

if "%1" == "" goto all

if /i %1 == all       goto all
if /i %1 == clean     goto all
if /i %1 == compile   goto compile

:all
nmake -f makefile.win clean 
if /i %1 == clean     goto :eof

:compile
nmake -f makefile.win
goto :eof

:missing
echo The specified configuration type is missing.  The tools for the
echo configuration might not be installed.
goto :eof
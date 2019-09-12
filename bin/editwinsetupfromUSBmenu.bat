@echo off

rem >> https://niemtin007.blogspot.com
rem >> The batch file is written by niemtin007.
rem >> Thank you for using Multiboot Toolkit.

title %~nx0
cd /d "%bindir%"
mode con lines=6 cols=70

if not exist "%ducky%\WINSETUP\" (
    color 4f & echo.
    echo ^>^> Please install winsetup module before running me
    timeout /t 15 >nul & exit
)

:option
call "%bindir%\colortool.bat"
echo                ^	^>^> WINSETUP BOOT MANAGER EDITOR  ^<^<
echo                -------------------------------------
echo.
set mode=
set /P mode= ^*              [ 1 ] Legacy mode - [ 2 ] UEFI mode ^> 
if "%mode%"=="1" goto :legacy
if "%mode%"=="2" goto :uefi
color 4f & echo. & echo ^>^>  Invalid Input. & timeout /t 15 >nul & goto :option

:legacy
"%bindir%\bootice.exe" /edit_bcd /easymode /file=%ducky%\BOOT\bcd
call "%bindir%\exit.bat"

:uefi
"%bindir%\bootice.exe" /edit_bcd /easymode /file=%ducky%\EFI\MICROSOFT\Boot\bcd
call "%bindir%\exit.bat"

@echo off

rem >> https://niemtin007.blogspot.com
rem >> The batch file is written by niemtin007.
rem >> Thank you for using Multiboot Toolkit.

title %~nx0
cd /d "%~dp0"
set "skipscan=true"
set "curdir=%~dp0"
set "bindir=%~dp0bin"
if not exist "bin" (
    color 4f & echo.
    echo ^>^> Warning: Data Loss
    timeout /t 15 >nul & exit
) else (
    call "%bindir%\colortool.bat"
    call "%bindir%\permissions.bat"
    call "%bindir%\multibootscan.bat"
    call "%bindir%\language.bat"
    call "%bindir%\partassist.bat"
)

:main
> "%tmp%\hide.vbs" (
    echo.
    echo Dim Args^(^)
    echo ReDim Args^(WScript.Arguments.Count - 1^)
    echo.
    echo For i = 0 To WScript.Arguments.Count - 1
    echo     Args^(i^) = """" ^& WScript.Arguments^(i^) ^& """"
    echo Next
    echo.
    echo CreateObject^("WScript.Shell"^).Run Join^(Args^), 0, False
)
cls & echo.
echo =====================================================================
echo %_lang0819_%
echo =====================================================================
echo  [ 01 ] = %_lang0821_% [ 09 ] = %_lang0829_%
echo  [ 02 ] = %_lang0822_% [ 10 ] = %_lang0830_%
echo  [ 03 ] = %_lang0823_% [ 11 ] = %_lang0831_%
echo  [ 04 ] = %_lang0824_% [ 12 ] = %_lang0832_%
echo  [ 05 ] = %_lang0825_% [ 13 ] = %_lang0833_%
echo  [ 06 ] = %_lang0826_% [ 14 ] = %_lang0834_%
echo  [ 07 ] = %_lang0827_% [ 15 ] = %_lang0835_%
echo  [ 08 ] = %_lang0828_% [ 16 ] = %_lang0836_%
echo =====================================================================
echo.
set "option=14" rem set default
set /p option= %_lang0905_% [ ? ] = 
cd /d "%bindir%"
if "%offline%"=="0" goto :online
if "%offline%"=="1" goto :offline

:online
if "%option%"=="1"  call "Grub2Theme.bat"
if "%option%"=="2"  call "rEFIndTheme.bat"
if "%option%"=="3"  call "CloverInstaller.bat"
if "%option%"=="4"  call "rEFIndInstaller.bat"
if "%option%"=="5"  call "SetDefaultBoot.bat"
if "%option%"=="6"  call "EditWinPEBootManager.bat"
if "%option%"=="7"  call "EditWinSetupFromUSBMenu.bat"
if "%option%"=="8"  call "grub2-filemanager.bat"
if "%option%"=="9"  call "FixBootloader.bat"
if "%option%"=="10" call "UnhideDataPartition.bat"
if "%option%"=="11" call "EaseConvertdisk.bat"
if "%option%"=="12" "%tmp%\hide.vbs" "NTFSDriveProtect.bat" & exit
if "%option%"=="13" call "ChangeLanguage.bat"
if "%option%"=="14" "%tmp%\hide.vbs" "QemuBootTester.bat" & exit
if "%option%"=="15" call "UpdateMultiboot.bat"
if "%option%"=="16" call "sortgrub2menu.bat"
color 4f & echo. & echo %_lang0003_% & timeout /t 15 >nul & goto :main

:Offline
if "%option%"=="3"  call "CloverInstaller.bat"
if "%option%"=="4"  call "rEFIndInstaller.bat"
if "%option%"=="8"  call "grub2-filemanager.bat"
if "%option%"=="10" call "UnhideDataPartition.bat"
if "%option%"=="11" call "EaseConvertdisk.bat"
if "%option%"=="14" "%tmp%\hide.vbs" "QemuBootTester.bat" & exit
color 4f & echo. & echo %_lang0003_% & timeout /t 15 >nul & goto :main


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
echo                       ^> EXTRA FEATURES MENU ^<                      
echo =====================================================================
echo  [ 01 ] = Grub2  Theme                [ 09 ] = Fix Bootloader        
echo  [ 02 ] = rEFInd Theme                [ 10 ] = Unhide Data Partition 
echo  [ 03 ] = Clover Installer            [ 11 ] = Ease and Convert disk 
echo  [ 04 ] = rEFInd Installer            [ 12 ] = NTFS Drive Protect    
echo  [ 05 ] = Set Default Boot (UEFI)     [ 13 ] = Change Language       
echo  [ 06 ] = Edit WinPE Boot Manager     [ 14 ] = Qemu Boot Tester      
echo  [ 07 ] = Edit WinSetupFromUSB Menu   [ 15 ] = Update Multiboot      
echo  [ 08 ] = Update Grub2-filemanager    [ 16 ] = Update grub4dos       
echo =====================================================================
echo.
set "option=14" rem set default
set /p option= ^> %_lang0905_% [ ? ] = 
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
if "%option%"=="16" call "update-grub4dos.bat"
color 4f & echo. & echo %_lang0003_% & timeout /t 15 >nul & goto :main

:Offline
if "%option%"=="3"  call "CloverInstaller.bat"
if "%option%"=="4"  call "rEFIndInstaller.bat"
if "%option%"=="8"  call "grub2-filemanager.bat"
if "%option%"=="10" call "UnhideDataPartition.bat"
if "%option%"=="11" call "EaseConvertdisk.bat"
if "%option%"=="14" "%tmp%\hide.vbs" "QemuBootTester.bat" & exit
color 4f & echo. & echo %_lang0003_% & timeout /t 15 >nul & goto :main


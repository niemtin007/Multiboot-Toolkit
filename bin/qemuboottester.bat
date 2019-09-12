@echo off

rem >> https://niemtin007.blogspot.com
rem >> The batch file is written by niemtin007.
rem >> Thank you for using Multiboot Toolkit.

rem title %~nx0
rem pushd "%cd%"
rem cd /d "%bindir%"
rem echo. & echo ^> Preparing file... Please wait...
rem 7za x "qemu.7z" -o"%tmp%" -aos -y >nul
rem mode con lines=11 cols=45
rem :main
rem cls
rem echo.
rem echo          ###  QEMU BOOT TESTER  ###
rem echo.
rem echo ============================================
rem echo   [ 1 ] = Legacy BIOS   [ 3 ] = UEFI 32bit  
rem echo   [ 2 ] = UEFI 64 bit   [ 4 ] = Gui Mode    
rem echo ============================================
rem echo.
rem cd /d "%tmp%\QemuBootTester"
rem set "option=1" rem set default
rem set /p option= ^> Option [ ? ] = 
rem if "%option%"=="1" goto :LegacyBIOS
rem if "%option%"=="2" goto :UEFIx64
rem if "%option%"=="3" goto :UEFIx32
rem if "%option%"=="4" goto :guimode
rem color 4f & goto :main
rem 
rem :LegacyBIOS
rem if "%offline%"=="1" goto :guimode
rem qemu-system-x86_64 -m 768 -smp 1 -vga std -hda \\.\PhysicalDrive%disk% -boot c
rem exit
rem 
rem :UEFIx64
rem if "%offline%"=="1" goto :guimode
rem qemu-system-x86_64 -m 768 -smp 1 -bios efi64.fd -hda \\.\PhysicalDrive%disk% -boot c
rem exit
rem 
rem :UEFIx32
rem if "%offline%"=="1" goto :guimode
rem qemu-system-x86_64 -m 768 -smp 1 -bios efi32.fd -hda \\.\PhysicalDrive%disk% -boot c
rem exit
rem 
rem :guimode
rem cd /d "%bindir%"
rem     start QemuBootTester.exe
rem     exit






title %~nx0
cls 
mode con lines=1 cols=10
echo.
echo ^>^> Cleaning up trash, wait a minute...
echo.
cd /d "%tmp%"
    del "%tmp%\*.*" /s /q /f >nul
    for /d %%i in ("%tmp%\*.*") do rmdir "%%i" /s /q >nul
    cls
cd /d "%bindir%"
    7za x "qemu.7z" -o"%tmp%" -aoa -y >nul
cd /d "%tmp%"
    start qemuboottester.exe
    exit






rem for /f "skip=1" %%i in ('wmic computersystem get totalphysicalmemory') do (
rem     set totalram=%%i
rem     goto :break1
rem )
rem :break1
rem for /f "skip=1" %%i in ('wmic os get freephysicalmemory') do (
rem     set freeram=%%i
rem     goto :break2
rem )
rem :break2

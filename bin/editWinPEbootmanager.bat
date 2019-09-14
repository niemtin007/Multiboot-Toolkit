@echo off

rem >> https://niemtin007.blogspot.com
rem >> The batch file is written by niemtin007.
rem >> Thank you for using Multiboot Toolkit.

title %~nx0

cd /d "%ducky%\BOOT"
    if exist "secureboot" (
        for /f "tokens=*" %%b in (secureboot) do set "secureboot=%%b"
    )

:option
call "%bindir%\colortool.bat"
echo.
echo            ^	^>^> MINI WINDOWS BOOT MANAGER EDITOR ^<^<
echo                 --------------------------------------
echo.
choice /c yn /cs /n /m "*               Do you want to add new menu? (y/n) > "
    if errorlevel 2 goto :option-2
    if errorlevel 1 call bcdautomenu.bat
:option-2
echo.
choice /c 12 /cs /n /m "*               [ 1 ] Legacy mode  [ 2 ] UEFI mode > "
    if errorlevel 2 goto :uefi3264bit
    if errorlevel 1 goto :legacy3264bit

:legacy3264bit
set "source=%ducky%\BOOT\bootmgr\B84"
echo.
echo ^*               Source^: %source%
"%bindir%\bootice.exe" /edit_bcd /easymode /file=%source%
call "%bindir%\exit.bat"

:uefi3264bit
call :check.virtualdisk
    if "%virtualdisk%"=="true" goto :External
call :check.harddisk
    if "%harddisk%"=="true" goto :External
call :check.usbdisk
    if "%usb%"=="true" goto :Removable
call :check.externaldisk
    if "%externaldisk%"=="true" goto :External

:Removable
if "%secureboot%"=="n" (
    set refindpart=1
    goto :installbcd
) else (
    set refindpart=2
    set securepart=1
    goto :installbcd
)

:External
if "%secureboot%"=="n" (
    set refindpart=0
    goto :installbcd
) else (
    set refindpart=1
    set securepart=0
    goto :installbcd
)

:installbcd
rem >> open Configuration BCD file...
if "%secureboot%"=="n" (
    set "source=%ducky%\EFI\Microsoft\Boot\bcd"
) else (
    set "source=%bindir%\secureboot\EFI\Microsoft\Boot\bcd"
)
echo.
echo ^*               Source^: %source%

"%bindir%\bootice.exe" /edit_bcd /easymode /file="%source%"

rem >> copy Configuration BCD file to the destination...
rem if not "%virtualdisk%"=="true" (
rem     call "%bindir%\bcdautoset.bat"
rem )

rem if not "%secureboot%"=="n" (
rem     %partassist% /hd:%disk% /whide:%securepart% /src:%source% /dest:EFI\Microsoft\Boot
rem )

call "%bindir%\exit.bat"



rem >> begin functions
:check.partitiontable
for /f "tokens=2" %%b in ('wmic path win32_diskpartition get type ^, diskindex ^| find /i "%disk%"') do set "GPT=%%b"
exit /b 0

:check.virtualdisk
wmic diskdrive get name, model | find /i "Msft Virtual Disk SCSI Disk Device" | find /i "\\.\physicaldrive%disk%" > nul
    if not errorlevel 1 set "virtualdisk=true"
wmic diskdrive get name, model | find /i "Microsoft Virtual Disk" | find /i "\\.\physicaldrive%disk%" > nul
    if not errorlevel 1 set "virtualdisk=true"
wmic diskdrive get name, model | find /i "Microsoft Sanal Diski" | find /i "\\.\physicaldrive%disk%" > nul
    if not errorlevel 1 set "virtualdisk=true"
exit /b 0

:check.harddisk
wmic diskdrive get name, mediatype | find /i "Fixed hard disk media" | find /i "\\.\physicaldrive%disk%" > nul
    if not errorlevel 1 (
        set "harddisk=true"
        echo. & echo. & echo %_lang0102_%
        color 4f & echo %_lang0103_% & timeout /t 15 > nul & cls
    )
exit /b 0

:check.usbdisk
wmic diskdrive get name, mediatype | find /i "Removable Media" | find /i "\\.\physicaldrive%disk%" > nul
    if not errorlevel 1 set "usb=true"
exit /b 0

:check.externaldisk
wmic diskdrive get name, mediatype | find /i "External hard disk media" | find /i "\\.\physicaldrive%disk%" > nul
    if not errorlevel 1 set "externaldisk=true"
exit /b 0
rem >> end functions

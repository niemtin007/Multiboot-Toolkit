@echo off

rem >> https://niemtin007.blogspot.com
rem >> The batch file is written by niemtin007.
rem >> Thank you for using Multiboot Toolkit.

title %~nx0
pushd "%cd%"
cd /d "%bindir%"
mode con lines=18 cols=70

:Select
cd /d "%bindir%"
    call colortool.bat
%partassist% /list
echo.
set /p disk= %_lang0101_%
set /a disk=%disk%+0
call :check.virtualdisk
    if "%virtualdisk%"=="true" goto :continue
call :check.harddisk
    if "%harddisk%"=="true" goto :Select
call :check.usbdisk
    if "%usb%"=="true" goto :continue
call :check.externaldisk
    if "%externaldisk%"=="true" goto :continue
color 4f & echo. & echo %_lang0104_% & timeout /t 15 > nul & goto :Select

:continue
for /f %%b in ('wmic volume get driveletter^, label ^| findstr /i "MULTIBOOT"') do set "ducky=%%b"
    set /a partition=0
    if exist "%ducky%\EFI\BOOT\mark" (
        goto :break
    ) else (
        goto :unhidepartition
    )
:unhidepartition
%partassist% /hd:%disk% /unhide:%partition%
%partassist% /hd:%disk% /setletter:%partition% /letter:auto
for /f %%b in ('wmic volume get driveletter^, label ^| findstr /i "MULTIBOOT"') do set "ducky=%%b"
    if not exist "%ducky%\EFI\BOOT\mark" (
        %partassist% /hd:%disk% /hide:%partition%
        set /a partition=%partition%+1
        goto :unhidepartition
    ) else (
        goto :break
    )
:break
for /f "tokens=*" %%b in (%ducky%\EFI\BOOT\mark) do set "author=%%b"
    if "%author%"=="niemtin007" (
        call "%bindir%\exit.bat"
    )




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

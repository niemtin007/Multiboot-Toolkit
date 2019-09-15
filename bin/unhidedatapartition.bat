@echo off

rem >> https://niemtin007.blogspot.com
rem >> The batch file is written by niemtin007.
rem >> Thank you for using Multiboot Toolkit.

title %~nx0
cd /d "%bindir%"

:Select
cd /d "%bindir%"
    call colortool.bat
%partassist% /list
echo.
set /p disk= %_lang0101_%
set /a disk=%disk%+0
cd /d "%bindir%"
    call checkdisktype.bat
    if "%virtualdisk%"=="true"  goto :continue
    if "%harddisk%"=="true"     goto :Select
    if "%usb%"=="true"          goto :continue
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

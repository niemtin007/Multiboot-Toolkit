@echo off

rem >> https://niemtin007.blogspot.com
rem >> The batch file is written by niemtin007.
rem >> Thank you for using Multiboot Toolkit.

title %~nx0
mode con lines=3 cols=20

cd /d "%bindir%"
    7za x "driveprotect.7z" -o"%tmp%" -aos -y > nul
    if "%processor_architecture%" == "x86" (
        set DriveProtect=driveprotect.exe
    ) else (
        set DriveProtect=driveprotectx64.exe
    )
cd /d "%tmp%\driveprotect"
    start %DriveProtect%
    exit

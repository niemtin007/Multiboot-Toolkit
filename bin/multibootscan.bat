@echo off

rem >> https://niemtin007.blogspot.com
rem >> The batch file is written by niemtin007.
rem >> Thank you for using Multiboot Toolkit.

> "%tmp%\identify.vbs" (
    echo Dim Message, Speak
    echo Set Speak=CreateObject^("sapi.spvoice"^)
    echo Speak.Speak "Multiboot Drive Found"
)

:while
for /f %%b in ('wmic volume get driveletter^, label ^| findstr /i "MULTIBOOT"') do set "ducky=%%b"
    if not exist "%ducky%\EFI\BOOT\mark" goto :progress
    for /f "tokens=*" %%b in (%ducky%\EFI\BOOT\mark) do set "author=%%b"
    if not defined author (
        set "offline=0"
        goto :progress
    ) else (
        cd /d "%tmp%" & start identify.vbs
        cls & echo. & echo ^>^> Multiboot Drive Found ^^^^ & timeout /t 2 >nul
        goto :break
    )
    :progress
        if "%skipscan%"=="true" set "offline=1" & goto :EOF
        cls & echo ^> Connecting   & timeout /t 1 >nul
        cls & echo ^> Connecting.  & timeout /t 1 >nul
        cls & echo ^> Connecting.. & timeout /t 1 >nul
        cls & echo ^> Connecting...& timeout /t 1 >nul
    goto :while

:break
if not "%author%"=="niemtin007" (
    cls & color 4f & echo.
    echo ^>^> Run [ 01 ] Install Multiboot.bat to reinstall & timeout /t 15 >nul & exit
)
for /f "tokens=2 delims= " %%b in ('wmic path win32_logicaldisktopartition get antecedent^, dependent ^| find "%ducky%"') do set "disk=%%b"
    set "disk=%disk:~1,1%"
    set /a disk=%disk%+0
for /f "tokens=3 delims=#" %%b in ('wmic partition get name ^| findstr /i "#%disk%,"') do set "partition=%%b"
    set /a partition=%partition%+0

del /s /q "%tmp%\identify.vbs" >nul

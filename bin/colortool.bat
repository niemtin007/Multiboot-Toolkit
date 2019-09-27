@echo off

rem >> https://niemtin007.blogspot.com
rem >> The batch file is written by niemtin007.
rem >> Thank you for using Multiboot Toolkit.

cls
mode con lines=18 cols=70

cd /d "%bindir%"
    set /a num=%random% %%117 +1
    set "itermcolors=%num%.itermcolors"
    if "%color%"=="true" goto :skipcheck
    7za x "colortool.7z" -o"%tmp%" -aos -y > nul

rem Check for DotNet 4.0 Install
cd /d "%tmp%\colortool"
    set "checkdotnet=%temp%\Output.log"
    reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP" /s | find "v4" > %checkdotnet%
        if %errorlevel% equ 0 (
            colortool -b -q %itermcolors%
            set "color=true"
            goto :exit
        ) else (
            set "color=false"
            goto :exit
        )

:skipcheck
cd /d "%tmp%\colortool"
    colortool -b -q %itermcolors%

:exit
rem echo colortool %itermcolors%
rem timeout /t 2 >nul
cls
cd /d "%bindir%"
mode con lines=18 cols=70

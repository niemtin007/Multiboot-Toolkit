@echo off

rem >> https://niemtin007.blogspot.com
rem >> The batch file is written by niemtin007.
rem >> Thank you for using Multiboot Toolkit.

cls
echo.
cd /d "%bindir%"
    echo ^>^> Loading, Please wait...
    7za x "partassist.7z" -o"%tmp%" -aos -y > nul
    set partassist="%tmp%\partassist\partassist.exe"
    set bootice="%bindir%\bootice.exe"
cd /d "%tmp%\partassist"
    if "%processor_architecture%"=="x86" (
        SetupGreen32.exe -i > nul
        LoadDrv_Win32.exe -i > nul
    ) else (
        SetupGreen64.exe -i > nul
        LoadDrv_x64.exe -i > nul
    )

>"%tmp%\partassist\cfg.ini" (
    echo [Language]
    echo LANGUAGE=lang\%langpa%.txt;%langcode%
    echo LANGCHANGED=1
    echo [Version]
    echo Version=4
    echo [Product Version]
    echo v=2
    echo Lang=%langpa%
    echo [CONFIG]
    echo COUNT=2
    echo KEY=AOPR-21ROI-6Y7PL-Q4118
    echo [PA]
    echo POPUPMESSAGE=1
)

> "%tmp%\partassist\winpeshl.ini" (
    echo [LaunchApp]
    echo AppPath=%tmp%\partassist\PartAssist.exe
)

cls

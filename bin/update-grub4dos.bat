@echo off

rem >> https://niemtin007.blogspot.com
rem >> The batch file is written by niemtin007.
rem >> Thank you for using Multiboot Toolkit.

cd /d "%bindir%"
    7za x "wget.7z" -o"%tmp%" -aoa -y >nul

cd /d "%tmp%"
    wget -q -O g4dtemp.log  http://grub4dos.chenall.net > nul
    for /f "tokens=2,3 delims=/" %%a in ('type "g4dtemp.log" ^| findstr /i "<h1.*.7z" ^| find /n /v "" ^| find "[1]"') do (
            set "ver=%%b"
            set "sourcelink=http://dl.grub4dos.chenall.net/%%b.7z"
    )
    echo.
    echo ^> Downloading %ver%...
    timeout /t 3 >nul

    wget -q -O grub4dos.7z %sourcelink% >nul
    del g4dtemp.log

cd /d "%bindir%\extra-modules"
    "%bindir%\7za.exe" e -ogrub4dos -aoa "%tmp%\grub4dos.7z" grub4dos-0.4.6a/grldr grub4dos-0.4.6a/grub.exe grub4dos0.4.6a/grldr_cd.bin >nul
    del /s /q "%tmp%\grub4dos.7z" > nul

    echo.
    echo ^> Updating grub4dos to Multiboot device...
    xcopy "grub4dos\grldr" "%ducky%\" /e /g /h /r /y /q

timeout /t 3 >nul

call "%bindir%\hidefile.bat"
call "%bindir%\exit.bat"
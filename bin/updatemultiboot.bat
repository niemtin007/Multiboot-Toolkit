@echo off

rem >> https://niemtin007.blogspot.com
rem >> The batch file is written by niemtin007.
rem >> Thank you for using Multiboot Toolkit.

title %~nx0
mode con lines=18 cols=70
rem >> Preparing files...
cd /d "%ducky%\BOOT"
    for /f "tokens=*" %%b in (lang) do set "lang=%%b"
    echo. & echo ^> Found current language is %lang%
    for /f "tokens=*" %%b in (rEFInd) do set "rtheme=%%b"
        if not defined rtheme (
            set rtheme=Universe
        ) else (
            echo. & echo ^> Found current rEFInd theme is %rtheme%
        )
    if exist secureboot (
        for /f "tokens=*" %%b in (secureboot) do set "secureboot=%%b"
    )
cd /d "%ducky%\BOOT\grub\themes"
    for /f "tokens=*" %%b in (theme) do set "gtheme=%%b"
        if not defined gtheme (
            set gtheme=Breeze-5
        ) else (
            echo. & echo ^> Found current grub2 theme is %gtheme%
        )
cd /d "%bindir%"
    7za x "grub2.7z" -o"%tmp%" -aos -y >nul
    7za x "rEFInd_themes\%rtheme%.7z" -o"%tmp%\rEFInd_themes" -aoa -y > nul
    7za x "refind.7z" -o"%tmp%" -aoa -y > nul
    call colortool.bat

rem if not exist "%ducky%\EFI\BOOT\version" (
rem     cls & color 4f & echo.
rem     echo %_lang0500_%
rem     timeout /t 15 >nul & exit
rem )

rem cd /d "%bindir%"
rem     for /f "tokens=*" %%b in (version) do set /a "cur_version=%%b"
rem cd /d "%ducky%\EFI\BOOT\"
rem     for /f "tokens=*" %%b in (version) do set /a "version=%%b"
rem if %cur_version% LEQ %version% (
rem     cls & color 4f & echo.
rem     echo %_lang0501_%
rem     echo %_lang0502_% & timeout /t 15 >nul & exit
rem )

cd /d "%bindir%"
    echo. & echo ^> Updating data...
    "%bindir%\7za.exe" x "data.7z" -o"%ducky%\" -aoa -y >nul
    xcopy /y "version" "%ducky%\EFI\BOOT\" > nul
cd /d "%bindir%"
    7za x "wincdemu.7z" -o"%ducky%\ISO\" -aoa -y >nul
cd /d "%bindir%\secureboot\BOOT"
    xcopy "boot.sdi" "%ducky%\BOOT\" /e /g /h /r /y /q > nul
cd /d "%bindir%\extra-modules"
    xcopy "grub4dos\grldr" "%ducky%\" /e /g /h /r /y /q >nul
    call "%bindir%\hidefile.bat"
cd /d "%bindir%\extra-modules"
    "%bindir%\7za.exe" x "grub2-filemanager.7z" -o"%ducky%\BOOT\grub\" -aoa -y > nul
rem >> install Syslinux Bootloader
cd /d "%bindir%"
    syslinux --force --directory /BOOT/syslinux %ducky% %ducky%\BOOT\syslinux\syslinux.bin
rem >> install grub2 Bootloader
cd /d "%bindir%"
    echo.
    echo ^> Installing Grub2 Bootloader...
    set "destination=MULTIBOOT"
    silentcmd grub2installer.bat
cd /d "%bindir%"
    7za x "%bindir%\config\%lang%.7z" -o"%ducky%\" -aoa -y > nul
cd /d "%tmp%\rEfind_themes\%rtheme%\icons"
    copy "grubx64.png" "%ducky%\EFI\BOOT\grubx64.png" > nul
    copy "grubx64.png" "%ducky%\EFI\BOOT\grubia32.png" > nul
    copy "winsetupx64.png" "%ducky%\EFI\BOOT\winsetupx64.png" > nul
    copy "winsetupx64.png" "%ducky%\EFI\BOOT\winsetupia32.png" > nul
    copy "xorbootx64.png" "%ducky%\EFI\BOOT\xorbootx64.png" > nul
cd /d "%tmp%\rEfind_themes\%rtheme%\icons"
    xcopy "others" "%ducky%\EFI\BOOT\" /e /g /h /r /y /q > nul
cd /d "%bindir%"
    7za x "%bindir%\grub2_themes\%gtheme%.7z" -o"%ducky%\BOOT\grub\themes\" -aoa -y > nul
cd /d "%bindir%\config"
    call "main.bat" & call "smartfinn.bat"
cd /d "%ducky%\EFI\Microsoft\Boot"
    call "%bindir%\bcdautoset.bat" bcd
    timeout /t 2 >nul
    call "%bindir%\exit.bat"

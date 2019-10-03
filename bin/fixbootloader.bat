@echo off

rem >> https://niemtin007.blogspot.com
rem >> The batch file is written by niemtin007.
rem >> Thank you for using Multiboot Toolkit.

title %~nx0
cd /d "%bindir%"
mode con lines=15 cols=70

cd /d "%ducky%\BOOT"
    if exist "secureboot" (
        for /f "tokens=*" %%b in (secureboot) do set "secureboot=%%b"
    )
cd /d "%ducky%"
    if exist boot (ren boot BOOT > nul)
cd /d "%ducky%\boot"
    if exist grub_old (rename grub_old grub)
    if exist efi (rename efi EFI > nul)
cd /d "%ducky%\EFI"
    if exist boot (rename boot BOOT > nul)
    if exist microsoft (rename microsoft MICROSOFT > nul)
if exist "%ducky%\WINSETUP" (
    goto :WINSETUP
) else (
    goto :grub
)
:WINSETUP
cd /d "%ducky%\efi\boot"
    copy /y backup\WinSetup\winsetupx64.efi %ducky%\efi\boot\ > nul
    copy /y backup\WinSetup\winsetupia32.efi %ducky%\efi\boot\ > nul
    xcopy /y /q /h /r %ducky%\BOOT\grub\menu.lst %ducky%\ > nul
    if exist %ducky%\winsetup.lst (del /S /Q /F %ducky%\winsetup.lst > nul)

:grub
echo.
choice /c yn /cs /n /m "%_lang0837_%"
    if errorlevel 2 goto :grub2
    if errorlevel 1 goto :grub4dos
:grub4dos
cd /d "%bindir%"
    7za x "wget.7z" -o"%tmp%" -aoa -y >nul
cd /d "%tmp%"
    wget -q -O g4dtemp.log  http://grub4dos.chenall.net > nul
    for /f "tokens=2,3 delims=/" %%a in ('type "g4dtemp.log" ^| findstr /i "<h1.*.7z" ^| find /n /v "" ^| find "[1]"') do (
            set "ver=%%b"
            set "sourcelink=http://dl.grub4dos.chenall.net/%%b.7z"
    )
    echo ^  Updating %ver%...
    wget -q -O grub4dos.7z %sourcelink% >nul
    del g4dtemp.log
cd /d "%bindir%\extra-modules"
    "%bindir%\7za.exe" e -ogrub4dos -aoa "%tmp%\grub4dos.7z" grub4dos-0.4.6a/grldr grub4dos-0.4.6a/grub.exe grub4dos0.4.6a/grldr_cd.bin >nul
    del /s /q "%tmp%\grub4dos.7z" > nul
    xcopy "grub4dos\grldr" "%ducky%\" /e /g /h /r /y /q > nul

:grub2
echo.
choice /c yn /cs /n /m "%_lang0503_%"
    if errorlevel 2 goto :config
    if errorlevel 1 (
    cd /d "%bindir%"
        echo %_lang0504_%
        silentcmd grub2installer.bat MULTIBOOT
        rem wscript invisiblecmd.vbs grub2installer.bat MULTIBOOT
    )

:config
cd /d "%ducky%\BOOT\"
    for /f "tokens=*" %%b in (lang) do set "lang=%%b"
cd /d "%ducky%\BOOT\grub\themes"
    for /f "tokens=*" %%b in (theme) do set "gtheme=%%b"
cd /d "%bindir%\config\"
    call "main.bat"
cd /d "%ducky%\EFI\Microsoft\Boot"
    call "%bindir%\bcdautoset.bat" bcd
rem >> install Syslinux Bootloader
"%bindir%\syslinux.exe" --force --directory /BOOT/syslinux %ducky% %ducky%\BOOT\syslinux\syslinux.bin
rem >> install Syslinux Bootloader
if exist "%ducky%\DLC1" (
"%bindir%\syslinux.exe" --force --directory /DLC1/Boot %ducky% %ducky%\DLC1\Boot\syslinux.bin
)
rem --------------------------------------------------------------------
"%bindir%\7za.exe" x "%bindir%\config\%lang%.7z" -o"%ducky%\" -aoa -y > nul
cd /d "%bindir%\extra-modules"
    "%bindir%\7za.exe" x "grub2-filemanager.7z" -o"%ducky%\BOOT\grub\" -aoa -y >nul
    >"%ducky%\BOOT\grub\lang.sh" (echo export lang=%langfm%;)
call "%bindir%\hidefile.bat"
rem set "source=%bindir%\secureboot"
rem if not "%secureboot%"=="n" (
rem     %partassist% /hd:%disk% /whide:0 /src:%source% /dest:
rem ) else (
rem     cd /d "%bindir%"
rem         xcopy "secureboot" "%ducky%\" /e /g /h /r /y /q > nul
rem )
call "%bindir%\exit.bat"


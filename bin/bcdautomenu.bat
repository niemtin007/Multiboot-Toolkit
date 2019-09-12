@echo off

rem >> https://niemtin007.blogspot.com
rem >> The batch file is written by niemtin007.
rem >> Thank you for using Multiboot Toolkit.

mode con lines=100 cols=70

> "%tmp%\winpemenu.txt" (
echo.
echo ^>^>     Example WinPE Legacy BIOS entries
echo        ---------------------------------
echo [ 01 ] Boot Win10PE SE          64bit
echo [ 02 ] Boot Win8PE              64bit
echo [ 03 ] Hiren’s BootCD PE        64bit
echo [ 04 ] Bob.Omb’s Modified Win10PE x64
echo [ 05 ] Boot Win10PE SE          32bit
echo [ 06 ] Boot Win8PE              32bit
echo [ 07 ] Boot Win7PE              32bit
echo [ 08 ] Boot MiniXP
echo [ 09 ] Install Win 7-8-10 with ISO method                  WIM ^& ISO
echo [ .. ] Switch to Grub4Dos Menu
echo [ .. ] Switch to GRUB2 Menu
echo.
echo ^>^>     Example WinPE UEFI entries
echo        ---------------------------------
echo [ 01 ] Win10PE SE                x64 UEFI
echo [ 02 ] Win8PE                    x64 UEFI
echo [ 03 ] Win10PE SE                x64 UEFI               DLC Boot
echo [ 04 ] Win10PE SE                x64 UEFI               Strelec
echo [ 05 ] Hirens BootCD PE          x64 UEFI
echo [ 06 ] Bob.Omb Modified Win10PE  x64 UEFI
echo [ 07 ] Setup Windows from sources                       WIM ^& ISO
echo -------------------------------------------------------------------
echo [ 01 ] Win10PE SE                x86 UEFI
echo [ 02 ] Win8PE                    x86 UEFI
echo [ 03 ] Win10PE SE                x86 UEFI               DLC Boot
echo [ 04 ] Win10PE SE                x86 UEFI               Strelec
echo [ 05 ] Setup Windows from sources                       WIM ^& ISO
echo -------------------------------------------------------------------
echo.
echo ^>^>     New menu entry edit below:
echo.
echo [ .. ] Modify your new entry here
echo.
)

echo.
echo            ^	^>^> MINI WINDOWS BOOT MANAGER EDITOR ^<^<
echo                 --------------------------------------
echo.
echo ^> Please edit a new menu name in the last line of the text file.
"%tmp%\winpemenu.txt"

cd /d "%ducky%\WIM"
    echo.
    echo ^> List all WIM modules:
    for /f "tokens=*" %%i in ('dir /a:-d /b') do (
        if exist %%~ni.wim (
            echo.
            echo ^  %%~ni.wim
            set "wim=true"
        )
    )
    if not "%wim%"=="true" (
        echo.
        echo.  WIM file not found^!
    )

echo.
echo.  ------------------------------------------------------------------
echo.  Hint^! Press the first letter then press "Tab" to get name quickly
echo.  ------------------------------------------------------------------
echo.
set /p bootfilename= ^> Input the WIM name here: 
set "bootfile=\WIM\%bootfilename%"

for /f "delims=" %%b in (%tmp%\winpemenu.txt) do set menutitle=%%b
del /f /q "%tmp%\winpemenu.txt"

:: Legacy BIOS Mode
echo.
echo %menutitle%
echo.
echo ^> Creating a menu for Legacy BIOS Mode...
set "source=%ducky%\BOOT\bootmgr\B84"
call :create.entry

:: UEFI Mode
echo.
echo ^> Creating a menu for UEFI Mode...
set "source=%ducky%\EFI\MICROSOFT\Boot\bcd"
call :create.entry

echo.
echo.  ------------------------------------------------------------------
echo.                 Continue to edit your WinPE menu                   
echo.  ------------------------------------------------------------------
echo.
goto :eof

rem >> begin functions
:create.entry
set "Object={7619dcc8-fafe-11d9-b411-000476eba25f}"
bcdedit /store %source% /copy {default} /d "%menutitle%" > %tmp%\tmpuuid.txt
for /f "tokens=7 delims=. " %%b in (%tmp%\tmpuuid.txt) do set identifier=%%b
del /f /q "%tmp%\tmpuuid.txt"
bcdedit /store %source% /set %identifier% device ramdisk=[%ducky%]%bootfile%,%Object%
bcdedit /store %source% /set %identifier% osdevice ramdisk=[%ducky%]%bootfile%,%Object% >nul
timeout /t 1 >nul
exit /b 0
rem >> end functions

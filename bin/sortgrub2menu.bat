@echo off

rem >> https://niemtin007.blogspot.com
rem >> The batch file is written by niemtin007.
rem >> Thank you for using Multiboot Toolkit.

:main
cd /d "%bindir%"
    call colortool.bat

echo                   _    ____  
echo   __ _ _ __ _   _^| ^|__^|___ \  a. %_config0115_%
echo  / _` ^| '__^| ^| ^| ^| '_ \ __^) ^| b. %_config0109_%
echo ^| ^(_^| ^| ^|  ^| ^|_^| ^| ^|_^) / __/  c. %_config0110_%
echo  \__, ^|_^|   \__,_^|_.__^|_____^| d. %_config0111_%
echo  ^|___/                        e. %_config0100_%
echo   _ __ ___   ___ _ __  _   _  f. %_config0101_%
echo  ^| '_ ` _ \ / _ ^| '_ \^| ^| ^| ^| g. %_config0102_%
echo  ^| ^| ^| ^| ^| ^|  __^| ^| ^| ^| ^|_^| ^| h. %_config0107_%
echo  ^|_^| ^|_^| ^|_^|\___^|_^| ^|_^|\__,_^| i. %_config0112_%
echo           _ _     _           k. %_config0113_%
echo          ^| ^(_^)___^| ^|_         l. %_config0128_%
echo          ^| ^| / __^| __^|        m. %_config0116_%
echo          ^| ^| \__ ^| ^|_         n. %_config0124_%
echo          ^|_^|_^|___/\__^|        o. %_config0125_%
echo.
set list=a b c d e f g h i k l m n o
set /p list= "%_lang0838_%"
    rem check the character of the string
    echo %list%| findstr /r /c:"[a-o]" > nul
    if not "%errorlevel%"=="0" goto :main

cd /d "%ducky%\BOOT\grub"
    >"menu.list" (echo %list%)

cd /d "%ducky%\BOOT\GRUB\themes\"
    for /f "tokens=*" %%b in (theme) do set "gtheme=%%b"

cd /d "%bindir%\config"
    call "main.bat"
    call "%bindir%\exit.bat"

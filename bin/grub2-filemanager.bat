@echo off

rem >> https://niemtin007.blogspot.com
rem >> The batch file is written by niemtin007.
rem >> Thank you for using Multiboot Toolkit.

cls
echo.
echo ^> Downloading grub2-filemanager...
cd /d "%bindir%\extra-modules"
    "%bindir%\7za.exe" x "%bindir%\curl.7z" -o"%tmp%" -aos -y > nul
    "%tmp%\curl\curl.exe" -L -s -o master.zip https://github.com/a1ive/grub2-filemanager/archive/master.zip
    "%bindir%\7za.exe" x "%bindir%\extra-modules\master.zip" -o"%bindir%\extra-modules\" -y >nul
    del "master.zip" /s /q /f >nul
cd /d "%bindir%\extra-modules\grub2-filemanager-master\boot\
    xcopy "grub" "%bindir%\extra-modules\grub2-filemanager\" /e /y /q >nul
cd /d "%bindir%\extra-modules\"
    rmdir "grub2-filemanager-master" /s /q >nul

echo.
echo ^> Setting grub2-filemanager config...

cd /d "%bindir%\extra-modules\grub2-filemanager\"
>> main.lua (
    echo hotkey = "f6" 
    echo command = "configfile $prefix/main.cfg"
    echo grub.add_hidden_menu ^(hotkey, command, "return"^)
)

>> help.lua (
    echo hotkey = "f6" 
    echo command = "configfile $prefix/main.cfg"
    echo grub.add_hidden_menu ^(hotkey, command, "return"^)
)

>> open.lua (
    echo hotkey = "f6" 
    echo command = "configfile $prefix/main.cfg"
    echo grub.add_hidden_menu ^(hotkey, command, "return"^)
)

>> osdetect.lua (
    echo hotkey = "f6" 
    echo command = "configfile $prefix/main.cfg"
    echo grub.add_hidden_menu ^(hotkey, command, "return"^)
)

>> power.lua (
    echo hotkey = "f6" 
    echo command = "configfile $prefix/main.cfg"
    echo grub.add_hidden_menu ^(hotkey, command, "return"^)
)

>> settings.lua (
    echo hotkey = "f6" 
    echo command = "configfile $prefix/main.cfg"
    echo grub.add_hidden_menu ^(hotkey, command, "return"^)
)

timeout /t 2 >nul

rem >> store grub2-filemanager to archive
cd /d "%bindir%\extra-modules"
    "%bindir%\7za.exe" a grub2-filemanager.7z .\grub2-filemanager\* >nul
    if exist "grub2-filemanager" (rd /S /Q "grub2-filemanager" >nul)
    if "%offline%"=="0" call "%bindir%\exit.bat"
    echo.
    echo ^> Updating grub2-filemanager to MultibootUSB...
    "%bindir%\7za.exe" x "grub2-filemanager.7z" -o"%ducky%\BOOT\grub\" -aoa -y >nul
    timeout /t 3 >nul
    call "%bindir%\exit.bat"

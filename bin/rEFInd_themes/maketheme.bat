@echo off

cd /d "%~dp0"
    del /s /q Notes.txt
    del /s /q sound.wav
    del /s /q sound_night.wav
    del /s /q theme.plist
    rd /s /q anime
    rd /s /q Anim_1_Logo
    rd /s /q dark_logo
    rd /s /q logo
    rd /s /q scrollbar
    rd /s /q X_LOGO

cd /d "%~dp0icons"
    mkdir others
    copy /y os_vista.icns .\others\bootia32.png
    copy /y os_vista.icns .\others\bootx64.png
    copy /y os_vista.icns .\others\winpeia32.png
    copy /y os_vista.icns .\others\winpex64.png
    copy /y os_clover.icns cloverx64.png
    if exist os_grub.icns (
        copy /y os_grub.icns grubx64.png
    ) else (
        copy /y os_linux.icns grubx64.png
    )
    copy /y os_mav.icns xorbootx64.png
    copy /y os_win.icns winsetupx64.png
    if not exist os_win7 copy /y os_win.icns os_win7.icns
    if not exist os_win8 copy /y os_win.icns os_win8.icns
    if not exist os_win10 copy /y os_win.icns os_win10.icns




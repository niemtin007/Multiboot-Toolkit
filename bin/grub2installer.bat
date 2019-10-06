@echo off

rem >> https://niemtin007.blogspot.com
rem >> The batch file is written by niemtin007.
rem >> Thank you for using Multiboot Toolkit.

cls
cd /d "%bindir%"
    7za x "grub2.7z" -o"%tmp%" -aos -y >nul

:grub2begin
rem >> the argument is the drive letter label of multiboot device, MULTIBOOT is the default
for /f %%b in ('wmic volume get driveletter^, label ^| findstr /i "%~1"') do set "dest=%%b"
    if exist "%dest%\EFI\BOOT\mark" (
        for /f "tokens=*" %%b in (%dest%\EFI\BOOT\mark) do set "author=%%b"
    )
    if not "%author%"=="niemtin007" (
        cls & echo. & echo ^> Finding destination...
        timeout /t 2 >nul & goto :grub2begin
    )

rem >> create vhd disk
cd /d "%tmp%"
    if exist "Grub2.vhd" (del /s /q "Grub2.vhd" >nul)
    (
        echo create vdisk file="%tmp%\Grub2.vhd" maximum=50 type=expandable
        echo attach vdisk
        echo create partition primary
        echo format fs=fat32 label="Grub2"
        echo assign letter=v
    ) | diskpart
rem >> install grub2 for Legacy BIOS mode
move /y "%ducky%\BOOT\grub\*.lst" "%ducky%\BOOT" >nul
cd /d "%tmp%\grub2"
    grub-install --target=i386-pc --force --boot-directory=%ducky%\BOOT \\.\physicaldrive%disk%
move /y "%ducky%\BOOT\*.lst" "%ducky%\BOOT\grub" >nul
cd /d "%tmp%\grub2\i386-pc"
    copy "lnxboot.img" "%ducky%\BOOT\grub\i386-pc" /y >nul
cd /d "%ducky%\BOOT\grub\i386-pc"
    copy /b lnxboot.img+Core.img g2ldr

rem >> install grub2 for EFI mode
cd /d "%tmp%\grub2"
    grub-install --target=x86_64-efi --efi-directory=V:\ --boot-directory=%ducky%\BOOT --bootloader-id=grub --modules=part_gpt --removable
    grub-install --target=i386-efi --efi-directory=V:\ --boot-directory=%ducky%\BOOT --bootloader-id=grub --modules=part_gpt --removable

cd /d "V:\EFI\BOOT"
    rem > copy to multiboot data partition
    copy "BOOTIA32.EFI" "%dest%\EFI\BOOT\grubia32.efi" /y >nul
    copy "BOOTX64.EFI" "%dest%\EFI\BOOT\grubx64.efi" /y >nul
    copy "grub.efi" "%dest%\EFI\BOOT\grub.efi" /y >nul
    rem > make backup
    copy "BOOTIA32.EFI" "%bindir%\secureboot\EFI\Boot\backup\Grub2\bootia32.efi" /y >nul
    copy "BOOTX64.EFI" "%bindir%\secureboot\EFI\Boot\backup\Grub2\bootx64.efi" /y >nul
    copy "grub.efi" "%bindir%\secureboot\EFI\Boot\backup\Grub2\grub.efi" /y >nul

cd /d "%tmp%"
    (
        echo select vdisk file="%tmp%\Grub2.vhd"
        echo detach vdisk
    ) | diskpart
    del /s /q "Grub2.vhd" >nul

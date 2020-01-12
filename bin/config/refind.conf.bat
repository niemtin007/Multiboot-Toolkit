@echo off

cd /d "%bindir%\rEFInd"

> "refind.conf" (
    echo timeout 30
    echo hideui hints
    echo icons_dir themes/icons
    echo banner themes/background.png
    echo banner_scale fillscreen
    echo selection_big   themes/selection_big.png
    echo selection_small themes/selection_small.png
    echo #resolution 5
    echo use_graphics_for linux
    echo showtools about,shutdown,reboot
    echo scanfor internal,external,optical,manual
    echo dont_scan_volumes "Recovery HD"
    echo dont_scan_volumes "EFI"
    echo dont_scan_volumes "ESP"
    echo dont_scan_dirs ESP:/EFI/boot,EFI/Dell,EFI/memtest86
    echo dont_scan_files shim.efi, bootia32.efi, refind_x64.efi, konbootX64.efi, KonBootDxeX64.efi, KonBootDxeIA32.efi, bootmgr.efi, memtest.efi
)

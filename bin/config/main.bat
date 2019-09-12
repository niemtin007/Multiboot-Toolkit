@echo off

cd /d "%bindir%\config"
    xcopy /s /y "grubcfg" "%ducky%\BOOT\grub\" >nul

>"%ducky%\BOOT\grub\main.cfg" (
echo insmod font
echo if loadfont unicode ; then
echo     if keystatus --shift ; then true ; else
echo         if [ "${grub_platform}" == "efi" ]; then
echo             insmod efi_gop
echo             insmod efi_uga
echo         else
echo             insmod vbe
echo             insmod vga
echo         fi
echo             insmod gfxterm
echo             set gfxmode=1024x768,800x600,auto
echo             set gfxpayload=auto
echo             terminal_output gfxterm
echo         if terminal_output gfxterm ; then true ; else
echo             terminal gfxterm
echo         fi
echo     fi
echo fi
echo.
echo if [ "${grub_platform}" == "pc" ]; then
echo     insmod vbe
echo     insmod vga
echo fi
echo.
echo # Timeout for menu
echo set timeout=30
echo # Default boot entry
echo set default=0
echo.
echo # Menu Themes
echo set theme=$prefix/themes/%gtheme%/theme.txt
echo set locale_dir=$prefix/locale
echo set icondir=$prefix/themes/icons
echo export theme
echo.
echo # Enable pager for GRUB command-line
echo set pager=1
echo.
echo # Partition holding files
echo probe -u $root --set=rootuuid
echo set imgdevpath="/dev/disk/by-uuid/$rootuuid"
echo export imgdevpath rootuuid
echo.
echo # Custom variables
echo set drive_label=multiboot
echo export drive_label
echo set binpath="/BOOT"
echo set isopath="/ISO"
echo export binpath isopath
echo.
echo insmod all_video
echo insmod video_bochs
echo insmod video_cirrus
echo insmod font
echo insmod gfxmenu
echo insmod gettext
echo insmod jpeg
echo insmod png
echo insmod part_acorn
echo insmod part_amiga
echo insmod part_apple
echo insmod part_bsd
echo insmod part_gpt
echo insmod part_msdos
echo insmod part_sun
echo insmod part_sunpc
echo insmod ext2
echo insmod ntfs
echo insmod fat
echo insmod insmod search_fs_uuid
echo insmod iso9660
echo.
echo search.fs_label M-ESP edir
echo search.fs_label rEFInd rdir
echo search.fs_label MULTIBOOT mdir
echo.
echo # Load personalized configuration
echo if [ -e "$prefix/grub.cfg.local" ]; then
echo   source "$prefix/grub.cfg.local"
echo fi
echo.
echo # For globbing
echo insmod regexp
echo.
echo.
echo menuentry "%_config0115_%" --class refind {
echo     echo "%_config0126_%"
echo     configfile ${prefix}/init.sh
echo }
echo.
echo if [ -e "${prefix}/hackeros.cfg" ]; then
echo menuentry "%_config0109_%" --class SecurityOS {
echo     echo "%_config0003_%"
echo     configfile "${prefix}/hackeros.cfg"
echo }
echo fi
echo.
echo if [ -e "${prefix}/linux.cfg" ]; then
echo menuentry "%_config0110_%" --class icon-linux {
echo     echo "%_config0003_%"
echo     configfile "${prefix}/linux.cfg"
echo }
echo fi
echo.
echo if [ -e "${prefix}/antivirus.cfg" ]; then
echo menuentry "%_config0111_%" --class eset {
echo     echo "%_config0003_%"
echo     configfile "${prefix}/antivirus.cfg"
echo }
echo fi
echo.
echo if [ "${grub_platform}" == "efi" ]; then
echo if [ -e "($edir)/EFI/BOOT/winpex64.efi" ]; then
echo     if [ "${grub_cpu}" == "x86_64" ]; then
echo     menuentry "%_config0100_%" --class win8 {
echo         insmod part_%type%
echo         insmod chain
echo         chainloader "($edir)/EFI/BOOT/winpex64.efi"
echo     }
echo     fi
echo     if [ "${grub_cpu}" == "i386" ]; then
echo     menuentry "%_config0100_%" --class win8 { 
echo         insmod part_%type%
echo         insmod chain
echo         chainloader "($edir)/EFI/BOOT/winpeia32.efi"
echo     }
echo     fi
echo fi
echo if [ "${grub_cpu}" == "x86_64" ]; then
echo menuentry "%_config0100_%" --class win8 {
echo     insmod part_%type%
echo     insmod chain
echo     chainloader /EFI/BOOT/bootx64.efi
echo }
echo fi
echo if [ "${grub_cpu}" == "i386" ]; then
echo menuentry "%_config0100_%" --class win8 { 
echo     insmod part_%type%
echo     insmod chain
echo     chainloader /EFI/BOOT/bootia32.efi
echo }
echo fi
rem echo fi
echo if [ -e "/WINSETUP" ]; then
echo     if [ "${grub_cpu}" == "x86_64" ]; then
echo     menuentry "%_config0101_%" --class winusb {
echo         insmod part_%type%
echo         insmod chain
echo         chainloader /EFI/BOOT/winsetupx64.efi
echo     }
echo     fi
echo     if [ "${grub_cpu}" == "i386" ]; then
echo     menuentry "%_config0101_%" --class winusb { 
echo         insmod part_%type%
echo         insmod chain
echo         chainloader /EFI/BOOT/winsetupia32.efi
echo     }
echo     fi
echo fi
echo fi
echo.
echo if [ "${grub_platform}" == "pc" ]; then
echo     if [ -e "/BOOT/bootmgr/disk.mbr" ]; then
echo        menuentry "%_config0102_%" --class syslinux {
echo            chainloader /Boot/Syslinux/syslinux.bin
echo        }
echo        menuentry "%_config0103_%" --class icon-gnu {
echo            search --file /grldr --set=root
echo            insmod ntldr
echo            ntldr /grldr
echo        }
echo        if [ -e "/bootmgr" ]; then
echo        menuentry "%_config0101_%" --class winusb {
echo            search --file /bootmgr --set=root
echo            insmod ntldr
echo            ntldr /bootmgr
echo        }
echo        fi
echo     fi
echo fi
echo.
echo menuentry "%_config0107_%" --class winusb {
echo     echo "%_config0003_%"
echo     configfile "${prefix}/bootfromwim.cfg"
echo }
echo if [ "${grub_platform}" == "pc" ]; then
echo     if [ -e "/BOOT/bootmgr/disk.mbr" ]; then
echo     menuentry "%_config0106_%" --class win8 {
echo         search --file /BOOT/bootmgr/bootmgr --set=root
echo         insmod ntldr
echo         ntldr /BOOT/bootmgr/bootmgr
echo     }
echo     fi
echo fi
echo.
echo.
echo if [ -e "${prefix}/acronis.cfg" ]; then
echo menuentry "%_config0112_%" --class icon-tool {
echo     echo "%_config0003_%"
echo     configfile "${prefix}/acronis.cfg"
echo }
echo fi
echo.
echo if [ -e "${prefix}/partition.cfg" ]; then
echo menuentry "%_config0113_%" --class utility {
echo     echo "%_config0003_%"
echo     configfile "${prefix}/partition.cfg"
echo }
echo fi
echo.
echo if [ "${grub_platform}" == "pc" ]; then   
echo     menuentry "%_config0127_%" --class win {
echo     search --file /BOOT/HDD --set=root/BOOT
echo     insmod ntldr
echo     ntldr /BOOT/HDD
echo }
echo fi
echo. 
echo if [ "${grub_platform}" == "efi" ]; then
echo     menuentry "%_config0128_%" --class win {
echo     search -f /EFI/Microsoft/Boot/bootmgfw.efi -s root
echo     chainloader /EFI/Microsoft/Boot/bootmgfw.efi
echo }
echo fi
echo if [ "${grub_platform}" == "pc" ]; then
echo if [ -e "/BOOT/grub/winsetup.lst" ]; then
echo     menuentry "%_config0129_%" --class iso {
echo         search --file /BOOT/bootmgr/bootisowim --set=root
echo         insmod ntldr
echo         ntldr /BOOT/bootmgr/bootisowim
echo     }
echo     menuentry "%_config0130_%" --class icon-xp {
echo         set opts='find --set-root --ignore-floppies --ignore-cd /BOOT/grub/winsetup.lst;
echo                   configfile /BOOT/grub/winsetup.lst'
echo         linux /BOOT/grub/grub.exe --config-file=${opts}
echo     }
echo fi
echo fi
echo.
echo # Grub options
echo submenu "%_config0116_%" --class tool_part {
echo     set icondir=$prefix/themes/icons
echo.
echo     menuentry "%_config0000_%" --class arrow_left {
echo         echo "%_config0000_%"
echo         configfile "${prefix}/main.cfg"
echo     }
echo.
echo     menuentry "%_config0117_%" --class tool_part {
echo         ls -l
echo         sleep --interruptible 9999
echo     }
echo.
echo     menuentry "%_config0118_%" --class tool_part {
echo         insmod lvm
echo     }
echo.
echo     menuentry "%_config0119_%" --class tool_part {
echo         insmod dm_nv
echo         insmod mdraid09_be
echo         insmod mdraid09
echo         insmod mdraid1x
echo         insmod raid5rec
echo         insmod raid6rec
echo     }
echo.
echo     menuentry "%_config0120_%" --class tool_part {
echo         insmod ata
echo         update_paths
echo     }
echo.
echo     menuentry "%_config0121_%" --class tool_part {
echo         insmod ohci
echo         insmod uhci
echo         insmod usbms
echo         update_paths
echo     }
echo.
echo     menuentry "%_config0122_%" --class tool_part {
echo         insmod luks
echo         insmod geli
echo         cryptomount -a
echo     }
echo.
echo     menuentry "%_config0123_%" --class tool_part {
echo         serial
echo         terminal_input --append serial
echo         terminal_output --append serial
echo     }
echo.
echo     menuentry "%_config0000_%" --class arrow_left {
echo         echo "%_config0000_%"
echo         configfile "${prefix}/main.cfg"
echo     }
echo }
echo.
echo menuentry "%_config0124_%" --class icon-reboot {
echo     echo "%_config0003_%"
echo     reboot
echo }
echo menuentry "%_config0125_%" --class icon-shutdown {
echo     echo "%_config0003_%"
echo     halt --no-apm
echo }
)


>"%ducky%\BOOT\grub\bootfromwim.cfg" (
echo set icondir=$prefix/themes/icons
echo.
echo function bootfromwim {
echo     echo Loading WinPE to ramdisk, please wait...
echo     if [ "${grub_platform}" == "pc" ]; then
echo        linux16 /BOOT/wimboot/wimboot rawbcd rawwim
echo        initrd16 newc:bootmgr:/BOOT/wimboot/bootmgr \
echo                 newc:bootmgr.exe:/BOOT/wimboot/bootmgr.exe \
echo                 newc:bcd:/BOOT/wimboot/bcd \
echo                 newc:boot.sdi:/BOOT/boot.sdi \
echo                 newc:boot.wim:"$1"
echo     fi
echo     if [ "${grub_cpu}" == "i386" ]; then
echo         wimboot @:bootmgfw.efi:/BOOT/wimboot/bootmgfw.efi \
echo                 @:bcd:/BOOT/wimboot/bcd \
echo                 @:boot.sdi:/BOOT/boot.sdi \
echo                 @:boot.wim:"$1";
echo     fi
echo     if [ "${grub_platform}" == "efi" ]; then
echo         wimboot @:bootmgfw.efi:/BOOT/wimboot/bootmgfw.efi \
echo                 @:bcd:/BOOT/wimboot/bcd \
echo                 @:boot.sdi:/BOOT/boot.sdi \
echo                 @:boot.wim:"$1";
echo     fi
echo }
echo.
echo function GetHotkey {
echo     if [ "$k" != "." ]; then
echo         set hotkeys="_0123456789adfghijklmnopqrstuwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ`=,."
echo         regexp -s k "${k}(.)" "$hotkeys"
echo     fi
echo }
echo.
echo function ListWimBoot {
echo     set wimmessage="Getting the list of files in \"/WIM\". Please wait..."
echo     set nowim="Please copy all your WIM files to the \"/WIM\" folder first."
echo     echo "${wimmessage}"
echo     set k="_"
echo     for file in /WIM/*.wim /WIM/*.WIM; do
echo         if ! test -f "$file"; then continue; fi
echo         regexp -s filename "/WIM/(.*)" "$file"
echo         if [ -z "$havefile" ]; then set havefile="1"; fi
echo         GetHotkey
echo     menuentry "[ ${k} ] ${filename}" "$filename" --hotkey="${k}" --class wim {
echo         bootfromwim /WIM/${2}
echo     }
echo     done
echo     if [ -z "$havefile" ]; then
echo         esc 2 "${nowim}"
echo     else
echo         unset havefile
echo         source ${prefix}/bootfromwim.cfg
echo     fi
echo     unset filename
echo }
echo.
echo if [ -e "/WIM" ]; then
echo     submenu "%_config0132_%" --class icon-memtest {
echo         ListWimBoot
echo     }
echo fi
echo.
echo if [ -e "/SSTR/bootmgr" ]; then
echo menuentry "%_config0104_%" --class strelec {
echo     search --file /SSTR/bootmgr --set=root
echo     insmod ntldr
echo     ntldr /SSTR/bootmgr
echo }
echo fi
echo if [ -e "/SSTR/BOOTMGR" ]; then
echo menuentry "%_config0104_%" --class strelec {
echo     search --file /SSTR/BOOTMGR --set=root
echo     insmod ntldr
echo     ntldr /SSTR/BOOTMGR
echo }
echo fi
echo if [ -e "/DLC1/Boot/gru4.lst" ]; then
echo menuentry "%_config0105_% - Grub4dos" --class dlc {
echo     search --file /BOOT/bootdlc --set=root
echo     insmod ntldr
echo     ntldr /BOOT/bootdlc
echo }
echo fi
echo if [ -e "/DLC1/Boot/syslinux.bin" ]; then
echo menuentry "%_config0105_% - Syslinux" --class dlc {
echo     chainloader /DLC1/Boot/syslinux.bin
echo }
echo fi
echo.
echo if [ -e "/WIM/aomeibackup.wim" ]; then
echo     menuentry "AOMEI Backupper TechPlus PE 64bit" --class aomeibackup {
echo         bootfromwim /WIM/aomeibackup.wim
echo     }
echo fi
echo if [ -e "/WIM/hbcdpe.wim" ]; then
echo     menuentry "Hiren Boot CD PE            64bit" --class hirens {
echo         bootfromwim /WIM/hbcdpe.wim
echo     }
echo fi
echo if [ -e "/WIM/w10pe64.wim" ]; then
echo     menuentry "Win10PE SE                  64bit" --class winusb {
echo         bootfromwim /WIM/w10pe64.wim
echo     }
echo fi
echo if [ -e "/WIM/BobW10PE.wim" ]; then
echo     menuentry "Bob.Omb’s Modified Win10PE  64bit" --class winusb {
echo         bootfromwim /WIM/BobW10PE.wim
echo     }
echo fi
echo if [ -e "/WIM/w8.1se64.wim" ]; then
echo     menuentry "Win8.1SE                    64bit" --class winusb {
echo         bootfromwim /WIM/w8.1se64.wim
echo     }
echo fi
echo if [ -e "/WIM/w8pe64.wim" ]; then
echo     menuentry "Win8PE                      64bit" --class winusb {
echo         bootfromwim /WIM/w8pe64.wim
echo     }
echo fi
echo if [ -e "/DLC1/W10PE/W10x64.wim" ]; then
echo     menuentry "Win10PE DLC                 64bit" --class dlc {
echo         bootfromwim /DLC1/W10PE/W10x64.wim
echo     }
echo fi
echo if [ -e "/SSTR/strelec10x64Eng.wim" ]; then
echo     menuentry "Win10PE Sergei Strelec      64bit" --class strelec {
echo         bootfromwim /SSTR/strelec10x64Eng.wim
echo     }
echo fi
echo if [ -e "/WIM/bootisox64.wim" ]; then
echo     menuentry "WinSetup (ISO method)       64bit" --class iso {
echo         bootfromwim /WIM/bootisox64.wim
echo }
echo fi
echo.
echo if [ -e "/WIM/w10pe32.wim" ]; then
echo     menuentry "Win10PE SE                  32bit" --class winusb {
echo         bootfromwim /WIM/w10pe32.wim
echo     }
echo fi
echo if [ -e "/WIM/w8.1se32.wim" ]; then
echo     menuentry "Win8.1SE                    32bit" --class winusb {
echo         bootfromwim /WIM/w8.1se32.wim
echo     }
echo fi
echo if [ -e "/WIM/w8pe32.wim" ]; then
echo     menuentry "Win8PE                      32bit" --class winusb {
echo         bootfromwim /WIM/w8pe32.wim
echo     }
echo fi
echo if [ -e "/WIM/w7pe32.wim" ]; then
echo     menuentry "Win7PE                      32bit" --class winusb {
echo         bootfromwim /WIM/w7pe32.wim
echo     }
echo fi
echo if [ -e "/DLC1/W10PE/W10x86.wim" ]; then
echo     menuentry "Win10PE DLC                 32bit" --class dlc {
echo         bootfromwim /DLC1/W10PE/W10x86.wim
echo     }
echo fi
echo if [ -e "/SSTR/strelec10Eng.wim" ]; then
echo     menuentry "Win10PE Sergei Strelec      32bit" --class strelec {
echo         bootfromwim /SSTR/strelec10Eng.wim
echo     }
echo fi
echo if [ -e "/SSTR/strelec8Eng.wim" ]; then
echo     menuentry "Win8PE Sergei Strelec       32bit" --class strelec {
echo         bootfromwim /SSTR/strelec8Eng.wim
echo     }
echo fi
echo if [ -e "/SSTR/strelec8NEEng.wim" ]; then
echo     menuentry "Win8NE Sergei Strelec       32bit" --class strelec {
echo         bootfromwim /SSTR/strelec8NEEng.wim
echo     }
echo fi
echo.
echo if [ -e "/WIM/bootisox86.wim" ]; then
echo     menuentry "WinSetup (ISO method)       32bit" --class iso {
echo         bootfromwim /WIM/bootisox86.wim
echo     }
echo fi
echo.
echo menuentry "return to main menu" --class arrow_left {
echo     echo "return to main menu"
echo     configfile "${prefix}/main.cfg"
echo }
)

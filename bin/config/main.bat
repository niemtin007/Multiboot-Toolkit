@echo off

cd /d "%bindir%\config"
    xcopy /s /y "grubcfg" "%ducky%\BOOT\grub\" >nul

cd /d "%ducky%\BOOT\grub"
    if exist menu.list (
        for /f "tokens=*" %%b in (menu.list) do set "list=%%b"
    ) else (
        set list=a b c d e f g h i k l m n o
    )
    >"main.cfg" (
        echo.
        echo # Load grub2 modules
        echo set modlist='font jpeg png regexp'
        echo for module in $modlist; do
        echo     insmod $module
        echo done
        echo.
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
        echo # Timeout for menu
        echo set timeout=30
        echo.
        echo # Custom variables
        echo set locale_dir=$prefix/locale
        echo set drive_label=multiboot
        echo set binpath="/BOOT"
        echo set isopath="/ISO"
        echo export locale_dir drive_label binpath isopath
        echo.
        echo search.fs_label M-ESP edir
        echo search.fs_label rEFInd rdir
        echo search.fs_label MULTIBOOT mdir
        echo export edir rdir mdir
        echo.
        echo probe -u $mdir --set=dev_uuid
        echo export dev_uuid
        echo.
        echo # Menu Themes
        echo set theme=$prefix/themes/%gtheme%/theme.txt
        echo set icondir=$prefix/themes/icons
        echo export theme icondir
        echo.
        echo.
        echo.
    )

    for %%b in (%list%) do (
        call :%%b
    )

    >"bootfromwim.cfg" (
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
        echo     else
        echo         wimboot @:bootmgfw.efi:/BOOT/wimboot/bootmgfw.efi \
        echo                 @:bcd:/BOOT/wimboot/bcd \
        echo                 @:boot.sdi:/BOOT/boot.sdi \
        echo                 @:boot.wim:"$1"
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
        echo if [ -e ^(hd0,msdos1^)/* ]; then
        echo    if [ -e "/SSTR/bootmgr" ]; then
        echo    menuentry "%_config0104_%" --class strelec {
        echo        search --file /SSTR/bootmgr --set=root
        echo        insmod ntldr
        echo        ntldr /SSTR/bootmgr
        echo    }
        echo    fi
        echo    if [ -e "/SSTR/BOOTMGR" ]; then
        echo    menuentry "%_config0104_%" --class strelec {
        echo        search --file /SSTR/BOOTMGR --set=root
        echo        insmod ntldr
        echo        ntldr /SSTR/BOOTMGR
        echo    }
        echo    fi
        echo    if [ -e "/DLC1/Boot/gru4.lst" ]; then
        echo    menuentry "%_config0105_% - Grub4dos" --class dlc {
        echo        search --file /BOOT/bootdlc --set=root
        echo        insmod ntldr
        echo        ntldr /BOOT/bootdlc
        echo    }
        echo    fi
        echo    if [ -e "/DLC1/Boot/syslinux.bin" ]; then
        echo    menuentry "%_config0105_% - Syslinux" --class dlc {
        echo        chainloader /DLC1/Boot/syslinux.bin
        echo    }
        echo    fi
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
        echo menuentry "%_config0000_%" --class arrow-left {
        echo     echo "%_config0000_%"
        echo     configfile "${prefix}/main.cfg"
        echo }
    )

goto :eof

:a
:: Grub2 File Manager Menu
>>"main.cfg" (

    echo.
    echo if [ -e "/EFI/BOOT/grubfmx64.efi" ]; then
    echo    menuentry "%_config0115_% - full" --class refind {
    echo        echo "%_config0126_%"
    echo        if [ "${grub_platform}" == "pc" ]; then
    echo           linux /EFI/BOOT/loadfm
    echo           initrd /EFI/BOOT/grubfm.iso
    echo        else
    echo           chainloader /EFI/BOOT/grubfmx64.efi
    echo        fi
    echo    }
    echo else
    echo    menuentry "%_config0115_% - lite" --class refind {
    echo        echo "%_config0126_%"
    echo        configfile ${prefix}/init.sh
    echo    }
    echo fi
    echo.
)
exit /b 0

:b
:: Pentesting ISO Images Menu
>>"main.cfg" (
    echo if [ -e "${prefix}/hackeros.cfg" ]; then
    echo    menuentry "%_config0109_%" --class SecurityOS {
    echo        echo "%_config0003_%"
    echo        configfile "${prefix}/hackeros.cfg"
    echo    }
    echo fi
    echo.
)
exit /b 0

:c
:: Linux ISO Images Menu
>>"main.cfg" (
    echo if [ -e "${prefix}/linux.cfg" ]; then
    echo    menuentry "%_config0110_%" --class icon-linux {
    echo        echo "%_config0003_%"
    echo        configfile "${prefix}/linux.cfg"
    echo    }
    echo fi
    echo.
)
exit /b 0

:d
:: Antivirus ISO Images Menu
>>"main.cfg" (
    echo if [ -e "${prefix}/antivirus.cfg" ]; then
    echo    menuentry "%_config0111_%" --class eset {
    echo        echo "%_config0003_%"
    echo        configfile "${prefix}/antivirus.cfg"
    echo    }
    echo fi
    echo.
)
exit /b 0

:e
:: WinPE Boot Manager UEFI Menu
>>"main.cfg" (
    echo if [ "${grub_platform}" == "efi" ]; then
    echo    if [ -e "($edir)/EFI/BOOT/winpex64.efi" ]; then
    echo        if [ "${grub_cpu}" == "x86_64" ]; then
    echo           menuentry "%_config0100_%" --class win8 {
    echo               chainloader "($edir)/EFI/BOOT/winpex64.efi"
    echo           }
    echo        fi
    echo        if [ "${grub_cpu}" == "i386" ]; then
    echo           menuentry "%_config0100_%" --class win8 { 
    echo               chainloader "($edir)/EFI/BOOT/winpeia32.efi"
    echo           }
    echo        fi
    echo    fi
    echo    if [ "${grub_cpu}" == "x86_64" ]; then
    echo       menuentry "%_config0100_%" --class win8 {
    echo           chainloader /EFI/BOOT/bootx64.efi
    echo       }
    echo    fi
    echo    if [ "${grub_cpu}" == "i386" ]; then
    echo        menuentry "%_config0100_%" --class win8 { 
    echo            chainloader /EFI/BOOT/bootia32.efi
    echo        }
    echo    fi
    echo fi
    echo if [ "${grub_platform}" == "pc" ]; then
    echo     if [ -e ^(hd0,msdos1^)/* ]; then
    echo     menuentry "%_config0106_%" --class win8 {
    echo         search --file /BOOT/bootmgr/bootmgr --set=root
    echo         insmod ntldr
    echo         ntldr /BOOT/bootmgr/bootmgr
    echo     }
    echo     fi
    echo fi
    echo.
)
exit /b 0

:f
:: WinSetupFromUSB Menu
>>"main.cfg" (
    echo if [ "${grub_platform}" == "efi" ]; then
    echo    if [ "${grub_cpu}" == "x86_64" ]; then
    echo       menuentry "%_config0133_%" --class iso {
    echo           chainloader /EFI/BOOT/winsetupfmx64.efi
    echo       }
    echo        if [ -e "/BOOT/bootmgr/winsetupx64.efi" ]; then
    echo           menuentry "%_config0129_%" --class strelec {
    echo               chainloader /EFI/BOOT/winsetupx64.efi
    echo           }
    echo        fi
    echo    fi
    echo    if [ "${grub_cpu}" == "i386" ]; then
    echo       menuentry "%_config0133_%" --class iso {
    echo           chainloader /EFI/BOOT/winsetupfmia32.efi
    echo       }
    echo        if [ -e "/BOOT/bootmgr/winsetupia32.efi" ]; then
    echo            menuentry "%_config0129_%" --class strelec { 
    echo                chainloader /EFI/BOOT/winsetupia32.efi
    echo            }
    echo        fi
    echo    fi
    echo fi
    echo.
    echo if [ "${grub_platform}" == "pc" ]; then
    echo    if [ -e ^(hd0,msdos1^)/* ]; then
    echo        if [ -e "/bootmgr" ]; then
    echo           menuentry "%_config0101_%" --class winusb {
    echo               search --file /bootmgr --set=root
    echo               insmod ntldr
    echo               ntldr /bootmgr
    echo           }
    echo        fi
    echo           menuentry "%_config0133_%" --class iso {
    echo               linux /EFI/BOOT/loadfm
    echo               initrd /EFI/BOOT/winsetupfm.iso
    echo           }
    echo        if [ -e "/BOOT/bootmgr/bootisowim" ]; then
    echo           menuentry "%_config0129_%" --class strelec {
    echo               search --file /BOOT/bootmgr/bootisowim --set=root
    echo               insmod ntldr
    echo               ntldr /BOOT/bootmgr/bootisowim
    echo           }
    echo        fi
    echo        if [ -e "/BOOT/grub/winsetup.lst" ]; then
    echo           menuentry "%_config0130_%" --class icon-xp {
    echo               set opts='find --set-root --ignore-floppies --ignore-cd /BOOT/grub/winsetup.lst;
    echo                         configfile /BOOT/grub/winsetup.lst'
    echo               linux /BOOT/grub/grub.exe --config-file=${opts}
    echo           }
    echo        fi
    echo    fi
    echo fi
    echo.
)
exit /b 0

:g
:: Legacy BIOS Mode Menu
>>"main.cfg" (
    echo if [ "${grub_platform}" == "pc" ]; then
    echo    if [ -e ^(hd0,msdos1^)/* ]; then
    echo       menuentry "%_config0102_%" --class syslinux {
    echo           chainloader /Boot/Syslinux/syslinux.bin
    echo       }
    echo       menuentry "%_config0103_%" --class icon-gnu {
    echo           search --file /grldr --set=root
    echo           insmod ntldr
    echo           ntldr /grldr
    echo       }
    echo    fi
    echo fi
    echo.
)
exit /b 0

:h
:: WinPE Systems Collection Menu
>>"main.cfg" (
    echo menuentry "%_config0107_%" --class winusb {
    echo     echo "%_config0003_%"
    echo     configfile "${prefix}/bootfromwim.cfg"
    echo }
    echo.
)
exit /b 0

:i
:: Acronis ISO Images Menu
>>"main.cfg" (
    echo if [ -e "${prefix}/acronis.cfg" ]; then
    echo    menuentry "%_config0112_%" --class icon-tool {
    echo        echo "%_config0003_%"
    echo        configfile "${prefix}/acronis.cfg"
    echo    }
    echo fi
    echo.
)
exit /b 0

:k
:: System Tools Menu
>>"main.cfg" (
    echo if [ -e "${prefix}/partition.cfg" ]; then
    echo    menuentry "%_config0113_%" --class utility {
    echo        echo "%_config0003_%"
    echo        configfile "${prefix}/partition.cfg"
    echo    }
    echo fi
    echo.
)
exit /b 0

:l
:: Boot From Internal HDD Menu
>>"main.cfg" (
    echo if [ "${grub_platform}" == "efi" ]; then
    echo    menuentry "%_config0128_%" --class win {
    echo        search -f /EFI/Microsoft/Boot/bootmgfw.efi -s root
    echo        chainloader /EFI/Microsoft/Boot/bootmgfw.efi
    echo    }
    echo    if [ -e "/EFI/BOOT/OneFileLinux.efi" ]; then
    echo        menuentry "One File Linux" --class icon-linux {
    echo            chainloader /EFI/BOOT/OneFileLinux.efi
    echo        }
    echo    fi
    echo fi
    echo if [ "${grub_platform}" == "pc" ]; then
    echo    if [ -e ^(hd0,msdos1^)/* ]; then
    echo       menuentry "%_config0127_%" --class win {
    echo           search --file /BOOT/HDD --set=root/BOOT
    echo           insmod ntldr
    echo           ntldr /BOOT/HDD
    echo       }
    echo    fi
    echo fi
    echo.
)
exit /b 0

:m
:: Super Grub2 Menu
>>"main.cfg" (
    echo menuentry "%_config0116_%" --class tool_part {
    echo     insmod datehook
    echo     
    echo     set sg2d_directory="${config_directory}/sgd"
    echo     export sg2d_directory
    echo     set afd_directory="${config_directory}"
    echo     export afd_directory
    echo     
    echo     if [ "$MONTH" -eq "4" -a "$DAY" -eq "1" ] ; then
    echo       configfile "${afd_directory}/afd2012.cfg"
    echo     else
    echo       configfile "${sg2d_directory}/main.cfg"
    echo     fi
    echo }
    echo.
)
exit /b 0

:n
:: Restart System Menu
>>"main.cfg" (
    echo menuentry "%_config0124_%" --class system-reboot {
    echo     echo "%_config0003_%"
    echo     reboot
    echo }
    echo.
)
exit /b 0

:o
:: Shutdown System Menu
>>"main.cfg" (
    echo menuentry "%_config0125_%" --class system-shutdown {
    echo     echo "%_config0003_%"
    echo     halt --no-apm
    echo }
    echo.
)
exit /b 0

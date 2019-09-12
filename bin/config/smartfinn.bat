@echo off

rem >> https://niemtin007.blogspot.com
rem >> batch file write by niemtin007. Thank you for using.

>"%ducky%\BOOT\grub\smartfinn.cfg" (
echo.
echo function _entry_alpine {
echo     menuentry "${1}" --id alpine "${2}" --class alpine {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         set root=loop
echo         linux /boot/vmlinuz-vanilla iso-scan/filename=$iso_path alpine_dev=usbdisk:vfat BOOT_IMAGE=/boot/vmlinuz-vanilla modules=loop,squashfs,sd-mod,usb-storage nomodeset initrd=/boot/initramfs-vanilla
echo         initrd /boot/initramfs-vanilla
echo     }
echo     return 0
echo }
echo.
echo function _entry_android {
echo     menuentry "${1}" --id android "${2}" --class android-x86 {
echo         set iso_path="$2"
echo         export iso_path
echo         search --set=root --file $iso_path
echo         probe -u -s rootuuid $root
echo         export rootuuid
echo         loopback loop $iso_path
echo         root=^(loop^)
echo         configfile /efi/boot/android.cfg
echo         loopback --delete loop
echo     }
echo     return 0
echo }
echo.
echo function _entry_antergos {
echo     menuentry "${1}" --id antergos "${2}" --class antergos {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         linux ^(loop^)/arch/boot/vmlinuz img_dev=/dev/disk/by-label/${ROOT_LABEL} img_loop=$iso_path archisobasedir=arch archisodevice=/dev/loop0 earlymodules=loop noeject noprompt --
echo         initrd ^(loop^)/arch/boot/archiso.img
echo     }
echo     return 0
echo }
echo.
echo function _entry_antix {
echo     menuentry "${1} - Legacy mode only" --id antix "${2}" --class antix {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         linux ^(loop^)/antiX/vmlinuz nocheckfs disable=lx loop.max_loop=255 log_buf_len=128K nomodeset failsafe noxorg fromiso=$iso_path
echo         initrd ^(loop^)/antiX/initrd.gz
echo     }
echo     return 0
echo }
echo.
echo function _entry_apricity_os {
echo     menuentry "${1}" --id apricity_os "${2}" --class apricity {
echo         set iso_path="$2"
echo         set archi="x86_64"
echo         loopback loop $iso_path
echo         linux ^(loop^)/arch/boot/${archi}/vmlinuz img_dev=/dev/disk/by-label/${ROOT_LABEL} img_loop=$iso_path archisobasedir=arch archisodevice=/dev/loop0 earlymodules=loop noeject noprompt --
echo         initrd ^(loop^)/arch/boot/${archi}/archiso.img
echo     }
echo     return 0
echo }
echo.
echo function _entry_archlabs {
echo     menuentry "${1}" --id archlabs "${2}" --class arch {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         linux ^(loop^)/arch/boot/x86_64/vmlinuz img_dev=/dev/disk/by-label/${ROOT_LABEL} img_loop=$iso_path archisobasedir=arch archisodevice=/dev/loop0 archisolabel=AL-X86_64 cow_spacesize=1G earlymodules=loop noeject noprompt --
echo         initrd ^(loop^)/arch/boot/intel_ucode.img ^(loop^)/arch/boot/x86_64/archiso.img
echo     }
echo     return 0
echo }
echo.
echo function _entry_archlinux {
echo     menuentry "${1}" --id archlinux "${2}" --class arch {
echo         set iso_path="$2"
echo         set archi="i686"
echo         if cpuid -l; then
echo             set archi="x86_64"
echo         fi
echo         loopback loop $iso_path
echo         linux ^(loop^)/arch/boot/${archi}/vmlinuz img_dev=/dev/disk/by-label/${ROOT_LABEL} img_loop=$iso_path archisobasedir=arch archisodevice=/dev/loop0 earlymodules=loop noeject noprompt --
echo         initrd ^(loop^)/arch/boot/${archi}/archiso.img
echo     }
echo     return 0
echo }
echo.
echo function _entry_archman {
echo     menuentry "${1}" --id archman "${2}" --class arch {
echo         set iso_path="$2"
echo         set archi="i686"
echo         if cpuid -l; then
echo             set archi="x86_64"
echo         fi
echo         loopback loop $iso_path
echo         linux ^(loop^)/arch/boot/${archi}/vmlinuz img_dev=/dev/disk/by-label/${ROOT_LABEL} img_loop=$iso_path archisobasedir=arch archisodevice=/dev/loop0 earlymodules=loop noeject noprompt --
echo         initrd ^(loop^)/arch/boot/intel_ucode.img ^(loop^)/arch/boot/${archi}/archiso.img
echo     }
echo     return 0
echo }
echo.
echo function _entry_archstrike {
echo     menuentry "${1}" --id archstrike "${2}" --class archstrike {
echo         set iso_path="$2"
echo         set archi="i686"
echo         if cpuid -l; then
echo             set archi="x86_64"
echo         fi
echo         loopback loop $iso_path
echo         linux ^(loop^)/arch/boot/${archi}/vmlinuz img_dev=/dev/disk/by-label/${ROOT_LABEL} img_loop=$iso_path archisobasedir=arch archisodevice=/dev/loop0 earlymodules=loop noeject noprompt --
echo         initrd ^(loop^)/arch/boot/intel_ucode.img ^(loop^)/arch/boot/${archi}/archiso.img
echo     }
echo     return 0
echo }
echo.
echo function _entry_arco {
echo     menuentry "${1}" --id arco "${2}" --class arch {
echo         set iso_path="$2"
echo         set archi="i686"
echo         if cpuid -l; then
echo             set archi="x86_64"
echo         fi
echo         loopback loop $iso_path
echo         linux ^(loop^)/arch/boot/${archi}/vmlinuz img_dev=/dev/disk/by-label/${ROOT_LABEL} img_loop=$iso_path archisobasedir=arch archisodevice=/dev/loop0 earlymodules=loop noeject noprompt --
echo         initrd ^(loop^)/arch/boot/intel_ucode.img ^(loop^)/arch/boot/${archi}/archiso.img
echo     }
echo     return 0
echo }
echo.
echo function _entry_backbox {
echo     menuentry "${1}" --id backbox "${2}" --class backbox {
echo         set iso_path="$2"
echo         export iso_path
echo         search --set=root --file $iso_path
echo         probe -u -s rootuuid $root
echo         export rootuuid
echo         loopback loop $iso_path
echo         root=^(loop^)
echo         configfile /boot/grub/loopback.cfg
echo         loopback --delete loop
echo     }
echo     return 0
echo }
echo.
echo function _entry_bbqlinux {
echo     menuentry "${1}" --id bbqlinux "${2}" --class bbqlinux {
echo         set iso_path="$2"
echo         set archi="i686"
echo         if cpuid -l; then
echo             set archi="x86_64"
echo         fi
echo         loopback loop $iso_path
echo         linux ^(loop^)/bbqlinux/boot/${archi}/vmlinuz img_dev=/dev/disk/by-label/${ROOT_LABEL} img_loop=$iso_path archisobasedir=bbqlinux archisodevice=/dev/loop0 earlymodules=loop noeject noprompt --
echo         initrd ^(loop^)/bbqlinux/boot/${archi}/archiso.img
echo     }
echo     return 0
echo }
echo.
echo function _entry_blackarch {
echo     menuentry "${1}" --id blackarch "${2}" --class arch {
echo         echo "User: root"
echo         echo "Password: blackarch"
echo         set iso_path="${2}"; export iso_path
echo         regexp --set=1:archi  '^.*/.*-^(.+^)\..*$' $iso_path
echo         loopback loop $iso_path
echo         probe -l ^(loop^) --set=mlabel
echo         linux ^(loop^)/blackarch/boot/x86_64/vmlinuz img_dev=/dev/disk/by-label/${ROOT_LABEL} img_loop=$iso_path archisobasedir=blackarch archisodevice=/dev/loop0 archisolabel=mlabel
echo         initrd ^(loop^)/blackarch/boot/intel_ucode.img ^(loop^)/blackarch/boot/amd_ucode.img ^(loop^)/blackarch/boot/x86_64/archiso.img
echo     }
echo     return 0
echo }
echo.
echo function _entry_bluestar {
echo     menuentry "${1}" --id bluestar "${2}" --class arch {
echo         set iso_path="$2"
echo         set archi="i686"
echo         if cpuid -l; then
echo             set archi="x86_64"
echo         fi
echo         loopback loop $iso_path
echo         linux ^(loop^)/arch/boot/${archi}/vmlinuz img_dev=/dev/disk/by-label/${ROOT_LABEL} img_loop=$iso_path archisobasedir=arch archisodevice=/dev/loop0 ipv6.disable=1 disablehooks=v86d,915resolution,gma3600 modprobe.blacklist=uvesafb
echo         initrd ^(loop^)/arch/boot/${archi}/archiso.img
echo     }
echo     return 0
echo }
echo.
echo function _entry_bodhi {
echo     menuentry "${1}" --id bodhi "${2}" --class bodhi {
echo         set iso_path="$2"
echo         export iso_path
echo         search --set=root --file $iso_path
echo         probe -u -s rootuuid $root
echo         export rootuuid
echo         loopback loop $iso_path
echo         root=^(loop^)
echo         configfile /boot/grub/loopback.cfg
echo         loopback --delete loop
echo     }
echo     return 0
echo }
echo.
echo function _entry_bugtraq {
echo     menuentry "${1}" --id bugtraq "${2}" --class bugtraq {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         linux ^(loop^)/casper/vmlinuz iso-scan/filename=$iso_path file=/cdrom/preseed/custom.seed boot=casper quiet splash --
echo         initrd ^(loop^)/casper/initrd.gz
echo     }
echo     return 0
echo }
echo.
echo function _entry_caine {
echo     menuentry "${1}" --id caine "${2}" --class caine {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         set gfxpayload=keep
echo         linux ^(loop^)/casper/vmlinuz boot=casper quiet splash nomdmonddf nomdmonisw iso-scan/filename=$iso_path
echo         initrd ^(loop^)/casper/initrd.gz
echo     }
echo     return 0
echo }
echo.
echo function _entry_centos {
echo     menuentry "${1}" --id centos "${2}" --class centos {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         linuxefi ^(loop^)/images/pxeboot/vmlinuz inst.stage2=hd:LABEL=CentOS\x207\x20x86_64 iso-scan/filename=$iso_path
echo         initrdefi ^(loop^)/images/pxeboot/initrd.img
echo     }
echo     return 0
echo }
echo.
echo function _entry_cosmic {
echo     menuentry "${1}" --id cosmic "${2}" --class ubuntu {
echo         set iso_path="$2"
echo         export iso_path
echo         search --set=root --file $iso_path
echo         probe -u -s rootuuid $root
echo         export rootuuid
echo         loopback loop $iso_path
echo         root=^(loop^)
echo         configfile /boot/grub/loopback.cfg
echo         loopback --delete loop
echo     }
echo     return 0
echo }
echo.
echo function _entry_cyborg {
echo     menuentry "${1}" --id cyborg "${2}" --class cyborg {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         set gfxpayload=keep
echo         linux ^(loop^)/live/vmlinuz boot=live components text username=root hostname=cyborg findiso=$iso_path
echo         initrd ^(loop^)/live/initrd.img
echo     }
echo     return 0
echo }
echo.
echo function _entry_debian {
echo     menuentry "${1}" --id debian "${2}" --class debian {
echo         set iso_path="$2"
echo         export iso_path
echo         search --set=root --file $iso_path
echo         probe -u -s rootuuid $root
echo         export rootuuid
echo         loopback loop $iso_path
echo         root=^(loop^)
echo         configfile /boot/grub/grub.cfg
echo         loopback --delete loop
echo     }
echo     return 0
echo }
echo.
echo function _entry_deepin_live {
echo     menuentry "${1}" --id deepin_live "${2}" --class deepin {
echo         set iso_path="$2"
echo         export iso_path
echo         loopback loop $iso_path
echo         linux ^(loop^)/live/vmlinuz boot=live components findiso=$iso_path config
echo         initrd ^(loop^)/live/initrd.img
echo     }
echo     return 0
echo }
echo.
echo function _entry_deepin {
echo     menuentry "${1}" --id deepin "${2}" --class deepin {
echo         set iso_path="$2"
echo         export iso_path
echo         loopback loop $iso_path
echo         linux ^(loop^)/live/vmlinuz.efi boot=live union=overlay livecd-installer locale=zh_EN findiso=$iso_path config
echo         initrd ^(loop^)/live/initrd.lz
echo     }
echo     return 0
echo }
echo.
echo function _entry_deft {
echo     menuentry "${1}" --id deft "${2}" --class deft {
echo         set iso_path="$2"
echo         export iso_path
echo         loopback loop $iso_path
echo         linux ^(loop^)/casper/vmlinuz file=/cdrom/preseed/lubuntu.seed boot=casper iso-scan/filename=$iso_path
echo         initrd ^(loop^)/casper/initrd.lz
echo     }
echo     return 0
echo }
echo.
echo function _entry_deftz {
echo     menuentry "${1}" --id deftz "${2}" --class deft {
echo         set iso_path="$2"
echo         export iso_path
echo         search --set=root --file $iso_path
echo         probe -u -s rootuuid $root
echo         export rootuuid
echo         loopback loop $iso_path
echo         root=^(loop^)
echo         configfile /boot/grub/loopback.cfg
echo         loopback --delete loop
echo     }
echo     return 0
echo }
echo.
echo function _entry_elementaryos {
echo     menuentry "${1}" --id elementaryos "${2}" --class elementary {
echo         set iso_path="$2"
echo         export iso_path
echo         search --set=root --file $iso_path
echo         probe -u -s rootuuid $root
echo         export rootuuid
echo         loopback loop $iso_path
echo         root=^(loop^)
echo         configfile /boot/grub/loopback.cfg
echo         loopback --delete loop
echo     }
echo     return 0
echo }
echo.
echo function _entry_fedora_security {
echo     menuentry "${1}" --id fedora_security "${2}" --class fedora {
echo         set iso_path="$2"
echo         loopback loop "(${isodir})$iso_path"
echo         probe -u ^(loop^) --set=loopuuid
echo         set id=UUID=$loopuuid
echo         if [ "${grub_platform}" == "efi" ]; then
echo            linuxefi ^(loop^)/images/pxeboot/vmlinuz root=live:$id rd.live.image iso-scan/filename=$iso_path
echo            initrdefi ^(loop^)/images/pxeboot/initrd.img
echo         fi
echo         if [ "${grub_platform}" == "pc" ]; then
echo            linux ^(loop^)/isolinux/vmlinuz root=live:$id rootfstype=auto ro rd.live.image xquiet nosplash  rhgb rd.luks=0 rd.md=0 rd.dm=0 nomodeset iso-scan/filename=$iso_path
echo            initrd ^(loop^)/isolinux/initrd.img
echo         fi
echo     }
echo     return 0
echo }
echo.
echo function _entry_fedora {
echo     menuentry "${1}" --id fedora "${2}" --class fedora {
echo         set iso_path="$2"
echo         loopback loop "($isodir)$iso_path"
echo         probe -u ^(loop^) --set=loopuuid
echo         set id=UUID=$loopuuid
echo         linux ^(loop^)/isolinux/vmlinuz root=live:$id rootfstype=auto ro rd.live.image xquiet nosplash  rhgb rd.luks=0 rd.md=0 rd.dm=0 nomodeset iso-scan/filename=$iso_path
echo         initrd ^(loop^)/isolinux/initrd.img
echo     }
echo     return 0
echo }
echo.
echo function _entry_gecko {
echo     menuentry "${1}" --id gecko "${2}" --class opensuse {
echo         set iso_path="$2"
echo         set btrfs_relative_path="y"
echo         export btrfs_relative_path
echo         loopback loop "${iso_path}"
echo         search --file --set=root /boot/0x197d2c94
echo         linux ^(loop^)/boot/x86_64/loader/linux apparmor=0 root=live:CDLABEL=GeckoLinux_STATIC_Plasma rd.live.image rd.live.overlay.persistent rd.live.overlay.cowfs=ext4 iso-scan/filename=${iso_path}
echo         initrd ^(loop^)/boot/x86_64/loader/initrd
echo     }
echo     return 0
echo }
echo.
echo function _entry_avl {
echo     menuentry "${1}" --id avl "${2}" --class avl {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         linux ^(loop^)/live/vmlinuz boot=live quiet splash threadirqs transparent_hugepage=never noresume findiso=$iso_path
echo         initrd ^(loop^)/live/initrd.gz
echo     }
echo     return 0
echo }
echo.
echo function _entry_kali {
echo     menuentry "${1}" --id kali "${2}" --class kali {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         linux ^(loop^)/live/vmlinuz boot=live noconfig=sudo username=root hostname=kali noswap noautomount findiso=$iso_path --
echo         initrd ^(loop^)/live/initrd.img
echo     }
echo     return 0
echo }
echo.
echo function _entry_linux_lite {
echo     menuentry "${1}" --id linux_lite "${2}" --class lite {
echo         set iso_path="$2"
echo         export iso_path
echo         search --set=root --file $iso_path
echo         probe -u -s rootuuid $root
echo         export rootuuid
echo         loopback loop $iso_path
echo         root=^(loop^)
echo         configfile /boot/grub/loopback.cfg
echo         loopback --delete loop
echo     }
echo     return 0
echo }
echo.
echo function _entry_devuan {
echo     menuentry "${1}" --id devuan "${2}" --class devuan {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         set gfxpayload=keep
echo         linux ^(loop^)/live/vmlinuz boot=live username=devuan iso-scan/filename=$iso_path
echo         initrd ^(loop^)/live/initrd.img ^(loop^)/live/filesystem.squashfs
echo     }
echo     return 0
echo }
echo.
echo function _entry_discreete {
echo     menuentry "${1}" --id discreete "${2}" --class discreete {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         set gfxpayload=keep
echo         linux ^(loop^)/live/vmlinuz boot=live components hostname=discreete username=somebody locales=en_US.UTF-8 keyboard-layouts=us iso-scan/filename=$iso_path
echo         initrd ^(loop^)/live/initrd.img
echo     }
echo     return 0
echo }
echo.
echo function _entry_kodachi {
echo     menuentry "${1}" --id kodachi "${2}" --class kodachi {
echo         set iso_path="$2"
echo         export iso_path
echo         search --set=root --file $iso_path
echo         probe -u -s rootuuid $root
echo         export rootuuid
echo         loopback loop $iso_path
echo         root=^(loop^)
echo         configfile /boot/grub/loopback.cfg
echo         loopback --delete loop
echo     }
echo     return 0
echo }
echo.
echo function _entry_kaos {
echo     menuentry "${1}" --id kaos "${2}" --class arch {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         linux ^(loop^)/kdeos/boot/x86_64/kdeosiso img_dev=/dev/disk/by-label/${ROOT_LABEL} img_loop=$iso_path kdeosisobasedir=kdeos archisodevice=/dev/loop0 kdeosisolabel=KAOS_20190425 xdriver=no nouveau.modeset=1 i915.modeset=1 radeon.modeset=1 nonfree=no
echo         initrd ^(loop^)/kdeos/boot/x86_64/kdeosiso.img
echo     }
echo     return 0
echo }
echo.
echo function _entry_linuxbbq {
echo     menuentry "${1}" --id linuxbbq "${2}" --class bbqlinux {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         linux ^(loop^)/live/vmlinuz boot=live config fromiso=$iso_path toram --
echo         initrd ^(loop^)/live/initrd.img
echo     }
echo     return 0
echo }
echo.
echo function _entry_linuxmint {
echo     menuentry "${1}" --id linuxmint "${2}" --class linuxmint {
echo         set iso_path="$2"
echo         export iso_path
echo         search --set=root --file $iso_path
echo         probe -u -s rootuuid $root
echo         export rootuuid
echo         loopback loop $iso_path
echo         root=^(loop^)
echo         configfile /boot/grub/loopback.cfg
echo         loopback --delete loop
echo     }
echo     return 0
echo }
echo.
echo function _entry_lxle {
echo     menuentry "${1}" --id lxle "${2}" --class lxle {
echo         set iso_path="$2"
echo         export iso_path
echo         search --set=root --file $iso_path
echo         probe -u -s rootuuid $root
echo         export rootuuid
echo         loopback loop $iso_path
echo         root=^(loop^)
echo         configfile /boot/grub/loopback.cfg
echo         loopback --delete loop
echo     }
echo     return 0
echo }
echo.
echo function _entry_manjaro {
echo     menuentry "${1}" --id manjaro "${2}" --class manjaro {
echo         set iso_path="$2"
echo         regexp --set=1:archi  '^.*/.*-^(.+^)\..*$' $iso_path
echo         loopback loop $iso_path
echo         probe -l ^(loop^) --set=mlabel
echo         linux ^(loop^)/boot/vmlinuz-${archi} img_dev=/dev/disk/by-uuid/${ROOT_UUID} img_loop=$iso_path misobasedir=manjaro misolabel=${mlabel} nouveau.modeset=1 i915.modeset=1 radeon.modeset=1 logo.nologo overlay=nonfree nonfree=yes earlymodules=loop noeject noprompt --
echo         initrd ^(loop^)/boot/initramfs-${archi}.img
echo     }
echo     return 0
echo }
echo.
echo.
echo.
echo function _entry_memdisk {
echo     menuentry "${1}" --id memdisk "${2}" --class memdisk {
echo         set iso_path="$2"
echo         export iso_path
echo         search --set=root --file $iso_path
echo         probe -u -s rootuuid $root
echo         export rootuuid
echo         loopback loop $iso_path
echo         root=^(loop^)
echo         configfile /boot/grub/loopback.cfg
echo         loopback --delete loop
echo     }
echo     return 0
echo }
echo.
echo function _entry_mx {
echo     menuentry "${1}" --id mx "${2}" --class mx {
echo         set iso_path="$2"
echo         set bootparms="from=all quiet"
echo         search -f $iso_path --set=root
echo         loopback loop $iso_path
echo         linux ^(loop^)/antiX/vmlinuz fromiso=$iso_path $bootparms
echo         initrd ^(loop^)/antiX/initrd.gz
echo     }
echo     return 0
echo }
echo.
echo function _entry_neon {
echo     menuentry "${1}" --id neon "${2}" --class neon {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         load_video
echo         set gfxpayload=keep
echo         linux ^(loop^)/casper/vmlinuz  file=/cdrom/preseed/kubuntu.seed boot=casper maybe-ubiquity iso-scan/filename=${iso_path}
echo         initrd ^(loop^)/casper/initrd.lz
echo     }
echo     return 0
echo }
echo.
echo function _entry_neptune {
echo     menuentry "${1}" --id neptune "${2}" --class neptune {
echo         set iso_path="$2"
echo         export iso_path
echo         search --set=root --file $iso_path
echo         probe -u -s rootuuid $root
echo         export rootuuid
echo         loopback loop $iso_path
echo         root=^(loop^)
echo         configfile /boot/grub/grub.cfg
echo         loopback --delete loop
echo     }
echo     return 0
echo }
echo.
echo function _entry_netrunner {
echo     menuentry "${1}" --id netrunner "${2}" --class netrunner {
echo         set iso_path="$2"
echo         export iso_path
echo         search --set=root --file $iso_path
echo         probe -u -s rootuuid $root
echo         export rootuuid
echo         loopback loop $iso_path
echo         root=^(loop^)
echo         configfile /boot/grub/grub.cfg
echo         loopback --delete loop
echo     }
echo     return 0
echo }
echo.
echo function _entry_nst {
echo     menuentry "${1}" --id nst "${2}" --class nst {
echo         set iso_path="$2"
echo         loopback loop "($isodir)$iso_path"
echo         probe -u ^(loop^) --set=loopuuid
echo         set id=UUID=$loopuuid
echo         linux ^(loop^)/isolinux/vmlinuz0 root=live:$id rootfstype=auto ro rd.live.image xquiet nosplash  rhgb rd.luks=0 rd.md=0 rd.dm=0 nomodeset iso-scan/filename=$iso_path
echo         initrd ^(loop^)/isolinux/initrd0.img
echo     }
echo     return 0
echo }
echo.
echo function _entry_opensuse_leap {
echo     menuentry "${1}" --id opensuse "${2}" --class opensuse {
echo         set iso_path="$2"
echo         loopback loop "($isodir)$iso_path"
echo         linux ^(loop^)/boot/x86_64/loader/linux root=live:CDLABEL=openSUSE_Leap_15.0_GNOME_Live rd.live.image rd.live.overlay.persistent rd.live.overlay.cowfs=ext4 iso-scan/filename=$iso_path
echo         initrd ^(loop^)/boot/x86_64/loader/initrd
echo     }
echo     return 0
echo }
echo function _entry_opensuse_tumblew {
echo     menuentry "${1}" --id opensuse "${2}" --class opensuse {
echo         set iso_path="$2"
echo         loopback loop "($isodir)$iso_path"
echo         linux ^(loop^)/boot/x86_64/loader/linux root=live:CDLABEL=openSUSE_Tumbleweed_KDE_Live rd.live.image rd.live.overlay.persistent rd.live.overlay.cowfs=ext4 iso-scan/filename=$iso_path
echo         initrd ^(loop^)/boot/x86_64/loader/initrd
echo     }
echo     return 0
echo }
echo.
echo function _entry_ophcrack {
echo     menuentry "${1}" --id ophcrack "${2}" --class ophcrack {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         linux ^(loop^)/boot/bzImage rw root=/dev/null vga=normal lang=C kmap=us screen=1024x768x16 autologin
echo         initrd ^(loop^)/boot/rootfs.gz
echo     }
echo     return 0
echo }
echo.
echo function _entry_parrot {
echo     menuentry "${1}" --id parrot "${2}" --class parrot {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         linux ^(loop^)/live/vmlinuz findiso=$iso_path boot=live hostname=parrot components noautomount
echo         initrd ^(loop^)/live/initrd.img
echo     }
echo     return 0
echo }
echo.
echo function _entry_pclinux {
echo     menuentry "${1}" --id pclinux "${2}" --class pclinux {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         linux ^(loop^)/isolinux/vmlinuz livecd=livecd root=/dev/rd/3 vga=788 keyb=us findiso=$iso_path
echo         initrd ^(loop^)/isolinux/initrd.gz
echo     }
echo     return 0
echo }
echo.
echo function _entry_slackware {
echo     menuentry "${1}" --id slackware "${2}" --class slackware {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         linux ^(loop^)/kernels/huge.s/bzImage vga=normal load_ramdisk=1 prompt_ramdisk=0 ro printk.time=0 nomodeset SLACK_KERNEL=huge.s iso-scan/filename=$iso_path
echo         initrd ^(loop^)/isolinux/initrd.img
echo     }
echo     return 0
echo }
echo.
echo function _entry_pepper {
echo     menuentry "${1}" --id pepper "${2}" --class pepper {
echo         set iso_path="$2"
echo         export iso_path
echo         search --set=root --file $iso_path
echo         probe -u -s rootuuid $root
echo         export rootuuid
echo         loopback loop $iso_path
echo         root=^(loop^)
echo         configfile /boot/grub/loopback.cfg
echo         loopback --delete loop
echo     }
echo     return 0
echo }
echo.
echo function _entry_pentoo {
echo     menuentry "${1}" --id pentoo "${2}" --class pentoo {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         bootoptions="root=/dev/ram0 init=/linuxrc dokeymap looptype=squashfs loop=/image.squashfs cdroot vga=791 isoboot=$iso_path"
echo         linux ^(loop^)/isolinux/pentoo $bootoptions
echo         initrd ^(loop^)/isolinux/pentoo.igz
echo     }
echo     return 0
echo }
echo.
echo function _entry_pinguyos {
echo     menuentry "${1}" --id pinguyos "${2}" --class pinguy {
echo         set iso_path="$2"
echo         export iso_path
echo         search --set=root --file $iso_path
echo         probe -u -s rootuuid $root
echo         export rootuuid
echo         loopback loop $iso_path
echo         root=^(loop^)
echo         configfile /boot/grub/grub.cfg
echo         loopback --delete loop
echo     }
echo     return 0
echo }
echo.
echo function _entry_pop {
echo     menuentry "${1}" --id pop "${2}" --class pop {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         linux ^(loop^)/casper_pop-os_19.04_amd64_intel_debug_25/vmlinuz.efi boot=casper live-media-path=/casper_pop-os_19.04_amd64_intel_debug_25 hostname=pop-os username=pop-os iso-scan/filename=$iso_path
echo         initrd ^(loop^)/casper_pop-os_19.04_amd64_intel_debug_25/initrd.gz
echo     }
echo     return 0
echo }
echo.
echo function _entry_porteus {
echo     menuentry "${1}" --id porteus "${2}" --class porteus {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         linux ^(loop^)/boot/syslinux/vmlinuz changes=/porteus cliexec=\$^(zkp^)/initthis.cfg delay=4 kmap=us vga=791 utc iso-scan/filename=$iso_path
echo         initrd ^(loop^)/boot/syslinux/initrd.xz
echo     }
echo     return 0
echo }
echo.
echo function _entry_pup {
echo     menuentry "${1}" --id pup "${2}" --class linux {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         linux ^(loop^)/vmlinuz pfix=ram iso-scan/filename=$iso_path
echo         initrd ^(loop^)/initrd.gz
echo     }
echo     return 0
echo }
echo.
echo function _entry_q4os {
echo     menuentry "${1}" --id q4os "${2}" --class q4os {
echo         set iso_path="$2"
echo         export iso_path
echo         search --set=root --file $iso_path
echo         probe -u -s rootuuid $root
echo         export rootuuid
echo         loopback loop $iso_path
echo         root=^(loop^)
echo         configfile /boot/grub/grub.cfg
echo         loopback --delete loop
echo     }
echo     return 0
echo }
echo.
echo function _entry_qubes {
echo     menuentry "${1}" --id qubes "${2}" --class qubes {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         linux ^(loop^)/isolinux/vmlinuz inst.stage2=hd:LABEL=Qubes-R4.0-x86_64 xdriver=vesa nomodeset iso-scan/filename=$iso_path
echo         initrd ^(loop^)/isolinux/initrd.img ^(loop^)/isolinux/xen.gz
echo     }
echo     return 0
echo }
echo.
echo function _entry_react {
echo     menuentry "${1}" --id react "${2}" --class react {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         root=^(loop^)
echo         multiboot ^(loop^)/loader/freeldr.sys
echo     }
echo     return 0
echo }
echo.
echo function _entry_redcore {
echo     menuentry "${1} - Legacy mode only" --id redcore "${2}" --class redcore {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         linux ^(loop^)/boot/vmlinuz rd.live.image root=CDLABEL=REDCORE rootfstype=auto vconsole.keymap=us rd.locale.LANG=en_US.utf8 modprobe.blacklist=vboxvideo loglevel=1 console=tty0 rd.luks=0 rd.lvm=0 rd.md=0 rd.dm=0 iso-scan/filename=$iso_path
echo         initrd ^(loop^)/boot/initrd
echo     }
echo     return 0
echo }
echo.
echo function _entry_sabayon {
echo     menuentry "${1}" --id sabayon "${2}" --class sabayon {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         linux ^(loop^)/boot/sabayon root=/dev/ram0 overlayfs cdroot root=live:UUID=5c403dad00049b51 rootfstype=auto rd.live.overlay.overlayfs rd.live.image isoboot=$iso_path
echo         initrd ^(loop^)/boot/sabayon.igz
echo     }
echo     return 0
echo }
echo.
echo function _entry_slacko {
echo     menuentry "${1}" --id slacko "${2}" --class slacko {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         linux ^(loop^)/vmlinuz iso-scan/filename=$iso_path
echo         initrd ^(loop^)/initrd.gz
echo     }
echo     return 0
echo }
echo.
echo function _entry_slackware {
echo     menuentry "${1}" --id slackware "${2}" --class slackware {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         linux ^(loop^)/kernels/huge.s/bzImage vga=normal load_ramdisk=1 prompt_ramdisk=0 ro printk.time=0 nomodeset SLACK_KERNEL=huge.s iso-scan/filename=$iso_path
echo         initrd ^(loop^)/isolinux/initrd.img
echo     }
echo     return 0
echo }
echo.
echo function _entry_slax {
echo     menuentry "${1}" --id slax "${2}" --class slax {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         linux ^(loop^)/slax/boot/vmlinuz vga=normal load_ramdisk=1 prompt_ramdisk=0 rw printk.time=0 slax.flags=perch,automount iso-scan/filename=$iso_path
echo         initrd ^(loop^)/slax/boot/initrfs.img
echo     }
echo     return 0
echo }
echo.
echo function _entry_solus {
echo     menuentry "${1}" --id solus "${2}" --class solus {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         linux ^(loop^)/boot/kernel root=live:CDLABEL=SolusLiveBudgie ro rd.luks=0 rd.md=0 iso-scan/filename=$iso_path
echo         initrd ^(loop^)/boot/initrd.img
echo     }
echo     return 0
echo }
echo.
echo function _entry_sparky {
echo     menuentry "${1}" --id sparky "${2}" --class sparky {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         linux ^(loop^)/live/vmlinuz boot=live live-config live-media-path=/live iso-scan/filename=$iso_path
echo         initrd ^(loop^)/live/initrd.img
echo     }
echo     return 0
echo }
echo.
echo function _entry_steam {
echo     menuentry "${1}" --id steam "${2}" --class steamos {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         linux ^(loop^)/install.amd/vmlinuz preseed/file=/cdrom/default.preseed DEBCONF_DEBUG=developer preseed/file=/cdrom/default.preseed DEBCONF_DEBUG=developer desktop=steamos priority=high vga=788 iso-scan/filename=$iso_path
echo         initrd ^(loop^)/install.amd/gtk/initrd.gz
echo     }
echo     return 0
echo }
echo.
echo function _entry_subgraph {
echo     menuentry "${1}" --id subgraph "${2}" --class subgraph {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         linux ^(loop^)/live/vmlinuz boot=live noconfig=sudo username=user user-fullname=User hostname=subgraph union=overlay quiet splash apparmor=1 security=apparmor iso-scan/filename=$iso_path
echo         initrd ^(loop^)/live/initrd.img
echo     }
echo     return 0
echo }
echo.
echo function _entry_tails {
echo     menuentry "${1}" --id tails "${2}" --class tails {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         linux ^(loop^)/live/vmlinuz boot=live config live-media=removable nopersistence noprompt timezone=Etc/UTC block.events_dfl_poll_msecs=1000 splash noautologin module=Tails slab_nomerge slub_debug=FZP mce=0 vsyscall=none page_poison=1 mds=full,nosmt union=aufs iso-scan/filename=$iso_path
echo         initrd ^(loop^)/live/initrd.img
echo     }
echo     return 0
echo }
echo.
echo function _entry_true {
echo     menuentry "${1}" --id true "${2}" --class true {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         linux ^(loop^)/vmlinuz iso-scan/filename=$iso_path
echo         initrd ^(loop^)/initrd.gz
echo     }
echo     return 0
echo }
echo.
echo function _entry_septor {
echo     menuentry "${1}" --id septor "${2}" --class septor {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         linux ^(loop^)/live/vmlinuz boot=live components quiet splash keyboard-layouts=us iso-scan/filename=$iso_path
echo         initrd ^(loop^)/live/initrd.img
echo     }
echo     return 0
echo }
echo.
echo function _entry_ubuntu {
echo     menuentry "${1}" --id ubuntu "${2}" --class ubuntu {
echo         set iso_path="$2"
echo         export iso_path
echo         search --set=root --file $iso_path
echo         probe -u -s rootuuid $root
echo         export rootuuid
echo         loopback loop $iso_path
echo         root=^(loop^)
echo         configfile /boot/grub/loopback.cfg
echo         loopback --delete loop
echo     }
echo     return 0
echo }
echo.
echo function _entry_ultimate {
echo     menuentry "${1}" --id ultimate "${2}" --class ultimate {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         set gfxpayload=keep
echo         linux ^(loop^)/casper/vmlinuz file=/cdrom/preseed/ultimate.seed boot=casper iso-scan/filename=$iso_path --
echo         initrd ^(loop^)/casper/initrd.lz
echo     }
echo     return 0
echo }
echo.
echo function _entry_voyager {
echo     menuentry "${1}" --id voyager "${2}" --class voyager {
echo         set iso_path="$2"
echo         export iso_path
echo         search --set=root --file $iso_path
echo         probe -u -s rootuuid $root
echo         export rootuuid
echo         loopback loop $iso_path
echo         root=^(loop^)
echo         configfile /boot/grub/loopback.cfg
echo         loopback --delete loop
echo     }
echo     return 0
echo }
echo.
echo function _entry_voyager9 {
echo     menuentry "${1}" --id voyager "${2}" --class voyager {
echo         terminal_output gfxterm
echo         set iso_path="$2"
echo         loopback aloop $iso_path
echo         insmod play
echo         play 960 440 1 0 4 440 1
echo         linux ^(aloop^)/live/vmlinuz boot=live components locales=en_US.UTF-8 keyboard-layouts=us memtest noapic noapm nodma nomce nolapic nomodeset nosmp nosplash vga=normal iso-scan/filename=$iso_path
echo         initrd ^(aloop^)/live/initrd.img
echo     }
echo     return 0
echo }
echo.
echo function _entry_zorin {
echo     menuentry "${1}" --id zorin "${2}" --class zorin {
echo         set iso_path="$2"
echo         export iso_path
echo         search --set=root --file $iso_path
echo         probe -u -s rootuuid $root
echo         export rootuuid
echo         loopback loop $iso_path
echo         root=^(loop^)
echo         configfile /boot/grub/loopback.cfg
echo         loopback --delete loop
echo     }
echo     return 0
echo }
echo.
echo function _entry_redobackup {
echo     menuentry "${1}" --id redobackup "${2}" {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         linux ^(loop^)/casper/vmlinuz boot=casper vga=791 quiet splash iso-scan/filename=$iso_path --
echo         initrd ^(loop^)/casper/initrd.lz
echo     }
echo     return 0
echo }
echo.
echo function _entry_rosa {
echo     menuentry "${1}" --id rosa "${2}" --class rosa {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         linux ^(loop^)/isolinux/vmlinuz0 root=live:LABEL=ROSA.FRESH.KDE.R10.x86_64 ro rd.live.image quiet rootflags=rw,noatime rd.luks=0 rd.md=0 rd.dm=0 rhgb splash=silent logo.nologo iso-scan/filename=$iso_path
echo         initrd ^(loop^)/isolinux/initrd0.img
echo     }
echo     return 0
echo }
echo.
echo function _entry_rescatux {
echo     menuentry "${1}" --id rescatux "${2}" --class rescatux {
echo         set iso_path="$2"
echo         export iso_path
echo         search --set=root --file $iso_path
echo         probe -u -s rootuuid $root
echo         export rootuuid
echo         loopback loop $iso_path
echo         root=^(loop^)
echo         configfile /boot/grub/grub.cfg
echo         loopback --delete loop
echo     }
echo     return 0
echo }
echo.
echo function _entry_trisquel {
echo     menuentry "${1}" --id trisquel "${2}" --class trisquel {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         set gfxpayload=keep
echo         linux ^(loop^)/casper/vmlinuz  file=/cdrom/preseed/trisquel.seed boot=casper iso-scan/filename=$iso_path
echo         initrd ^(loop^)/casper/initrd
echo     }
echo     return 0
echo }
echo.
echo function _entry_wifislax {
echo     menuentry "${1}" --id wifislax "${2}" --class wifislax {
echo         set iso_path="$2"
echo         export iso_path
echo         search --set=root --file $iso_path
echo         loopback loop $iso_path
echo         linux ^(loop^)/boot/vmlinuz livemedia=/dev/disk/by-uuid/$rootuuid:$iso_path kbd=us kbd tz=US/Pacific tz locale=en_US.utf8 locate xkb= xkb rw nop iso-scan/filename=$iso_path
echo         initrd ^(loop^)/boot/initrd.xz
echo     }
echo     return 0
echo }
echo.
echo.
echo.
echo ### PARTITION TOOLS ###
echo.
echo function _entry_aiosrt {
echo     menuentry "${1}" --id aiosrt "${2}" --class hirens {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         set gfxpayload=keep
echo         linux ^(loop^)/casper/vmlinuz.efi boot=casper iso-scan/filename=$iso_path
echo         initrd ^(loop^)/casper/initrd.lz
echo     }
echo     return 0
echo }
echo.
echo function _entry_bootrepairdisk {
echo     menuentry "${1}" --id bootrepairdisk "${2}" --class repair {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         set gfxpayload=keep
echo         linux ^(loop^)/casper/vmlinuz.efi iso-scan/filename=$iso_path file=/cdrom/preseed/lubuntu.seed boot=casper
echo         initrd ^(loop^)/casper/initrd.lz
echo     }
echo     return 0
echo }
echo.
echo function _entry_clonezilla {
echo     menuentry "${1}" --id clonezilla "${2}" --class clonezilla {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         linux ^(loop^)/live/vmlinuz findiso=$iso_path boot=live union=overlay username=user config quiet noswap edd=on nomodeset noeject toram=filesystem.squashfs vga=normal nosplash
echo         initrd ^(loop^)/live/initrd.img
echo     }
echo     return 0
echo }
echo.
echo function _entry_easyre {
echo     menuentry "${1}" --id easyre "${2}" --class easyrecovery {
echo         set iso_path="$2"
echo         set opts='map $iso_path ^(0xff^);
echo                   map --hook;
echo                   chainloader ^(0xff^);'
echo         linux16 /BOOT/GRUB/grub.exe --config-file=${opts}
echo     }
echo     return 0
echo }
echo.
echo function _entry_easyre_w8 {
echo     menuentry "${1}" --id easyre_w8 "${2}" --class easyrecovery {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         probe -u $root --set=rootuuid
echo         set imgdevpath="/dev/disk/by-uuid/$rootuuid"
echo         linux ^(loop^)/boot/bzImage rw root=/dev/null autologin sound=noconf kmap=en acpi=off noapic nolapic noacpi nomodeset @LXV3NSAtZTE0MTg1NzgwMzUgLXpiYmIxNjIwMjM3MTZmYTQ3ZTg2OGIwZTg0YWVlOGY4Y2Y3NDdhMTE5 
echo         initrd ^(loop^)/boot/rootfs.gz
echo     }
echo     return 0
echo }
echo.
echo function _entry_easyre_w10 {
echo     menuentry "${1}" --id easyre_w10 "${2}" --class easyrecovery {
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo     }
echo     return 0
echo }
echo.
echo function _entry_grub4dos {
echo     menuentry "${1}" --id grub4dos "${2}" --class linux {
echo         set iso_path="$2"
echo         set opts='map $iso_path ^(0xff^);
echo                   map --hook;
echo                   chainloader ^(0xff^);'
echo         linux16 /BOOT/GRUB/grub.exe --config-file=${opts}
echo     }
echo     return 0
echo }
echo.
echo function _entry_minitool {
echo     menuentry "MiniTool Partition Wizard Boot Disk" --id minitool "${2}" --class minitool {
echo         set gfxpayload=keep
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         linux ^(loop^)/casper/vmlinuz.efi ramdisk_size=409600 root=/dev/ram0 rw iso-scan/filename=$iso_path
echo         initrd ^(loop^)/casper/tinycore.gz
echo     }
echo     return 0
echo }
echo.
echo function _entry_rdriveimage {
echo     menuentry "Start R-DriveImage" --id rdriveimage "${2}" --class r-drive-image {
echo         set gfxpayload=keep
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         if [ "${grub_cpu}" == "x86_64" ]; then
echo            linux ^(loop,msdos3^)/kernel64 vga=791 iso-scan/filename=$iso_path
echo            initrd ^(loop,msdos3^)/lrfsbase.bin ^(loop,msdos3^)/rm_scsi.b64 ^(loop,msdos3^)/rm_pata.b64 ^(loop,msdos3^)/rm_usb.b64 ^(loop,msdos3^)/rm_pcard.b64 ^(loop,msdos3^)/rm_video.b64 ^(loop,msdos3^)/rm_other.b64 ^(loop,msdos3^)/rootgui ^(loop,msdos3^)/rmconfig.bin
echo         fi
echo         if [ "${grub_platform}" == "pc" ]; then
echo            linux16 /boot/grub/i386-pc/memdisk iso raw
echo            initrd16 $iso_path
echo         fi
echo     }
echo     return 0
echo }
echo.
echo function _entry_paragon {
echo     menuentry "Start Paragon-RCD in normal mode" --id paragon "${2}" --class paragon {
echo         set gfxpayload=keep
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         linux ^(loop^)/boot/x86_64/loader/linux ramdisk_size=512000 ramdisk_blocksize=4096 vga=0x314 splash=silent panic=1
echo         initrd ^(loop^)/boot/x86_64/loader/initrd
echo     }
echo     menuentry "Start Paragon-RCD in safe mode" --id paragon "${2}" --class paragon {
echo         set gfxpayload=keep
echo         set iso_path="$2"
echo         loopback loop $iso_path
echo         linux ^(loop^)/boot/x86_64/loader/linux ramdisk_size=512000 ramdisk_blocksize=4096 splash=silent ide=nodma apm=off noresume edd=off powersaved=off nohz=off highres=off processsor.max+cstate=1 vga=0x314 panic=1 nomodeset x11failsafe
echo         initrd ^(loop^)/boot/x86_64/loader/initrd
echo     }
echo     return 0
echo }
echo.
echo function _entry_pmagic {
echo     menuentry "${1}" --id pmagic "${2}" {
echo         set iso_path="$2"
echo         set kernel="(loop)/pmagic/bzImage"
echo         set initrd="(loop)/pmagic/initrd.img (loop)/pmagic/fu.img (loop)/pmagic/m32.img"
echo         if cpuid -l; then
echo             set kernel="(loop)/pmagic/bzImage64"
echo             set initrd="(loop)/pmagic/initrd.img (loop)/pmagic/fu.img (loop)/pmagic/m64.img"
echo         fi
echo         loopback loop $iso_path
echo         linux $kernel edd=on vga=normal vmalloc=512MiB boot=live eject=no iso_filename=$iso_path load_ramdisk=1 --
echo         initrd $initrd
echo     }
echo     return 0
echo }
echo.
echo function _entry_systemrescuecd {
echo     submenu "${submenu_symbol}${1}" --id systemrescuecd "${2}" --class systemrescuecd {
echo         set iso_path="${2}"; export iso_path
echo         regexp --set=1:archi  '^.*/.*-^(.+^)\..*$' $iso_path
echo         loopback loop $iso_path
echo         probe -l ^(loop^) --set=mlabel
echo         set kernel="(loop)/sysresccd/boot/x86_64/vmlinuz"
echo         if cpuid -l; then
echo             set kernel="(loop)/sysresccd/boot/x86_64/vmlinuz"
echo         fi
echo         set initrd="(loop)/sysresccd/boot/intel_ucode.img (loop)/sysresccd/boot/amd_ucode.img (loop)/sysresccd/boot/x86_64/sysresccd.img"
echo         set cmdline="archisobasedir=sysresccd archisodevice=/dev/disk/by-label/$mlabel setkmap=us rootpass=rescue"
echo         menuentry "System Rescue CD (default options)" --id boot --class systemrescuecd {
echo             loopback loop $iso_path
echo             linux $kernel isoloop=$iso_path $cmdline
echo             initrd $initrd
echo         }
echo         menuentry "System Rescue CD (dostartx)" --class systemrescuecd {
echo             loopback loop $iso_path
echo             linux $kernel isoloop=$iso_path $cmdline dostartx
echo             initrd $initrd
echo         }
echo         menuentry "System Rescue CD (docache)" --class systemrescuecd {
echo             loopback loop $iso_path
echo             linux $kernel isoloop=$iso_path $cmdline docache
echo             initrd $initrd
echo         }
echo         menuentry "System Rescue CD (serial)" --class systemrescuecd {
echo             loopback loop $iso_path
echo             linux $kernel isoloop=$iso_path $cmdline console=tty0 console=ttyS0,115200n8
echo             initrd $initrd
echo         }
echo         menuentry "MEMTEST: Memory test using Memtest86+" {
echo             loopback loop $iso_path
echo             linux16 ^(loop^)/bootdisk/memtestp
echo         }
echo         menuentry "NTPASSWD: Reset or edit Windows passwords" {
echo             loopback loop $iso_path
echo             linux16 ^(loop^)/ntpasswd/vmlinuz rw vga=1
echo             initrd16 ^(loop^)/ntpasswd/initrd.cgz ^(loop^)/ntpasswd/scsi.cgz
echo         }
echo         menuentry "SGD: Super Grub2 Disk" {
echo             loopback loop $iso_path
echo             linux16 ^(loop^)/isolinux/memdisk floppy raw
echo             initrd16 ^(loop^)/bootdisk/grubdisk.img
echo         }
echo         menuentry "FREEDOS: Clone of the MSDOS Operating System" {
echo             loopback loop $iso_path
echo             linux16 ^(loop^)/isolinux/memdisk floppy
echo             initrd16 ^(loop^)/bootdisk/freedos.img
echo         }
echo         menuentry "NETBOOT: Boot from the network" {
echo             loopback loop $iso_path
echo             linux16 ^(loop^)/isolinux/netboot
echo         }
echo         menuentry "HDT: recent hardware diagnostics tool" {
echo             loopback loop $iso_path
echo             linux16 ^(loop^)/isolinux/memdisk floppy
echo             initrd16 ^(loop^)/bootdisk/hdt.img
echo         }
echo         menuentry "AIDA: old hardware diagnostics tool" {
echo             loopback loop $iso_path
echo             linux16 ^(loop^)/isolinux/memdisk floppy
echo             initrd16 ^(loop^)/bootdisk/aida.img
echo         }
echo         menuentry "GAG: Graphical Boot Manager" {
echo             loopback loop $iso_path
echo             linux16 ^(loop^)/isolinux/memdisk floppy
echo             initrd16 ^(loop^)/bootdisk/gag.img
echo         }
echo         menuentry "DBAN: erase all data from the disk" {
echo             loopback loop $iso_path
echo             linux16 ^(loop^)/bootdisk/dban.bzi nuke="dwipe" silent
echo         }
echo         menuentry "MHDD: Low-level Hard Drive diagnostic tool" {
echo             loopback loop $iso_path
echo             linux16 ^(loop^)/isolinux/memdisk floppy
echo             initrd16 ^(loop^)/bootdisk/mhdd.img
echo         }
echo     }
echo     return 0
echo }
echo.
echo.
echo.
echo ### ANTIVIRUS LIVE ISO ###
echo.
echo function _entry_bitdefender {
echo     menuentry "${1}" --id bitdefender "${2}" --class icon-bit {
echo         set iso_path="$2"
echo         loopback loop "($isodir)$iso_path"
echo         set root=loop
echo         insmod video_bochs
echo         insmod video_cirrus
echo         echo "Loading..."
echo         set SQUASHFILE="/rescue/livecd.squashfs"
echo         set kopts_common="root=/dev/ram0 real_root=/dev/loop0 loop=${SQUASHFILE} cdroot_marker=${SQUASHFILE} initrd udev cdroot scandelay=10"
echo         if [ "${grub_platform}" == "efi" ]; then
echo             linuxefi /boot/kernel.x86_64-efi ${kopts_common} lang=en iso-scan/filename=$iso_path
echo             initrdefi /boot/initfs.x86_64-efi
echo         fi
echo         if [ "${grub_platform}" == "pc" ]; then
echo             linux /boot/kernel.i386-pc ${kopts_common} lang=en iso-scan/filename=$iso_path
echo             initrd /boot/initfs.i386-pc
echo         fi
echo     }
echo     return 0
echo }
echo.
echo function _entry_avira {
echo     menuentry "Avira Rescue System" --id avira "${2}" --class avira {
echo         set iso_path="$2"
echo         export iso_path
echo         set gfxpayload=keep
echo         search --set=root --file $iso_path
echo         loopback loop $iso_path
echo         linux ^(loop^)/casper/vmlinuz file=/cdrom/preseed/ubuntu.seed boot=casper -- debian-installer/language=en console-setup/layoutcode=en iso-scan/filename=${iso_path}
echo         initrd ^(loop^)/casper/initrd.lz
echo     }
echo     return 0
echo }
echo.
echo function _entry_kaspersky {
echo     menuentry "Kaspersky Rescue Disk 18" --id kaspersky "${2}" --class kav {
echo         set iso_path=/DATA/krd.iso
echo         export iso_path
echo         search --set=root --file $iso_path
echo         loopback loop $iso_path
echo         if cpuid -l; then set _kernel="k-x86_64"; else set _kernel_="k-x86"; fi
echo         linux ^(loop^)/boot/grub/${_kernel} net.ifnames=0 lang=en dostartx isoloop=krd.iso
echo         initrd ^(loop^)/boot/grub/initrd.xz
echo     }
echo     return 0
echo }
)
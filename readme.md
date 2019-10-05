

## Multiboot Toolkit

A small program to allow you to create a bootable disk on USB Flash Drive or HDD/SSD External Hard Drive. It works well for both       Legacy BIOS Mode and UEFI Mode.

> **USB Flash drive:**
Multiboot Toolkit only supports to create a bootable disk base on the MBR partition table.

> **HDD/SSD External Hard Drive:** 
It is supported to create a bootable disk for both the MBR partition table and the GPT partition table without losing your data.





## Features
1. Supported boot Legacy BIOS mode with Grub2, Grub4dos and Syslinux
2. Supported boot UEFI mode with rEFInd, Grub2, Clover and Xorboot
3. Boot into Windows / Linux / macOS UEFI mode via rEFInd in Multiboot OS
4. Supported for booting Linux live ISO (only show menu when ISO file is available)
5. Supported for booting Live Antivirus which used to scan for viruses outside the Windows environment
6. Supported boot live hacker distros include powerful tools in pentesting, anonymity, forensics
7. Supported rescue tools, such as Acronis True Image, Parted Magic, Bitdefender Rescue CD
8. WinPE SE boot supported for advanced rescue (partition, rescue data, test computer hardware through WinPE SE)
9. Install Windows directly through WinSetupfromUSB or indirectly through WinPE SE




## Platform

   Windows (7 or higher version)
   
   > Recommend to use on Windows 10 for multi-language supporting.





## Installing

Run batch files as administrator to install/add modules/customize a multiboot device.

**1. Create bootable disk:**
   ![Install-Multiboot.png](https://i.imgur.com/22DKPp2.png)

**2. Intergrate Modules:**
   ![Install-Modules.png](https://i.imgur.com/ndqOxtq.png)

**2. Customize/Repair Multiboot Device:**
   ![Extra-Features.png](https://i.imgur.com/WxEitMe.png)





## Running the tests

 * Run "[ 03 ] Extra-Features.bat" as administrator >> Just Enter to open QemuBootTester
 * Or setup virtual machine with [Virtual Machine USB Boot](https://github.com/DavidBrenner3/VMUB/releases) to test it (recommend)
  
   



## Preview
**1. Grub2 Menu:**
  ![grub2menu.png](https://i.imgur.com/TwDUn5W.jpg)
  
**2. rEFInd Menu:**
  ![rEFindmenu.png](https://i.imgur.com/vDD6uso.jpg)



## For my particular thanks to the author of the following projects:
   1. Bootloader & Boot Manager: [GRUB2](https://www.gnu.org/software/grub) | [rEFInd](http://www.rodsbooks.com/refind) | [Clover EFI](https://clover-wiki.zetam.org) | [Syslinux](http://www.syslinux.org) | [Grub4dos](http://grub4dos.chenall.net)
   
   2. Disk Tools: [AOMEI Partition Assistant](http://www.disk-partition.com) | [BootICE](http://www.ipauly.com) | [GPT fdisk ](http://www.rodsbooks.com/gdisk) | [WinCDEmu](http://wincdemu.sysprogs.org)
   
   3. Grub2 File Manager: [Grub2 File Manager](https://a1ive.github.io/grub2-filemanager)
   
   4. Development Tools: [7-Zip](http://www.7-zip.org) | [Wget](https://www.gnu.org/software/wget) | [Curl](https://curl.haxx.se/windows)
   
   5. Utility tools: [WinSetupFromUSB](http://www.winsetupfromusb.com) | [YUMI boot](https://www.pendrivelinux.com) | [Ntfs Drive Protection](http://www.sordum.org)

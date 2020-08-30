## Multiboot Toolkit

A small program to allow you to create a bootable disk on USB Flash Drive or HDD/SSD External Hard Drive. It works well for both Legacy BIOS Mode and UEFI Mode.

> **USB Flash drive:**
> Multiboot Toolkit supports to create a bootable disk base on the MBR partition table (recommended). Bootable disk base on the GPT partition table still in beta with limited features.

> **HDD/SSD External Hard Drive:**
> It is supported to create a bootable disk for both the MBR partition table and the GPT partition table without losing your data.

## Features

1. Support booting in both Legacy BIOS mode & UEFI mode.
2. Secure boot for WinPE via Windows Boot Manager only.
3. Manage multi-OS easily via rEFInd or Clover Boot Manager.
4. Install Windows and Linux directly from ISO via live mode.
5. Easy to customize bootable disk and bootloader/bootmanager.

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

- [ 3 ] CUSTOM THE MULTIBOOT DEVICE >> press [ n ] to open QemuBootTester
- Or setup virtual machine with [Virtual Machine USB Boot](https://github.com/DavidBrenner3/VMUB/releases) to test it (recommended)

## Preview

**1. Grub2 Menu:**
![grub2menu.png](https://i.imgur.com/TwDUn5W.jpg)

**2. rEFInd Menu:**
![rEFindmenu.png](https://i.imgur.com/vDD6uso.jpg)

## For my particular thanks to the author of the following projects:

1.  Bootloader & Boot Manager: [GRUB2](https://www.gnu.org/software/grub) | [rEFInd](http://www.rodsbooks.com/refind) | [Clover EFI](https://clover-wiki.zetam.org) | [Syslinux](http://www.syslinux.org) | [Grub4dos](http://grub4dos.chenall.net)

2.  Disk Tools: [AOMEI Partition Assistant](http://www.disk-partition.com) | [BootICE](http://www.ipauly.com) | [GPT fdisk ](http://www.rodsbooks.com/gdisk) | [WinCDEmu](http://wincdemu.sysprogs.org)

3.  Grub2 File Manager: [Grub2 File Manager](https://a1ive.github.io/grub2-filemanager)

4.  Development Tools: [7-Zip](http://www.7-zip.org) | [Wget](https://www.gnu.org/software/wget) | [Curl](https://curl.haxx.se/windows)

5.  Utility tools: [WinSetupFromUSB](http://www.winsetupfromusb.com) | [YUMI boot](https://www.pendrivelinux.com) | [Ntfs Drive Protection](http://www.sordum.org)

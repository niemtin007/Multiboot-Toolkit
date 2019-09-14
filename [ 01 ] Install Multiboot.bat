@echo off

rem >> https://niemtin007.blogspot.com
rem >> The batch file is written by niemtin007.
rem >> Thank you for using Multiboot Toolkit.

title %~nx0
cd /d "%~dp0"
set "lang=English"
set "rtheme=Universe"
set "gtheme=Breeze-5"
set "bindir=%~dp0bin"
call :check.data
rem >> check device
call :scan.label MULTIBOOT
call :check.author %ducky%
call :check.letter X:

:Select
rem begin preparing file
cd /d "%tmp%"
    if not exist rEFInd_themes (mkdir rEFInd_themes)
cd /d "%bindir%"
    call colortool.bat
    7za x "rEFInd_themes\%rtheme%.7z" -o"%tmp%\rEFInd_themes" -aoa -y > nul
    7za x "refind.7z" -o"%tmp%" -aoa -y > nul
rem end preparing file
%partassist% /list
echo.
set /p disk= %_lang0101_%
set /a disk=%disk%+0
call :check.virtualdisk
    if "%virtualdisk%"=="true" call :rEFInd.part & goto :External
call :check.harddisk
    if "%harddisk%"=="true" goto :Select
call :check.usbdisk
    if "%usb%"=="true" call :rEFInd.part & goto :Removable
call :check.externaldisk
    if "%externaldisk%"=="true" call :rEFInd.part & goto :External
color 4f & echo. & echo %_lang0104_% & timeout /t 15 > nul & goto :Select

:Removable
rem >> prepare partitions space for Removable Media
cls
rem need use bootice to rebuild MBR disk partition. It's important for flash drive.
%bootice% /device=%disk% /partitions /repartition /usb-hdd /fstype=fat32 /quiet
%partassist% /hd:%disk% /del:all
rem >> create rEFInd partition
%partassist% /hd:%disk% /cre /pri /size:%esp% /end /fs:fat32 /align /label:rEFInd /letter:X
if not exist "X:\" (
    %partassist% /hd:%disk% /setletter:0 /letter:X
)
cd /d "X:\"
    mkdir "X:\ISO\"
    mkdir "X:\EFI\BOOT\themes\"
    >"X:\EFI\BOOT\mark" (echo niemtin007)
cd /d "%tmp%"
    xcopy "rEfind" "X:\EFI\BOOT\" /e /g /h /r /y /q > nul
cd /d "%tmp%\rEfind_themes"
    xcopy "%rtheme%" "X:\EFI\BOOT\themes\" /e /g /h /r /y /q > nul
%partassist% /hd:%disk% /hide:0
if "%secureboot%"=="n" goto :usbmultibootdata
rem >> create ESP partition
%partassist% /hd:%disk% /cre /pri /size:50 /fs:fat32 /label:M-ESP /letter:X
%partassist% /move:X /right:auto /align
if not exist "X:\" (
    %partassist% /hd:%disk% /setletter:0 /letter:X
)
cd /d "X:\"
    mkdir "X:\EFI\BOOT\"
    >"X:\EFI\BOOT\mark" (echo niemtin007)
cd /d "%tmp%\rEfind_themes\%rtheme%\icons"
    xcopy "others" "X:\EFI\BOOT\" /e /g /h /r /y /q
%partassist% /hd:%disk% /hide:0
rem >> create Multiboot data partition
:usbmultibootdata
%partassist% /hd:%disk% /cre /pri /size:auto /fs:ntfs /act /align /label:MULTIBOOT /letter:X
if not exist "X:\" (
    %partassist% /hd:%disk% /setletter:0 /letter:X
)
goto :extractdata

rem >> prepare partitions space for External hard disk media
:External
echo.
call :count.partition
    if not defined part goto :Setup rem the disk is an unallocated
    set /a "part=%part%+0"
    set /a GB=0
    set /p GB= %_lang0106_%
    set /a GB=%GB%+0
    rem check the character of the number
    echo %esp%| findstr /r "^[1-9][0-9]*$">nul
    if not "%errorlevel%"=="0" goto :External
    rem sum size of the esp partition
    set /a MB=(%GB%*1024+%esp%)
    if "%GB%"=="0" if "%installed%"=="true" (
        echo. & echo %_lang0107_% & timeout /t 300 > nul
        goto :delete
    )
    if "%GB%"=="0" (
        cls & echo. & color 4f
        echo %_lang0108_% & timeout /t 15 > nul
        goto :External
    )
    goto :continue
:delete
cd /d "%bindir%"
    call colortool.bat
call :count.partition
    if "%part%"=="%deletedpart%" goto :continue rem all partition was deleted
call :unhide.partition 0
call :check.author X:
if "%installed%"=="true" (
    set deletedpart=%part%
    %partassist% /hd:%disk% /del:0
    goto :delete
)
:continue
if exist "X:\" (chkdsk X: /f)
%partassist% /hd:%disk% /setletter:0 /letter:auto
%partassist% /hd:%disk% /resize:0 /reduce-left:%MB% /align

:Setup
if "%secureboot%"=="y" (goto :esp1) else (goto :esp2)
:esp1
cd /d "%bindir%" & call colortool.bat
rem >> Create EFI System Partition 1
%partassist% /hd:%disk% /cre /pri /size:50 /fs:fat32 /act /align /label:M-ESP /letter:X
if not exist "X:\" (
    %partassist% /hd:%disk% /setletter:0 /letter:X
)
cd /d "X:\"
    mkdir "X:\EFI\BOOT\"
    >"X:\EFI\BOOT\mark" (echo niemtin007)
cd /d "%tmp%\rEfind_themes\%rtheme%\icons"
    xcopy "others" "X:\EFI\BOOT\" /e /g /h /r /y /q > nul
%partassist% /hd:%disk% /hide:0
:esp2
cd /d "%bindir%" & call colortool.bat
rem >> Create EFI System Partition 2
%partassist% /hd:%disk% /cre /pri /size:%esp% /fs:fat32 /act /align /label:rEFInd /letter:X
if "%secureboot%"=="n" (set /a partition=0) else (set /a partition=1)
:recheckesp2
if not exist "X:\" (
    call :unhide.partition %partition%
    goto :recheckesp2
)
cd /d "X:\"
    mkdir "X:\ISO\"
    mkdir "X:\EFI\BOOT\themes\"
    >"X:\EFI\BOOT\mark" (echo niemtin007)
cd /d "%tmp%"
    xcopy "rEfind" "X:\EFI\BOOT\" /e /g /h /r /y /q > nul
cd /d "%tmp%\rEfind_themes"
    xcopy "%rtheme%" "X:\EFI\BOOT\themes\" /e /g /h /r /y /q > nul
%partassist% /hd:%disk% /hide:%partition%
rem >> Create Multiboot Data Partition
if not "%secureboot%"=="n" (
    set /a offset=%esp%+58
    set /a partition=1
) else (
    set /a offset=%esp%+8
    set /a partition=2
)
call :check.partitiontable
if "%GPT%"=="GPT:" (
    %partassist% /hd:%disk% /cre /pri /size:auto /offset:%offset% /fs:ntfs /act /align /label:MULTIBOOT /letter:X
) else (
    %partassist% /hd:%disk% /cre /pri /size:auto /fs:ntfs /act /align /label:MULTIBOOT /letter:X
)
rem >> Installing Multiboot Data
:recheckmultiboot
cd /d "%bindir%"
    call colortool.bat
if not exist "X:\" (
    call :unhide.partition %partition%
    goto :recheckmultiboot
)
:extractdata
call :scan.label MULTIBOOT
cd /d "%bindir%"
    if "%ducky%"=="X:" (
        "%bindir%\7za.exe" x "data.7z" -o"X:\" -aoa -y
    ) else (
        cls & echo. & color 4f
        echo %_lang0110_% & timeout /t 15 > nul & exit
    )
    >"X:\EFI\BOOT\mark" (echo niemtin007)
    >"X:\BOOT\grub\themes\theme" (echo %gtheme%)
    >"X:\BOOT\esp" (echo %esp%)
    >"X:\BOOT\lang" (echo %lang%)
    >"X:\BOOT\secureboot" (echo %secureboot%)
    xcopy "version" "X:\EFI\BOOT\" > nul
    if "%virtualdisk%"=="true" (
        >"X:\BOOT\virtualdisk" (echo true)
    )
    if "%GPT%"=="GPT:" (
        >"X:\BOOT\bootmgr\disk.gpt" (echo true)
    ) else (
        >"X:\BOOT\bootmgr\disk.mbr" (echo true)
    )
cd /d "%bindir%\config\bcd"
    xcopy "B84" "X:\BOOT\bootmgr\" /e /g /h /r /y /q > nul
cd /d "%bindir%\secureboot\BOOT"
    xcopy "boot.sdi" "X:\BOOT\" /e /g /h /r /y /q > nul
cd /d "%bindir%\extra-modules"
    xcopy "grub4dos\grldr" "X:\" /e /g /h /r /y /q >nul
    call "%bindir%\hidefile.bat"
cd /d "%bindir%"
    7za x "wincdemu.7z" -o"X:\ISO\" -aoa -y >nul
rem >> install Syslinux Bootloader
cd /d "%bindir%"
    syslinux --force --directory /BOOT/syslinux X: X:\BOOT\syslinux\syslinux.bin
rem >> install grub2 Bootloader
cd /d "%bindir%"
    if "%GPT%"=="GPT:" call :gdisk
    echo.
    echo ^>^> Installing Grub2 Bootloader...
    silentcmd grub2installer.bat MULTIBOOT
cd /d "%bindir%\extra-modules"
    "%bindir%\7za.exe" x "grub2-filemanager.7z" -o"X:\BOOT\grub\" -aoa -y > nul
cd /d "%bindir%"
    echo.
    echo %_lang0112_% %lang%
    7za x "%bindir%\config\%lang%.7z" -o"%ducky%\" -aoa -y > nul
cd /d "%tmp%\rEfind_themes\%rtheme%\icons"
    echo.
    echo %_lang0111_% %rtheme%
    >"%ducky%\BOOT\rEFInd" (echo %rtheme%)
    copy "grubx64.png" "X:\EFI\BOOT\grubx64.png" > nul
    copy "grubx64.png" "X:\EFI\BOOT\grubia32.png" > nul
    copy "winsetupx64.png" "X:\EFI\BOOT\winsetupx64.png" > nul
    copy "winsetupx64.png" "X:\EFI\BOOT\winsetupia32.png" > nul
    copy "xorbootx64.png" "X:\EFI\BOOT\xorbootx64.png" > nul
cd /d "%tmp%\rEfind_themes\%rtheme%\icons"
    xcopy "others" "X:\EFI\BOOT\" /e /g /h /r /y /q > nul
cd /d "%bindir%"
    echo.
    echo %_lang0113_% %gtheme%
    7za x "%bindir%\grub2_themes\%gtheme%.7z" -o"X:\BOOT\grub\themes\" -aoa -y > nul
cd /d "%bindir%\config"
    call "main.bat"
cd /d "%bindir%\secureboot\EFI\Microsoft\Boot"
    call "%bindir%\bcdautoset.bat" bcd
rem >> install secure boot file
set "source=%bindir%\secureboot"
rem > for USB
if "%usb%"=="true" if "%secureboot%"=="n" (
    >"X:\BOOT\secureboot" (echo n)
    cd /d "%tmp%\rEfind_themes\%rtheme%\icons"
        xcopy "others" "X:\EFI\BOOT\" /e /g /h /r /y /q > nul
    cd /d "%bindir%"
        xcopy "secureboot" "X:\" /e /g /h /r /y /q > nul
    %partassist% /hd:%disk% /setletter:0 /letter:auto
    call "%bindir%\exit.bat"
)
if "%usb%"=="true" if "%secureboot%"=="y" (
    %partassist% /hd:%disk% /whide:1 /src:%source%
    %partassist% /hd:%disk% /setletter:0 /letter:auto
)
rem > for HDD/SSD
if "%GPT%"=="GPT:" (set mpart=3) else (set mpart=2)
if not "%usb%"=="true" if "%secureboot%"=="y" (
    %partassist% /hd:%disk% /whide:0 /src:%source%
    %partassist% /hd:%disk% /setletter:%mpart% /letter:auto
)
if "%GPT%"=="GPT:" (set mpart=2) else (set mpart=1)
if not "%usb%"=="true" if "%secureboot%"=="n" (
    >"X:\BOOT\secureboot" (echo n)
    cd /d "%tmp%\rEfind_themes\%rtheme%\icons"
        xcopy "others" "X:\EFI\BOOT\" /e /g /h /r /y /q > nul
    cd /d "%bindir%"
        xcopy "secureboot" "X:\" /e /g /h /r /y /q > nul
    %partassist% /hd:%disk% /setletter:%mpart% /letter:auto
)
if "%installmodules%"=="y" (
    cd /d "%~dp0"
    call "[ 02 ] Install Modules.bat"
)
call "%bindir%\exit.bat"



rem >> begin functions
:check.data
if not exist "bin" (
    color 4f & echo.
    echo ^>^> Warning: Data Loss
    timeout /t 15 > nul & exit
) else (
    call "%bindir%\permissions.bat"
    call "%bindir%\language.bat"
    call "%bindir%\license.bat"
    call "%bindir%\partassist.bat"
)
exit /b 0

:scan.label
for /f %%b in ('wmic volume get driveletter^, label ^| findstr /i "%~1"') do set "ducky=%%b"
    if not defined ducky set "offline=true"
exit /b 0

:check.author
if exist "%~1\EFI\BOOT\mark" (
    for /f "tokens=*" %%b in (%~1\EFI\BOOT\mark) do set "author=%%b"
)
if "%author%"=="niemtin007" set "installed=true"
if "%offline%"=="true" goto :Select
if exist "%~1\EFI\BOOT\mark" if not defined author (
    cls & echo. & color 4f
    echo %_lang0109_% & timeout /t 15 > nul & exit
)
exit /b 0

:check.partitiontable
for /f "tokens=2" %%b in ('wmic path win32_diskpartition get type ^, diskindex ^| find /i "%disk%"') do set "GPT=%%b"
exit /b 0

:check.virtualdisk
wmic diskdrive get name, model | find /i "Msft Virtual Disk SCSI Disk Device" | find /i "\\.\physicaldrive%disk%" > nul
    if not errorlevel 1 set "virtualdisk=true"
wmic diskdrive get name, model | find /i "Microsoft Virtual Disk" | find /i "\\.\physicaldrive%disk%" > nul
    if not errorlevel 1 set "virtualdisk=true"
wmic diskdrive get name, model | find /i "Microsoft Sanal Diski" | find /i "\\.\physicaldrive%disk%" > nul
    if not errorlevel 1 set "virtualdisk=true"
exit /b 0

:check.harddisk
wmic diskdrive get name, mediatype | find /i "Fixed hard disk media" | find /i "\\.\physicaldrive%disk%" > nul
    if not errorlevel 1 (
        set "harddisk=true"
        echo. & echo. & echo %_lang0102_%
        color 4f & echo %_lang0103_% & timeout /t 15 > nul & cls
    )
exit /b 0

:check.usbdisk
wmic diskdrive get name, mediatype | find /i "Removable Media" | find /i "\\.\physicaldrive%disk%" > nul
    if not errorlevel 1 set "usb=true"
exit /b 0

:check.externaldisk
wmic diskdrive get name, mediatype | find /i "External hard disk media" | find /i "\\.\physicaldrive%disk%" > nul
    if not errorlevel 1 set "externaldisk=true"
exit /b 0

:check.letter
for /f "tokens=2 delims= " %%b in ('wmic path win32_logicaldisktopartition get antecedent^, dependent ^| find /i "%~1"') do set "disk=%%b"
    if not defined disk set "match=false"
    set "disk=%disk:~1,1%"
    set /a disk=%disk%+0
wmic diskdrive get name, model, interfacetype, mediatype | find /i "\\.\physicaldrive%disk%" | find /i "Fixed hard disk media" > nul
    if "%errorlevel%"=="0" (
        if exist "X:\" (
            color 4f & echo. & echo %_lang0000_% & timeout /t 15 > nul
            call :assignletter.diskpart
            exit
        )
    )
exit /b 0

:count.partition
for /f "tokens=3 delims=#" %%b in ('wmic partition get name ^| findstr /i "#%disk%,"') do set "part=%%b"
exit /b 0

:unhide.partition
%partassist% /hd:%disk% /unhide:%~1
%partassist% /hd:%disk% /setletter:%~1 /letter:X
exit /b 0

:assignletter.diskpart
cd /d "%bindir%"
    call colortool.bat
    mode con lines=20 cols=80
for %%p in (z y x w v u t s r q p o n m l k j i h g f e d) do (
    if not exist %%p:\nul set letter=%%p
)
cd /d "%tmp%"
    if not exist "diskpart" (mkdir "diskpart")
cd /d "%tmp%\diskpart"
    for /f "tokens=2 delims= " %%b in ('echo list volume ^| diskpart ^| find /i "    X  "') do set "volume=%%b"
    > "assigndriveletter.txt" (
        echo list volume
        echo select volume %volume%
        echo assign letter=%letter%
    )
    diskpart /s assigndriveletter.txt
    pause > nul
cd /d "%tmp%"
    if exist "diskpart" (rd /s /q "diskpart" > nul)
    cls & mode con lines=18 cols=70
exit /b 0

:gdisk
cd /d "%bindir%"
    7za x "gdisk.7z" -o"%tmp%" -aos -y > nul
    if "%processor_architecture%"=="x86" (
        set gdisk=gdisk32.exe
    ) else (
        set gdisk=gdisk64.exe
    )

> "%tmp%\gdisk.vbs" (
    echo Dim Speak
    echo Set Speak=CreateObject^("sapi.spvoice"^)
    echo Speak.Speak "Welcome to GPT fdisk. It is an awesome tool made by Rod Smith. Visit this site: www.rodsbooks.com to meet him."
    echo WScript.Sleep 3
    echo Speak.Speak "To create BIOS Boot Partition, please follow the instructions:"
    echo WScript.Sleep 2
    echo Speak.Speak "Press n"
    echo WScript.Sleep 2
    echo Speak.Speak "then enter"
    echo WScript.Sleep 2
    echo Speak.Speak "enter"
    echo WScript.Sleep 2
    echo Speak.Speak "enter"
    echo WScript.Sleep 2
    echo Speak.Speak "enter"
    echo WScript.Sleep 2
    echo Speak.Speak "press"
    echo Speak.Speak "e"
    echo WScript.Sleep 1
    echo Speak.Speak "f"
    echo WScript.Sleep 1
    echo Speak.Speak "0"
    echo WScript.Sleep 1
    echo Speak.Speak "2"
    echo WScript.Sleep 2
    echo Speak.Speak "then enter"
    echo WScript.Sleep 2
    echo Speak.Speak "press w"
    echo WScript.Sleep 2
    echo Speak.Speak "then enter"
    echo WScript.Sleep 2
    echo Speak.Speak "press y"
    echo WScript.Sleep 2
    echo Speak.Speak "enter to finish"
)

cd /d "%tmp%"
    start gdisk.vbs
    call "%bindir%\colortool.bat"
    mode con lines=33 cols=70
    echo.
    echo ---------------------------------------------------------------------
    echo      TO CREATE BIOS BOOT PARTITION, PLEASE FOLLOW THE INSTRUCTON:
    echo.
    echo                           press n then enter
    echo                          enter ^> enter ^> enter
    echo                          press ef02 then enter
    echo                            press w then enter
    echo                                 press y
    echo                             enter to finish
    echo ---------------------------------------------------------------------
    echo.
    echo.
cd /d "%tmp%\gdisk"
    %gdisk% \\.\physicaldrive%disk%
cd /d "%bindir%"
    taskkill /f /im wscript.exe /t > nul
    del /s /q "%tmp%\gdisk.vbs" >nul
    call colortool.bat
exit /b 0

:rEFInd.part
call "%bindir%\colortool.bat"
echo.
echo 	  %_lang0006_%           %_lang0007_% (MB)
echo 	==========================         ===============
echo 	^* Bitdefender                                  900
echo 	^* Fedora                                      1800
echo 	^* Network Security Toolkit                    3400
echo 	==========================         ===============
echo 	^* %_lang0008_%                                 6100
echo 	+++++++++++++++++++++++++++++++++++++++++++++++++++
echo 	%_lang0009_%=50MB)
echo.
choice /c yn /cs /n /m "> Auto start modules installer after finish [ y/n ] > "
    if errorlevel 1 set "installmodules=y"
    if errorlevel 2 set "installmodules=n"
echo.
choice /c yn /cs /n /m "> Create EFI Partition for Secure Boot      [ y/n ] > "
    if errorlevel 1 set "secureboot=y"
    if errorlevel 2 set "secureboot=n"
:rEFIndsize
echo.
set esp=50
set /p esp= %_lang0010_% ^> 
    rem check the character of the number
    echo %esp%| findstr /r "^[1-9][0-9]*$">nul
    if not "%errorlevel%"=="0" goto :rEFIndsize
    rem set the minimum size of the partition
    if %esp% LSS 50 (
        echo. & echo %_lang0011_% 50MB & timeout /t 15 > nul
        goto :rEFIndsize
    )
exit /b 0
rem >> end functions

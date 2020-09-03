@echo off

:: https://niemtin007.blogspot.com
:: The batch file is written by niemtin007.
:: Thank you for using Multiboot Toolkit.

cd /d "%~dp0"
set "bindir=%~dp0bin"
set "rtheme=Glassy"
set "gtheme=CyberSecurity"
set "title=License"
if not exist Modules mkdir Modules

if not exist "bin" (
    echo. & echo ^>^> Warning: Missing Files
    timeout /t 15 >nul & exit
) else (
    call :permissions
    call :get.freeDrive
    call :license
)

:mainMenu

set "title=Menu"

call :colortool

echo.
echo =====================================================================
echo %_lang0017_%
echo %_lang0018_%
echo %_lang0019_%
echo =====================================================================
echo.
choice /c 1234q /cs /n /m "%_lang0020_%"
    if errorlevel 5 call :license
    if errorlevel 4 timeout /t 1 >nul & goto :qemuboottester
    if errorlevel 3 timeout /t 1 >nul & goto :extraFeatures
    if errorlevel 2 timeout /t 1 >nul & goto :moduleInstaller
    if errorlevel 1 timeout /t 1 >nul & goto :bootableCreator





:: =========================================
:: INSTALL MULTIBOOT
:: =========================================

:bootableCreator

set "title=Bootable Creator"

call :colortool
call :list.disk

echo.
set /p disk= %_lang0101_%
    if "%disk%"=="q" goto :mainMenu
call :checkdisktype
    if "%virtualdisk%"=="true"  call :rEFInd.part      & goto :External
    if "%harddisk%"=="true"     call :harddisk.warning & goto :bootableCreator
    if "%usb%"=="true"          call :rEFInd.part      & goto :removable
    if "%externaldisk%"=="true" call :rEFInd.part      & goto :External
    color 0e & echo. & echo %_lang0104_% & timeout /t 15 >nul & goto :bootableCreator

:removable
call :colortool
:: prepare partitions space for removable Media
echo.
echo ^> Cleaning disk...
call :clean.disk
call :clean.disk
call :get.freeDrive
:: create rEFInd partition
call :colortool
partassist /hd:%disk% /cre /pri /size:%esp% /end /fs:fat32 /align /label:REFIND /letter:%freedrive%
call :unhide.partition 0
call :pushdata.rEFInd
mountvol %freedrive%: /d
if "%secureboot%"=="n" goto :usbmultibootdata
:: create ESP partition
call :colortool
partassist /hd:%disk% /cre /pri /size:50 /fs:fat32 /label:M-ESP /letter:%freedrive%
partassist /move:%freedrive% /right:auto /align
call :unhide.partition 0
call :pushdata.ESP
mountvol %freedrive%: /d
:usbmultibootdata
:: create Multiboot data partition
call :colortool
call :create.mpart
call :unhide.partition 0
goto :extractdata

:External
call :scan.label MULTIBOOT
:: prepare partitions space for External hard disk media
call :count.partition
    :: the disk is an unallocated
    if not defined partcount goto :Setup
    :: set multiboot data partition size
    echo.
    set /a GB=0
    set /p GB= %_lang0106_%
    set /a GB=%GB%+0
    :: check the character of the number
    echo %esp%| findstr /r "^[1-9][0-9]*$">nul
        if not "%errorlevel%"=="0" goto :External
    :: sum size of the esp partition
    set /a MB=(%GB%*1024+%esp%)
    :: check the installed status and give instruction
    if "%online%"=="true" if "%disk%"=="%diskscan%" (
        echo. & echo %_lang0107_% & timeout /t 300 >nul
        goto :delete
    )
    if "%online%"=="false" if "%GB%"=="0" (
        call :colortool
        echo. & echo %_lang0108_% & timeout /t 15 >nul
        goto :External
    )
    goto :continue
:delete
call :colortool
call :count.partition
    if not defined partcount goto :Setup
:: delete all multiboot partition without data loss
partassist /hd:%disk% /unhide:0
call :get.freeDrive
partassist /hd:%disk% /setletter:0 /letter:%freedrive%
call :check.author %freedrive%:
:: this code not perfect
:: {case-1} if a partition file system isn't windows type may be deleted
:: {case-2} data will lose if the user copied the EFI folder into a 
::          data partition with the same Multiboot's drive label
if "%installed%"=="true" if "%disk%"=="%diskscan%" (
    partassist /hd:%disk% /del:0
    goto :delete
)
:continue
call :fix.filesystem
partassist /hd:%disk% /setletter:0 /letter:auto
:: only resize partition for new size setting or new installing
if "%online%"=="true" if not "%GB%"=="0" (
    partassist /hd:%disk% /resize:0 /reduce-left:%MB% /align
)
if "%online%"=="false" (
    partassist /hd:%disk% /resize:0 /reduce-left:%MB% /align
)

:Setup
call :get.freeDrive
call :set.partnum esp2 esp1
:esp1
:: Create ESP Partition
call :colortool
call :create.epart
call :unhide.partition 0
call :pushdata.ESP
mountvol %freedrive%: /d
:esp2
:: Create rEFInd partition
call :colortool
call :create.rpart
call :unhide.partition %rpart%
call :pushdata.rEFInd
mountvol %freedrive%: /d
:: Create Multiboot Data Partition
call :colortool
call :check.diskInfo
if "%GPT%"=="true" (
    partassist /hd:%disk% /cre /pri /size:auto /offset:%offset% /fs:ntfs /act /align /label:MULTIBOOT /letter:%freedrive%
) else (
    partassist /hd:%disk% /cre /pri /size:auto /fs:ntfs /act /align /label:MULTIBOOT /letter:%freedrive%
)
call :unhide.partition %mpart%

:extractdata
call :colortool
call :scan.label MULTIBOOT
    if "%ducky%"=="%freedrive%:" (
        7z x "data.7z" -o"%ducky%\" -aoa -y
    ) else (
        call :colortool
        echo. & echo %_lang0110_% & timeout /t 7 >nul
        :: change data partition label to DATA
        label %ducky% DATA & goto :extractdata
    )
    >"%ducky%\EFI\BOOT\mark"          (echo niemtin007)
    >"%ducky%\BOOT\rEFInd"            (echo %rtheme%)
    >"%ducky%\BOOT\grub\themes\theme" (echo %gtheme%)
    >"%ducky%\BOOT\esp"               (echo %esp%)
    >"%ducky%\BOOT\lang"              (echo %lang%)
    >"%ducky%\BOOT\secureboot"        (echo %secureboot%)
    if "%virtualdisk%"=="true" (
        >"%ducky%\BOOT\virtualdisk" (echo true)
    )
    xcopy "version" "%ducky%\EFI\BOOT\" >nul
cd /d "%bindir%\config\bcd"
    xcopy "B84" "%ducky%\BOOT\bootmgr\" /e /g /h /r /y /q >nul
cd /d "%bindir%\secureboot\BOOT"
    xcopy "boot.sdi" "%ducky%\BOOT\"    /e /g /h /r /y /q >nul
cd /d "%bindir%"
    :: install grub4dos
    call :grub4dosinstaller %ducky%
    :: install wincdemu to mount iso files
    7z x "wincdemu.7z" -o"%ducky%\ISO\" -aoa -y >nul
    :: install Syslinux Bootloader
    syslinux --force --directory /BOOT/syslinux %ducky% %ducky%\BOOT\syslinux\syslinux.bin
    :: install grub2 Bootloader
    call :colortool
    if "%GPT%"=="true" call :gdisk
    echo.
    echo %_lang0116_%
    call :grub2installer MULTIBOOT
    call :install.grubfm
    :: install language
    echo.
    echo %_lang0112_% %lang%
    7z x "%bindir%\config\%lang%.7z" -o"%ducky%\" -aoa -y >nul
cd /d "%tmp%\rEfind_themes\%rtheme%\icons"
    echo.
    echo %_lang0111_% %rtheme%
    call :rEFInd.icons %ducky%
    echo.
    echo %_lang0113_% %gtheme%
    call :install.gtheme
cd /d "%bindir%\secureboot\EFI\Microsoft\Boot"
    call :bcdautoset bcd
:: install secure boot file
if "%secureboot%"=="n" call :pushdata.secure
if "%secureboot%"=="y" call :get.path epath M-ESP
if "%secureboot%"=="y" (
    cd /d "%bindir%"
        call :copy.hidden "secureboot" "%epath%" >nul 2>&1
    cd /d "%bindir%\secureboot\EFI\Boot"
        xcopy "backup" "%ducky%\EFI\Boot\backup\" /e /g /h /r /y /q >nul
)
:: start modules installer
if "%installmodules%"=="y" call :moduleInstaller

mountvol %ducky% /d
call :check.letter
call :clean.bye





:: =========================================
:: INSTALL MODULES
:: =========================================

:moduleInstaller

set "title=Module Installer"
set "curpath=%~dp0Modules"

call :colortool
call :multibootscan
call :gather.info


:modules.main
> "%tmp%\modules.vbs" (
    echo Dim Message, Speak
    echo Set Speak=CreateObject^("sapi.spvoice"^)
    echo Speak.Speak "Please put all modules you need into the Modules folder."
    echo Speak.Speak "Then press any key to continue..."
)
:: move module to the source folder
call :moveISO specialiso
call :moveISO isoextract

call :get.freeDrive

if "%installmodules%"=="y" (
    call :check.empty
    goto :modules.continue
)

call :colortool
echo.
echo ======================================================================
echo %_lang0200_%
echo ^   %curpath%
echo %_lang0201_% %ducky%
echo ======================================================================
if not exist "%ducky%\PortableApps" call :PortableAppsPlatform
echo.
cd /d "%tmp%"
    echo %_lang0202_%
    call :speechOn modules.vbs
    echo %_lang0203_% & timeout /t 300 >nul
    call :speechOff modules.vbs
    call :check.empty

:modules.continue
cd /d "%bindir%"
    if not exist specialiso mkdir specialiso
    if not exist isoextract mkdir isoextract

:: create all modules namelist
if not exist "%ducky%\BOOT\namelist\temp" mkdir "%ducky%\BOOT\namelist\temp"
for /f "tokens=*" %%i in ('dir /a:-d /b "%curpath%"') do (
    >"%ducky%\BOOT\namelist\temp\%%~ni" (echo %%i)
)
:: rename all modules namelist
cd /d "%bindir%"
    for /f "delims=" %%f in (isoextract.list) do (
        cd /d "%ducky%\BOOT\namelist\temp"
            if exist "*%%f*" ren "*%%f*" "%%f" >nul
        cd /d "%bindir%"
    )
:: move all iso to temp folder
call :moveISOTemp isoextract
call :moveISOTemp specialiso

:: check iso extract type
call :checkISO isoextract modules.specialiso

cd /d "%bindir%"
    7z x "wincdemu.7z" -o"%tmp%" -aoa -y >nul
    wincdemu /install
:extract.list
cd /d "%ducky%\BOOT\namelist\temp"
    call :iso.extract aomei , AOMEI-Backup
    call :iso.extract android , Android-x86
    call :iso.extract anhdv , anhdvPE
    call :iso.extract Bob.Ombs , Bob.Ombs.Win10PEx64
    call :iso.extract bugtraq , Bugtraq
    call :iso.extract caine , Caine
    call :iso.extract cyborg-hawk , Cyborg-hawk
    call :iso.extract discreete , Discreete
    call :iso.extract dlc.boot , DLCBoot
    call :iso.extract drweb , Dr.Web
    call :iso.extract eset_sysrescue , Eset
    call :iso.extract hbcd_pe , HirensBoot
    call :iso.extract phoenixos , PhoenixOS
    call :iso.extract primeos , PrimeOS
    call :iso.extract -elite- , Weakerthan
    call :iso.extract wnl8 , WeakNet
    call :iso.extract lionsec , LionSec
    call :iso.extract subgraph-os , Subgraph-os
    call :iso.extract Sergei_Strelec , Strelec
    call :iso.extract systemrescuecd , SystemRescueCD
    wincdemu /uninstall

:modules.specialiso
:: disabled iso linux run on fat32 partition (hidden partition)
if exist "%ducky%\EFI\BOOT\usb.gpt" goto :modules.populariso
:: check special iso type
call :checkISO specialiso modules.populariso

cd /d "%ducky%\BOOT"
    for /f "tokens=*" %%b in (esp) do set "esp=%%b"
    set /a "esp=%esp%+0"
    set /a "size=0"
call :colortool
    for /f "tokens=*" %%x in ('dir /s /a /b "specialiso"') do set /a "size+=%%~zx"
    set /a "size=%size%/1024/1024"

:install.speiso
call :get.path rpath REFIND
if %size% LEQ %esp% (
    if exist "%bindir%\specialiso\*.iso" (
        cls & echo. & echo %_lang0204_% & echo.
        cd /d "%bindir%"
            call :copy.hidden "specialiso" "%rpath%\ISO"
    )
) else (
    call :colortool
    echo. & echo %_lang0205_%
    echo ----------------------------------------------------------------------
    echo %_lang0206_%
    echo %_lang0207_%
    echo %_lang0208_%
    echo ----------------------------------------------------------------------
    timeout /t 15 >nul
)

:modules.populariso
:: copy all ISO to multiboot
call :colortool
echo.
echo %_lang0209_%
for /f "tokens=*" %%b in ('dir /a /b "%curpath%\*.iso"') do (
    if not exist "%ducky%\ISO\%%b" (
        for /f "delims=" %%f in (iso.list) do (
            if exist "%curpath%\*%%f*.iso" (
                echo %%b | findstr /i /c:"%%f" 1>nul
                    if errorlevel 1 (
                        echo false >nul
                    ) else (
                        robocopy "%curpath%" "%ducky%\ISO" %%b /njh /njs /nc /ns
                    )
            )
        )
    )
)

:: copy Kaspersky Rescue Disk 18 to multiboot
call :colortool
if exist "%curpath%\krd.iso" (
    if not exist "%ducky%\DATA\krd.iso" (
        echo.
        echo ^> Kaspersky Rescue Disk 18 %_lang0015_%
        robocopy "%curpath%" "%ducky%\DATA" krd.iso /njh /njs /nc /ns
    )
)

:modules.wim
:: copy all *.wim module on multiboot
call :colortool
echo.
echo %_lang0210_%
echo.
for /f "delims=" %%f in (wim.list) do (
    if not exist "%ducky%\WIM\%%f" (
        if not exist "%ducky%\APPS\%%f" (
            if exist "%curpath%\%%f.wim" (
                robocopy "%curpath%" "%ducky%\WIM" %%f.wim /njh /njs /nc /ns
            )
            if exist "%curpath%\%%f.7z" (
                robocopy "%curpath%" "%ducky%\WIM" %%f.7z /njh /njs /nc /ns
            )
        )
    )
)
:: rename and move all *.wim to the destination
cd /d "%ducky%\WIM"
    if exist *w*8*1*.wim (
        move /y *w*8*1*.wim WIM
        cd /d "%ducky%\WIM"
            ren *w*8*1*64* w8.1se64.wim
            ren *w*8*1*32* w8.1se32.wim
            ren *w*8*1*86* w8.1se32.wim
        cd /d "%ducky%"
    )
    :: rename winpe
    if exist *w*10*64*  ren *w*10*64* w10pe64.wim
    if exist *w*10*32*  ren *w*10*32* w10pe32.wim
    if exist *w*10*86*  ren *w*10*86* w10pe32.wim
    if exist *w*8*64*   ren *w*8*64*  w8pe64.wim
    if exist *w*8*32*   ren *w*8*32*  w8pe32.wim
    if exist *w*8*86*   ren *w*8*86*  w8pe32.wim
    if exist *w*7*32*   ren *w*7*32*  w7pe32.wim
    if exist *xp*       ren *xp*      XP.wim
    :: rename apps & tools for winpe
    if exist *dr*v*.wim move /y *drv*.wim  %ducky%\APPS >nul
    if exist *dr*v*.iso move /y *drv*.iso  %ducky%\APPS >nul
    if exist *app*.wim  move /y *app*.wim  %ducky%\APPS >nul
    if exist *app*.iso  move /y *app*.iso  %ducky%\APPS >nul
    if exist *tool*.wim move /y *tool*.wim %ducky%\APPS >nul
    if exist *tool*.iso move /y *tool*.iso %ducky%\APPS >nul

:: Install Wim Sources Module
if not exist "%ducky%\WIM\bootx64.wim" if not exist "%ducky%\WIM\bootx86.wim" (
    if exist "%curpath%\*Wim*Sources*Module*.7z" (
        cls & echo. & echo %_lang0213_%
        7z x "%curpath%\*Wim*Sources*Module*.7z" -o"%ducky%\" -aoa -y >nul
        cd /d "%bindir%\secureboot\EFI\Boot\backup\WinSetupISOWIM"
            if exist winsetupia32.efi copy winsetupia32.efi "%ducky%\EFI\BOOT" /y >nul
            if exist winsetupx64.efi  copy winsetupx64.efi "%ducky%\EFI\BOOT" /y >nul
        cd /d "%bindir%\config"
            if exist bootisowim copy bootisowim "%ducky%\BOOT\bootmgr" /y >nul
    )
)
:: Windows install.wim module (wim method)
call :colortool
echo.
echo %_lang0214_%
echo.
echo %_lang0215_%
echo.
setlocal enabledelayedexpansion
for %%i in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist "%%i:\sources\setup.exe" (
        if exist "%%i:\sources\install.wim" (
            for /f "tokens=4 delims= " %%j in ('dism /Get-WimInfo /WimFile:%%i:\sources\install.wim /index:1 ^| Find "Name"') do (
                echo ^   * Windows %%j ISO found in %%i:\ drive
                echo %_lang0216_%
                if not exist "%ducky%\Sources\install%%~nj8664.wim" (
                    copy "%%i:\sources\install.wim" "%ducky%\Sources\" >nul
                    cd /d "%ducky%\Sources\"
                    ren install.wim install%%~nj8664.wim
                    echo %_lang0217_%
                ) else (
                    echo ^     ^>^> Your Windows %%j doesn't need to install again
                )
            )
        )
    )
)
endlocal & cls

:: Windows Install ISO Module (ISO method)
cd /d "%ducky%\WIM"
    if not exist "bootisox64.wim" if not exist "bootisox86.wim" (
    cd /d "%curpath%"
        if exist "*WinSetup*ISO*Module*.7z" (
            cls & echo. & echo %_lang0218_%
            7z x "*WinSetup*ISO*Module*.7z" -o"%ducky%\WIM\" -aoa -y
        )
    )

:: Install Grub2 File Manager
call :colortool
    set "list=grubfmia32.efi grubfmx64.efi grubfm.iso"
    if exist "%curpath%\grubfm-*.7z" (
        cls & echo. & echo %_lang0224_%
        7z x "%curpath%\grubfm-*.7z" -o"%ducky%\EFI\Boot\" %list% -r -y >nul
    )

:: copy all *.exe module on multiboot
cd /d "%curpath%"
    if exist "*portable.*" (
        cls & echo. & echo %_lang0219_%
        7z x "*portable.*" -o"%ducky%\PortableApps\" -aoa -y >nul
    )
:: return iso file to modules folder
cd /d "%bindir%"
    call :moveISO specialiso
    call :moveISO isoextract

for /f "tokens=*" %%i in ('dir /s /a /b "%ducky%\BOOT\namelist\temp"') do set /a tsize+=%%~zi
    if defined tsize (move /y "%ducky%\BOOT\namelist\temp\*.*" "%ducky%\BOOT\namelist\" >nul)
    rd /s /q "%ducky%\BOOT\namelist\temp"

:: update config for Grub2
call "%bindir%\config\main.bat"

cd /d "%bindir%"
    rd /s /q specialiso >nul
    rd /s /q isoextract >nul

call :clean.bye





:: =========================================
:: EXTRAL FEATURES
:: =========================================

:extraFeatures

set "curdir=%~dp0"

call :colortool
call :multibootscan skip
call :gather.info


:extra.main
set "title=Extra Features"
call :colortool
echo.
echo =====================================================================
echo %_lang0819_%
echo =====================================================================
echo  [ a ] = %_lang0821_%   [ i ] = %_lang0829_%
echo  [ b ] = %_lang0822_%   [ j ] = %_lang0830_%
echo  [ c ] = %_lang0823_%   [ k ] = %_lang0831_%
echo  [ d ] = %_lang0824_%   [ l ] = %_lang0832_%
echo  [ e ] = %_lang0825_%   [ m ] = %_lang0833_%
echo  [ f ] = %_lang0826_%   [ n ] = %_lang0834_%
echo  [ g ] = %_lang0827_%   [ o ] = %_lang0835_%
echo  [ h ] = %_lang0828_%   [ p ] = %_lang0836_%
echo =====================================================================
echo.
:: ----------------------------------------------
:: a b c d e f g h i j  k  l  m  n  o  p  q
:: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17
:: ----------------------------------------------
if exist "%ducky%\EFI\Boot\usb.gpt" goto :usb.gpt
if "%installed%"=="true"  goto :extra.online
if "%installed%"=="false" goto :extra.offline

:extra.online
choice /c abcdefghijklmnopq /cs /n /m "%_lang0020_%"
    if errorlevel 17 timeout /t 1 >nul & goto :mainMenu
    if errorlevel 16 timeout /t 1 >nul & goto :sortgrub2menu
    if errorlevel 15 timeout /t 1 >nul & goto :updatemultiboot
    if errorlevel 14 timeout /t 1 >nul & goto :qemuboottester
    if errorlevel 13 timeout /t 1 >nul & goto :changelanguage
    if errorlevel 12 timeout /t 1 >nul & goto :NTFSdriveprotect
    if errorlevel 11 timeout /t 1 >nul & goto :easeconvertdisk
    if errorlevel 10 timeout /t 1 >nul & goto :OneFileLinux
    if errorlevel 9  timeout /t 1 >nul & goto :fixbootloader
    if errorlevel 8  timeout /t 1 >nul & goto :grub2-filemanager
    if errorlevel 7  timeout /t 1 >nul & goto :editwinsetupfromUSB
    if errorlevel 6  timeout /t 1 >nul & goto :editWinPEbootmanager
    if errorlevel 5  timeout /t 1 >nul & goto :setdefaultboot
    if errorlevel 4  timeout /t 1 >nul & goto :rEFIndInstaller
    if errorlevel 3  timeout /t 1 >nul & goto :cloverinstaller
    if errorlevel 2  timeout /t 1 >nul & goto :rEFIndtheme
    if errorlevel 1  timeout /t 1 >nul & goto :grub2theme

:extra.offline
choice /c cdhknq /cs /n /m "%_lang0020_%"
    if errorlevel 6  timeout /t 1 >nul & goto :mainMenu
    if errorlevel 5  timeout /t 1 >nul & goto :qemuboottester
    if errorlevel 4  timeout /t 1 >nul & goto :easeconvertdisk
    if errorlevel 3  timeout /t 1 >nul & goto :grub2-filemanager
    if errorlevel 2  timeout /t 1 >nul & goto :rEFIndInstaller
    if errorlevel 1  timeout /t 1 >nul & goto :cloverinstaller

:usb.gpt
choice /c afghilmnpq /cs /n /m "%_lang0020_%"
    if errorlevel 10 timeout /t 1 >nul & goto :mainMenu
    if errorlevel 9  timeout /t 1 >nul & goto :sortgrub2menu
    if errorlevel 8  timeout /t 1 >nul & goto :qemuboottester
    if errorlevel 7  timeout /t 1 >nul & goto :changelanguage
    if errorlevel 6  timeout /t 1 >nul & goto :NTFSdriveprotect
    if errorlevel 5  timeout /t 1 >nul & goto :fixbootloader
    if errorlevel 4  timeout /t 1 >nul & goto :grub2-filemanager
    if errorlevel 3  timeout /t 1 >nul & goto :editwinsetupfromUSB
    if errorlevel 2  timeout /t 1 >nul & goto :editWinPEbootmanager
    if errorlevel 1  timeout /t 1 >nul & goto :grub2theme















:: =========================================
:: BEGIN FUNCTIONS
:: =========================================

:colortool
    cls
    cd /d "%bindir%"
        set /a num=%random% %%105 +1
        set "itermcolors=%num%.itermcolors"
        if "%color%"=="true" goto :skipcheck.color
        7z x "colortool.7z" -o"%tmp%" -aos -y >nul
        :: get Multiboot Toolkit Version
        for /f "tokens=*" %%b in (version) do set /a "cur_version=%%b"
            set /a cur_a=%cur_version:~0,1%
            set /a cur_b=%cur_version:~1,1%
            set /a cur_c=%cur_version:~2,1%
    :: Check for DotNet 4.0 Install
    cd /d "%tmp%\colortool"
        reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP" /s | find "v4" > Output.log
            if %errorlevel% equ 0 (
                colortool -b -q %itermcolors%
                set "color=true"
                goto :exit.color
            ) else (
                set "color=false"
                goto :exit.color
            )
    
    :skipcheck.color
    cd /d "%tmp%\colortool"
        colortool -b -q %itermcolors%
    
    :exit.color
    cls
    cd /d "%bindir%"
    mode con lines=18 cols=70
    title Multiboot Toolkit %cur_a%.%cur_b%.%cur_c% - %title%
exit /b 0


:permissions
    ver | findstr /i "6\.1\." >nul
        if %errorlevel% equ 0 set "windows=7"
        if not "%windows%"=="7" chcp 65001 >nul
    
    :: BatchGotAdmin (Run as Admin code starts)
    cd /d "%temp%"
    :: Check for permissions
    >nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
    :: If error flag set, we do not have admin.
    if '%errorlevel%' NEQ '0' (goto UACPrompt) else (goto gotAdmin)
    :UACPrompt
        echo Set UAC = CreateObject^("Shell.Application"^) > getadmin.vbs
        echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> getadmin.vbs
        getadmin.vbs
        exit
    :gotAdmin
        if exist getadmin.vbs del getadmin.vbs
    :: BatchGotAdmin (Run as Admin code ends)
exit /b 0


:license
    call :colortool
    cd /d "%tmp%"
    > welcome.vbs (
        echo Dim Message, Speak
        echo Set Speak=CreateObject^("sapi.spvoice"^)
        echo Speak.Speak "Welcome to Multiboot Toolkit %cur_a%.%cur_b%.%cur_c%"
        echo WScript.Sleep 1
        echo Speak.Speak "Multiboot Toolkit is the open-source software."
        echo Speak.Speak "It's released under General Public Licence."
        echo Speak.Speak "You can use, modify and redistribute if you wish."
        echo Speak.Speak "Choose a default language to continue..."
    )
    echo ^  __  __      _ _   _ _              _     _____         _ _   _ _   
    echo ^ ^|  \/  ^|_  _^| ^| ^|_^(_^) ^|__  ___  ___^| ^|_  ^|_   _^|__  ___^| ^| ^|_^(_^) ^|_ 
    echo ^ ^| ^|\/^| ^| ^|^| ^| ^|  _^| ^| '_ \/ _ \/ _ \  _^|   ^| ^|/ _ \/ _ \ ^| / / ^|  _^|
    echo ^ ^|_^|  ^|_^|\_,_^|_^|\__^|_^|_.__/\___/\___/\__^|   ^|_^|\___/\___/_^|_\_\_^|\__^|
    echo ^                                                                %cur_a%.%cur_b%.%cur_c%
    echo.
    echo ^  Multiboot Toolkit is the open-source software. It's released under
    echo ^  General Public Licence ^(GPL^). You can use, modify and redistribute
    echo ^  if you wish. You can download from my blog niemtin007.blogspot.com
    echo.
    echo ^  Thanks to:
    echo ^  ------------------------------------------------------------------
    echo ^  Ha Son, Tayfun Akkoyun, anhdv, lethimaivi, A1ive, Hoang Duch2, ...
    echo ^  ------------------------------------------------------------------
    call :speechOn welcome.vbs
    echo.
    echo ^  [ 1 ] = English  [ 2 ] = Vietnam  [ 3 ] = Turkish  [ 4 ] = Chinese
    echo.
    choice /c 1234a /cs /n /m "> Choose a default language [ ? ] = "
        if errorlevel 1 set "lang=English"
        if errorlevel 2 set "lang=Vietnam"
        if errorlevel 3 set "lang=Turkish"
        if errorlevel 4 set "lang=SimplifiedChinese"
        if errorlevel 5 set "lang=autodetect"
    call :speechOff welcome.vbs
    call :partassist.init
    :: change language
    call :colortool
    call language.bat
    goto :mainMenu
exit /b 0


:partassist.init
    cls
    echo.
    cd /d "%bindir%"
        echo ^>^> Loading, Please wait...
        7z x "partassist.7z" -o"%tmp%" -aos -y >nul
        path=%path%;%bindir%;%tmp%;%tmp%\partassist
    :: begin preparing file
    call :extract.rEFInd
    cd /d "%tmp%\partassist"
        if "%processor_architecture%"=="x86" (
            SetupGreen32 -i >nul
            LoadDrv_Win32 -i >nul
        ) else (
            SetupGreen64 -i >nul
            LoadDrv_x64 -i >nul
        )
        > cfg.ini (
            echo [Language]
            echo LANGUAGE=lang\%langpa%.txt;%langcode%
            echo LANGCHANGED=1
            echo [Version]
            echo Version=4
            echo [Product Version]
            echo v=2
            echo Lang=%langpa%
            echo [CONFIG]
            echo COUNT=2
            echo KEY=AOPR-21ROI-6Y7PL-Q4118
            echo [PA]
            echo POPUPMESSAGE=1
        )
        > winpeshl.ini (
            echo [LaunchApp]
            echo AppPath=%tmp%\partassist\PartAssist.exe
        )
    cls
exit /b 0


:clean.bye
    call :colortool
    for /f %%b in (
        'wmic volume get driveletter^, label ^| findstr /i "MULTIBOOT"'
        ) do set "ducky=%%b"
    for /f "delims=" %%f in (hide.list) do (
        if exist "%ducky%\%%f"     attrib +s +h "%ducky%\%%f"
        if exist "%ducky%\ISO\%%f" attrib +s +h "%ducky%\ISO\%%f"
        if exist "%ducky%\WIM\%%f" attrib +s +h "%ducky%\WIM\%%f"
    )
    cd /d "%tmp%\partassist"
        if "%processor_architecture%"=="x86" (
            SetupGreen32 -u >nul
            LoadDrv_Win32 -u >nul
        ) else (
            SetupGreen64 -u >nul
            LoadDrv_x64 -u >nul
        )
    cd /d "%tmp%"
        :: clean up the trash and exit
        set "dlist=colortool curl driveprotect gdisk grub2 partassist CLOVER rEFInd rEFInd_themes"
        for %%d in (%dlist%) do (
            if exist "%%d" rmdir "%%d" /s /q >nul
        )
        set "flist=clover* grubfm* hide.vbs Output.log qemuboottester.exe wincdemu.exe wget*"
        for %%f in (%flist%) do (
            if exist "%%f" del "%%f" /s /q >nul
        )
        > thanks.vbs (
            echo Dim Message, Speak
            echo Set Speak=CreateObject^("sapi.spvoice"^)
            echo Speak.Speak "Successful! Thank you for using Multiboot Toolkit"
        )
        cls
        echo.
        echo %_lang0012_%
        echo %_lang0013_%
        call :speechOn thanks.vbs
        timeout /t 3 >nul
        del /s /q thanks.vbs >nul
        exit
exit /b 0


:check.diskInfo
    set GPT=false
    for /f "tokens=4,5,8" %%b in (
        'echo list disk ^| diskpart ^| find /i "Disk %disk%"'
        ) do (
            set /a disksize=%%b
            set    diskunit=%%c
            if /i "%%d"=="*" set GPT=true
        )
    for /f "tokens=1 delims=\\.\" %%b in (
        'wmic diskdrive list brief ^| find /i "physicaldrive%disk%"'
        ) do set "model=%%b"
exit /b 0


:get.path
    :: find and use volume id instead of drive letter for a hidden partition
    for /f %%b in (
        'wmic volume get label^, id ^| findstr %~2'
        ) do set "tpath=%%b"
    if exist "%tpath%\EFI\BOOT\mark" (
        for /f "tokens=*" %%b in (%tpath%\EFI\BOOT\mark) do set "author=%%b"
    )
    if not "%author%"=="niemtin007" echo %~2 not found! & pause >nul & exit
    set "%~1=%tpath%"
exit /b 0


:copy.hidden
    :: copy file/folder to hidden partition using volume id
    copy %~1 %~2 /y
    for /f "tokens=*" %%i in ('dir /a:d /b "%~1"') do (
        if not exist %~2\%%i md %~2\%%i
        call :copy.hidden %~1\%%i %~2\%%i
    )
exit /b 0


:get.freeDrive
    set "freedrive="
    :: http://wiki.uniformserver.com/index.php/Batch_files:_First_Free_Drive#Final_Solution
    for %%a in (Z Y X W V U T S R Q P O N M L K J I H G F E D C) do (
        cd %%a: 1>>nul 2>&1 & if errorlevel 1 set freedrive=%%a
    )
exit /b 0


:check.letter
    echo.
    echo %_lang0123_%
    call :get.freeDrive
    :: get volume number instead of specifying a drive letter for missing drive letter case
    for /f "tokens=2" %%b in (
        'echo list volume ^| diskpart ^| find /i "MULTIBOOT"'
        ) do set "volume=%%b"
    vol %~1 >nul 2>&1
        if errorlevel 0 if exist "%~1" set "volume=%~1"
    :: assign drive letter
    (
        echo select volume %volume%
        echo assign letter=%freedrive%
    ) | diskpart >nul
exit /b 0


:scan.label
    set "ducky="
    set "online=false"
    :: get drive letter from label
    for /f %%b in (
        'wmic volume get driveletter^, label ^| findstr /i "%~1"'
        ) do set "ducky=%%b"
        :: in case drive letter missing the ducky is the %~1 argument
        vol %ducky% >nul 2>&1
            if errorlevel 1 (
                call :check.letter
                call :scan.label %~1
            ) else (
                if exist "%ducky%\EFI\BOOT\mark" set online=true
            )
        :: get disk number from drive letter
        for /f "tokens=2 delims= " %%b in (
            'wmic path win32_logicaldisktopartition get antecedent^, dependent ^| find "%ducky%"'
            ) do set "diskscan=%%b"
            if defined diskscan set /a "diskscan=%diskscan:~1,1%"
exit /b 0


:check.author
    set label=false
    set author=whoiam
    set installed=false
    :: check disk unavailable
    vol %~1 >nul 2>&1
        if errorlevel 1 set label=BBP
    for /f "tokens=1-5*" %%1 in ('vol %~1') do (
        set label=%%6 & goto :break.label
    )
    :break.label
    if exist "%~1\EFI\BOOT\mark" (
        for /f "tokens=*" %%b in (%~1\EFI\BOOT\mark) do set "author=%%b"
    )
    if "%author%"=="niemtin007" (
        if "%label%"=="M-ESP "     set installed=true
        if "%label%"=="REFIND "    set installed=true
        if "%label%"=="MULTIBOOT " set installed=true
    ) else (
        if "%label%"=="BBP"        set installed=true
    )
exit /b 0


:checkdisktype
    :: reset all disks variable
    set "virtualdisk=false"
    set "harddisk=false"
    set "usb=false"
    set "externaldisk=false"
    set /a disk=%disk%+0
    :: check.virtualdisk
    wmic diskdrive get name, model | find /i "Msft Virtual Disk SCSI Disk Device" | find /i "\\.\physicaldrive%disk%" >nul
        if not errorlevel 1 set "virtualdisk=true"
    wmic diskdrive get name, model | find /i "Microsoft Virtual Disk" | find /i "\\.\physicaldrive%disk%" >nul
        if not errorlevel 1 set "virtualdisk=true"
    wmic diskdrive get name, model | find /i "Microsoft Sanal Diski" | find /i "\\.\physicaldrive%disk%" >nul
        if not errorlevel 1 set "virtualdisk=true"
    :: check.harddisk
    wmic diskdrive get name, mediatype | find /i "Fixed hard disk media" | find /i "\\.\physicaldrive%disk%" >nul
        if not errorlevel 1 set "harddisk=true"
        if "%virtualdisk%"=="true" set "harddisk=false"
    :: check.usbdisk
    wmic diskdrive get name, mediatype | find /i "Removable Media" | find /i "\\.\physicaldrive%disk%" >nul
        if not errorlevel 1 set "usb=true"
    :: check.externaldisk
    wmic diskdrive get name, mediatype | find /i "External hard disk media" | find /i "\\.\physicaldrive%disk%" >nul
        if not errorlevel 1 set "externaldisk=true"
exit /b 0


:count.partition
    set "partcount="
    :: count the total number of partition in a disk
    for /f "tokens=3 delims=#" %%b in (
        'wmic partition get name ^| findstr /i "#%disk%,"'
        ) do set "partcount=%%b"
exit /b 0


:set.partnum
    if "%usb%"=="true" if "%secureboot%"=="n" (
        set /a rpart=1
        goto :%~1
    ) 
    if "%usb%"=="true" if "%secureboot%"=="y" (
        set /a rpart=2
        set /a mpart=1
        set /a spart=1
        goto :%~2
    )
    
    if "%secureboot%"=="n" (
        set /a rpart=0
        set /a mpart=1
        set /a offset=%esp%+8
        goto :%~1
    ) 
    if "%secureboot%"=="y" (
        set /a rpart=1
        set /a mpart=0
        set /a spart=0
        set /a offset=%esp%+58
        goto :%~2
    )
exit /b 0


:unhide.partition
    if not exist "%freedrive%:\" (
        partassist /hd:%disk% /unhide:%~1
        partassist /hd:%disk% /setletter:%~1 /letter:%freedrive%
        goto :unhide.partition
    )
exit /b 0


:list.disk
    setlocal
    :: find the last disk
    for /f "tokens=2" %%b in (
        'echo list disk ^| diskpart ^| find /i "Disk"'
        ) do set /a disk=%%b
    :: check USB GPT
    echo.
    echo Loading, please wait...
    cd /d "%bindir%"
        call :checkdisktype
        if "%usb%"=="true" call :check.diskInfo
    :: display USB GPT information for partassist
    cls & partassist /list
    if "%usb%"=="true" if "%GPT%"=="true" (
        if "%diskunit%"=="GB" echo   %disk%     ^| %disksize% %diskunit%         ^| %model% GPT
        if "%diskunit%"=="MB" echo   %disk%     ^| %disksize% %diskunit%       ^| %model% GPT
    )
    endlocal
exit /b 0


:fix.filesystem
    :: automatically fix file system error to keep data safety
    :: use it before using the "/resize" and "/move" of partassist
    if exist %freedrive%:\ chkdsk /f %freedrive%:
exit /b 0


:clean.disk
    (
        echo select disk %disk%
        echo clean
        echo convert mbr
        echo exit
    ) | diskpart >nul
exit /b 0


:create.rpart
    echo.
    echo ^> Creating rEFInd partition...
    (
        echo select disk %disk%
        echo create partition primary size=%esp%
        echo format quick fs=fat32 label="REFIND"
        echo assign letter=%freedrive%
        echo exit
    ) | diskpart >nul
exit /b 0


:create.epart
    echo.
    echo ^> Creating ESP Partition...
    (
        echo select disk %disk%
        echo create partition primary size=50
        echo format quick fs=fat32 label="M-ESP"
        echo assign letter=%freedrive%
        echo exit
    ) | diskpart >nul
exit /b 0


:create.mpart
    echo.
    echo ^> Creating Multiboot data partition...
    (
        echo select disk %disk%
        echo create partition primary
        echo format quick fs=ntfs label="MULTIBOOT"
        echo assign letter=%freedrive%
        echo active
        echo exit
    ) | diskpart >nul
exit /b 0


:harddisk.warning
    echo. & echo. & echo %_lang0102_%
    color 0e & echo %_lang0103_% & timeout /t 15 >nul & cls
exit /b 0


:pushdata.ESP
    cd /d "%freedrive%:\"
        mkdir "%freedrive%:\EFI\BOOT\"
        >"%freedrive%:\EFI\BOOT\mark" (echo niemtin007)
    cd /d "%tmp%\rEfind_themes\%rtheme%\icons"
        xcopy "others" "%freedrive%:\EFI\BOOT\" /e /g /h /r /y /q >nul
exit /b 0


:pushdata.rEFInd
    cd /d "%freedrive%:\"
        mkdir "%freedrive%:\ISO\"
        mkdir "%freedrive%:\EFI\BOOT\themes\"
        >"%freedrive%:\EFI\BOOT\mark" (echo niemtin007)
    cd /d "%tmp%"
        xcopy "rEfind" "%freedrive%:\EFI\BOOT\" /e /g /h /r /y /q >nul
    cd /d "%tmp%\rEfind_themes"
        xcopy "%rtheme%" "%freedrive%:\EFI\BOOT\themes\" /e /g /h /r /y /q >nul
exit /b 0


:pushdata.secure
    >"%ducky%\BOOT\secureboot" (echo n)
    cd /d "%tmp%\rEfind_themes\%rtheme%\icons"
        xcopy "others" "%ducky%\EFI\BOOT\" /e /g /h /r /y /q >nul
    cd /d "%bindir%"
        xcopy "secureboot" "%ducky%\" /e /g /h /r /y /q >nul
exit /b 0


:rEFInd.icons
    copy "grubx64.png" "%~1\EFI\BOOT\grubx64.png" >nul
    copy "grubx64.png" "%~1\EFI\BOOT\grubia32.png" >nul
    copy "os_linux.icns" "%~1\EFI\BOOT\OneFileLinux.png" >nul
    copy "winsetupx64.png" "%~1\EFI\BOOT\winsetupx64.png" >nul
    copy "winsetupx64.png" "%~1\EFI\BOOT\winsetupia32.png" >nul
    copy "winsetupx64.png" "%~1\EFI\BOOT\winsetupfmx64.png" >nul
    copy "winsetupx64.png" "%~1\EFI\BOOT\winsetupfmia32.png" >nul
    copy "xorbootx64.png" "%~1\EFI\BOOT\xorbootx64.png" >nul
    xcopy "others" "%~1\EFI\BOOT\" /e /g /h /r /y /q >nul
exit /b 0


:grub4dosinstaller
    cd /d "%bindir%\extra-modules\grub4dos"
        xcopy "grldr" "%~1\" /e /g /h /r /y /q >nul
        xcopy "grub.exe" "%~1\BOOT\grub" /e /g /h /r /y /q >nul
    cd /d "%bindir%"
exit /b 0


:grub2installer
    cd /d "%bindir%"
        7z x "grub2.7z" -o"%tmp%" -aos -y >nul
    :: install grub2 for Legacy BIOS mode
    if not "%~2"=="legacydisable" (
        echo ^   installing for i386-pc platform.
        cd /d "%tmp%\grub2"
            grub-install --target=i386-pc --force --boot-directory=%ducky%\BOOT \\.\physicaldrive%disk% >nul 2>&1
        cd /d "%tmp%\grub2\i386-pc"
            copy "lnxboot.img" "%ducky%\BOOT\grub\i386-pc" >nul
        cd /d "%ducky%\BOOT\grub\i386-pc"
            copy /b lnxboot.img+Core.img g2ldr >nul
    )
    :: install grub2 for EFI mode
    cd /d "%tmp%\grub2"
        call :get.path rpath REFIND
        echo ^   installing for i386-efi platform.
        grub-install --target=i386-efi --efi-directory=%rpath% --boot-directory=%ducky%\BOOT --bootloader-id=grub --modules=progress --removable >nul 2>&1
        echo ^   installing for x86_64-efi platform.
        grub-install --target=x86_64-efi --efi-directory=%rpath% --boot-directory=%ducky%\BOOT --bootloader-id=grub --modules=progress --removable >nul 2>&1
        :: copy to multiboot data partition
        copy "%rpath%\EFI\BOOT\BOOTX64.EFI"  "%ducky%\EFI\BOOT\grubx64.efi"  /y >nul
        copy "%rpath%\EFI\BOOT\BOOTIA32.EFI" "%ducky%\EFI\BOOT\grubia32.efi" /y >nul
        copy "%rpath%\EFI\BOOT\grub.efi"     "%ducky%\EFI\BOOT\grub.efi"     /y >nul
    :: make backup
    cd /d "%ducky%\EFI\BOOT"
        copy "grubx64.efi"  "%bindir%\secureboot\EFI\Boot\backup\Grub2\bootx64.efi"  /y >nul
        copy "grubia32.efi" "%bindir%\secureboot\EFI\Boot\backup\Grub2\bootia32.efi" /y >nul
        copy "grub.efi"     "%bindir%\secureboot\EFI\Boot\backup\Grub2\grub.efi"     /y >nul
    cd /d "%bindir%\secureboot\EFI\Boot\backup"
        xcopy "Grub2" "%ducky%\EFI\BOOT\backup\Grub2\" /y >nul
    cd /d "%bindir%"
exit /b 0


:gdisk
    cd /d "%bindir%"
        7z x "gdisk.7z" -o"%tmp%" -aos -y >nul
        if "%processor_architecture%"=="x86" (
            set gdisk=gdisk32.exe
        ) else (
            set gdisk=gdisk64.exe
        )
    :: create a BIOS Boot Partition
    cd /d "%tmp%\gdisk"
        (
            echo n
            echo.
            echo.
            echo.
            echo ef02
            echo w
            echo y
        ) | %gdisk% \\.\physicaldrive%disk% >nul 2>&1
        cls
        echo.
        echo %_lang0117_%
    cd /d "%bindir%"
        timeout /t 1 >nul
exit /b 0


:rEFInd.part
    if "%usb%"=="false" goto :rEFInd.ask
    color 0e
    echo.
    echo -------------------------------------------------------------------
    echo %_lang0118_%
    echo %_lang0119_%
    echo -------------------------------------------------------------------
    echo.
    choice /c yn /cs /n /m "%_lang0120_%"
        if errorlevel 1 set "usbgpt=true"
        if errorlevel 2 set "usbgpt=false"
        if "%usbgpt%"=="false" goto :rEFInd.ask
        if "%usbgpt%"=="true" if "%windows%"=="7" (
            echo %_lang0125_% & timeout /t 15 >nul & goto :rEFInd.ask
        )
    choice /c yn /cs /n /m "%_lang0124_%"
        if errorlevel 1 set "usblegacy=false"
        if errorlevel 2 set "usblegacy=true"
        if "%usbgpt%"=="true" call :createusb.gpt
    :rEFInd.ask
    call :colortool
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
    choice /c yn /cs /n /m "%_lang0114_%"
        if errorlevel 1 set "installmodules=y"
        if errorlevel 2 set "installmodules=n"
    echo.
    choice /c ynq /cs /n /m "%_lang0115_%"
        if errorlevel 1 set "secureboot=y"
        if errorlevel 2 set "secureboot=n"
        if errorlevel 3 goto :rEFInd.ask
    :rEFIndsize
    echo.
    set esp=50
    set /p esp= %_lang0010_% ^> 
        :: check the character of the number
        echo %esp%| findstr /r "^[1-9][0-9]*$">nul
        if not "%errorlevel%"=="0" goto :rEFIndsize
        :: set the minimum size of the partition
        if %esp% LSS 50 (
            echo. & echo %_lang0011_% 50MB & timeout /t 15 >nul
            goto :rEFIndsize
        )
exit /b 0


:bcdautoset
    echo.
    echo %_lang0004_%
    set "bcd=%~1"
    set "Object={7619dcc8-fafe-11d9-b411-000476eba25f}"
    :: edit menu [ 01 ] Win10PE SE                x64 UEFI
    set "bootfile=\WIM\w10pe64.wim"
    set "identifier={default}"
    call :bcd.reset
    :: edit menu [ 02 ] Win8PE                    x64 UEFI
    set "bootfile=\WIM\w8pe64.wim"
    set "identifier={6e700c3b-7cca-4b2b-bca6-5a486db4b4ec}"
    call :bcd.reset
    :: edit menu [ 03 ] Win10PE SE                x64 UEFI           DLC Boot
    set "bootfile=\DLC1\W10PE\W10x64.wim"
    set "identifier={1584ef96-c13d-4ee2-b1b1-8fce4a0834a1}"
    call :bcd.reset
    :: edit menu [ 04 ] Win10PE SE                x64 UEFI           Strelec
    set "bootfile=\SSTR\strelec10x64Eng.wim"
    set "identifier={ebb0ef9d-19d7-47a6-8f0a-ec37ffa958fb}"
    call :bcd.reset
    :: edit menu [ 05 ] Hiren’s BootCD PE         x64 UEFI
    set "bootfile=\WIM\hbcdpe.wim"
    set "identifier={9a349bcd-72ba-40e1-ba0d-c2638ebbeeab}"
    call :bcd.reset
    :: edit menu [ 06 ] Bob.Omb’s Modified Win10PEx64 UEFI
    set "bootfile=\WIM\BobW10PE.wim"
    set "identifier={dfbac4eb-329a-4665-a876-568ae3f1f3c4}"
    call :bcd.reset
    :: edit menu [ 07 ] Setup Windows from sources                   Wim & ISO
    set "bootfile=\WIM\bootisox64.wim"
    set "identifier={d314f67b-45b3-4dac-b244-46a733f2583c}"
    call :bcd.reset
    :: --------------------------------------------------------------------------
    echo.& echo %_lang0005_%
    :: edit menu [ 01 ] Win10PE SE                x86 UEFI
    set "bootfile=\WIM\w10pe32.wim"
    set "identifier={8b08eb1f-1588-45d5-9327-a8c3c9af04cb}"
    call :bcd.reset
    :: edit menu [ 02 ] Win8PE                    x86 UEFI
    set "bootfile=\WIM\w8pe32.wim"
    set "identifier={1d17bd3f-8d1f-45af-98ff-fde29926a9c5}"
    call :bcd.reset
    :: edit menu [ 03 ] Win10PE SE                x86 UEFI           DLC Boot
    set "bootfile=\DLC1\W10PE\W10x86.wim"
    set "identifier={0e695210-306a-45df-9a89-7710c2b80ed0}"
    call :bcd.reset
    :: edit menu [ 04 ] Win10PE SE                x86 UEFI           Strelec
    set "bootfile=\SSTR\strelec10Eng.wim"
    set "identifier={65fcaee2-301e-44b2-94ee-e8875e58f509}"
    call :bcd.reset
    :: edit menu [ 05 ] Setup Windows from sources                   Wim & ISO
    set "bootfile=\WIM\bootisox86.wim"
    set "identifier={2247cc17-b047-45e4-b2cd-d4196ff5d2fb}"
    call :bcd.reset
exit /b 0
:bcd.reset
    bcdedit /store %bcd% /set %identifier% device ramdisk=[%ducky%]%bootfile%,%Object% >nul
    bcdedit /store %bcd% /set %identifier% osdevice ramdisk=[%ducky%]%bootfile%,%Object% >nul
exit /b 0


:createusb.gpt
    :: create ESP partition
    echo.
    echo %_lang0121_%
    (
        echo select disk %disk%
        echo clean
        echo convert gpt
        echo create partition primary size=50
        echo format quick fs=fat label="ESP"
        echo assign letter=%freedrive%
        echo exit
    ) | diskpart >nul
    :: push files into the ESP partition
    call :pushdata.rEFInd
    :: remove drive letter
    (
        echo select volume %freedrive%
        echo remove letter %freedrive%
        echo exit
    ) | diskpart >nul
    :: create MULTIBOOT partition
    (
        echo select disk %disk%
        echo create partition primary
        echo format quick fs=ntfs label="MULTIBOOT"
        echo shrink desired=8
        echo assign letter=%freedrive%
        echo exit
    ) | diskpart >nul
    :: create BIOS Boot Partition for Legacy BIOS Mode
    if "%usblegacy%"=="true" (
        call :gdisk
        :: a guide of the disk format waning messenger
        echo -------------------------------------------------------------------
        echo %_lang0126_%
        echo %_lang0127_%
        echo -------------------------------------------------------------------
        :: delete drive letter for BIOS Boot Partition
        bootice /device=%disk%:2 /partitions /delete_letter /quiet
    )
    :: recheck data partition
    call :scan.label MULTIBOOT
    if not "%ducky%"=="%freedrive%:" (
        call :colortool
        echo. & echo %_lang0110_% & timeout /t 15 >nul & exit
    )
    :: installing data
    echo.
    echo %_lang0122_%
    cd /d "%ducky%"
        for %%b in (APPS BOOT\grub\themes EFI\BOOT ISO WIM) do mkdir %%b
        >"BOOT\lang"              (echo %lang%)
        >"EFI\BOOT\mark"          (echo niemtin007)
        >"BOOT\grub\themes\theme" (echo %gtheme%)
        >"EFI\BOOT\usb.gpt"       (echo USB GPT Bootable Disk)
    cd /d "%bindir%"
        xcopy "secureboot" "%ducky%\" /e /g /h /r /y /q >nul
        set "file=Autorun.inf usb.ico B64 XORBOOT grub"
        set "efi=gdisk.efi OneFileLinux.efi winsetupia32.efi winsetupx64.efi xorbootx64.efi"
        if "%usblegacy%"=="true" (
            7z x "data.7z" -o"%ducky%\" -aoa -y >nul
        ) else (
            7z x "data.7z" -o"%ducky%\" %file% %efi% -r >nul
        )
        :: install grub2 bootloader
        echo.
        echo %_lang0116_%
        if "%usblegacy%"=="true" (
            call :grub2installer MULTIBOOT
        ) else (
            call :grub2installer MULTIBOOT legacydisable
        )
        :: install grub2 file manager
        call :install.grubfm
        :: install language
        echo.
        echo %_lang0112_% %lang%
        7z x "%bindir%\config\%lang%.7z" -o"%ducky%\" -aoa -y >nul
        :: install grub2 theme
        echo.
        echo %_lang0113_% %gtheme%
        call :install.gtheme
    cd /d "%ducky%\EFI\Microsoft\Boot"
        :: setup WIM path in BCD store for UEFI mode
        call :bcdautoset bcd
    cd /d "%tmp%\rEfind_themes\%rtheme%\icons"
        :: install icons for rEFInd Boot Manager
        call :rEFInd.icons %ducky%
    :: specifies that the ESP does not receive a drive letter by default
    (
        echo select disk %disk%
        echo select partition 1
        echo gpt attributes=0x4000000000000000
        echo select partition 3
        echo gpt attributes=0x4000000000000000
        echo exit
    ) | diskpart >nul
        call :clean.bye
exit /b 0


:speechOn
    if exist "%systemroot%\SysWOW64\Speech\SpeechUX\sapi.cpl" start %~1
exit /b 0


:speechOff
    if not "%~2"=="nonstop" (
        taskkill /f /im wscript.exe /t /fi "status eq running">nul
    )
    if exist "%tmp%\%~1" del /s /q "%tmp%\%~1" >nul
exit /b 0





:: --------------------------------------------
:: Module functions
:: --------------------------------------------

:multibootscan
    cls
    call :scan.label MULTIBOOT
    call :check.author %ducky%
        if "%installed%"=="true" (
            set /a disk=%diskscan%
            goto :break.scan
        ) else (
            goto :progress.scan
        )
    :progress.scan
        if "%~1"=="skip" goto :offline.scan
        cls & echo ^> Connecting    & timeout /t 1 >nul
        cls & echo ^> Connecting.   & timeout /t 1 >nul
        cls & echo ^> Connecting..  & timeout /t 1 >nul
        cls & echo ^> Connecting... & timeout /t 1 >nul
        goto :multibootscan
    :break.scan
    cd /d "%tmp%"
        > identify.vbs (
            echo Dim Message, Speak
            echo Set Speak=CreateObject^("sapi.spvoice"^)
            echo Speak.Speak "Multiboot Drive Found"
        )
        call :speechOn identify.vbs
    call :colortool
        echo. & echo ^>^> Multiboot Drive Found ^^^^
        timeout /t 1 >nul
        call :speechOff identify.vbs nonstop
        call :check.protected
    :offline.scan
    call :partassist.init
exit /b 0


:check.protected
    if exist "%ducky%" (
        cd /d "%ducky%"
            >disk.protect echo true
            if not exist disk.protect (
                call :colortool
                echo.
                echo ^>^> Please Stop Protection on your device.
                call :NTFSdriveprotect loop
            ) else (
                del /s /q disk.protect >nul
            )
    )
exit /b 0


:check.empty
    setlocal
    set _tmp=
    for /f "delims=" %%b in ('dir /b "%curpath%"') do set _tmp="%%b"
    if {%_tmp%}=={} (
        call :colortool
        cls
        echo.
        echo %_lang0220_%
        echo.
        choice /c yn /cs /n /m "%_lang0221_%"
        if errorlevel 2 goto :modules.main
        if errorlevel 1 start https://docs.google.com/spreadsheets/d/1HzW6t3Rh_8_BnT8Ddawe1epwrMdVzvmRAjtN3qX-G9k/edit?usp=sharing & exit
    )
    cd /d "%bindir%"
        set "module=false"
        for /f "delims=" %%f in (iso.list, isoextract.list, specialiso.list, wim.list) do (
            cd /d "%curpath%"
                if exist "*%%f*" set "module=true"
            cd /d "%bindir%"
        )
        if "%module%"=="false" (
            cls & echo.
            echo %_lang0222_%
            pause >nul
            goto :modules.main
        )
    endlocal
exit /b 0


:iso.extract
    if exist "%~1" if not exist "%ducky%\ISO_Extract\%~2\*.*" (
        set "modulename=%~2"
        for /f "tokens=*" %%b in (%~1) do set "isopath=%bindir%\isoextract\%%b"
        call :iso.mount
    )
exit /b 0


:iso.mount
    call :colortool
    wincdemu "%isopath%" %freedrive%: /wait
    cls
    echo.
    echo ^>^> %modulename% %_lang0015_%
    echo.
    cd /d "%freedrive%:\"
        if "%modulename%"=="AOMEI-Backup" (
            copy "sources\boot.wim" "%ducky%\WIM\aomeibackup.wim" /y >nul
            mkdir "%ducky%\ISO_Extract\%modulename%\"
            >"%ducky%\ISO_Extract\%modulename%\Author.txt" (echo AOMEI)
            goto :iso.unmount
        )
        if "%modulename%"=="anhdvPE" (
            robocopy "%freedrive%:\APPS" "%ducky%\APPS" /njh /njs /nc /ns
            robocopy "%freedrive%:\WIM" "%ducky%\WIM" /njh /njs /nc /ns
            mkdir "%ducky%\ISO_Extract\%modulename%\"
            >"%ducky%\ISO_Extract\%modulename%\Author.txt" (echo Dang Van Anh)
            goto :iso.unmount
        )
        if "%modulename%"=="Bob.Ombs.Win10PEx64" (
            copy "sources\boot.wim" "%ducky%\WIM\BobW10PE.wim" /y >nul
            xcopy "Programs" "%ducky%\Programs\" /e /g /h /r /y
            mkdir "%ducky%\ISO_Extract\%modulename%\"
            >"%ducky%\ISO_Extract\%modulename%\Author.txt" (echo Bob.Ombs)
            goto :iso.unmount
        )
        if "%modulename%"=="DLCBoot" (
            xcopy "DLCBoot.exe" "%ducky%\" /e /g /h /r /y
            xcopy "DLC1" "%ducky%\DLC1\" /e /g /h /r /y
            mkdir "%ducky%\ISO_Extract\%modulename%\"
            >"%ducky%\ISO_Extract\%modulename%\Author.txt" (echo Tran Duy Linh)
            goto :iso.unmount
        )
        if "%modulename%"=="HirensBoot" (
            copy "sources\boot.wim" "%ducky%\WIM\hbcdpe.wim" /y >nul
            xcopy /s "Version.txt" "%ducky%\ISO_Extract\%modulename%\"
            goto :iso.unmount
        )
        if "%modulename%"=="Strelec" (
            xcopy "SSTR" "%ducky%\SSTR\" /e /g /h /r /y
            mkdir "%ducky%\ISO_Extract\%modulename%\"
            >"%ducky%\ISO_Extract\%modulename%\Author.txt" (echo Sergei Strelec)
            goto :iso.unmount
        )
    cd /d "%bindir%"
        for /f "delims=" %%f in (copy.list) do (
            if exist "%freedrive%:\%%f" (
                xcopy /s "%freedrive%:\%%f" "%ducky%\ISO_Extract\%modulename%\"
            )
        )
:iso.unmount
    wincdemu /unmount %freedrive%:
    cls & goto :extract.list
exit /b 0


:PortableAppsPlatform
    echo.
    choice /c ynq /cs /n /m "%_lang0223_%"
        if errorlevel 1 set "portable=true"
        if errorlevel 2 set "portable=false"
        if errorlevel 3 goto :mainMenu
        if "%portable%"=="true" (
            choice /c yn /cs /n /m ">> ---> Download the last PortableApps.com Platform? [ y/n ] > "
                if errorlevel 2 call :PortableAppsExtract
                if errorlevel 1 call :download.portableapps & call :PortableAppsExtract
                echo %_lang0012_%
                timeout /t 2 >nul
        )
exit /b 0

:get.portablePlatform
    set "sourcelink=https://portableapps.com/download"
    wget.exe -q -O portable.log %sourcelink% >nul
    for /f "tokens=3,* delims=_" %%a in (
        'type portable.log ^| findstr /i "PortableApps.com_Platform_Setup_.*.paf.exe" ^| find /n /v "" ^| find "[1]"'
    ) do set "ver=%%b"
    set "ver=%ver:~0,6%"
exit /b 0

:download.portableapps
    cd /d "%bindir%"
        if not exist PortableApps mkdir PortableApps
        7z x "wget.7z" -o"%tmp%" -aoa -y >nul
        7z x "PortableApps.7z" -o"PortableApps" -aoa -y >nul
    cd /d "%tmp%"
        call :get.portablePlatform >nul 2>&1
        set "sourcelink=https://portableapps.com/redirect/?a=PortableApps.comPlatform^&s^=s^&d^=pa^&f^=PortableApps.com_Platform_Setup_%ver%.paf.exe"
        wget -q --show-progress -O Platform_%ver%.paf.exe %sourcelink%
        set "list=PortableApps Start.exe"
        7z x "Platform_*.paf.exe" -o"%bindir%\PortableApps" %list% -r -y >nul
        del "Platform_%ver%.paf.exe" /s /q /f >nul
    cd /d "%bindir%"
        7z a PortableApps.7z .\PortableApps\* -sdel >nul
        if exist "PortableApps" (rd /s /q "PortableApps" >nul)
exit /b 0

:PortableAppsExtract
    cd /d "%bindir%"
        7z x "PortableApps.7z" -o"%ducky%\" -aoa -y >nul
exit /b 0


:moveISO
    if exist "%bindir%\%~1" (
        cd /d "%bindir%\%~1"
            if exist "*.iso" move /y "*.iso" "%curpath%" >nul
    )
exit /b 0


:moveISOTemp
    cd /d "%bindir%"
        for /f "delims=" %%f in (%~1.list) do (
            cd /d "%curpath%"
                if exist "*%%f*.iso" move /y "*%%f*.iso" "%bindir%\%~1" >nul
            cd /d "%bindir%"
        )
exit /b 0


:checkISO
    cd /d "%bindir%\%~1"
        for /f "delims=" %%f in (%bindir%\%~1.list) do (
            if exist "*%%f*.iso" goto :modules.go
        )
        goto :%~2
    :modules.go
exit /b 0





:: --------------------------------------------
:: Extra functions
:: --------------------------------------------

:gather.info
    if exist %ducky% cd /d "%ducky%\BOOT"
        if exist lang (
            for /f "tokens=*" %%b in (lang) do set "lang=%%b"
        )
        if exist rEFInd (
            for /f "tokens=*" %%b in (rEFInd) do set "rtheme=%%b"
        )
        if exist secureboot (
            for /f "tokens=*" %%b in (secureboot) do set "secureboot=%%b"
        ) else (
            set "secureboot=n"
        )
    if exist %ducky% cd /d "%ducky%\BOOT\GRUB\themes\"
        if exist theme (
            for /f "tokens=*" %%b in (theme) do set "gtheme=%%b"
        )
    cd /d "%bindir%"
exit /b 0


:changelanguage
    set "title=%_lang0833_%"
    call :colortool
    echo.
    echo ^> Current Language is %lang%
    echo ======================================================================
    echo        [ 1 ] = English                [ 2 ] = Vietnam                 
    echo        [ 3 ] = Turkish                [ 4 ] = Simplified Chinese      
    echo ======================================================================
    echo.
    choice /c 1234q /cs /n /m "%_lang0016_%"
        if errorlevel 5 goto :extra.main
        if errorlevel 4 set "lang=SimplifiedChinese" & goto :continue.lang
        if errorlevel 3 set "lang=Turkish" & goto :continue.lang
        if errorlevel 2 set "lang=Vietnam" & goto :continue.lang
        if errorlevel 1 set "lang=English" & goto :continue.lang

    :continue.lang
    echo.
    echo %_lang0014_%
    cd /d "%bindir%"
        7z.exe x "config\%lang%.7z" -o"%ducky%\" -aoa -y >nul
        >"%ducky%\BOOT\lang" (echo %lang%)
        call language.bat
    cd /d "%bindir%\config"
        call "main.bat"
        :: setting language for grub2 file manager
        >"%ducky%\BOOT\grub\lang.sh" (echo export lang=%langfm%;)
    call :clean.bye
exit /b 0


:sortgrub2menu
    set "title=%_lang0836_%"
    call :colortool
    echo                   _    ____  
    echo   __ _ _ __ _   _^| ^|__^|___ \  a. %_config0115_%
    echo  / _` ^| '__^| ^| ^| ^| '_ \ __^) ^| b. %_config0109_%
    echo ^| ^(_^| ^| ^|  ^| ^|_^| ^| ^|_^) / __/  c. %_config0110_%
    echo  \__, ^|_^|   \__,_^|_.__^|_____^| d. %_config0111_%
    echo  ^|___/                        e. %_config0100_%
    echo   _ __ ___   ___ _ __  _   _  f. %_config0101_%
    echo  ^| '_ ` _ \ / _ ^| '_ \^| ^| ^| ^| g. %_config0102_%
    echo  ^| ^| ^| ^| ^| ^|  __^| ^| ^| ^| ^|_^| ^| h. %_config0107_%
    echo  ^|_^| ^|_^| ^|_^|\___^|_^| ^|_^|\__,_^| i. %_config0112_%
    echo           _ _     _           k. %_config0113_%
    echo          ^| ^(_^)___^| ^|_         l. %_config0128_%
    echo          ^| ^| / __^| __^|        m. %_config0116_%
    echo          ^| ^| \__ ^| ^|_         n. %_config0124_%
    echo          ^|_^|_^|___/\__^|        o. %_config0125_%
    echo.
    set list=a b c d e f g h i k l m n o
    set /p list= "%_lang0838_%"
        :: check the character of the string
        echo %list%| findstr /r /c:"[a-o]" >nul
        if not "%errorlevel%"=="0" goto :sortgrub2menu
    
    cd /d "%ducky%\BOOT\grub"
        >"menu.list" (echo %list%)
    
    cd /d "%bindir%\config"
        call "main.bat"
        call :clean.bye
exit /b 0


:grub2theme
    set "title=%_lang0821_%"
    call :colortool
    set "curtheme=%gtheme%"
    echo.
    echo %_lang0300_% %curtheme%
    echo =====================================================================
    echo 01 = Aero      11 = Breeze-1      21 = Gentoo      31 = Raindrops    
    echo 02 = AirVision 12 = blur-grub2    22 = Grau        32 = SAO          
    echo 03 = Alienware 13 = Breeze_dark   23 = Huayralimbo 33 = SolarizedDark
    echo 04 = Anonymous 14 = Breeze-5      24 = Journey     34 = Solstice     
    echo 05 = Archlinux 15 = CyberSecurity 25 = Monochrome  35 = Standby      
    echo 06 = Ask-larry 16 = Dark_Colors   26 = Oxygen      36 = Steam        
    echo 07 = Atomic    17 = Dark_squares  27 = Plasma-dark 37 = StylishDark  
    echo 08 = Aurora    18 = Devuan        28 = poly-dark   38 = Tela         
    echo 09 = Axiom     19 = Eternity      29 = Powerman    39 = Ubuntu-lucid 
    echo 10 = Bluec4d   20 = FagiadaBue    30 = RainbowDash 40 = Vimix        
    echo =====================================================================
    echo.
    set /P ask= %_lang0301_%
    if "%ask%"=="1"  (set "gtheme=Aero"            & goto :continue.gtheme)
    if "%ask%"=="2"  (set "gtheme=Air_Vision"      & goto :continue.gtheme)
    if "%ask%"=="3"  (set "gtheme=Alienware"       & goto :continue.gtheme)
    if "%ask%"=="4"  (set "gtheme=Anonymous"       & goto :continue.gtheme)
    if "%ask%"=="5"  (set "gtheme=Archlinux"       & goto :continue.gtheme)
    if "%ask%"=="6"  (set "gtheme=Ask-larry"       & goto :continue.gtheme)
    if "%ask%"=="7"  (set "gtheme=Atomic"          & goto :continue.gtheme)
    if "%ask%"=="8"  (set "gtheme=Aurora"          & goto :continue.gtheme)
    if "%ask%"=="9"  (set "gtheme=Axiom"           & goto :continue.gtheme)
    if "%ask%"=="10" (set "gtheme=Bluec4d"         & goto :continue.gtheme)
    if "%ask%"=="11" (set "gtheme=Breeze-1"        & goto :continue.gtheme)
    if "%ask%"=="12" (set "gtheme=blur-grub2"      & goto :continue.gtheme)
    if "%ask%"=="13" (set "gtheme=Breeze_dark"     & goto :continue.gtheme)
    if "%ask%"=="14" (set "gtheme=Breeze-5"        & goto :continue.gtheme)
    if "%ask%"=="15" (set "gtheme=CyberSecurity"   & goto :continue.gtheme)
    if "%ask%"=="16" (set "gtheme=Dark_Colors"     & goto :continue.gtheme)
    if "%ask%"=="17" (set "gtheme=Dark_squares"    & goto :continue.gtheme)
    if "%ask%"=="18" (set "gtheme=Devuan"          & goto :continue.gtheme)
    if "%ask%"=="19" (set "gtheme=Eternity"        & goto :continue.gtheme)
    if "%ask%"=="20" (set "gtheme=FagiadaBue"      & goto :continue.gtheme)
    if "%ask%"=="21" (set "gtheme=Gentoo"          & goto :continue.gtheme)
    if "%ask%"=="22" (set "gtheme=Grau"            & goto :continue.gtheme)
    if "%ask%"=="23" (set "gtheme=Huayralimbo"     & goto :continue.gtheme)
    if "%ask%"=="24" (set "gtheme=Journey"         & goto :continue.gtheme)
    if "%ask%"=="25" (set "gtheme=Monochrome"      & goto :continue.gtheme)
    if "%ask%"=="26" (set "gtheme=Oxygen"          & goto :continue.gtheme)
    if "%ask%"=="27" (set "gtheme=Plasma-dark"     & goto :continue.gtheme)
    if "%ask%"=="28" (set "gtheme=poly-dark"       & goto :continue.gtheme)
    if "%ask%"=="29" (set "gtheme=Powerman"        & goto :continue.gtheme)
    if "%ask%"=="30" (set "gtheme=RainbowDash"     & goto :continue.gtheme)
    if "%ask%"=="31" (set "gtheme=Raindrops"       & goto :continue.gtheme)
    if "%ask%"=="32" (set "gtheme=SAO"             & goto :continue.gtheme)
    if "%ask%"=="33" (set "gtheme=SolarizedDark"   & goto :continue.gtheme)
    if "%ask%"=="34" (set "gtheme=Solstice"        & goto :continue.gtheme)
    if "%ask%"=="35" (set "gtheme=Standby"         & goto :continue.gtheme)
    if "%ask%"=="36" (set "gtheme=Steam"           & goto :continue.gtheme)
    if "%ask%"=="37" (set "gtheme=StylishDark"     & goto :continue.gtheme)
    if "%ask%"=="38" (set "gtheme=Tela"            & goto :continue.gtheme)
    if "%ask%"=="39" (set "gtheme=Ubuntu-lucid"    & goto :continue.gtheme)
    if "%ask%"=="40" (set "gtheme=Vimix"           & goto :continue.gtheme)
    if "%ask%"=="q"  goto :extra.main
    color 0e & echo. & echo %_lang0003_% & timeout /t 15 >nul & goto :grub2theme
    
    :continue.gtheme
    cd /d "%ducky%\BOOT\grub\themes"
        if exist "%curtheme%" rmdir /s /q "%curtheme%" >nul
        if not exist "%gtheme%" call :install.gtheme
        >"%ducky%\BOOT\grub\themes\theme" (echo %gtheme%)
        call :clean.bye
exit /b 0


:rEFIndtheme
    set "title=%_lang0822_%"
    call :colortool
    echo.
    echo %_lang0400_% %rtheme%
    echo =====================================================================
    echo 01 = Apocalypse   12 = CloverBootcam 23 = Glassy     34 = Oceanix    
    echo 02 = BGM          13 = Clovernity    24 = GoldClover 35 = Pandora    
    echo 03 = BGM256       14 = Clover-X      25 = Gothic     36 = Red        
    echo 04 = black        15 = CrispyOSX     26 = HighSierra 37 = Shield     
    echo 05 = Bluemac      16 = Crystal       27 = HMF        38 = SimpleGrey 
    echo 06 = Buttons      17 = Dark          28 = iclover    39 = Simplicity 
    echo 07 = Carbon       18 = DarkBoot      29 = Leather    40 = Smooth     
    echo 08 = Catalina     19 = DarkBootX     30 = MacOSX     41 = Sphere     
    echo 09 = Chrome       20 = ElCapitan     31 = MavsStyle  42 = Underground
    echo 10 = Circla       21 = Emerald       32 = Mojave     43 = Universe   
    echo 11 = ClassicMacOS 22 = GameOfThrones 33 = Neon       44 = Woody      
    echo =====================================================================
    echo.
    set /p ask= %_lang0401_%
    if "%ask%"=="1"  set "rtheme=Apocalypse"     & goto :continue.rtheme
    if "%ask%"=="2"  set "rtheme=BGM"            & goto :continue.rtheme
    if "%ask%"=="3"  set "rtheme=BGM256"         & goto :continue.rtheme
    if "%ask%"=="4"  set "rtheme=black"          & goto :continue.rtheme
    if "%ask%"=="5"  set "rtheme=Bluemac"        & goto :continue.rtheme
    if "%ask%"=="6"  set "rtheme=Buttons"        & goto :continue.rtheme
    if "%ask%"=="7"  set "rtheme=Carbon"         & goto :continue.rtheme
    if "%ask%"=="8"  set "rtheme=Catalina"       & goto :continue.rtheme
    if "%ask%"=="9"  set "rtheme=Chrome"         & goto :continue.rtheme
    if "%ask%"=="10" set "rtheme=Circla"         & goto :continue.rtheme
    if "%ask%"=="11" set "rtheme=ClassicMacOS"   & goto :continue.rtheme
    if "%ask%"=="12" set "rtheme=CloverBootcamp" & goto :continue.rtheme
    if "%ask%"=="13" set "rtheme=Clovernity"     & goto :continue.rtheme
    if "%ask%"=="14" set "rtheme=Clover-X"       & goto :continue.rtheme
    if "%ask%"=="15" set "rtheme=CrispyOSX"      & goto :continue.rtheme
    if "%ask%"=="16" set "rtheme=Crystal"        & goto :continue.rtheme
    if "%ask%"=="17" set "rtheme=Dark"           & goto :continue.rtheme
    if "%ask%"=="18" set "rtheme=DarkBoot"       & goto :continue.rtheme
    if "%ask%"=="19" set "rtheme=DarkBootX"      & goto :continue.rtheme
    if "%ask%"=="20" set "rtheme=ElCapitan"      & goto :continue.rtheme
    if "%ask%"=="21" set "rtheme=Emerald"        & goto :continue.rtheme
    if "%ask%"=="22" set "rtheme=GameOfThrones"  & goto :continue.rtheme
    if "%ask%"=="23" set "rtheme=Glassy"         & goto :continue.rtheme
    if "%ask%"=="24" set "rtheme=GoldClover"     & goto :continue.rtheme
    if "%ask%"=="25" set "rtheme=Gothic"         & goto :continue.rtheme
    if "%ask%"=="26" set "rtheme=HighSierra"     & goto :continue.rtheme
    if "%ask%"=="27" set "rtheme=HMF"            & goto :continue.rtheme
    if "%ask%"=="28" set "rtheme=iclover"        & goto :continue.rtheme
    if "%ask%"=="29" set "rtheme=Leather"        & goto :continue.rtheme
    if "%ask%"=="30" set "rtheme=MacOSX"         & goto :continue.rtheme
    if "%ask%"=="31" set "rtheme=MavsStyle"      & goto :continue.rtheme
    if "%ask%"=="32" set "rtheme=Mojave"         & goto :continue.rtheme
    if "%ask%"=="33" set "rtheme=Neon"           & goto :continue.rtheme
    if "%ask%"=="34" set "rtheme=Oceanix"        & goto :continue.rtheme
    if "%ask%"=="35" set "rtheme=Pandora"        & goto :continue.rtheme
    if "%ask%"=="36" set "rtheme=Red"            & goto :continue.rtheme
    if "%ask%"=="37" set "rtheme=Shield"         & goto :continue.rtheme
    if "%ask%"=="38" set "rtheme=SimpleGrey"     & goto :continue.rtheme
    if "%ask%"=="39" set "rtheme=Simplicity"     & goto :continue.rtheme
    if "%ask%"=="40" set "rtheme=Smooth"         & goto :continue.rtheme
    if "%ask%"=="41" set "rtheme=Sphere"         & goto :continue.rtheme
    if "%ask%"=="42" set "rtheme=Underground"    & goto :continue.rtheme
    if "%ask%"=="43" set "rtheme=Universe"       & goto :continue.rtheme
    if "%ask%"=="44" set "rtheme=Woody"          & goto :continue.rtheme
    if "%ask%"=="q"  goto :extra.main
    color 0e & echo. & echo %_lang0003_% & timeout /t 15 >nul & goto :rEFIndtheme

    :continue.rtheme
    call :checkdisktype
        if "%harddisk%"=="true" (
            echo.
            echo ^>^> Hard Disk detected, auto quit...
            timeout /t 3 >nul & exit
        )
        call :set.partnum install.rtheme install.rtheme

    :install.rtheme
    call :extract.rEFInd
    cd /d "%tmp%\rEFInd_themes\%rtheme%\icons"
        >"%ducky%\BOOT\rEFInd" (echo %rtheme%)
        echo. & echo %_lang0402_%
        if exist "%ducky%\EFI\CLOVER\*.*" (
            xcopy "cloverx64.png" "%ducky%\EFI\CLOVER\" /e /z /r /y /q >nul
        )
        call :rEFInd.icons %ducky%
    :: Install rEFind theme
    echo.
    echo ^>^> Installing rEFind theme...
    echo.
    call :get.path rpath REFIND
    cd /d "%tmp%\rEFInd_themes"
        call :copy.hidden "%rtheme%" "%rpath%\EFI\BOOT\themes"
    :: Copy icon to secure boot partition
    if not "%secureboot%"=="n" (
        call :get.path spath M-ESP
        cd /d "%tmp%\rEFInd_themes\%rtheme%\icons"
            call :copy.hidden "others" "%spath%\EFI\BOOT"
    )
    call :clean.bye
exit /b 0


:install.gtheme
    7z x "%bindir%\grub2_themes\%gtheme%.7z" -o"%ducky%\BOOT\grub\themes\" -aoa -y >nul
    7z x "%bindir%\grub2_themes\icons.7z" -o"%ducky%\BOOT\grub\themes\" -aoa -y >nul
    7z x "%bindir%\grub2font.7z" -o"%ducky%\BOOT\grub\themes\%gtheme%" -aoa -y >nul
    call "%bindir%\config\main.bat"
exit /b 0


:easeconvertdisk
    set "title=%_lang0831_%"
    call :colortool
    call :list.disk
    echo.
    set /p disk= %_lang0101_%
        if "%disk%"=="q" goto :extra.main
    call :checkdisktype
        if "%virtualdisk%"=="true" goto :option.convert
        if "%harddisk%"=="true" (
            echo. & echo. & echo %_lang0102_%
            color 0e & echo %_lang0103_% & timeout /t 15 >nul & cls
            goto :easeconvertdisk
        )
        if "%usb%"=="true" goto :option.convert
        if "%externaldisk%"=="true" goto :option.convert
        color 0e & echo. & echo %_lang0104_% & timeout /t 15 >nul & goto :easeconvertdisk
    
    :option.convert
    call :colortool
    cd /d "%tmp%"
        > warning.vbs (
            echo Dim Speak
            echo Set Speak=CreateObject^("sapi.spvoice"^)
            echo Speak.Speak "WARNING!"
            echo WScript.Sleep 4
            echo Speak.Speak "These features will delete all partition on your External Drive"
            echo WScript.Sleep 2
            echo Speak.Speak "Please backup your data on the External Drive before continue"
            echo WScript.Sleep 4
            echo Speak.Speak "Press 1 to Initialize a disk as GPT"
            echo WScript.Sleep 2
            echo Speak.Speak "Press 2 to Initialize a disk as MBR"
            echo WScript.Sleep 2
        )
        call :speechOn warning.vbs
    
    echo.
    echo %_lang0813_%
    echo ---------------------------------------------------------------------
    echo %_lang0814_%
    echo %_lang0815_%
    echo.
    echo %_lang0816_%
    echo %_lang0817_%
    echo ---------------------------------------------------------------------
    echo.
    echo ^>  Disk %disk% was selected.
    echo.
    choice /c 12 /cs /n /m "*  %_lang0905_% [ ? ] = "
        if errorlevel 1 set "option=1"
        if errorlevel 2 set "option=2"
        :: do not change the errorlevel order in the two lines above
        call :speechOff warning.vbs
    
    echo.
    choice /c yn /cs /n /m "%_lang0818_%"
        if errorlevel 2 call :colortool & goto :option.convert
        if errorlevel 1 goto :continue.convert
    
    :continue.convert
    timeout /t 2 >nul
    if "%option%"=="1" cls & goto :GPT.convert
    if "%option%"=="2" cls & goto :MBR.convert
    
    :GPT.convert
    partassist /hd:%disk% /del:all
    partassist /init:%disk% /gpt
    timeout /t 2 >nul & goto :exit.convert
    
    :MBR.convert
    partassist /hd:%disk% /del:all
    partassist /init:%disk%
    timeout /t 2 >nul
    
    :exit.convert
    goto :mainMenu
exit /b 0


:editWinPEbootmanager
    set "title=%_lang0826_%"
    call :colortool
    echo.
    echo            ^	^>^> MINI WINDOWS BOOT MANAGER EDITOR ^<^<
    echo                 --------------------------------------
    echo.
    cd /d "%bindir%"
    choice /c ynq /cs /n /m "%_lang0800_%"
        if errorlevel 3 goto :extra.main
        if errorlevel 2 goto :option.pe
        if errorlevel 1 call :bcdautomenu
    
    :option.pe
    echo.
    choice /c 12 /cs /n /m "*               [ 1 ] Legacy mode  [ 2 ] UEFI mode > "
        if errorlevel 2 goto :uefi3264bit
        if errorlevel 1 goto :legacy3264bit
    
    :legacy3264bit
    set "source=%ducky%\BOOT\bootmgr\B84"
    echo.
    echo ^*               Source^: %source%
    bootice /edit_bcd /easymode /file=%source%
    call :colortool
    call :clean.bye
    
    :uefi3264bit
    :: open Configuration BCD file...
    if "%secureboot%"=="n" (
        set "source=%ducky%\EFI\Microsoft\Boot\bcd"
    ) else (
        set "source=%bindir%\secureboot\EFI\Microsoft\Boot\bcd"
    )
    echo.
    echo ^*               Source^: %source%
    "%bindir%\bootice.exe" /edit_bcd /easymode /file="%source%"
    :: copy Configuration BCD file to the destination...
    if "%secureboot%"=="y" call :bcdautoset bcd
    if "%secureboot%"=="y" call :get.path epath M-ESP
    if "%secureboot%"=="y" (
        call :copy.hidden "%source%" "%epath%\EFI\Microsoft\Boot" >nul 2>&1
    )
    call :colortool
    goto :extra.main
exit /b 0


:bcdautomenu
    mode con lines=100 cols=70
    > "%tmp%\winpemenu.txt" (
        echo.
        echo %_lang0801_%
        echo.
        echo [ 01 ] Boot Win10PE SE          64bit
        echo [ 02 ] Boot Win8PE              64bit
        echo [ 03 ] Hiren’s BootCD PE        64bit
        echo [ 04 ] Bob.Omb’s Modified Win10PE x64
        echo [ 05 ] Boot Win10PE SE          32bit
        echo [ 06 ] Boot Win8PE              32bit
        echo [ 07 ] Boot Win7PE              32bit
        echo [ 08 ] Boot MiniXP
        echo [ 09 ] Install Win 7-8-10 with ISO method                  WIM ^& ISO
        echo [ .. ] Switch to Grub4Dos Menu
        echo [ .. ] Switch to GRUB2 Menu
        echo.
        echo %_lang0802_%
        echo.
        echo [ 01 ] Win10PE SE                x64 UEFI
        echo [ 02 ] Win8PE                    x64 UEFI
        echo [ 03 ] Win10PE SE                x64 UEFI               DLC Boot
        echo [ 04 ] Win10PE SE                x64 UEFI               Strelec
        echo [ 05 ] Hirens BootCD PE          x64 UEFI
        echo [ 06 ] Bob.Omb Modified Win10PE  x64 UEFI
        echo [ 07 ] Setup Windows from sources                       WIM ^& ISO
        echo -------------------------------------------------------------------
        echo [ 01 ] Win10PE SE                x86 UEFI
        echo [ 02 ] Win8PE                    x86 UEFI
        echo [ 03 ] Win10PE SE                x86 UEFI               DLC Boot
        echo [ 04 ] Win10PE SE                x86 UEFI               Strelec
        echo [ 05 ] Setup Windows from sources                       WIM ^& ISO
        echo -------------------------------------------------------------------
        echo.
        echo %_lang0803_%
        echo.
        echo %_lang0804_%
        echo.
    )
    
    echo.
    echo            ^	^>^> MINI WINDOWS BOOT MANAGER EDITOR ^<^<
    echo                 --------------------------------------
    echo.
    echo %_lang0805_%
    "%tmp%\winpemenu.txt"
    
    cd /d "%ducky%\WIM"
        echo.
        echo %_lang0806_%
        for /f "tokens=*" %%i in ('dir /a:-d /b 2^>nul') do (
            if exist %%~ni.wim (
                echo.
                echo ^  %%~ni.wim
                set "wim=true"
            )
        )
        if not "%wim%"=="true" (
            echo.
            echo. %_lang0807_%
        )
    
    echo.
    echo.  ------------------------------------------------------------------
    echo. %_lang0808_%
    echo.  ------------------------------------------------------------------
    echo.
    set /p bootfilename= %_lang0809_%
    set "bootfile=\WIM\%bootfilename%"
    
    for /f "delims=" %%b in (%tmp%\winpemenu.txt) do set menutitle=%%b
    del /f /q "%tmp%\winpemenu.txt"
    
    :: Legacy BIOS Mode
    echo.
    echo %menutitle%
    echo.
    echo %_lang0810_%
    set "source=%ducky%\BOOT\bootmgr\B84"
    call :create.entry
    
    :: UEFI Mode
    echo.
    echo %_lang0811_%
    if "%secureboot%"=="n" (
        set "source=%ducky%\EFI\Microsoft\Boot\bcd"
    ) else (
        set "source=%bindir%\secureboot\EFI\Microsoft\Boot\bcd"
    )
    call :create.entry
    
    echo.
    echo.  ------------------------------------------------------------------
    echo.  %_lang0812_%
    echo.  ------------------------------------------------------------------
    echo.
exit /b 0


:create.entry
    set "Object={7619dcc8-fafe-11d9-b411-000476eba25f}"
    bcdedit /store %source% /copy {default} /d "%menutitle%" > %tmp%\tmpuuid.txt
    for /f "tokens=7 delims=. " %%b in (%tmp%\tmpuuid.txt) do set identifier=%%b
    del /f /q "%tmp%\tmpuuid.txt"
    bcdedit /store %source% /set %identifier% device ramdisk=[%ducky%]%bootfile%,%Object%
    bcdedit /store %source% /set %identifier% osdevice ramdisk=[%ducky%]%bootfile%,%Object% >nul
    timeout /t 1 >nul
exit /b 0


:editwinsetupfromUSB
    set "title=%_lang0827_%"
    call :colortool
    if not exist "%ducky%\WINSETUP\" (
        color 0e & echo.
        echo ^>^> Please install winsetup module before running me
        timeout /t 15 >nul & goto :extra.main
    )
    
    :option.winsetup
    echo                ^	^>^> WINSETUP BOOT MANAGER EDITOR  ^<^<
    echo                -------------------------------------
    echo.
    set mode=
    set /P mode= "^*              [ 1 ] Legacy mode - [ 2 ] UEFI mode ^> "
    if "%mode%"=="1" goto :legacy.winsetup
    if "%mode%"=="2" goto :uefi.winsetup
    if "%mode%"=="q" goto :extra.main
    color 0e & echo. & echo ^>^>  Invalid Input. & timeout /t 15 >nul & goto :option.winsetup
    
    :legacy.winsetup
    bootice /edit_bcd /easymode /file=%ducky%\BOOT\bcd
    call :clean.bye
    
    :uefi.winsetup
    bootice /edit_bcd /easymode /file=%ducky%\EFI\MICROSOFT\Boot\bcd
    call :clean.bye
exit /b 0


:fixbootloader
    set "title=%_lang0829_%"
    call :colortool
    call :check.diskInfo
    echo                  ------------------------------------
    echo                    __ _        _                 _   
    echo                   / _^(___  __ ^| ^|__   ___   ___ ^| ^|_ 
    echo                  ^| ^|_^| \ \/ / ^| '_ \ / _ \ / _ \^| __^|
    echo                  ^|  _^| ^|^>  ^<  ^| ^|_^) ^| ^(_^) ^| ^(_^) ^| ^|_ 
    echo                  ^|_^| ^|_/_/\_\ ^|_.__/ \___/ \___/ \__^|
    echo.
    echo                  ------------------------------------
    echo.
    cd /d "%bindir%"
        7z x "wget.7z" -o"%tmp%" -aoa -y >nul
    cd /d "%ducky%"
        if exist boot ren boot BOOT >nul
    cd /d "%ducky%\boot"
        if exist grub_old ren grub_old grub
        if exist efi ren efi EFI >nul
    cd /d "%ducky%\EFI"
        if exist boot ren boot BOOT >nul
        if exist microsoft ren microsoft MICROSOFT >nul
    if exist "%ducky%\WINSETUP" (
        goto :winsetup.fix
    ) else (
        goto :grub.fix
    )
    
    :winsetup.fix
    cd /d "%ducky%\efi\boot"
        copy /y backup\WinSetup\winsetupx64.efi %ducky%\efi\boot\ >nul
        copy /y backup\WinSetup\winsetupia32.efi %ducky%\efi\boot\ >nul
        xcopy /y /q /h /r %ducky%\BOOT\grub\menu.lst %ducky%\ >nul
        if exist %ducky%\winsetup.lst (del /s /q /f %ducky%\winsetup.lst >nul)
    
    :grub.fix
    if "%GPT%"=="true" goto :grub2.fix
    echo.
    choice /c ynq /cs /n /m "%_lang0837_%"
        if errorlevel 3 goto :extra.main
        if errorlevel 2 goto :grub2.fix
        if errorlevel 1 call :download.grub4dos
    
    :grub2.fix
    echo.
    choice /c ynq /cs /n /m "%_lang0503_%"
        if errorlevel 3 goto :fixbootloader
        if errorlevel 2 goto :config.fix
        if errorlevel 1 set "installgrub2=true"

        if "%installgrub2%"=="true" (
            choice /c ynq /cs /n /m "> Download the last build from A1ive?        [ y/n ] > "
                if errorlevel 1 set "downloadgrub2=true"
                if errorlevel 2 set "downloadgrub2=false"
                if errorlevel 3 goto :fixbootloader
        )
        if "%downloadgrub2%"=="true" call :download.grub2
        echo %_lang0504_%
        call :grub2installer MULTIBOOT

    :config.fix
    cd /d "%bindir%\config\"
        call "main.bat"
    cd /d "%ducky%\EFI\Microsoft\Boot"
        call :bcdautoset bcd
    :: install Syslinux Bootloader
    if "%GPT%"=="false" (
        "%bindir%\syslinux.exe" --force --directory /BOOT/syslinux %ducky% %ducky%\BOOT\syslinux\syslinux.bin
        if exist "%ducky%\DLC1" (
        "%bindir%\syslinux.exe" --force --directory /DLC1/Boot %ducky% %ducky%\DLC1\Boot\syslinux.bin
        )
    )
    :: --------------------------------------------------------------------
    7z x "%bindir%\config\%lang%.7z" -o"%ducky%\" -aoa -y >nul
    cd /d "%bindir%\extra-modules"
        7z x "grub2-filemanager.7z" -o"%ducky%\BOOT\grub\" -aoa -y >nul
        >"%ducky%\BOOT\grub\lang.sh" (echo export lang=%langfm%;)
    :: update default efi boot
    set "option=Grub2"
    if "%installgrub2%"=="true" if exist "%ducky%\EFI\BOOT\WindowsGrub2" (
        goto :install.defaultboot
    )
    call :clean.bye
exit /b 0


:download.grub4dos
    cd /d "%tmp%"
        wget -q -O g4dtemp.log  http://grub4dos.chenall.net >nul
        for /f "tokens=2,3 delims=/" %%a in (
            'type "g4dtemp.log" ^| findstr /i "<h1.*.7z" ^| find /n /v "" ^| find "[1]"'
            ) do (
                set "ver=%%b"
                set "sourcelink=http://dl.grub4dos.chenall.net/%%b.7z"
            )
        if "%~1"=="skip" (
            echo Updating %ver%...
        ) else (
            echo ^  Updating %ver%...
        )
        wget -q -O grub4dos.7z %sourcelink% >nul
        del g4dtemp.log
    cd /d "%bindir%\extra-modules"
        set "file=grub4dos-0.4.6a/grldr grub4dos-0.4.6a/grub.exe grub4dos0.4.6a/grldr_cd.bin"
        7z e -ogrub4dos -aoa "%tmp%\grub4dos.7z" %file% >nul
        del /s /q "%tmp%\grub4dos.7z" >nul
exit /b 0


:download.grub2
    cd /d "%tmp%"
        if exist "grub" rd /s /q "grub" >nul
        if exist "grub2" rd /s /q "grub2" >nul
        :: download last release
        if not "%~1"=="skip" echo ^  Downloading Grub2 from A1ive...
        set "sourcelink=https://github.com/a1ive/grub/releases/download/latest/grub2-latest.tar.gz"
        wget -q --show-progress -O grub2-latest.tar.gz %sourcelink%
        if not "%~1"=="skip" echo ^  Repacking Grub2...
        set "list=i386-efi i386-pc locale x86_64-efi grub-install.exe"
        7z x grub2-latest.tar.gz >nul
        7z x grub2-latest.tar %list% -r -y >nul
        ren grub grub2 >nul
        7z a grub2.7z grub2\ -sdel >nul
        if exist "grub2" rd /s /q "grub2" >nul
        if exist "grub2-latest.*" del "grub2-latest.*" /s /q /f >nul
        move /y grub2.7z %bindir% >nul
    cd /d "%bindir%"
exit /b 0


:download.grubfm
    cd /d "%bindir%"
        7z x "wget.7z" -o"%tmp%" -aoa -y >nul
    cd /d "%tmp%"
        set "sourcelink=https://github.com/a1ive/grub2-filemanager/releases"
        wget.exe -q -O grubfm.log %sourcelink% >nul
        for /f tokens^=1^,6^ delims^=/^" %%a in (
            'type grubfm.log ^| findstr /i "releases/tag.*.</a>" ^| find /n /v "" ^| find "[1]"'
        ) do set "ver=%%b"
        set "url=https://github.com/a1ive/grub2-filemanager/releases/download/%ver%/grubfm-%langfm%.7z"
        if not "%~1"=="skip" (
            echo.
            echo ^> Downloading grub2-filemanager %ver%...
        )
        wget.exe -q --show-progress -O grubfm-%ver%.7z %url%
exit /b 0

:install.grubfm
    7z x "%bindir%\extra-modules\grub2-filemanager.7z" -o"%ducky%\BOOT\grub\" -aoa -y >nul
    >"%ducky%\BOOT\grub\lang.sh" (echo export lang=%langfm%;)
exit /b 0

:grub2-filemanager
    set "title=%_lang0828_%"
    call :colortool
    echo                     ___            _      __
    echo                   / _ \_ __ _   _^| ^|__  / _^|_ __ ___
    echo                  / /_\/ '__^| ^| ^| ^| '_ \^| ^|_^| '_ ` _ \
    echo                 / /_\\^| ^|  ^| ^|_^| ^| ^|_) ^|  _^| ^| ^| ^| ^| ^|
    echo                 \____/^|_^|   \__,_^|_.__/^|_^| ^|_^| ^|_^| ^|_^|
    echo                                                  A1ive
    echo.
    echo ^                      [ 1 ] Origin build ^(full^)
    echo ^                      [ 2 ] Source Script ^(lite^)
    echo.
    choice /c 12q /cs /n /m "%_lang0020_%"
        if errorlevel 3 goto :extra.main
        if errorlevel 2 goto :grubfm-script
        if errorlevel 1 goto :grubfm-build

    :grubfm-build
        call :download.grubfm
        set "list=grubfmia32.efi grubfmx64.efi grubfm.iso"
        cls & echo. & echo %_lang0224_%
        7z x "%tmp%\grubfm*.7z" -o"%ducky%\EFI\Boot\" %list% -r -y >nul
        call :clean.bye
    
    :grubfm-script
        echo.
        echo ^> Downloading grub2-filemanager...
        cd /d "%bindir%\extra-modules"
            7z x "%bindir%\curl.7z" -o"%tmp%" -aos -y >nul
            set "link=https://github.com/a1ive/grub2-filemanager/archive/lua.zip"
            "%tmp%\curl\curl.exe" -L -s -o grubfm.zip %link%
            7z x "%bindir%\extra-modules\grubfm.zip" -o"%bindir%\extra-modules\" -y >nul
            del "grubfm.zip" /s /q /f >nul
        cd /d "%bindir%\extra-modules\grub2-filemanager-lua\boot\
            xcopy "grub" "%bindir%\extra-modules\grub2-filemanager\" /e /y /q >nul
        cd /d "%bindir%\extra-modules\"
            rmdir "grub2-filemanager-lua" /s /q >nul

        echo.
        echo ^> Setting grub2-filemanager config...
        :: insert backdoor
        cd /d "%bindir%\extra-modules\grub2-filemanager"
        
        for %%b in (main help open osdetect power settings) do (
            if exist %%b.lua >> %%b.lua (
                echo hotkey = "f6" 
                echo command = "configfile $prefix/main.cfg"
                echo grub.add_hidden_menu ^(hotkey, command, "return"^)
            )
        )

        timeout /t 2 >nul

        :: store grub2-filemanager to archive
        cd /d "%bindir%\extra-modules"
            7z a grub2-filemanager.7z .\grub2-filemanager\* >nul
            if exist "grub2-filemanager" rd /s /q "grub2-filemanager" >nul
            if "%installed%"=="false" call :clean.bye
            echo.
            echo ^> Updating grub2-filemanager to MultibootUSB...
            7z x "grub2-filemanager.7z" -o"%ducky%\BOOT\grub\" -aoa -y >nul
            timeout /t 3 >nul
            call :clean.bye
exit /b 0


:setdefaultboot
    set "title=%_lang0825_%"
    call :colortool
    echo.
    echo      %_lang0900_%
    echo ---------------------------------------------------------------------
    echo  %_lang0901_%
    echo  %_lang0902_%
    echo  %_lang0903_%
    echo  %_lang0904_%
    echo ---------------------------------------------------------------------
    echo.
    choice /c 1234q /cs /n /m "%_lang0905_% > "
        if errorlevel 5 timeout /t 1 >nul & goto :extra.main
        if errorlevel 4 timeout /t 1 >nul & set "option=Grub2"
        if errorlevel 3 timeout /t 1 >nul & set "option=rEFInd"
        if errorlevel 2 timeout /t 1 >nul & set "option=Secure_Grub2"
        if errorlevel 1 timeout /t 1 >nul & set "option=Secure_rEFInd"

    :install.defaultboot
    cd /d "%bindir%\secureboot\EFI\Boot\backup"
        if not exist Grub2 mkdir Grub2
    cd /d "%ducky%\BOOT"
        if not exist "secureboot" goto :setdefaultboot
        set "Grub2=%bindir%\secureboot\EFI\Boot\backup\Grub2"
        set "rEFInd=%bindir%\secureboot\EFI\Boot\backup\rEFInd"
        set "WinPE=%bindir%\secureboot\EFI\Boot\backup\WinPE"
    if exist "%ducky%\EFI\BOOT\backup\Grub2" (
        cd /d "%ducky%\EFI\BOOT\backup"
            if exist Grub2 copy Grub2 %Grub2% /y >nul
    )
    echo.
    call :checkdisktype
        if "%harddisk%"=="true" goto :setdefaultboot
        call :set.partnum nonsecure.default secure.default
    
    :nonsecure.default
    if "%option%"=="Secure_rEFInd" cls & goto :setdefaultboot
    if "%option%"=="Secure_Grub2"  cls & goto :setdefaultboot
    call :get.path rpath REFIND
    if "%option%"=="rEFInd" (
        call :copy.hidden %rEFInd% "%rpath%\EFI\BOOT"
    )
    if "%option%"=="Grub2" (
        call :copy.hidden %Grub2% "%rpath%\EFI\BOOT"
        >"%ducky%\EFI\BOOT\WindowsGrub2" (echo true)
    )
    timeout /t 1 >nul
    call :clean.bye
    
    :secure.default
    call :get.path rpath REFIND
    call :get.path epath M-ESP
    if "%option%"=="Secure_rEFInd" (
        call :copy.hidden %WinPE% "%epath%\EFI\BOOT"
        call :copy.hidden %rEFInd% "%rpath%\EFI\BOOT"
        cd /d "%ducky%\EFI\BOOT\"
            if exist bootx64.efi  del bootx64.efi  /s /f
            if exist bootia32.efi del bootia32.efi /s /f
    )
    if "%option%"=="Secure_Grub2" (
        call :copy.hidden %WinPE% "%epath%\EFI\BOOT"
        call :copy.hidden %Grub2% "%rpath%\EFI\BOOT"
    )
    if "%option%"=="rEFInd" (
        if exist "%epath%\EFI\BOOT\*x64.efi" del "%epath%\EFI\BOOT\*x64.efi"
        if exist "%epath%\EFI\BOOT\*ia32.efi" del "%epath%\EFI\BOOT\*ia32.efi"
        call :copy.hidden %rEFInd% "%rpath%\EFI\BOOT"
        cd /d "%bindir%"
            xcopy "secureboot" "%ducky%\" /e /g /h /r /y
    )
    if "%option%"=="Grub2" (
        call :copy.hidden %Grub2% "%epath%\EFI\BOOT"
        cd /d "%bindir%"
            xcopy "secureboot" "%ducky%\" /e /g /h /r /y
            >"%ducky%\EFI\BOOT\WindowsGrub2" (echo true)
    )
    timeout /t 1 >nul
    call :clean.bye
exit /b 0


:updatemultiboot
    set "title=%_lang0835_%"
    call :colortool
    echo.
    cd /d "%bindir%"
        7z x "grub2.7z" -o"%tmp%" -aos -y >nul
        7z x "rEFInd_themes\%rtheme%.7z" -o"%tmp%\rEFInd_themes" -aoa -y >nul
        7z x "refind.7z" -o"%tmp%" -aoa -y >nul
    
    echo.
    echo ---------------------------------------------------------------------
    echo.          [ 1 ] Update config only   [ 2 ] Update full data
    echo.          [ 3 ] Download and Update all bootloader and data
    echo ---------------------------------------------------------------------
    echo.
    choice /c 123q /cs /n /m "#   Choose your option [ ? ] > "
        if errorlevel 4 goto :extra.main
        if errorlevel 3 goto :updateOnline
        if errorlevel 2 goto :updateOffline
        if errorlevel 1 goto :updateconfig
    
    :updateOnline
    echo.
    call :download.clover skip
    call :download.rEFInd
    call :download.grub2 skip
    call :download.grubfm skip
    call :download.portableapps
    call :download.grub4dos skip

    :updateOffline
    cd /d "%bindir%"
        echo. & echo ^>^> Updating data...
        call :PortableAppsExtract
        7z x "data.7z" -o"%ducky%\" -aoa -y >nul
        xcopy /y "version" "%ducky%\EFI\BOOT\" >nul
    cd /d "%bindir%"
        7z x "wincdemu.7z" -o"%ducky%\ISO\" -aoa -y >nul
    cd /d "%bindir%\secureboot\BOOT"
        xcopy "boot.sdi" "%ducky%\BOOT\" /e /g /h /r /y /q >nul
        call :grub4dosinstaller %ducky%
    cd /d "%tmp%"
        set "list=grubfmia32.efi grubfmx64.efi grubfm.iso"
        if exist "grubfm*.*" (
            echo. & echo %_lang0224_%
            7z x "%tmp%\grubfm*.7z" -o"%ducky%\EFI\Boot\" %list% -r -y >nul
            del "grubfm*.*" /s /q /f >nul
        )
    
    :: install Syslinux Bootloader
    cd /d "%bindir%"
        syslinux --force --directory /BOOT/syslinux %ducky% %ducky%\BOOT\syslinux\syslinux.bin
    
    call :install.clover skip
    :: install grub2 Bootloader
    cd /d "%bindir%"
        echo.
        echo %_lang0116_%
        call :grub2installer MULTIBOOT
    cd /d "%bindir%"
        7z x "%bindir%\config\%lang%.7z" -o"%ducky%\" -aoa -y >nul
    cd /d "%tmp%\rEfind_themes\%rtheme%\icons"
        call :rEFInd.icons %ducky%
    cd /d "%bindir%"
        call :install.gtheme
    cd /d "%ducky%\EFI\Microsoft\Boot"
        call :bcdautoset bcd
    call :install.rEFInd

    :updateconfig
    cd /d "%bindir%\config"
        call "main.bat"
        timeout /t 2 >nul
        call :clean.bye
exit /b 0


:OneFileLinux
    set "title=%_lang0830_%"
    call :colortool
    echo.
    cd /d "%bindir%"
        7z x "wget.7z" -o"%tmp%" -aoa -y >nul
    cd /d "%tmp%"
        echo.
        echo ^> Get last version...
        set "sourcelink=https://github.com/zhovner/OneFileLinux/releases"
        wget.exe -q -O OneFileLinux.log %sourcelink% >nul
        for /f "tokens=1,6 delims=/" %%a in (
            'type OneFileLinux.log ^| findstr /i "releases/tag.*.</a>" ^| find /n /v "" ^| find "[1]"'
        ) do set "ver=%%b"
        set "ver=%ver:~0,6%"
        set "url=https://github.com/zhovner/OneFileLinux/releases/download/%ver%/OneFileLinux.efi"
        cls
        echo.
        echo ^> Downloading OneFileLinux.efi %ver%...
        wget.exe -q --show-progress -O OneFileLinux.efi %url%
        cls
        echo.
        echo ^> Integrate to multiboot device...
        copy OneFileLinux.efi "%ducky%\EFI\Boot\" /y >nul
        call :clean.bye
exit /b 0


:NTFSdriveprotect
    cd /d "%bindir%"
        7z x "driveprotect.7z" -o"%tmp%" -aos -y >nul
        if "%processor_architecture%" == "x86" (
            set "DriveProtect=driveprotect.exe"
        ) else (
            set "DriveProtect=driveprotectx64.exe"
        )
    cd /d "%tmp%\driveprotect"
        start /i /wait %DriveProtect%
        if "%~1"=="loop" goto :multibootscan
        exit
exit /b 0


:qemuboottester
    call :colortool
    echo.
    echo ^>^> Cleaning up trash, wait a minute...
    echo.
    cd /d "%tmp%"
        del "%tmp%\*.*" /s /q /f >nul
        for /d %%i in ("%tmp%\*.*") do rmdir "%%i" /s /q >nul
        cls
    cd /d "%bindir%"
        7z x "qemu.7z" -o"%tmp%" -aoa -y >nul
    cd /d "%tmp%"
        start qemuboottester.exe
        exit
exit /b 0


:cloverinterface
    echo.
    echo        _                       _           _        _ _           
    echo    ___^| ^| _____   _____ _ __  ^(_^)_ __  ___^| ^|_ __ _^| ^| ^| ___ _ __ 
    echo   / __^| ^|/ _ \ \ / / _ \ '__^| ^| ^| '_ \/ __^| __/ _` ^| ^| ^|/ _ \ '__^|
    echo  ^| ^(__^| ^| ^(_^) \ V /  __/ ^|    ^| ^| ^| ^| \__ \ ^|^| ^(_^| ^| ^| ^|  __/ ^|   
    echo   \___^|_^|\___/ \_/ \___^|_^|    ^|_^|_^| ^|_^|___/\__\__,_^|_^|_^|\___^|_^|   
    echo. 
    echo.
exit /b 0

:get.cloverversion
    for /f tokens^=1^,6^ delims^=/^" %%a in (
        'type clover.log ^| findstr /i "releases/tag.*.</a>" ^| find /n /v "" ^| find "[1]"'
    ) do set "ver=%%b"
exit /b 0

:download.clover
    cd /d "%bindir%"
        if exist "clover" rd /s /q "clover" >nul
        mkdir clover
        7z x "clover.7z" -o"clover" -aoa -y >nul
        7z x "wget.7z" -o"%tmp%" -aoa -y >nul
    :: get clover iso file
    cd /d "%tmp%"
        :: get the lastest version name
        set "sourcelink=https://github.com/CloverHackyColor/CloverBootloader/releases"
        wget -q -O "clover.log" %sourcelink%
        call :get.cloverversion >nul 2>&1
        :: download clover
        if not "%~1"=="skip" (
            echo.
            echo ^> Downloading Clover Boot Manager v%ver%...
        )
        set "url=%sourcelink%/download/%ver%/Clover-%ver%-X64.iso.7z"
        wget -q --show-progress -O Clover-%ver%-X64.iso.7z %url%
        del "clover.log" /s /q /f >nul
        :: extract clover iso
        if exist "*Clover*.iso.7z" (
            7z x "*Clover*.iso.7z" -o"%tmp%" -y >nul
            del "*Clover*.iso.7z" /s /q /f >nul
            7z x "*Clover*.iso" -o"%tmp%" EFI -r -y >nul
        )
    :: delete non-necessary file
    if exist "%tmp%\EFI\CLOVER" (
        cd /d "%bindir%"
        for /f "delims=" %%f in (delete.list) do (
            if exist "%tmp%\EFI\CLOVER\%%f" (
                del "%tmp%\EFI\CLOVER\%%f" /s /q /f >nul
            )
        )
    )
    if exist "%tmp%\EFI\CLOVER" (
        cd /d "%tmp%\EFI\CLOVER"
            ren CLOVERX64.efi cloverx64.efi
    )
    xcopy "%tmp%\EFI\CLOVER" "%bindir%\Clover" /s /z /y /q >nul
    :: use rEFInd driver for clover
    7z x "%bindir%\refind.7z" -o"%tmp%" -aoa -y >nul
    if exist "%tmp%\rEFInd\drivers_x64" (
        xcopy "%tmp%\rEFInd\drivers_x64" "%bindir%\clover\drivers\UEFI" /s /z /y /q >nul
    )
    
    cd /d "%tmp%"
        if exist "EFI" (rd /s /q "EFI")
        if exist "clover*.iso" (del /s /q "clover*.iso" >nul)
    
    :: store clover to archive
    cd /d "%bindir%"
        7z a clover.7z .\clover\* -sdel >nul
        if exist "clover" (rd /s /q "clover" >nul)
exit /b 0

:install.clover
    echo.
    echo %_lang0712_%
    cd /d "%tmp%"
        if not exist rEFInd_themes (mkdir rEFInd_themes)
    cd /d "%bindir%"
        7z x "rEFInd_themes\%rtheme%.7z" -o"%tmp%\rEFInd_themes" -aoa -y >nul
        if not exist "%ducky%\EFI\CLOVER\" (mkdir "%ducky%\EFI\CLOVER\")
        7z x "clover.7z" -o"%ducky%\EFI\CLOVER\" -aoa -y >nul
    cd /d "%tmp%\rEFInd_themes\%rtheme%\icons"
        xcopy "cloverx64.png" "%ducky%\EFI\CLOVER\" /s /z /y /q >nul
    if "%~1" neq "skip" echo %_lang0715_%
    timeout /t 2 >nul
exit /b 0

:cloverinstaller
    set "title=%_lang0823_%"
    call :colortool
    call :check.systemInfo
    
    :clover
    cls 
    call :cloverinterface
    choice /c ynq /cs /n /m "%_lang0700_% > "
        if errorlevel 3 goto :extra.main
        if errorlevel 2 goto :cloverconfig
        if errorlevel 1 call :download.clover

    :cloverconfig
    if "%structure%"=="MBR" goto :option.clover
    echo.
    choice /c yn /cs /n /m "%_lang0702_% > "
        if errorlevel 2 goto :option.clover
        if errorlevel 1 goto :gdisk.clover
    
    :gdisk.clover
    call :colortool
    7z x "gdisk.7z" -o"%tmp%" -aos -y >nul
    if "%PROCESSOR_ARCHITECTURE%"=="x86" (
        set gdisk=gdisk32.exe
    ) else (
        set gdisk=gdisk64.exe
    )
    start http://cloudclovereditor.altervista.org/cce/index.php
    mode con lines=100 cols=81
    echo.
    echo %_lang0703_%
    echo -------------------------------------------------------------------------------
    echo %_lang0704_% %harddisk% %_lang0705_%
    echo %_lang0706_%
    echo %_lang0707_%
    echo -------------------------------------------------------------------------------
    echo.
    cd /d "%tmp%\gdisk"
        %gdisk% \\.\physicaldrive%harddisk%
    
    :option.clover
    call :colortool
    echo.
    echo ----------------------------------------------------------------------
    echo %_lang0708_%
    echo %_lang0709_%
    echo ----------------------------------------------------------------------
    echo.
    choice /c 12 /cs /n /m "%_lang0605_% [ ? ] > "
        if errorlevel 2 goto :MultibootOS.clover
        if errorlevel 1 goto :MultibootUSB.clover
    
    :MultibootUSB.clover
    if "%installed%"=="false" goto :option.clover
    call :colortool
    call :install.clover
    call :clean.bye
    
    :MultibootOS.clover
    if "%structure%"=="MBR" (
        call :colortool
        echo. & echo %_lang0713_% & timeout /t 15 >nul & goto :option.clover
    )
    echo.
    choice /c yn /cs /n /m "%_lang0714_%"
        if errorlevel 2 goto :option.clover
        if errorlevel 1 echo.
    :: installing Clover to ESP
    mountvol S: /d >nul
    mountvol S: /s
    cd /d "%bindir%"
        7z x "clover.7z" -o"S:\EFI\CLOVER\" -aoa -y >nul
    cd /d "%~dp0Modules"
        if exist "config.plist" (
            xcopy "config.plist" "S:\EFI\CLOVER\" /e /y /q >nul
        )
    timeout /t 2 >nul
    mountvol S: /d
    :: Add Cloverx64.efi to the UEFI NVRAM entries
    call :add.entry "Clover Boot Manager" "\EFI\CLOVER\cloverx64.efi"
    call :clean.bye
exit /b 0


:rEFIndinterface
    call :colortool
    echo.
    echo             __ _           _    _           _        _ _           
    echo   _ __ ___ / _^(_^)_ __   __^| ^|  ^(_^)_ __  ___^| ^|_ __ _^| ^| ^| ___ _ __ 
    echo  ^| '__/ _ \ ^|_^| ^| '_ \ / _` ^|  ^| ^| '_ \/ __^| __/ _` ^| ^| ^|/ _ \ '__^|
    echo  ^| ^| ^|  __/  _^| ^| ^| ^| ^| ^(_^| ^|  ^| ^| ^| ^| \__ \ ^|^| ^(_^| ^| ^| ^|  __/ ^|   
    echo  ^|_^|  \___^|_^| ^|_^|_^| ^|_^|\__,_^|  ^|_^|_^| ^|_^|___/\__\__,_^|_^|_^|\___^|_^|   
    echo.
    echo.
exit /b 0

:download.rEFInd
    cd /d "%bindir%"
        if not exist rEFInd mkdir rEFInd
        7z x "wget.7z" -o"%tmp%" -aoa -y >nul
    cd /d "%tmp%"
        :: download the last rEFInd
        set "sourcelink=https://sourceforge.net/projects/refind/files/latest/download"
        wget -q --show-progress -O refind-bin.zip %sourcelink%
        :: extract data
        if not exist "refind-bin" (
            if exist "refind-bin.zip" (
                7z x "refind-bin.zip" -o"%tmp%" -y >nul
                del "refind-bin.zip" /s /q /f >nul
            )
        )
        if exist "%tmp%\*refind-bin*" (
            move "%tmp%\*refind-bin*" "%tmp%\refind-bin" >nul
        )
    
    cd /d "%bindir%"
        for /f "delims=" %%f in (delete.list) do (
            if exist "%tmp%\refind-bin\refind\%%f" (
                del "%tmp%\refind-bin\refind\%%f" /s /q /f >nul
            )
        )
    
    cd /d "%tmp%\refind-bin\refind"
        rename refind_ia32.efi bootia32.efi
        rename refind_x64.efi  bootx64.efi
    
    cd /d "%tmp%\refind-bin"
        xcopy "refind" "%bindir%\rEFInd\" /s /z /y /q >nul
        call "%bindir%\config\refind.conf.bat"
    
    cd /d "%tmp%"
        if exist "refind-bin" rd /S /Q "refind-bin" >nul
    
    :: store refind to archive
    cd /d "%bindir%"
        7z a refind.7z rEFInd\ -sdel >nul
        if exist "rEFInd" rd /s /q "rEFInd" >nul
exit /b 0

:extract.rEFInd
    cd /d "%tmp%"
        if not exist rEFInd_themes mkdir rEFInd_themes
    call :colortool
        7z x "rEFInd_themes\%rtheme%.7z" -o"%tmp%\rEFInd_themes" -aoa -y >nul
        7z x "refind.7z" -o"%tmp%" -aoa -y >nul
exit /b 0

:install.rEFInd
    call :get.path rpath REFIND
    cd /d "%tmp%"
        call :copy.hidden "rEFInd" "%rpath%\EFI\BOOT" >nul 2>&1
exit /b 0

:rEFIndinstaller
    set "title=%_lang0824_%"
    call :colortool
    call :check.systemInfo
    
    :refind
    call :rEFIndinterface
    choice /c ynq /cs /n /m "%_lang0600_% > "
        if errorlevel 3 goto :extra.main
        if errorlevel 2 goto :option.rEFInd
        if errorlevel 1 call :download.rEFInd
    
    :option.rEFInd
    :: preparing file...
    call :extract.rEFInd
    :: make option
    call :colortool
    echo.
    echo ----------------------------------------------------------------------
    echo %_lang0603_%
    echo %_lang0604_%
    echo ----------------------------------------------------------------------
    echo.
    choice /c 12 /cs /n /m "%_lang0605_% [ ? ] > "
        if errorlevel 2 goto :MultibootOS.rEFInd
        if errorlevel 1 goto :MultibootUSB.rEFInd
    
    :MultibootUSB.rEFInd
    if "%installed%"=="false" goto :option.rEFInd
    call :install.rEFInd
    call :clean.bye

    :MultibootOS.rEFInd
    if "%structure%"=="MBR" (
        call :colortool
        echo. & echo %_lang0608_% & timeout /t 15 >nul & goto :option.rEFInd
    )
    echo.
    choice /c yn /cs /n /m "%_lang0609_%"
        if errorlevel 2 goto :option.rEFInd
        if errorlevel 1 echo.
    mountvol S: /d >nul
    mountvol S: /s
    cd /d "%tmp%"
        xcopy "rEFInd" "S:\EFI\rEFInd\" /e /y /q >nul
        xcopy "rEFInd_themes\%rtheme%" "S:\EFI\rEFInd\themes\" /e /y /q >nul
        timeout /t 2 >nul
    mountvol S: /d
    :: Add rEFIndx64.efi to the UEFI NVRAM entries
    call :add.entry "rEFInd Boot Manager" "\EFI\rEFInd\bootx64.efi"
    call :clean.bye
exit /b 0


:add.entry
    echo ^>  Creating %~1 entry to the UEFI NVRAM...
    bcdedit /set "{bootmgr}" path %~2 >nul
    bcdedit /set "{bootmgr}" description %~1 >nul
    echo.
    echo ^>  Use bootice to view/edit the boot entries management
    echo ^>  Choose "UEFI" ^>^> "Edit boot entries"
    cd /d "%bindir%" & bootice
exit /b 0


:check.systemInfo
    for /f "tokens=4 delims=\" %%b in ('wmic os get name') do set "harddisk=%%b"
        if defined harddisk set /a "harddisk=%harddisk:~8,1%"
    for /f "tokens=2" %%b in (
        'wmic path Win32_diskpartition get type ^, diskindex ^| find /i "%harddisk%"'
        ) do set "GPT=%%b"
        if /i "%GPT%" NEQ "GPT:" (
            color 0e & echo. & echo %_lang0001_%
            echo %_lang0002_%
            set structure=MBR
            timeout /t 15 >nul
        )
exit /b 0
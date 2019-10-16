@echo off

rem >> https://niemtin007.blogspot.com
rem >> The batch file is written by niemtin007.
rem >> Thank you for using Multiboot Toolkit.

title %~nx0
cd /d "%~dp0"
set "bindir=%~dp0bin"
set "rtheme=Leather"
set "gtheme=CyberSecurity"
call :check.data
rem >> check device
call :scan.label MULTIBOOT
call :check.author %ducky%
call :check.letter X:

:Select
rem begin preparing file
cd /d "%tmp%"
    if not exist rEFInd_themes (mkdir rEFInd_themes)
call :colortool
    7za x "rEFInd_themes\%rtheme%.7z" -o"%tmp%\rEFInd_themes" -aoa -y > nul
    7za x "refind.7z" -o"%tmp%" -aoa -y > nul
rem list all disk drive
call :list.disk
echo.
set /p disk= %_lang0101_%
set /a disk=%disk%+0
cd /d "%bindir%"
    call :checkdisktype
    if "%virtualdisk%"=="true"  call :rEFInd.part & goto :External
    if "%harddisk%"=="true"     call :harddisk.warning & goto :Select
    if "%usb%"=="true"          call :rEFInd.part & goto :Removable
    if "%externaldisk%"=="true" call :rEFInd.part & goto :External
    color 4f & echo. & echo %_lang0104_% & timeout /t 15 > nul & goto :Select

:Removable
rem >> prepare partitions space for Removable Media
cls
rem need to use bootice to rebuild MBR disk partition. It's important for flash drive.
%bootice% /device=%disk% /partitions /repartition /usb-hdd /fstype=fat32 /quiet
%partassist% /hd:%disk% /del:all
rem >> create rEFInd partition
call :colortool
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
call :colortool
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
call :colortool
%partassist% /hd:%disk% /cre /pri /size:auto /fs:ntfs /act /align /label:MULTIBOOT /letter:X
if not exist "X:\" (
    %partassist% /hd:%disk% /setletter:0 /letter:X
)
goto :extractdata

rem >> prepare partitions space for External hard disk media
:External
call :count.partition
    if not defined part goto :Setup rem the disk is an unallocated
    set /a "part=%part%+0"
    set /a GB=0
    echo.
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
call :colortool
call :count.partition
    if "%part%"=="%deletedpart%" goto :continue rem all partitions were deleted
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
rem >> Create EFI System Partition 1
call :colortool
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
rem >> Create EFI System Partition 2
call :colortool
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
call :colortool
if not "%secureboot%"=="n" (
    set /a offset=%esp%+58
    set /a partition=1
) else (
    set /a offset=%esp%+8
    set /a partition=2
)
call :check.partitiontable
if "%GPT%"=="true" (
    %partassist% /hd:%disk% /cre /pri /size:auto /offset:%offset% /fs:ntfs /act /align /label:MULTIBOOT /letter:X
) else (
    %partassist% /hd:%disk% /cre /pri /size:auto /fs:ntfs /act /align /label:MULTIBOOT /letter:X
)
rem >> Installing Multiboot Data
:recheckmultiboot
call :colortool
if not exist "X:\" (
    call :unhide.partition %partition%
    goto :recheckmultiboot
)
:extractdata
call :scan.label MULTIBOOT
cd /d "%bindir%"
    if "%ducky%"=="X:" (
        7za x "data.7z" -o"X:\" -aoa -y
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
    if "%GPT%"=="true" (
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
cd /d "%bindir%"
    7za x "wincdemu.7z" -o"X:\ISO\" -aoa -y >nul
rem >> install Syslinux Bootloader
cd /d "%bindir%"
    syslinux --force --directory /BOOT/syslinux X: X:\BOOT\syslinux\syslinux.bin
rem >> install grub2 Bootloader
call :colortool
    if "%GPT%"=="true" call :gdisk
    echo.
    echo %_lang0116_%
    silentcmd grub2installer.bat MULTIBOOT
cd /d "%bindir%\extra-modules"
    "%bindir%\7za.exe" x "grub2-filemanager.7z" -o"X:\BOOT\grub\" -aoa -y > nul
    >"%ducky%\BOOT\grub\lang.sh" (echo export lang=%langfm%;)
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
call :colortool
set "source=%bindir%\secureboot"
rem > for USB
if "%usb%"=="true" if "%secureboot%"=="n" (
    >"X:\BOOT\secureboot" (echo n)
    cd /d "%tmp%\rEfind_themes\%rtheme%\icons"
        xcopy "others" "X:\EFI\BOOT\" /e /g /h /r /y /q > nul
    cd /d "%bindir%"
        xcopy "secureboot" "X:\" /e /g /h /r /y /q > nul
    %partassist% /hd:%disk% /setletter:0 /letter:auto
    call :clean.bye
)
if "%usb%"=="true" if "%secureboot%"=="y" (
    %partassist% /hd:%disk% /whide:1 /src:%source%
    %partassist% /hd:%disk% /setletter:0 /letter:auto
)
rem > for HDD/SSD
if "%GPT%"=="true" (set mpart=3) else (set mpart=2)
if not "%usb%"=="true" if "%secureboot%"=="y" (
    %partassist% /hd:%disk% /whide:0 /src:%source%
    %partassist% /hd:%disk% /setletter:%mpart% /letter:auto
)
if "%GPT%"=="true" (set mpart=2) else (set mpart=1)
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
call :clean.bye



rem >> begin functions
:check.data
    if not exist "bin" (
        color 4f & echo.
        echo ^>^> Warning: Data Loss
        timeout /t 15 > nul & exit
    ) else (
        call :permissions
        call :license
    )
exit /b 0

:permissions
    call :colortool
    
    ver | findstr /i "6\.1\." > nul
        if %errorlevel% equ 0 set "windows=7"
        if not "%windows%"=="7" chcp 65001 > nul
    
    set randname=%random%%random%%random%%random%%random%
    md "%windir%\%randname%" 2>nul
    if %errorlevel%==0 goto :permissions.end
    if %errorlevel%==1 (
        echo.& echo ^>^> Please use right click - Run as administrator
        color 4f & timeout /t 15 >nul
        Set admin=fail
        goto permissions.end
    )
    goto :permissions
    
    :permissions.end
    rd "%windir%\%randname%" 2>nul
    if "%admin%"=="fail" exit
exit /b 0

:license
call :colortool
for /f "tokens=*" %%b in (version) do set /a "cur_version=%%b"
    set /a cur_a=%cur_version:~0,1%
    set /a cur_b=%cur_version:~1,1%
    set /a cur_c=%cur_version:~2,1%
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
    echo ^  License:
    echo ^  Multiboot Toolkit is the open-source software. It's released under
    echo ^  General Public Licence ^(GPL^). You can use, modify and redistribute
    echo ^  if you wish. You can download from my blog niemtin007.blogspot.com
    echo.
    echo ^  ------------------------------------------------------------------
    echo ^  Thanks to Ha Son, Tayfun Akkoyun, anhdv, lethimaivi, Hoang Duch2..
    echo ^  ------------------------------------------------------------------
    if exist "%systemroot%\SysWOW64\Speech\SpeechUX\sapi.cpl" start welcome.vbs
    echo.
    echo ^  [ 1 ] = English  [ 2 ] = Vietnam  [ 3 ] = Turkish  [ 4 ] = Chinese
    echo.
    choice /c 1234a /cs /n /m "> Choose a default language [ ? ] = "
        if errorlevel 1 set "lang=English"
        if errorlevel 2 set "lang=Vietnam"
        if errorlevel 3 set "lang=Turkish"
        if errorlevel 4 set "lang=SimplifiedChinese"
        if errorlevel 5 set "lang=autodetect"
    taskkill /f /im wscript.exe /t /fi "status eq running">nul
    del /s /q welcome.vbs >nul
    call :colortool
    call language.bat
    call :partassist.init
exit /b 0

:partassist.init
    cls
    echo.
    cd /d "%bindir%"
        echo ^>^> Loading, Please wait...
        7za x "partassist.7z" -o"%tmp%" -aos -y > nul
        set partassist="%tmp%\partassist\partassist.exe"
        set bootice="%bindir%\bootice.exe"
    cd /d "%tmp%\partassist"
        if "%processor_architecture%"=="x86" (
            SetupGreen32 -i > nul
            LoadDrv_Win32 -i > nul
        ) else (
            SetupGreen64 -i > nul
            LoadDrv_x64 -i > nul
        )
    >"%tmp%\partassist\cfg.ini" (
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
    > "%tmp%\partassist\winpeshl.ini" (
        echo [LaunchApp]
        echo AppPath=%tmp%\partassist\PartAssist.exe
    )
    cls
exit /b 0

:colortool
    cls
    mode con lines=18 cols=70
    cd /d "%bindir%"
        set /a num=%random% %%105 +1
        set "itermcolors=%num%.itermcolors"
        if "%color%"=="true" goto :skipcheck.color
        7za x "colortool.7z" -o"%tmp%" -aos -y > nul
    rem Check for DotNet 4.0 Install
    cd /d "%tmp%\colortool"
        set "checkdotnet=%temp%\Output.log"
        reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP" /s | find "v4" > %checkdotnet%
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

:list.disk
setlocal
    rem find the last disk
    for /f "tokens=2" %%b in ('echo list disk ^| diskpart ^| find /i "Disk"') do (
        set /a disk=%%b
    )
    rem check USB GPT
    echo.
    echo Loading, please wait...
    cd /d "%bindir%"
        call :checkdisktype
        if "%usb%"=="true" call :check.partitiontable
    rem list disk
    cls & %partassist% /list
    if "%usb%"=="true" if "%GPT%"=="true" (
        if "%diskunit%"=="GB" echo   %disk%     ^| %disksize% %diskunit%         ^| %model% GPT
        if "%diskunit%"=="MB" echo   %disk%     ^| %disksize% %diskunit%       ^| %model% GPT
    )
endlocal
exit /b 0

:checkdisktype
    :: reset all disk variable
    set "virtualdisk=false"
    set "harddisk=false"
    set "usb=false"
    set "externaldisk=false"
    :: check.virtualdisk
    wmic diskdrive get name, model | find /i "Msft Virtual Disk SCSI Disk Device" | find /i "\\.\physicaldrive%disk%" > nul
        if not errorlevel 1 set "virtualdisk=true"
    wmic diskdrive get name, model | find /i "Microsoft Virtual Disk" | find /i "\\.\physicaldrive%disk%" > nul
        if not errorlevel 1 set "virtualdisk=true"
    wmic diskdrive get name, model | find /i "Microsoft Sanal Diski" | find /i "\\.\physicaldrive%disk%" > nul
        if not errorlevel 1 set "virtualdisk=true"
    :: check.harddisk
    wmic diskdrive get name, mediatype | find /i "Fixed hard disk media" | find /i "\\.\physicaldrive%disk%" > nul
        if not errorlevel 1 set "harddisk=true"
    :: check.usbdisk
    wmic diskdrive get name, mediatype | find /i "Removable Media" | find /i "\\.\physicaldrive%disk%" > nul
        if not errorlevel 1 set "usb=true"
    :: check.externaldisk
    wmic diskdrive get name, mediatype | find /i "External hard disk media" | find /i "\\.\physicaldrive%disk%" > nul
        if not errorlevel 1 set "externaldisk=true"
exit /b 0

:check.partitiontable
    set GPT=false
    for /f "tokens=4,5,8" %%b in ('echo list disk ^| diskpart ^| find /i "Disk %disk%"') do (
        set /a disksize=%%b
        set    diskunit=%%c
        if /i "%%d"=="*" set GPT=true
    )
    for /f "tokens=1 delims=\\.\" %%b in ('wmic diskdrive list brief ^| find /i "physicaldrive%disk%"') do set "model=%%b"
exit /b 0

:harddisk.warning
    echo. & echo. & echo %_lang0102_%
    color 4f & echo %_lang0103_% & timeout /t 15 > nul & cls
exit /b 0

:check.letter
for /f "tokens=2 delims= " %%b in ('wmic path win32_logicaldisktopartition get antecedent^, dependent ^| find /i "%~1"') do set "disk=%%b"
    if not defined disk set "match=false"
    set "disk=%disk:~1,1%"
    set /a disk=%disk%+0
wmic diskdrive get name, model, interfacetype, mediatype | find /i "\\.\physicaldrive%disk%" | find /i "Fixed hard disk media" > nul
    if "%errorlevel%"=="0" (
        if exist "X:\" (
            setlocal
                set "skip=false"
                call :assignletter.diskpart
            endlocal
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
    call :colortool
    echo.
    echo %_lang0123_%
    for %%p in (z y x w v u t s r q p o n m l k j i h g f e d) do (
        if not exist %%p:\nul set letter=%%p
    )
    for /f "tokens=2 delims= " %%b in ('echo list volume ^| diskpart ^| find /i "    X  "') do set "volume=%%b"
    (
        echo select volume %volume%
        echo assign letter=%letter%
    ) | diskpart > nul
    cd /d "%~dp0"
        if "%skip%"=="false" call "[ 01 ] Install Multiboot.bat"
exit /b 0

:gdisk
cd /d "%bindir%"
    7za x "gdisk.7z" -o"%tmp%" -aos -y > nul
    if "%processor_architecture%"=="x86" (
        set gdisk=gdisk32.exe
    ) else (
        set gdisk=gdisk64.exe
    )
cd /d "%tmp%\gdisk"
    (
        echo n
        echo.
        echo.
        echo.
        echo ef02
        echo w
        echo y
    ) | %gdisk% \\.\physicaldrive%disk% > nul
    cls
    echo.
    echo %_lang0117_%
cd /d "%bindir%"
    timeout /t 1 > nul
exit /b 0

:rEFInd.part
    if "%usb%"=="true" (
        color 0e
        echo.
        echo --------------------------------------------------------------------
        echo %_lang0118_%
        echo %_lang0119_%
        echo --------------------------------------------------------------------
        echo.
        choice /c yn /cs /n /m "%_lang0120_%"
            if errorlevel 2 goto :rEFInd.ask
            if errorlevel 1 call :createusb.gpt
    )
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
    choice /c yn /cs /n /m "%_lang0115_%"
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

:createusb.gpt
    set ducky=X:
    rem > create multiboot data partition
    echo.
    echo %_lang0121_%
    (
        echo select disk %disk%
        echo clean
        echo convert gpt
        echo create partition primary size=50
        echo format quick fs=fat label="ESP"
        echo assign letter=X
        echo exit
    ) | diskpart > nul
    cd /d "X:\"
        mkdir "X:\EFI\BOOT\themes\"
        >"X:\EFI\BOOT\mark" (echo niemtin007)
    cd /d "%tmp%"
        xcopy "rEfind" "X:\EFI\BOOT\" /e /g /h /r /y /q > nul
    cd /d "%tmp%\rEfind_themes"
        xcopy "%rtheme%" "X:\EFI\BOOT\themes\" /e /g /h /r /y /q > nul
    (
        echo select volume X
        echo remove letter X
        echo exit
    ) | diskpart > nul
    (
        echo select disk %disk%
        echo create partition primary
        echo format quick fs=ntfs label="MULTIBOOT"
        echo assign letter=X
        echo exit
    ) | diskpart > nul
    rem > installing data
    cd /d "X:\"
        for %%b in (APPS BOOT\grub\themes EFI\BOOT WIM) do mkdir %%b
        >"BOOT\lang" (echo %lang%)
        >"EFI\BOOT\mark" (echo niemtin007)
        >"BOOT\grub\themes\theme" (echo %gtheme%)
        >"EFI\BOOT\usb.gpt" (echo USB GPT Bootable Disk)
    echo.
    echo %_lang0122_%
    cd /d "%bindir%"
        xcopy "secureboot" "X:\" /e /g /h /r /y /q > nul
        set "file=Autorun.inf usb.ico B64 XORBOOT icons fonts"
        set "efi=winsetupia32.efi winsetupx64.efi xorbootx64.efi"
        7za x "data.7z" -o"X:\" %file% %efi% -r > nul
    echo.
    echo %_lang0116_%
    cd /d "%bindir%"
        silentcmd grub2installer.bat MULTIBOOT
    cd /d "%bindir%\extra-modules"
        "%bindir%\7za.exe" x "grub2-filemanager.7z" -o"X:\BOOT\grub\" -aoa -y > nul
        >"%ducky%\BOOT\grub\lang.sh" (echo export lang=%langfm%;)
    cd /d "%bindir%"
        echo.
        echo %_lang0112_% %lang%
        7za x "%bindir%\config\%lang%.7z" -o"%ducky%\" -aoa -y > nul
    cd /d "%bindir%"
        echo.
        echo %_lang0113_% %gtheme%
        7za x "%bindir%\grub2_themes\%gtheme%.7z" -o"X:\BOOT\grub\themes\" -aoa -y > nul
    cd /d "%bindir%\config"
        call "main.bat"
    cd /d "X:\EFI\Microsoft\Boot"
        call "%bindir%\bcdautoset.bat" bcd
    cd /d "%tmp%\rEfind_themes\%rtheme%\icons"
        copy "grubx64.png" "X:\EFI\BOOT\grubx64.png" > nul
        copy "grubx64.png" "X:\EFI\BOOT\grubia32.png" > nul
        copy "winsetupx64.png" "X:\EFI\BOOT\winsetupx64.png" > nul
        copy "winsetupx64.png" "X:\EFI\BOOT\winsetupia32.png" > nul
        copy "xorbootx64.png" "X:\EFI\BOOT\xorbootx64.png" > nul
    cd /d "%tmp%\rEfind_themes\%rtheme%\icons"
        xcopy "others" "X:\EFI\BOOT\" /e /g /h /r /y /q > nul
        call :assignletter.diskpart
    (
        echo select disk %disk%
        echo select partition 1
        echo gpt attributes=0x4000000000000000
        echo exit
    ) | diskpart > nul
        call :clean.bye
exit /b 0

:clean.bye
call :colortool
for /f "delims=" %%f in (hide.list) do (
    if exist "%ducky%\%%f" (attrib +s +h "%ducky%\%%f")
    if exist "%ducky%\ISO\%%f" (attrib +s +h "%ducky%\ISO\%%f")
    if exist "%ducky%\WIM\%%f" (attrib +s +h "%ducky%\WIM\%%f")
)
cd /d "%tmp%\partassist"
    if "%processor_architecture%"=="x86" (
        SetupGreen32 -u > nul
        LoadDrv_Win32 -u > nul
    ) else (
        SetupGreen64 -u > nul
        LoadDrv_x64 -u > nul
    )
cd /d "%tmp%"
    rem >> clean up the trash and exit
    set "dlist=colortool curl driveprotect gdisk grub2 partassist rEFInd rEFInd_themes"
    for %%d in (%dlist%) do (
        if exist "%%d" rmdir "%%d" /s /q > nul
    )
    set "flist=hide.vbs Output.log qemuboottester.exe SilentCMD.log wincdemu.exe wget.exe"
    for %%f in (%flist%) do (
        if exist "%%f" del "%%f" /s /q > nul
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
    if exist "%systemroot%\SysWOW64\Speech\SpeechUX\sapi.cpl" start thanks.vbs
    timeout /t 3 >nul
    del /s /q thanks.vbs >nul
    exit
exit /b 0

rem >> end functions

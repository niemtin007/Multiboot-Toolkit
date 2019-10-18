@echo off

rem >> https://niemtin007.blogspot.com
rem >> The batch file is written by niemtin007.
rem >> Thank you for using Multiboot Toolkit.

title %~nx0
cd /d "%~dp0"
set "bindir=%~dp0bin"
set "curpath=%~dp0Modules"
if not exist "bin" (
    color 4f & echo.
    echo ^>^> Warning: Data Loss
    timeout /t 15 > nul & exit
) else (
    call :permissions
    call :multibootscan
)

:main
> "%tmp%\modules.vbs" (
    echo Dim Message, Speak
    echo Set Speak=CreateObject^("sapi.spvoice"^)
    echo Speak.Speak "Please put all modules you need into the Modules folder. Then press any key to continue..."
)
rem begin move module to the source folder
if exist "%bindir%\Special_ISO" (
    cd /d "%bindir%\Special_ISO"
        if exist "*.iso" (move /y "*.iso" "%curpath%" > nul)
)
if exist "%bindir%\ISO_Extract" (
    cd /d "%bindir%\ISO_Extract"
        if exist "*.iso" (move /y "*.iso" "%curpath%" > nul)
)
rem end move module to the source folder
if not exist "%~dp0Modules" (mkdir "%~dp0Modules")

call :check.letter X:

if "%installmodules%"=="y" (
    call :check.empty
    goto :continue
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
echo %_lang0202_%
cd /d "%tmp%"
    if exist "%systemroot%\SysWOW64\Speech\SpeechUX\sapi.cpl" start modules.vbs
    echo %_lang0203_% & timeout /t 300 > nul
    taskkill /f /im wscript.exe /t /fi "status eq running">nul
    del /s /q modules.vbs >nul
    call :check.empty

:continue
cd /d "%ducky%\BOOT"
    if not exist "secureboot" set "secureboot=n" & goto :progress
    for /f "tokens=*" %%b in (secureboot) do set "secureboot=%%b"

:progress
cd /d "%bindir%"
    if not exist Special_ISO (mkdir Special_ISO)
    if not exist ISO_Extract (mkdir ISO_Extract)

rem >> create all modules namelist
if not exist "%ducky%\BOOT\namelist\temp" mkdir "%ducky%\BOOT\namelist\temp"
for /f "tokens=*" %%i in ('dir /a:-d /b "%curpath%"') do (>"%ducky%\BOOT\namelist\temp\%%~ni" (echo %%i))
rem >> rename all modules namelist
cd /d "%bindir%"
    for /f "delims=" %%f in (iso.list, iso_extract.list, specialiso.list, wim.list) do (
        cd /d "%ducky%\BOOT\namelist\temp"
            if exist "*%%f*" (rename "*%%f*" "%%f" > nul)
        cd /d "%bindir%"
    )
rem >> move all iso to temp folder
cd /d "%bindir%"
    for /f "delims=" %%f in (iso_extract.list) do (
        cd /d "%curpath%"
            if exist "*%%f*.iso" (move /y "*%%f*.iso" "%bindir%\ISO_Extract" > nul)
        cd /d "%bindir%"
    )
cd /d "%bindir%"
    for /f "delims=" %%f in (specialiso.list) do (
        cd /d "%curpath%"
            if exist "*%%f*" (move /y "*%%f*" "%bindir%\Special_ISO" > nul)
        cd /d "%bindir%"
    )

rem check iso extract type 
cd /d "%bindir%\ISO_Extract"
    for /f "delims=" %%f in (%bindir%\iso_extract.list) do (
            if exist "*%%f*.iso" goto :extract
    )
    goto :specialiso
:extract
cd /d "%bindir%"
    7za x "wincdemu.7z" -o"%tmp%" -aoa -y >nul
cd /d "%tmp%"
    wincdemu /install
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
cd /d "%tmp%"
    wincdemu /uninstall

:specialiso
rem disabled iso linux run on fat32 partition (hidden partition)
if exist "%ducky%\EFI\BOOT\usb.gpt" goto :populariso
rem check special iso type 
cd /d "%bindir%\Special_ISO"
    for /f "delims=" %%f in (%bindir%\specialiso.list) do (
        if exist "*%%f*.iso" goto :specialiso-go
    )
    goto :populariso
:specialiso-go
cd /d "%ducky%\BOOT"
    for /f "tokens=*" %%b in (esp) do set "esp=%%b"
    set /a "esp=%esp%+0"
    set /a "size=0"
    if exist secureboot (
        for /f "tokens=*" %%b in (secureboot) do set "secureboot=%%b"
    )
    if "%secureboot%"=="n" (set rpart=0) else (set rpart=1)
call :colortool
    for /f "tokens=*" %%x in ('dir /s /a /b "Special_ISO"') do set /a "size+=%%~zx"
    set /a "size=%size%/1024/1024"
    set "source=%bindir%\Special_ISO"

call :check.letter %ducky% rem get disk number of Multiboot data partition

if %size% LEQ %esp% (
    if exist "%bindir%\Special_ISO\*.iso" (
        cls & echo. & echo %_lang0204_%
        timeout /t 2 > nul
        %partassist% /hd:%disk% /whide:%rpart% /src:%source% /dest:ISO
        timeout /t 3 > nul
    )
) else (
    cls & color 4f & echo. & echo %_lang0205_%
    echo ----------------------------------------------------------------------
    echo %_lang0206_%
    echo %_lang0207_%
    echo %_lang0208_%
    echo ----------------------------------------------------------------------
    timeout /t 15 > nul
)

:populariso
rem >> copy all ISO to multiboot
call :colortool
echo.
echo %_lang0209_%
for /f "delims=" %%f in (iso.list) do (
    if not exist "%ducky%\ISO\*%%f*.iso" (
        if exist "%curpath%\*%%f*.iso" (
            robocopy "%curpath%" "%ducky%\ISO" *%%f*.iso /njh /njs /nc /ns
        )
    )
)

rem >> copy Kaspersky Rescue Disk 18 to multiboot
call :colortool
if exist "%curpath%\krd.iso" (
    if not exist "%ducky%\DATA\krd.iso" (
        echo.
        echo ^> Kaspersky Rescue Disk 18 Module is being copied, please wait...
        robocopy "%curpath%" "%ducky%\DATA" krd.iso /njh /njs /nc /ns
    )
)

:wimmodules
rem >> copy all *.wim module on multiboot
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
rem >> rename and move all *.wim to the destination
cd /d "%ducky%\WIM"
    if exist *w*8*1*.wim (
        move /y *w*8*1*.wim WIM
        cd /d "%ducky%\WIM"
            rename *w*8*1*64* w8.1se64.wim
            rename *w*8*1*32* w8.1se32.wim
            rename *w*8*1*86* w8.1se32.wim
        cd /d "%ducky%"
    )
    rem rename winpe
    if exist *w*10*64* (rename *w*10*64* w10pe64.wim)
    if exist *w*10*32* (rename *w*10*32* w10pe32.wim)
    if exist *w*10*86* (rename *w*10*86* w10pe32.wim)
    if exist *w*8*64* (rename *w*8*64* w8pe64.wim)
    if exist *w*8*32* (rename *w*8*32* w8pe32.wim)
    if exist *w*8*86* (rename *w*8*86* w8pe32.wim)
    if exist *w*7*32* (rename *w*7*32* w7pe32.wim)
    if exist *xp* (rename *xp* XP.wim)
    rem renameame apps & tools for winpe
    if exist *dr*v*.wim (move /y *drv*.wim %ducky%\APPS > nul)
    if exist *dr*v*.iso (move /y *drv*.iso %ducky%\APPS > nul)
    if exist *app*.wim (move /y *app*.wim %ducky%\APPS > nul)
    if exist *app*.iso (move /y *app*.iso %ducky%\APPS > nul)
    if exist *tool*.wim (move /y *tool*.wim %ducky%\APPS > nul)
    if exist *tool*.iso (move /y *tool*.iso %ducky%\APPS > nul)

rem >> Install Wim Sources Module
if not exist "%ducky%\WIM\bootx64.wim" if not exist "%ducky%\WIM\bootx86.wim" (
    if exist "%~dp0Modules\*Wim*Sources*Module*.7z" (
        cls & echo. & echo %_lang0213_%
        "%bindir%\7za.exe" x "%~dp0Modules\*Wim*Sources*Module*.7z" -o"%ducky%\" -aoa -y > nul
    )
)
rem >> Windows install.wim module (wim method)
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
                    copy "%%i:\sources\install.wim" "%ducky%\Sources\" > nul
                    cd /d "%ducky%\Sources\"
                    rename install.wim install%%~nj8664.wim
                    echo %_lang0217_%
                ) else (
                    echo ^     ^>^> Your Windows %%j doesn't need to install again
                )
            )
        )
    )
)
endlocal & cls

rem >> Windows Install ISO Module (ISO method)
cd /d "%ducky%\WIM"
    if not exist "bootisox64.wim" if not exist "bootisox86.wim" (
    cd /d "%curpath%"
        if exist "*WinSetup*ISO*Module*.7z" (
            cls & echo. & echo %_lang0218_%
            "%bindir%\7za.exe" x "*WinSetup*ISO*Module*.7z" -o"%ducky%\WIM\" -aoa -y
        )
    )

rem >> Install Grub2 File Manager
call :colortool
    set "list=grubfmia32.efi grubfmx64.efi"
    if exist "%curpath%\grubfm-*.7z" (
        cls & echo. & echo %_lang0224_%
        7za x "%curpath%\grubfm-*.7z" -o"%ducky%\EFI\Boot\" %list% -r -y >nul
    )
)

rem >> copy all *.exe module on multiboot
cd /d "%curpath%"
    if exist "*portable.*" (
        cls & echo. & echo %_lang0219_%
        "%bindir%\7za.exe" x "*portable.*" -o"%ducky%\PortableApps\" -aoa -y > nul
    )
rem >> return iso file to modules folder
cd /d "%bindir%"
    if exist "ISO_Extract\*.iso" (move /y "ISO_Extract\*.iso" "%curpath%" > nul)
    if exist "Special_ISO\*.iso" (move /y "Special_ISO\*.iso" "%curpath%" > nul)

for /f "tokens=*" %%i in ('dir /s /a /b "%ducky%\BOOT\namelist\temp"') do set /a tsize+=%%~zi
    if defined tsize (move /y "%ducky%\BOOT\namelist\temp\*.*" "%ducky%\BOOT\namelist\" > nul)
    rd /s /q "%ducky%\BOOT\namelist\temp"

rem >> update config for Grub2
if not exist "%ducky%\EFI\BOOT\usb.gpt" (
    cd /d "%ducky%\BOOT"
        for /f "tokens=*" %%b in (lang) do set "lang=%%b"
    cd /d "%ducky%\BOOT\grub\themes"
        for /f "tokens=*" %%b in (theme) do set "gtheme=%%b"
    cd /d "%bindir%\config"
        call "main.bat"
)

cd /d "%bindir%"
    rd /s /q Special_ISO > nul
    rd /s /q ISO_Extract > nul

rem >> unhide the Multiboot Partition
call :check.partitiontable
    if not "%GPT%"=="true" (
        if "%secureboot%"=="n" (set /a "partition=1") else (set /a "partition=2")
    ) else (
        if "%secureboot%"=="n" (set /a "partition=2") else (set /a "partition=3")
    )
call :scan.label MULTIBOOT
    if "%offline%"=="true" (
        %partassist% /hd:%disk% /unhide:%partition%
        %partassist% /hd:%disk% /setletter:%partition% /letter:auto
    )

call :clean.bye





rem >> begin functions

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

:multibootscan
    > "%tmp%\identify.vbs" (
        echo Dim Message, Speak
        echo Set Speak=CreateObject^("sapi.spvoice"^)
        echo Speak.Speak "Multiboot Drive Found"
    )
    :while.scan
    for /f %%b in ('wmic volume get driveletter^, label ^| findstr /i "MULTIBOOT"') do set "ducky=%%b"
        if not exist "%ducky%\EFI\BOOT\mark" goto :progress.scan
        for /f "tokens=*" %%b in (%ducky%\EFI\BOOT\mark) do set "author=%%b"
        if not defined author (
            set "offline=0"
            goto :progress.scan
        ) else (
            cd /d "%tmp%"
            if exist "%systemroot%\SysWOW64\Speech\SpeechUX\sapi.cpl" start identify.vbs
            cls & echo. & echo ^>^> Multiboot Drive Found ^^^^ & timeout /t 2 >nul
            goto :break.scan
        )
        :progress.scan
            if "%skipscan%"=="true" set "offline=1" & goto :EOF
            cls & echo ^> Connecting   & timeout /t 1 >nul
            cls & echo ^> Connecting.  & timeout /t 1 >nul
            cls & echo ^> Connecting.. & timeout /t 1 >nul
            cls & echo ^> Connecting...& timeout /t 1 >nul
        goto :while.scan
    :break.scan
    if not "%author%"=="niemtin007" (
        cls & color 4f & echo.
        echo ^>^> Run [ 01 ] Install Multiboot.bat to reinstall & timeout /t 15 >nul & exit
    )
    for /f "tokens=2 delims= " %%b in ('wmic path win32_logicaldisktopartition get antecedent^, dependent ^| find "%ducky%"') do set "disk=%%b"
        set "disk=%disk:~1,1%"
        set /a disk=%disk%+0
    for /f "tokens=3 delims=#" %%b in ('wmic partition get name ^| findstr /i "#%disk%,"') do set "partition=%%b"
        set /a partition=%partition%+0
        del /s /q "%tmp%\identify.vbs" >nul
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

:check.letter
for /f "tokens=2 delims= " %%b in ('wmic path win32_logicaldisktopartition get antecedent^, dependent ^| find /i "%~1"') do set "disk=%%b"
    if not defined disk set "match=false"
    set "disk=%disk:~1,1%"
    set /a disk=%disk%+0
    if exist "X:\" call :assignletter.diskpart
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
        call "[ 02 ] Install Modules.bat"
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
        if errorlevel 2 goto :main
        if errorlevel 1 start https://docs.google.com/spreadsheets/d/1HzW6t3Rh_8_BnT8Ddawe1epwrMdVzvmRAjtN3qX-G9k/edit?usp=sharing & exit
    )
    cd /d "%bindir%"
        set "module=false"
        for /f "delims=" %%f in (iso.list, iso_extract.list, specialiso.list, wim.list) do (
            cd /d "%curpath%"
                if exist "*%%f*" set "module=true"
            cd /d "%bindir%"
        )
        if "%module%"=="false" (
            cls & echo.
            echo %_lang0222_%
            pause > nul
            goto :main
        )
endlocal
exit /b 0

:iso.extract
    if exist "%~1" if not exist "%ducky%\ISO_Extract\%~2\*.*" (
        set "modulename=%~2"
        for /f "tokens=*" %%b in (%~1) do set "isopath=%bindir%\ISO_Extract\%%b"
        call :iso.mount & goto :extract
    )
exit /b 0

:iso.mount
call :colortool
cd /d "%tmp%"
    wincdemu "%isopath%" X: /wait
    cls
    echo.
    echo ^>^> %modulename% %_lang0015_%
    echo.
    cd /d "X:\"
        if "%modulename%"=="AOMEI-Backup" (
            copy "sources\boot.wim" "%ducky%\WIM\aomeibackup.wim" /y > nul
            mkdir "%ducky%\ISO_Extract\%modulename%\"
            >"%ducky%\ISO_Extract\%modulename%\Author.txt" (echo AOMEI)
            goto :iso.unmount
        )
        if "%modulename%"=="anhdvPE" (
            rem xcopy "APPS" "%ducky%\APPS\" /e /g /h /r /y
            robocopy "X:\APPS" "%ducky%\APPS" /njh /njs /nc /ns
            rem xcopy "WIM" "%ducky%\WIM\" /e /g /h /r /y
            robocopy "X:\WIM" "%ducky%\WIM" /njh /njs /nc /ns
            mkdir "%ducky%\ISO_Extract\%modulename%\"
            >"%ducky%\ISO_Extract\%modulename%\Author.txt" (echo Dang Van Anh)
            goto :iso.unmount
        )
        if "%modulename%"=="Bob.Ombs.Win10PEx64" (
            copy "sources\boot.wim" "%ducky%\WIM\BobW10PE.wim" /y > nul
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
            copy "sources\boot.wim" "%ducky%\WIM\hbcdpe.wim" /y > nul
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
            if exist "X:\%%f" (
                xcopy /s "X:\%%f" "%ducky%\ISO_Extract\%modulename%\"
            )
        )
:iso.unmount
cd /d "%tmp%"
    wincdemu /unmount X:
    cls
exit /b 0

:PortableAppsPlatform
    echo.
    choice /c yn /cs /n /m "%_lang0223_%"
        if errorlevel 1 set "portable=true"
        if errorlevel 2 set "portable=false"
        if "%portable%"=="true" (
            cd /d "%bindir%"
                7za x "PortableApps.7z" -o"%ducky%\" -aoa -y > nul
                echo %_lang0012_%
                timeout /t 2 > nul
        )
exit /b 0

:check.partitiontable
    set GPT=false
    for /f "tokens=8" %%b in ('echo list disk ^| diskpart ^| find /i "Disk %disk%"') do (
        if /i "%%b"=="*" set GPT=true
    )
exit /b 0

:scan.label
for /f %%b in ('wmic volume get driveletter^, label ^| findstr /i "%~1"') do set "ducky=%%b"
    if not defined ducky set "offline=true"
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

rem >> end function

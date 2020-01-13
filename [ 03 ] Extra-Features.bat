@echo off

:: https://niemtin007.blogspot.com
:: The batch file is written by niemtin007.
:: Thank you for using Multiboot Toolkit.

cd /d "%~dp0"
set "skipscan=true"
set "curdir=%~dp0"
set "bindir=%~dp0bin"
if not exist "bin" (
    color 4f & echo.
    echo ^>^> Warning: Data Loss
    timeout /t 15 >nul & exit
) else (
    call :permissions
    call :multibootscan
    call :gather.info
)

:main
call :colortool
echo.
echo =====================================================================
echo %_lang0819_%
echo =====================================================================
echo  [ 01 ] = %_lang0821_% [ 09 ] = %_lang0829_%
echo  [ 02 ] = %_lang0822_% [ 10 ] = %_lang0830_%
echo  [ 03 ] = %_lang0823_% [ 11 ] = %_lang0831_%
echo  [ 04 ] = %_lang0824_% [ 12 ] = %_lang0832_%
echo  [ 05 ] = %_lang0825_% [ 13 ] = %_lang0833_%
echo  [ 06 ] = %_lang0826_% [ 14 ] = %_lang0834_%
echo  [ 07 ] = %_lang0827_% [ 15 ] = %_lang0835_%
echo  [ 08 ] = %_lang0828_% [ 16 ] = %_lang0836_%
echo =====================================================================
echo.
:: set default
set "option=14"
set /p option= %_lang0905_%

if exist "%ducky%\EFI\Boot\usb.gpt" goto :usb.gpt
if "%installed%"=="true"  goto :online
if "%installed%"=="false" goto :offline

:online
if "%option%"=="1"  call :grub2theme
if "%option%"=="2"  call :rEFIndtheme
if "%option%"=="3"  call :cloverinstaller
if "%option%"=="4"  call :rEFIndInstaller
if "%option%"=="5"  call :setdefaultboot
if "%option%"=="6"  call :editWinPEbootmanager
if "%option%"=="7"  call :editwinsetupfromUSB
if "%option%"=="8"  call :grub2-filemanager
if "%option%"=="9"  call :fixbootloader
if "%option%"=="10" call :unhidedatapartition
if "%option%"=="11" call :easeconvertdisk
if "%option%"=="12" call :NTFSdriveprotect
if "%option%"=="13" call :changelanguage
if "%option%"=="14" call :qemuboottester
if "%option%"=="15" call :updatemultiboot
if "%option%"=="16" call :sortgrub2menu
color 0e & echo. & echo %_lang0003_% & timeout /t 15 >nul & goto :main

:Offline
if "%option%"=="3"  call :cloverinstaller
if "%option%"=="4"  call :rEFIndInstaller
if "%option%"=="8"  call :grub2-filemanager
if "%option%"=="10" call :unhidedatapartition
if "%option%"=="11" call :easeconvertdisk
if "%option%"=="14" call :qemuboottester
color 0e & echo. & echo %_lang0003_% & timeout /t 15 >nul & goto :main

:usb.gpt
if "%option%"=="1"  call :grub2theme
if "%option%"=="6"  call :editWinPEbootmanager
if "%option%"=="7"  call :editwinsetupfromUSB
if "%option%"=="8"  call :grub2-filemanager
if "%option%"=="9"  call :fixbootloader
if "%option%"=="12" call :NTFSdriveprotect
if "%option%"=="13" call :changelanguage
if "%option%"=="14" call :qemuboottester
if "%option%"=="16" call :sortgrub2menu
color 0e & echo. & echo %_lang0003_% & timeout /t 15 >nul & goto :main





:: begin functions
:permissions
    call :colortool
    
    ver | findstr /i "6\.1\." >nul
        if %errorlevel% equ 0 set "windows=7"
        if not "%windows%"=="7" chcp 65001 >nul
    
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
    call :colortool
    call language.bat
    call :scan.label MULTIBOOT
    call :check.author %ducky%
        if "%installed%"=="true" (
            set /a disk=%diskscan%
            goto :break.scan
        ) else (
            goto :progress.scan
        )
    :progress.scan
        if "%skipscan%"=="true"     goto :offline.scan
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
        if exist "%systemroot%\SysWOW64\Speech\SpeechUX\sapi.cpl" start identify.vbs
    call :colortool
        echo. & echo ^>^> Multiboot Drive Found ^^^^
        timeout /t 2 >nul
    :: get disk number from drive label
        del /s /q "%tmp%\identify.vbs" >nul
    :offline.scan
    call :partassist.init
exit /b 0

:partassist.init
    cls
    echo.
    cd /d "%bindir%"
        echo ^>^> Loading, Please wait...
        7za x "partassist.7z" -o"%tmp%" -aos -y >nul
        set partassist="%tmp%\partassist\partassist.exe"
        set bootice="%bindir%\bootice.exe"
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

:colortool
    cls
    cd /d "%bindir%"
        set /a num=%random% %%105 +1
        set "itermcolors=%num%.itermcolors"
        if "%color%"=="true" goto :skipcheck.color
        7za x "colortool.7z" -o"%tmp%" -aos -y >nul
        :: get Multiboot Toolkit Version
        for /f "tokens=*" %%b in (version) do set /a "cur_version=%%b"
            set /a cur_a=%cur_version:~0,1%
            set /a cur_b=%cur_version:~1,1%
            set /a cur_c=%cur_version:~2,1%
    :: Check for DotNet 4.0 Install
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
    title Multiboot Toolkit %cur_a%.%cur_b%.%cur_c% - Extra Features
exit /b 0

:check.partitiontable
    set GPT=false
    for /f "tokens=4,5,8" %%b in (
        'echo list disk ^| diskpart ^| find /i "Disk %disk%"'
        ) do (
            set /a disksize=%%b
            set    diskunit=%%c
            if /i "%%d"=="*" set GPT=true
        )
exit /b 0

:gather.info
    cd /d "%ducky%\BOOT"
        if exist lang (
            for /f "tokens=*" %%b in (lang) do set "lang=%%b"
        )
        if exist rEFInd (
            for /f "tokens=*" %%b in (rEFInd) do set "rtheme=%%b"
        )
        if exist secureboot (
            for /f "tokens=*" %%b in (secureboot) do set "secureboot=%%b"
        )
    cd /d "%ducky%\BOOT\GRUB\themes\"
        if exist theme (
            for /f "tokens=*" %%b in (theme) do set "gtheme=%%b"
        )
    cd /d "%bindir%"
exit /b 0

:check.letter
    echo.
    echo %_lang0123_%
    :: http://wiki.uniformserver.com/index.php/Batch_files:_First_Free_Drive#Final_Solution
    for %%a in (z y x w v u t s r q p o n m l k j i h g f e d c) do (
        cd %%a: 1>>nul 2>&1 & if errorlevel 1 set freedrive=%%a
    )
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
    if "%~2"=="return" call "[ 01 ] Install Multiboot.bat"
exit /b 0

:scan.label
    set online=false
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
        if "%label%"=="rEFInd "    set installed=true
        if "%label%"=="MULTIBOOT " set installed=true
    ) else (
        if "%label%"=="BBP"        set installed=true
    )
exit /b 0

:checkdisktype
    :: reset all disk variable
    set "virtualdisk=false"
    set "harddisk=false"
    set "usb=false"
    set "externaldisk=false"
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
    :: check.usbdisk
    wmic diskdrive get name, mediatype | find /i "Removable Media" | find /i "\\.\physicaldrive%disk%" >nul
        if not errorlevel 1 set "usb=true"
    :: check.externaldisk
    wmic diskdrive get name, mediatype | find /i "External hard disk media" | find /i "\\.\physicaldrive%disk%" >nul
        if not errorlevel 1 set "externaldisk=true"
exit /b 0

:silentcmd
    > "%tmp%\hide.vbs" (
        echo.
        echo Dim Args^(^)
        echo ReDim Args^(WScript.Arguments.Count - 1^)
        echo.
        echo For i = 0 To WScript.Arguments.Count - 1
        echo     Args^(i^) = """" ^& WScript.Arguments^(i^) ^& """"
        echo Next
        echo.
        echo CreateObject^("WScript.Shell"^).Run Join^(Args^), 0, False
    )
exit /b 0

:changelanguage
    call :colortool
    echo.
    echo ^> Current Language is %lang%
    echo ======================================================================
    echo        [ 1 ] = English                [ 2 ] = Vietnam                 
    echo        [ 3 ] = Turkish                [ 4 ] = Simplified Chinese      
    echo ======================================================================
    echo.
    set mylang=1
    set /P mylang= %_lang0016_%
    if "%mylang%"=="1" set "lang=English" & goto :continue.lang
    if "%mylang%"=="2" set "lang=Vietnam" & goto :continue.lang
    if "%mylang%"=="3" set "lang=Turkish" & goto :continue.lang
    if "%mylang%"=="4" set "lang=SimplifiedChinese" & goto :continue.lang
    if "%mylang%"=="b" set goto :main
    color 0e & echo. & echo %_lang0003_% & timeout /t 15 >nul & goto :changelanguage
    
    :continue.lang
    echo.
    echo %_lang0014_%
    cd /d "%bindir%"
        7za.exe x "config\%lang%.7z" -o"%ducky%\" -aoa -y >nul
        >"%ducky%\BOOT\lang" (echo %lang%)
        call language.bat
    cd /d "%bindir%\config"
        call "main.bat"
    :: setting language for grub2 file manager
        >"%ducky%\BOOT\grub\lang.sh" (echo export lang=%langfm%;)
    call :clean.bye
exit /b 0

:sortgrub2menu
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
    if "%ask%"=="b"  goto :main
    color 0e & echo. & echo %_lang0003_% & timeout /t 15 >nul & goto :grub2theme
    
    :continue.gtheme
    cd /d "%ducky%\BOOT\grub\themes"
        if exist "%curtheme%" rmdir /s /q "%curtheme%" >nul
        if not exist "%gtheme%" (
            "%bindir%\7za.exe" x "%bindir%\grub2_themes\%gtheme%.7z" -aoa -y >nul
            "%bindir%\7za.exe" x "%bindir%\grub2_themes\icons.7z" -aoa -y >nul
            "%bindir%\7za.exe" x "%bindir%\grub2font.7z" -o"%gtheme%" -aoa -y >nul
        )
        >"%ducky%\BOOT\grub\themes\theme" (echo %gtheme%)
        call "%bindir%\config\main.bat"
        call :clean.bye
exit /b 0

:rEFIndtheme
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
    set /P ask= %_lang0401_%
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
    if "%ask%"=="b"  goto :main
    color 0e & echo. & echo %_lang0003_% & timeout /t 15 >nul & goto :rEFIndtheme

    :continue.rtheme
    cd /d "%tmp%"
        if not exist rEFInd_themes mkdir rEFInd_themes
    cd /d "%bindir%"
        call :colortool
        7za x "rEFInd_themes\%rtheme%.7z" -o"%tmp%\rEFInd_themes" -aoa -y >nul
    cd /d "%tmp%\rEFInd_themes\%rtheme%\icons"
        >"%ducky%\BOOT\rEFInd" (echo %rtheme%)
        echo. & echo %_lang0402_%
        if exist "%ducky%\EFI\CLOVER\*.*" (
            xcopy "cloverx64.png" "%ducky%\EFI\CLOVER\" /e /z /r /y /q >nul
        )
        call :rEFInd.icons %ducky%
        call :checkdisktype
            if "%virtualdisk%"=="true"  goto :external.rtheme
            if "%harddisk%"=="true"     exit
            if "%usb%"=="true"          goto :removable.rtheme
            if "%externaldisk%"=="true" goto :external.rtheme
    
    :removable.rtheme
    if "%secureboot%"=="n" (
        set refindpart=1
        goto :install.rtheme
    ) else (
        set refindpart=2
        set securepart=1
        goto :install.rtheme
    )
    
    :external.rtheme
    if "%secureboot%"=="n" (
        set refindpart=0
        goto :install.rtheme
    ) else (
        set refindpart=1
        set securepart=0
        goto :install.rtheme
    )

    :install.rtheme
    :: Install rEFind theme
    set "source=%tmp%\rEFInd_themes\%rtheme%"
    %partassist% /hd:%disk% /whide:%refindpart% /src:%source% /dest:EFI\BOOT\themes
    :: Copy icon to secure boot partition
    set "source=%tmp%\rEFInd_themes\%rtheme%\icons\others"
    if not "%secureboot%"=="n" (
        %partassist% /hd:%disk% /whide:%securepart% /src:%source% /dest:EFI\BOOT
    )
    call :clean.bye
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

:easeconvertdisk
    call :colortool
    %partassist% /list
    echo.
    set /p disk= %_lang0101_%
    set /a disk=%disk%+0
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
        if exist "%systemroot%\SysWOW64\Speech\SpeechUX\sapi.cpl" start warning.vbs
    
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
    choice /c 12 /cs /n /m "*  %_lang0905_% [ ? ] = "
        if errorlevel 1 set "option=1"
        if errorlevel 2 set "option=2"
        :: do not change the errorlevel order in the two lines above
        taskkill /f /im wscript.exe /t /fi "status eq running">nul
        del /s /q "%tmp%\warning.vbs" >nul
    
    echo.
    choice /c yn /cs /n /m "%_lang0818_%"
        if errorlevel 2 call :colortool & goto :option.convert
        if errorlevel 1 goto :continue.convert
    
    :continue.convert
    timeout /t 2 >nul
    if "%option%"=="1" cls & goto :GPT.convert
    if "%option%"=="2" cls & goto :MBR.convert
    
    :GPT.convert
    %partassist% /hd:%disk% /del:all
    %partassist% /init:%disk% /gpt
    timeout /t 2 >nul & goto :exit.convert
    
    :MBR.convert
    %partassist% /hd:%disk% /del:all
    %partassist% /init:%disk%
    timeout /t 2 >nul
    
    :exit.convert
    call :clean.bye
exit /b 0

:editWinPEbootmanager
    call :colortool
    echo.
    echo            ^	^>^> MINI WINDOWS BOOT MANAGER EDITOR ^<^<
    echo                 --------------------------------------
    echo.
    cd /d "%bindir%"
    choice /c ynb /cs /n /m "%_lang0800_%"
        if errorlevel 3 goto :main
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
    %bootice% /edit_bcd /easymode /file=%source%
    call :colortool
    call :clean.bye
    
    :uefi3264bit
    call :checkdisktype
        if "%virtualdisk%"=="true"  goto :external.pe
        if "%harddisk%"=="true"     goto :external.pe
        if "%usb%"=="true"          goto :removable.pe
        if "%externaldisk%"=="true" goto :external.pe
    
    :removable.pe
    if "%secureboot%"=="n" (
        set refindpart=1
        goto :installbcd.pe
    ) else (
        set refindpart=2
        set securepart=1
        goto :installbcd.pe
    )
    
    :external.pe
    if "%secureboot%"=="n" (
        set refindpart=0
        goto :installbcd.pe
    ) else (
        set refindpart=1
        set securepart=0
        goto :installbcd.pe
    )
    
    :installbcd.pe
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
    if not "%secureboot%"=="n" (
        call :bcdautoset bcd
        %partassist% /hd:%disk% /whide:%securepart% /src:%source% /dest:EFI\Microsoft\Boot
    )
    call :colortool
    call :clean.bye
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
    call :colortool
    if not exist "%ducky%\WINSETUP\" (
        color 0e & echo.
        echo ^>^> Please install winsetup module before running me
        timeout /t 15 >nul & exit
    )
    
    :option.winsetup
    echo                ^	^>^> WINSETUP BOOT MANAGER EDITOR  ^<^<
    echo                -------------------------------------
    echo.
    set mode=
    set /P mode= "^*              [ 1 ] Legacy mode - [ 2 ] UEFI mode ^> "
    if "%mode%"=="1" goto :legacy.winsetup
    if "%mode%"=="2" goto :uefi.winsetup
    if "%mode%"=="b" goto :main
    color 0e & echo. & echo ^>^>  Invalid Input. & timeout /t 15 >nul & goto :option.winsetup
    
    :legacy.winsetup
    %bootice% /edit_bcd /easymode /file=%ducky%\BOOT\bcd
    call :clean.bye
    
    :uefi.winsetup
    %bootice% /edit_bcd /easymode /file=%ducky%\EFI\MICROSOFT\Boot\bcd
    call :clean.bye
exit /b 0

:fixbootloader
    call :colortool
    call :check.partitiontable
    echo                  ------------------------------------
    echo                    __ _        _                 _   
    echo                   / _^(___  __ ^| ^|__   ___   ___ ^| ^|_ 
    echo                  ^| ^|_^| \ \/ / ^| '_ \ / _ \ / _ \^| __^|
    echo                  ^|  _^| ^|^>  ^<  ^| ^|_^) ^| ^(_^) ^| ^(_^) ^| ^|_ 
    echo                  ^|_^| ^|_/_/\_\ ^|_.__/ \___/ \___/ \__^|
    echo.
    echo                  ------------------------------------
    echo.
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
    choice /c ynb /cs /n /m "%_lang0837_%"
        if errorlevel 3 goto :main
        if errorlevel 2 goto :grub2.fix
        if errorlevel 1 goto :grub4dos.fix
    
    :grub4dos.fix
    cd /d "%bindir%"
        7za x "wget.7z" -o"%tmp%" -aoa -y >nul
    cd /d "%tmp%"
        wget -q -O g4dtemp.log  http://grub4dos.chenall.net >nul
        for /f "tokens=2,3 delims=/" %%a in (
            'type "g4dtemp.log" ^| findstr /i "<h1.*.7z" ^| find /n /v "" ^| find "[1]"'
            ) do (
                set "ver=%%b"
                set "sourcelink=http://dl.grub4dos.chenall.net/%%b.7z"
            )
        echo ^  Updating %ver%...
        wget -q -O grub4dos.7z %sourcelink% >nul
        del g4dtemp.log
    cd /d "%bindir%\extra-modules"
        set "file=grub4dos-0.4.6a/grldr grub4dos-0.4.6a/grub.exe grub4dos0.4.6a/grldr_cd.bin"
        "%bindir%\7za.exe" e -ogrub4dos -aoa "%tmp%\grub4dos.7z" %file% >nul
        del /s /q "%tmp%\grub4dos.7z" >nul
        xcopy "grub4dos\grldr" "%ducky%\" /e /g /h /r /y /q >nul
    
    :grub2.fix
    echo.
    choice /c yn /cs /n /m "%_lang0503_%"
        if errorlevel 2 goto :config.fix
        if errorlevel 1 (
        cd /d "%bindir%"
            echo %_lang0504_%
            call :grub2installer MULTIBOOT >nul 2>&1
        )
    
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
    "%bindir%\7za.exe" x "%bindir%\config\%lang%.7z" -o"%ducky%\" -aoa -y >nul
    cd /d "%bindir%\extra-modules"
        "%bindir%\7za.exe" x "grub2-filemanager.7z" -o"%ducky%\BOOT\grub\" -aoa -y >nul
        >"%ducky%\BOOT\grub\lang.sh" (echo export lang=%langfm%;)
    
    call :clean.bye
exit /b 0

:grub2-filemanager
    cls
    echo.
    echo ^> Downloading grub2-filemanager...
    cd /d "%bindir%\extra-modules"
        "%bindir%\7za.exe" x "%bindir%\curl.7z" -o"%tmp%" -aos -y >nul
        "%tmp%\curl\curl.exe" -L -s -o master.zip https://github.com/a1ive/grub2-filemanager/archive/master.zip
        "%bindir%\7za.exe" x "%bindir%\extra-modules\master.zip" -o"%bindir%\extra-modules\" -y >nul
        del "master.zip" /s /q /f >nul
    cd /d "%bindir%\extra-modules\grub2-filemanager-master\boot\
        xcopy "grub" "%bindir%\extra-modules\grub2-filemanager\" /e /y /q >nul
    cd /d "%bindir%\extra-modules\"
        rmdir "grub2-filemanager-master" /s /q >nul
    
    echo.
    echo ^> Setting grub2-filemanager config...
    :: insert backdoor
    cd /d "%bindir%\extra-modules\grub2-filemanager\"
    
    >> main.lua (
        echo hotkey = "f6" 
        echo command = "configfile $prefix/main.cfg"
        echo grub.add_hidden_menu ^(hotkey, command, "return"^)
    )
    
    >> help.lua (
        echo hotkey = "f6" 
        echo command = "configfile $prefix/main.cfg"
        echo grub.add_hidden_menu ^(hotkey, command, "return"^)
    )
    
    >> open.lua (
        echo hotkey = "f6" 
        echo command = "configfile $prefix/main.cfg"
        echo grub.add_hidden_menu ^(hotkey, command, "return"^)
    )
    
    >> osdetect.lua (
        echo hotkey = "f6" 
        echo command = "configfile $prefix/main.cfg"
        echo grub.add_hidden_menu ^(hotkey, command, "return"^)
    )
    
    >> power.lua (
        echo hotkey = "f6" 
        echo command = "configfile $prefix/main.cfg"
        echo grub.add_hidden_menu ^(hotkey, command, "return"^)
    )
    
    >> settings.lua (
        echo hotkey = "f6" 
        echo command = "configfile $prefix/main.cfg"
        echo grub.add_hidden_menu ^(hotkey, command, "return"^)
    )
    timeout /t 2 >nul
    
    :: store grub2-filemanager to archive
    cd /d "%bindir%\extra-modules"
        "%bindir%\7za.exe" a grub2-filemanager.7z .\grub2-filemanager\* >nul
        if exist "grub2-filemanager" rd /s /q "grub2-filemanager" >nul
        if "%installed%"=="false" call :clean.bye
        echo.
        echo ^> Updating grub2-filemanager to MultibootUSB...
        "%bindir%\7za.exe" x "grub2-filemanager.7z" -o"%ducky%\BOOT\grub\" -aoa -y >nul
        timeout /t 3 >nul
        call :clean.bye
exit /b 0

:setdefaultboot
    call :colortool
    cd /d "%bindir%\secureboot\EFI\Boot\backup"
        if not exist Grub2 mkdir Grub2
    cd /d "%ducky%\BOOT"
        if not exist "secureboot" goto :option.default
        set "Grub2=%bindir%\secureboot\EFI\Boot\backup\Grub2"
        set "rEFInd=%bindir%\secureboot\EFI\Boot\backup\rEFInd"
        set "WinPE=%bindir%\secureboot\EFI\Boot\backup\WinPE"
    cd /d "%ducky%\EFI\BOOT\backup"
        if exist Grub2 copy Grub2 %Grub2% /y >nul
    
    :option.default
    echo.
    echo      %_lang0900_%
    echo ---------------------------------------------------------------------
    echo  %_lang0901_%
    echo  %_lang0902_%
    echo  %_lang0903_%
    echo  %_lang0904_%
    echo ---------------------------------------------------------------------
    set "mode=3"
    set /P mode= %_lang0905_%
        if "%mode%"=="1" set "option=Secure_rEFInd" & goto :checkdisk.default
        if "%mode%"=="2" set "option=Secure_Grub2"  & goto :checkdisk.default
        if "%mode%"=="3" set "option=rEFInd"        & goto :checkdisk.default
        if "%mode%"=="4" set "option=Grub2"         & goto :checkdisk.default
        if "%mode%"=="b" goto :main
        color 0e & echo. & echo %_lang0104_% & timeout /t 15 >nul & goto :option.default
    
    :checkdisk.default
    call :checkdisktype
        if "%virtualdisk%"=="true"  goto :external.default
        if "%harddisk%"=="true"     goto :option.default
        if "%usb%"=="true"          goto :removable.default
        if "%externaldisk%"=="true" goto :external.default
    
    :removable.default
    if "%secureboot%"=="n" (
        set refindpart=1
        goto :nonsecure.default
    ) else (
        set refindpart=2
        set securepart=1
        goto :secure.default
    )
    
    :external.default
    if "%secureboot%"=="n" (
        set refindpart=0
        goto :nonsecure.default
    ) else (
        set refindpart=1
        set securepart=0
        goto :secure.default
    )
    
    :nonsecure.default
    if "%option%"=="Secure_rEFInd" cls & goto :option.default
    if "%option%"=="Secure_Grub2"  cls & goto :option.default
    if "%option%"=="rEFInd" (
        %partassist% /hd:%disk% /whide:%refindpart% /src:%rEFInd% /dest:\EFI\BOOT
    )
    if "%option%"=="Grub2" (
        %partassist% /hd:%disk% /whide:%refindpart% /src:%Grub2% /dest:\EFI\BOOT
        >"%ducky%\EFI\BOOT\WindowsGrub2" (echo true)
    )
    call :clean.bye
    
    :secure.default
    if "%option%"=="Secure_rEFInd" (
        %partassist% /hd:%disk% /whide:%securepart% /src:%WinPE% /dest:\EFI\BOOT
        %partassist% /hd:%disk% /whide:%refindpart% /src:%rEFInd% /dest:\EFI\BOOT
        cd /d "%ducky%\EFI\BOOT\"
            if exist bootx64.efi  del bootx64.efi  /s /f /q >nul
            if exist bootia32.efi del bootia32.efi /s /f /q >nul
    )
    if "%option%"=="Secure_Grub2" (
        %partassist% /hd:%disk% /whide:%securepart% /src:%WinPE% /dest:\EFI\BOOT
        %partassist% /hd:%disk% /whide:%refindpart% /src:%Grub2% /dest:\EFI\BOOT
    )
    if "%option%"=="rEFInd" (
        %partassist% /hd:%disk% /unhide:%securepart%
        %partassist% /hd:%disk% /setletter:%securepart% /letter:X
        cd /d "X:\EFI\BOOT\"
            if exist bootx64.efi   del bootx64.efi   /s /f /q >nul
            if exist bootia32.efi  del bootia32.efi  /s /f /q >nul
            if exist winpeia32.efi del winpeia32.efi /s /f /q >nul
            if exist winpex64.efi  del winpex64.efi  /s /f /q >nul
        %partassist% /hd:%disk% /hide:%securepart%
        %partassist% /hd:%disk% /whide:%refindpart% /src:%rEFInd% /dest:\EFI\BOOT
        cd /d "%bindir%"
            xcopy "secureboot" "%ducky%\" /e /g /h /r /y /q >nul
    )
    if "%option%"=="Grub2" (
        %partassist% /hd:%disk% /whide:%securepart% /src:%Grub2% /dest:\EFI\BOOT
        cd /d "%bindir%"
            xcopy "secureboot" "%ducky%\" /e /g /h /r /y /q >nul
            >"%ducky%\EFI\BOOT\WindowsGrub2" (echo true)
    )
    call :clean.bye
exit /b 0

:updatemultiboot
    :: Preparing files...
    call :colortool
        echo. & echo ^>^>  Current language: %lang%
        if not defined rtheme (
            set rtheme=Universe
        ) else (
            echo. & echo %_lang0400_% %rtheme%
        )
        if not defined gtheme (
            set gtheme=Breeze-5
        ) else (
            echo. & echo ^>^>  %_lang0300_% %gtheme%
        )
    
    cd /d "%bindir%"
        7za x "grub2.7z" -o"%tmp%" -aos -y >nul
        7za x "rEFInd_themes\%rtheme%.7z" -o"%tmp%\rEFInd_themes" -aoa -y >nul
        7za x "refind.7z" -o"%tmp%" -aoa -y >nul
    
    echo.
    echo ---------------------------------------------------------------------
    echo.          [ 1 ] Update config only   [ 2 ] Update full data
    echo ---------------------------------------------------------------------
    echo.
    choice /c 12b /cs /n /m "#   Choose your option [ ? ] > "
        if errorlevel 3 goto :main
        if errorlevel 2 goto :updatefull
        if errorlevel 1 goto :updateconfig
    
    :updatefull
    cd /d "%bindir%"
        echo. & echo ^> Updating data...
        "%bindir%\7za.exe" x "data.7z" -o"%ducky%\" -aoa -y >nul
        xcopy /y "version" "%ducky%\EFI\BOOT\" >nul
    cd /d "%bindir%"
        7za x "wincdemu.7z" -o"%ducky%\ISO\" -aoa -y >nul
    cd /d "%bindir%\secureboot\BOOT"
        xcopy "boot.sdi" "%ducky%\BOOT\" /e /g /h /r /y /q >nul
    cd /d "%bindir%\extra-modules"
        xcopy "grub4dos\grldr" "%ducky%\" /e /g /h /r /y /q >nul
    cd /d "%bindir%\extra-modules"
        "%bindir%\7za.exe" x "grub2-filemanager.7z" -o"%ducky%\BOOT\grub\" -aoa -y >nul
    
    :: install Syslinux Bootloader
    cd /d "%bindir%"
        syslinux --force --directory /BOOT/syslinux %ducky% %ducky%\BOOT\syslinux\syslinux.bin
    
    :: install grub2 Bootloader
    cd /d "%bindir%"
        echo.
        echo %_lang0116_%
        call :grub2installer MULTIBOOT >nul 2>&1
    cd /d "%bindir%"
        7za x "%bindir%\config\%lang%.7z" -o"%ducky%\" -aoa -y >nul
    cd /d "%tmp%\rEfind_themes\%rtheme%\icons"
        copy "grubx64.png"     "%ducky%\EFI\BOOT\grubx64.png" >nul
        copy "grubx64.png"     "%ducky%\EFI\BOOT\grubia32.png" >nul
        copy "winsetupx64.png" "%ducky%\EFI\BOOT\winsetupx64.png" >nul
        copy "winsetupx64.png" "%ducky%\EFI\BOOT\winsetupia32.png" >nul
        copy "xorbootx64.png"  "%ducky%\EFI\BOOT\xorbootx64.png" >nul
    cd /d "%tmp%\rEfind_themes\%rtheme%\icons"
        xcopy "others" "%ducky%\EFI\BOOT\" /e /g /h /r /y /q >nul
    cd /d "%bindir%"
        7za x "%bindir%\grub2_themes\%gtheme%.7z" -o"%ducky%\BOOT\grub\themes\" -aoa -y >nul
        7za x "%bindir%\grub2_themes\icons.7z" -o"X:\BOOT\grub\themes\" -aoa -y >nul
    cd /d "%ducky%\EFI\Microsoft\Boot"
        call :bcdautoset bcd
    
    :updateconfig
    cd /d "%bindir%\config"
        call "main.bat"
        timeout /t 2 >nul
        call :clean.bye
exit /b 0

:unhidedatapartition
    call :colortool
    %partassist% /list
    echo.
    set /p disk= %_lang0101_%
    set /a disk=%disk%+0
    call :checkdisktype
        if "%virtualdisk%"=="true"  goto :continue.unhide
        if "%harddisk%"=="true"     goto :unhidedatapartition
        if "%usb%"=="true"          goto :continue.unhide
        if "%externaldisk%"=="true" goto :continue.unhide
        color 0e & echo. & echo %_lang0104_% & timeout /t 15 >nul & goto :unhidedatapartition
    
    :continue.unhide
    for /f %%b in (
        'wmic volume get driveletter^, label ^| findstr /i "MULTIBOOT"'
        ) do set "ducky=%%b"
        set /a partition=0
        if exist "%ducky%\EFI\BOOT\mark" (
            goto :break.unhide
        ) else (
            goto :unhidepartition
        )
    
    :unhidepartition
    %partassist% /hd:%disk% /unhide:%partition%
    %partassist% /hd:%disk% /setletter:%partition% /letter:auto
    for /f %%b in (
        'wmic volume get driveletter^, label ^| findstr /i "MULTIBOOT"'
        ) do set "ducky=%%b"
        if not exist "%ducky%\EFI\BOOT\mark" (
            %partassist% /hd:%disk% /hide:%partition%
            set /a partition=%partition%+1
            goto :unhidepartition
        ) else (
            goto :break.unhide
        )
    
    :break.unhide
    for /f "tokens=*" %%b in (%ducky%\EFI\BOOT\mark) do set "author=%%b"
        if "%author%"=="niemtin007" (
            call :clean.bye
        )
exit /b 0

:NTFSdriveprotect
    call :colortool
        7za x "driveprotect.7z" -o"%tmp%" -aos -y >nul
        if "%processor_architecture%" == "x86" (
            set DriveProtect=driveprotect.exe
        ) else (
            set DriveProtect=driveprotectx64.exe
        )
    cd /d "%tmp%\driveprotect"
        start %DriveProtect%
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
        7za x "qemu.7z" -o"%tmp%" -aoa -y >nul
    cd /d "%tmp%"
        start qemuboottester.exe
        exit
exit /b 0

:cloverinstaller
    call :colortool
    if "%PROCESSOR_ARCHITECTURE%"=="x86" (
        set gdisk=gdisk32.exe
        ) else (
        set gdisk=gdisk64.exe
    )
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
    
    :clover
    cls 
    call :cloverinterface
    choice /c ynb /cs /n /m "%_lang0700_% > "
        if errorlevel 3 goto :main
        if errorlevel 2 goto :cloverconfig
        if errorlevel 1 goto :download.clover
    
    :download.clover
    cd /d "%bindir%"
        mkdir clover
        7za x "clover.7z" -o"clover" -aoa -y >nul
        7za x "wget.7z" -o"%tmp%" -aoa -y >nul
    :: get clover iso file
    cd /d "%tmp%"
        :: get the lastest version name
        set "sourcelink=https://sourceforge.net/projects/cloverefiboot/files/Bootable_ISO/"
        wget -q -O "clover.log" %sourcelink%
        for /f delims^=^"^ tokens^=2  %%a in (
            'type "clover.log" ^| findstr /i "<tr.*.lzma" ^| find /n /v "" ^| find "[1]"'
            ) do (set "name=%%a") >nul
        :: download clover
        cls
        call :cloverinterface
        echo ^>^> downloading %name%...
        echo.
        set "sourcelink=https://sourceforge.net/projects/cloverefiboot/files/Bootable_ISO/%name%/download"
        wget -q --show-progress -O "%name%" %sourcelink%
        del "clover.log" /s /q /f >nul
        :: extract clover iso
        if exist "*CloverISO*.tar.lzma" (
            "%bindir%\7za.exe" x "*CloverISO*.tar.lzma" -o"%tmp%" -y >nul
            del "*CloverISO*.tar.lzma" /s /q /f >nul
            "%bindir%\7za.exe" x "*CloverISO*.tar" -o"%tmp%" -y >nul
            del "*CloverISO*.tar" /s /q /f >nul
            ren Clover-*.iso clover.iso
        )
    :: mount clover iso and copy file
    cd /d "%bindir%"
        7za x "wincdemu.7z" -o"%tmp%" -aoa -y >nul
    cd /d "%tmp%"
        wincdemu /install
        wincdemu clover.iso X: /wait
    cd /d "X:\"
        xcopy "EFI" "%tmp%\EFI\" /s /z /y /q >nul
    cd /d "%tmp%"
        wincdemu /unmount X:
        wincdemu /uninstall
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
    :: make config for clover
    call "%bindir%\config\clover.conf.bat"
    :: use rEFInd driver for clover
    "%bindir%\7za.exe" x "%bindir%\refind.7z" -o"%tmp%" -aoa -y >nul
    if exist "%tmp%\rEFInd\drivers_x64" (
        xcopy "%tmp%\rEFInd\drivers_x64" "%bindir%\clover\drivers64UEFI" /s /z /y /q >nul
    )
    
    cd /d "%tmp%"
        if exist "EFI" (rd /s /q "EFI")
        if exist "clover.iso" (del /s /q "clover.iso" >nul)
    
    :: cd /d "%tmp%" & del "%tmp%\*.*" /s /q /f >nul
    :: for /d %%i in ("%tmp%\*.*") do rmdir "%%i" /s /q >nul
    
    :: store clover to archive
    cd /d "%bindir%"
        7za a clover.7z .\clover\* -sdel >nul
        if exist "clover" (rd /s /q "clover" >nul)
    
    :cloverconfig
    call :colortool
    if "%structure%"=="MBR" goto :option.clover
    cls 
    call :cloverinterface
    choice /c yn /cs /n /m "%_lang0702_% > "
        if errorlevel 2 goto :option.clover
        if errorlevel 1 goto :gdisk.clover
    
    :gdisk.clover
    call :colortool
    7za x "gdisk.7z" -o"%tmp%" -aos -y >nul
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
    echo.
    echo %_lang0712_%
    cd /d "%tmp%"
        if not exist rEFInd_themes (mkdir rEFInd_themes)
    cd /d "%bindir%"
        7za x "rEFInd_themes\%rtheme%.7z" -o"%tmp%\rEFInd_themes" -aoa -y >nul
        if not exist "%ducky%\EFI\CLOVER\" (mkdir "%ducky%\EFI\CLOVER\")
        7za x "clover.7z" -o"%ducky%\EFI\CLOVER\" -aoa -y >nul
    cd /d "%tmp%\rEFInd_themes\%rtheme%\icons"
        xcopy "cloverx64.png" "%ducky%\EFI\CLOVER\" /s /z /y /q >nul
    echo %_lang0715_%
    timeout /t 2 >nul
    goto :EasyUEFI.clover
    
    :MultibootOS.clover
    if "%structure%"=="MBR" (
        call :colortool
        echo. & echo %_lang0713_% & timeout /t 15 >nul & goto :option.clover
    )
    echo.
    choice /c yn /cs /n /m "%_lang0714_%"
        if errorlevel 2 goto :option.clover
        if errorlevel 1 call :colortool
    :: installing Clover to ESP
    mountvol s: /s
    cd /d "%tmp%"
        mkdir CLOVER
        7za x "%bindir%\clover.7z" -o"%tmp%\CLOVER\" -aoa -y >nul
        xcopy "%tmp%\CLOVER" "s:\EFI\CLOVER\" /e /y /q >nul
        if exist "%curdir%\config.plist" (
            xcopy "%curdir%\config.plist" "s:\EFI\CLOVER\" /e /y /q >nul
        )
    timeout /t 2 >nul
    mountvol s: /d
    echo.
    echo %_lang0715_%
    timeout /t 2 >nul
    goto :EasyUEFI.clover
    
    :EasyUEFI.clover
    cls
    call :cloverinterface
    "%bindir%\7za.exe" x "%bindir%\extra-modules\EasyUEFI.7z" -o"%tmp%" -y >nul
    echo.
    choice /c yn /cs /n /m "%_lang0716_%"
        if errorlevel 2 call :clean.bye
        if errorlevel 1 (
            cd /d "%tmp%\EasyUEFI"
                start EasyUEFIPortable.exe
                call :clean.bye
        )
exit /b 0
:: clover function
:cloverinterface
    echo.
    echo ----------------------------------------------------------------------
    echo                          ^> Clover Installer ^<                       
    echo ----------------------------------------------------------------------
    echo.
exit /b 0

:rEFIndinstaller
    call :colortool
    for /f "tokens=4 delims=\" %%b in ('wmic os get name') do set "harddisk=%%b"
        if defined harddisk set /a "harddisk=%harddisk:~8,1%"
    for /f "tokens=2" %%b in (
        'wmic path Win32_diskpartition get type ^, diskindex ^| find /i "%harddisk%"'
        ) do set "GPT=%%b"
        if /i "%GPT%" NEQ "GPT:" (
            color 0e & echo. & echo %_lang0001_%
            echo %_lang0002_%
            set "structure=MBR"
            timeout /t 15 >nul
        )
    
    :refind
    call :rEFIndinterface
    choice /c ynb /cs /n /m "%_lang0600_% > "
        if errorlevel 3 goto :main
        if errorlevel 2 goto :option.rEFInd
        if errorlevel 1 goto :download.rEFInd
    
    :download.rEFInd
    cd /d "%bindir%"
        if not exist rEFInd mkdir rEFInd
        7za x "wget.7z" -o"%tmp%" -aoa -y >nul
    cd /d "%tmp%"
        echo.
        :: download the last rEFInd
        set "sourcelink=https://sourceforge.net/projects/refind/files/latest/download"
        wget -q --show-progress -O refind-bin.zip %sourcelink%
        :: extract data
        if not exist "refind-bin" (
            if exist "refind-bin.zip" (
                "%bindir%\7za.exe" x "refind-bin.zip" -o"%tmp%" -y >nul
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
        7za a refind.7z rEFInd\ -sdel >nul
        if exist "rEFInd" rd /s /q "rEFInd" >nul
    
    :option.rEFInd
    set "rtheme=Universe"
    :: preparing file...
    if not exist rEFInd_themes mkdir rEFInd_themes
    cd /d "%tmp%"
        "%bindir%\7za.exe" x "%bindir%\refind.7z" -o"%tmp%" -aoa -y >nul
        "%bindir%\7za.exe" x "%bindir%\rEFInd_themes\%rtheme%.7z" -o"rEFInd_themes" -aoa -y >nul
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
    :: detected USB
    wmic diskdrive get name, mediatype | find /i "Removable Media" | find /i "\\.\physicaldrive%disk%" >nul
        if not errorlevel 1 (goto :Removable.rEFInd) else (goto :External.rEFInd)
        :Removable.rEFInd
        if "%secureboot%"=="n" (
            set refindpart=1
            goto :installrEFInd
        ) else (
            set refindpart=2
            set securepart=1
            goto :installrEFInd
        )
        :External.rEFInd
        if "%secureboot%"=="n" (
            set refindpart=0
            goto :installrEFInd
        ) else (
            set refindpart=1
            set securepart=0
            goto :installrEFInd
        )
    
    :installrEFInd
    set "source=%tmp%\rEFInd"
    %partassist% /hd:%disk% /whide:%refindpart% /src:%source% /dest:EFI\BOOT
    goto :EasyUEFI.rEFInd
    
    :MultibootOS.rEFInd
    if "%structure%"=="MBR" (
        call :colortool
        echo. & echo %_lang0608_% & timeout /t 15 >nul & goto :option.rEFInd
    )
    echo.
    choice /c yn /cs /n /m "%_lang0609_%"
        if errorlevel 2 goto :option.rEFInd
        if errorlevel 1 call :colortool
    mountvol s: /s
    cd /d "%tmp%"
        xcopy "rEFInd" "s:\EFI\refind\" /e /y /q >nul
        xcopy "rEFInd_themes\%rtheme%" "s:\EFI\rEFInd\themes" /e /y /q >nul
        timeout /t 2 >nul
    mountvol s: /d
    echo.
    echo %_lang0610_%
    timeout /t 2 >nul
    goto :EasyUEFI.rEFInd
    
    :EasyUEFI.rEFInd
    "%bindir%\7za.exe" x "%bindir%\extra-modules\EasyUEFI.7z" -o"%tmp%" -y >nul
    call :rEFIndinterface
    echo.
    choice /c yn /cs /n /m "%_lang0611_%"
        if errorlevel 2 call :clean.bye
        if errorlevel 1 (
            cd /d "%tmp%\EasyUEFI"
                start EasyUEFIPortable.exe
                call :clean.bye
        )
exit /b 0
:: rEFInd functions
:rEFIndinterface
    call :colortool
    echo.
    echo ----------------------------------------------------------------------
    echo                          ^> rEFInd Installer ^<                       
    echo ----------------------------------------------------------------------
    echo.
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

:grub2installer
    cd /d "%bindir%"
        7za x "grub2.7z" -o"%tmp%" -aos -y >nul
        if exist "V:\" call :check.letter V:
    :: create vhd disk
    cd /d "%tmp%"
        if exist "Grub2.vhd" del /s /q "Grub2.vhd" >nul
        (
            echo create vdisk file="%tmp%\Grub2.vhd" maximum=50 type=expandable
            echo attach vdisk
            echo create partition primary
            echo format fs=fat32 label="Grub2"
            echo assign letter=v
        ) | diskpart
    :: install grub2 for Legacy BIOS mode
    if not "%~2"=="legacydisable" (
        move /y "%ducky%\BOOT\grub\*.lst" "%ducky%\BOOT" >nul
        cd /d "%tmp%\grub2"
            grub-install --target=i386-pc --force --boot-directory=%ducky%\BOOT \\.\physicaldrive%disk%
        move /y "%ducky%\BOOT\*.lst" "%ducky%\BOOT\grub" >nul
        cd /d "%tmp%\grub2\i386-pc"
            copy "lnxboot.img" "%ducky%\BOOT\grub\i386-pc" /y >nul
        cd /d "%ducky%\BOOT\grub\i386-pc"
            copy /b lnxboot.img+Core.img g2ldr
    )
    :: install grub2 for EFI mode
    cd /d "%tmp%\grub2"
        grub-install --target=x86_64-efi --efi-directory=V:\ --boot-directory=%ducky%\BOOT --bootloader-id=grub --modules=part_gpt --removable
        grub-install --target=i386-efi --efi-directory=V:\ --boot-directory=%ducky%\BOOT --bootloader-id=grub --modules=part_gpt --removable
    cd /d "V:\EFI\BOOT"
        :: copy to multiboot data partition
        copy "BOOTIA32.EFI" "%ducky%\EFI\BOOT\grubia32.efi" /y >nul
        copy "BOOTX64.EFI"  "%ducky%\EFI\BOOT\grubx64.efi"  /y >nul
        copy "grub.efi"     "%ducky%\EFI\BOOT\grub.efi"     /y >nul
        :: make backup
        copy "BOOTIA32.EFI" "%bindir%\secureboot\EFI\Boot\backup\Grub2\bootia32.efi" /y >nul
        copy "BOOTX64.EFI"  "%bindir%\secureboot\EFI\Boot\backup\Grub2\bootx64.efi"  /y >nul
        copy "grub.efi"     "%bindir%\secureboot\EFI\Boot\backup\Grub2\grub.efi"     /y >nul
    cd /d "%tmp%"
        (
            echo select vdisk file="%tmp%\Grub2.vhd"
            echo detach vdisk
        ) | diskpart
        del /s /q "Grub2.vhd" >nul
    cd /d "%bindir%"
exit /b 0

:clean.bye
call :colortool
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
    set "dlist=colortool curl driveprotect gdisk grub2 partassist rEFInd rEFInd_themes"
    for %%d in (%dlist%) do (
        if exist "%%d" rmdir "%%d" /s /q >nul
    )
    set "flist=hide.vbs Output.log qemuboottester.exe wincdemu.exe wget.exe"
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
    if exist "%systemroot%\SysWOW64\Speech\SpeechUX\sapi.cpl" start thanks.vbs
    timeout /t 3 >nul
    del /s /q thanks.vbs >nul
    exit
exit /b 0

:: end function

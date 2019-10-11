@echo off

rem >> https://niemtin007.blogspot.com
rem >> The batch file is written by niemtin007.
rem >> Thank you for using Multiboot Toolkit.

title %~nx0
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
set "option=14" rem set default
set /p option= %_lang0905_% [ ? ] = 
cd /d "%bindir%"
if "%offline%"=="0" goto :online
if "%offline%"=="1" goto :offline

:online
if "%option%"=="1"  call :colortool & call :grub2theme
if "%option%"=="2"  call :colortool & call :rEFIndtheme
if "%option%"=="3"  call :colortool & call :cloverinstaller
if "%option%"=="4"  call :colortool & call :rEFIndInstaller
if "%option%"=="5"  call :colortool & call :setdefaultboot
if "%option%"=="6"  call :colortool & call :editWinPEbootmanager
if "%option%"=="7"  call :colortool & call :editwinsetupfromUSB
if "%option%"=="8"  call :colortool & call :grub2-filemanager
if "%option%"=="9"  call :colortool & call :fixbootloader
if "%option%"=="10" call :colortool & call :unhidedatapartition
if "%option%"=="11" call :colortool & call :easeconvertdisk
if "%option%"=="12" call :colortool & call :NTFSdriveprotect
if "%option%"=="13" call :colortool & call :changelanguage
if "%option%"=="14" call :colortool & call :qemuboottester
if "%option%"=="15" call :colortool & call :updatemultiboot
if "%option%"=="16" call :colortool & call :sortgrub2menu
color 4f & echo. & echo %_lang0003_% & timeout /t 15 >nul & goto :main

:Offline
if "%option%"=="3"  call :colortool & call :cloverinstaller
if "%option%"=="4"  call :colortool & call :rEFIndInstaller
if "%option%"=="8"  call :colortool & call :grub2-filemanager
if "%option%"=="10" call :colortool & call :unhidedatapartition
if "%option%"=="11" call :colortool & call :easeconvertdisk
if "%option%"=="14" call :colortool & call :qemuboottester
color 4f & echo. & echo %_lang0003_% & timeout /t 15 >nul & goto :main





rem >> begin functions
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
            cd /d "%tmp%" & start identify.vbs
            cls & echo. & echo ^>^> Multiboot Drive Found ^^^^ & timeout /t 2 >nul
            goto :break.scan
        )
        :progress.scan
            if "%skipscan%"=="true" set "offline=1" & goto :offline.scan
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
    :offline.scan
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
            SetupGreen32.exe -i > nul
            LoadDrv_Win32.exe -i > nul
        ) else (
            SetupGreen64.exe -i > nul
            LoadDrv_x64.exe -i > nul
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
        set /a num=%random% %%112 +1
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
    cd /d "%ducky%\BOOT"
        for /f "tokens=*" %%b in (lang) do set current=%%b
    echo.
    echo ^> Current Language is %current%
    echo ======================================================================
    echo        [ 1 ] = English                [ 2 ] = Vietnam                 
    echo        [ 3 ] = Turkish                [ 4 ] = Simplified Chinese      
    echo ======================================================================
    echo.
    set mylang=1
    set /P mylang= %_lang0016_% [ ? ] = 
    if "%mylang%"=="1" set "lang=English" & goto :continue.lang
    if "%mylang%"=="2" set "lang=Vietnam" & goto :continue.lang
    if "%mylang%"=="3" set "lang=Turkish" & goto :continue.lang
    if "%mylang%"=="4" set "lang=SimplifiedChinese" & goto :continue.lang
    color 4f & echo. & echo %_lang0003_% & timeout /t 15 >nul & cls & goto :changelanguage
    
    :continue.lang
    echo.
    echo %_lang0014_%
    cd /d "%bindir%"
        7za.exe x "config\%lang%.7z" -o"%ducky%\" -aoa -y > nul
        >"%ducky%\BOOT\lang" (echo %lang%)
        call language.bat
    cd /d "%ducky%\BOOT\GRUB\themes\"
        for /f "tokens=*" %%b in (theme) do set "gtheme=%%b"
    cd /d "%bindir%\config"
        call "main.bat"
    rem > setting language for grub2 file manager
        >"%ducky%\BOOT\grub\lang.sh" (echo export lang=%langfm%;)
    call :clean.bye
exit /b 0

:sortgrub2menu
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
        rem check the character of the string
        echo %list%| findstr /r /c:"[a-o]" > nul
        if not "%errorlevel%"=="0" goto :sortgrub2menu
    
    cd /d "%ducky%\BOOT\grub"
        >"menu.list" (echo %list%)
    
    cd /d "%ducky%\BOOT\GRUB\themes\"
        for /f "tokens=*" %%b in (theme) do set "gtheme=%%b"
    
    cd /d "%bindir%\config"
        call "main.bat"
        call :clean.bye
exit /b 0

:grub2theme
    cd /d "%ducky%\BOOT\"
        for /f "tokens=*" %%b in (lang) do set "lang=%%b"
    cd /d "%ducky%\BOOT\grub\themes"
        for /f "tokens=*" %%b in (theme) do set "gtheme=%%b"
    
    echo.
    echo %_lang0300_% %gtheme%
    echo =====================================================================
    echo 01 = Aero       09 = Breeze-1     17 = Gentoo      25 = RainbowDash  
    echo 02 = Air_Vision 10 = Breeze_dark  18 = Grau        26 = Raindrops    
    echo 03 = Alienware  11 = Breeze-5     19 = Huayralimbo 27 = SolarizedDark
    echo 04 = Archlinux  12 = Dark_Colors  20 = Journey     28 = Solstice     
    echo 05 = Ask-larry  13 = Dark_squares 21 = Monochrome  29 = Steam        
    echo 06 = Aurora     14 = Devuan       22 = Oxygen      30 = StylishDark  
    echo 07 = Axiom      15 = Eternity     23 = Plasma-dark 31 = Tela         
    echo 08 = Bluec4d    16 = FagiadaBue   24 = Powerman    32 = Ubuntu-lucid 
    echo =====================================================================
    echo.
    set /P ask= %_lang0301_% [ ? ]  = 
    if "%ask%"=="1"  (set "gtheme=Aero" & goto :continue.gtheme)
    if "%ask%"=="2"  (set "gtheme=Air_Vision" & goto :continue.gtheme)
    if "%ask%"=="3"  (set "gtheme=Alienware" & goto :continue.gtheme)
    if "%ask%"=="4"  (set "gtheme=Archlinux" & goto :continue.gtheme)
    if "%ask%"=="5"  (set "gtheme=Ask-larry" & goto :continue.gtheme)
    if "%ask%"=="6"  (set "gtheme=Aurora" & goto :continue.gtheme)
    if "%ask%"=="7"  (set "gtheme=Axiom" & goto :continue.gtheme)
    if "%ask%"=="8"  (set "gtheme=Bluec4d" & goto :continue.gtheme)
    if "%ask%"=="9"  (set "gtheme=Breeze-1" & goto :continue.gtheme)
    if "%ask%"=="10" (set "gtheme=Breeze_dark" & goto :continue.gtheme)
    if "%ask%"=="11" (set "gtheme=Breeze-5" & goto :continue.gtheme)
    if "%ask%"=="12" (set "gtheme=Dark_Colors" & goto :continue.gtheme)
    if "%ask%"=="13" (set "gtheme=Dark_squares" & goto :continue.gtheme)
    if "%ask%"=="14" (set "gtheme=Devuan" & goto :continue.gtheme)
    if "%ask%"=="15" (set "gtheme=Eternity" & goto :continue.gtheme)
    if "%ask%"=="16" (set "gtheme=FagiadaBue" & goto :continue.gtheme)
    if "%ask%"=="17" (set "gtheme=Gentoo" & goto :continue.gtheme)
    if "%ask%"=="18" (set "gtheme=Grau" & goto :continue.gtheme)
    if "%ask%"=="19" (set "gtheme=Huayra-limbo" & goto :continue.gtheme)
    if "%ask%"=="20" (set "gtheme=Journey" & goto :continue.gtheme)
    if "%ask%"=="21" (set "gtheme=Monochrome" & goto :continue.gtheme)
    if "%ask%"=="22" (set "gtheme=Oxygen" & goto :continue.gtheme)
    if "%ask%"=="23" (set "gtheme=Plasma-dark" & goto :continue.gtheme)
    if "%ask%"=="24" (set "gtheme=Powerman" & goto :continue.gtheme)
    if "%ask%"=="25" (set "gtheme=RainbowDash" & goto :continue.gtheme)
    if "%ask%"=="26" (set "gtheme=Raindrops" & goto :continue.gtheme)
    if "%ask%"=="27" (set "gtheme=SolarizedDark" & goto :continue.gtheme)
    if "%ask%"=="28" (set "gtheme=Solstice" & goto :continue.gtheme)
    if "%ask%"=="29" (set "gtheme=Steam" & goto :continue.gtheme)
    if "%ask%"=="30" (set "gtheme=StylishDark" & goto :continue.gtheme)
    if "%ask%"=="31" (set "gtheme=Tela" & goto :continue.gtheme)
    if "%ask%"=="32" (set "gtheme=Ubuntu-lucid" & goto :continue.gtheme)
    color 4f & echo. & echo %_lang0003_% & timeout /t 15 >nul & goto :grub2theme
    
    :continue.gtheme
    if not exist "%ducky%\BOOT\grub\themes\%gtheme%" (
        "%bindir%\7za.exe" x "%bindir%\grub2_themes\%gtheme%.7z" -o"%ducky%\BOOT\grub\themes\" -aoa -y >nul
    )
    >"%ducky%\BOOT\grub\themes\theme" (echo %gtheme%)
    call "%bindir%\config\main.bat"
    call :clean.bye
exit /b 0

:rEFIndtheme
    echo.
    cd /d "%ducky%\BOOT\"
        for /f "tokens=*" %%b in (rEFInd) do set "rtheme=%%b"
        if exist secureboot (
            for /f "tokens=*" %%b in (secureboot) do set "secureboot=%%b"
        )
    echo %_lang0400_% %rtheme%
    echo =====================================================================
    echo 01 = Apocalypse   12 = CloverBootcamp 23 = GoldClover 34 = Pandora   
    echo 02 = BGM          13 = Clovernity     24 = Gothic     35 = Red       
    echo 03 = BGM256       14 = Clover-X       25 = HighSierra 36 = Shield    
    echo 04 = black        15 = CrispyOSX      26 = HMF        37 = SimpleGrey
    echo 05 = Bluemac      16 = Crystal        27 = iclover    38 = Simplicity
    echo 06 = Buttons      17 = Dark           28 = Leather    39 = Smooth    
    echo 07 = Carbon       18 = DarkBoot       29 = MacOSX     40 = Sphere    
    echo 08 = Catalina     19 = DarkBootX      30 = MavsStyle  41 = Universe  
    echo 09 = Chrome       20 = ElCapitan      31 = Mojave     42 = Woody     
    echo 10 = Circla       21 = Emerald        32 = Neon                      
    echo 11 = ClassicMacOS 22 = Glassy         33 = Oceanix                   
    echo =====================================================================
    echo.
    set /P ask= %_lang0401_% [ ? ]  = 
    if "%ask%"=="1"  (set "rtheme=Apocalypse" & goto :continue.rtheme)
    if "%ask%"=="2"  (set "rtheme=BGM" & goto :continue.rtheme)
    if "%ask%"=="3"  (set "rtheme=BGM256" & goto :continue.rtheme)
    if "%ask%"=="4"  (set "rtheme=black" & goto :continue.rtheme)
    if "%ask%"=="5"  (set "rtheme=Bluemac" & goto :continue.rtheme)
    if "%ask%"=="6"  (set "rtheme=Buttons" & goto :continue.rtheme)
    if "%ask%"=="7"  (set "rtheme=Carbon" & goto :continue.rtheme)
    if "%ask%"=="8"  (set "rtheme=Catalina" & goto :continue.rtheme)
    if "%ask%"=="9"  (set "rtheme=Chrome" & goto :continue.rtheme)
    if "%ask%"=="10" (set "rtheme=Circla" & goto :continue.rtheme)
    if "%ask%"=="11" (set "rtheme=ClassicMacOS" & goto :continue.rtheme)
    if "%ask%"=="12" (set "rtheme=CloverBootcamp" & goto :continue.rtheme)
    if "%ask%"=="13" (set "rtheme=Clovernity" & goto :continue.rtheme)
    if "%ask%"=="14" (set "rtheme=Clover-X" & goto :continue.rtheme)
    if "%ask%"=="15" (set "rtheme=CrispyOSX" & goto :continue.rtheme)
    if "%ask%"=="16" (set "rtheme=Crystal" & goto :continue.rtheme)
    if "%ask%"=="17" (set "rtheme=Dark" & goto :continue.rtheme)
    if "%ask%"=="18" (set "rtheme=DarkBoot" & goto :continue.rtheme)
    if "%ask%"=="19" (set "rtheme=DarkBootX" & goto :continue.rtheme)
    if "%ask%"=="20" (set "rtheme=ElCapitan" & goto :continue.rtheme)
    if "%ask%"=="21" (set "rtheme=Emerald" & goto :continue.rtheme)
    if "%ask%"=="22" (set "rtheme=Glassy" & goto :continue.rtheme)
    if "%ask%"=="23" (set "rtheme=GoldClover" & goto :continue.rtheme)
    if "%ask%"=="24" (set "rtheme=Gothic" & goto :continue.rtheme)
    if "%ask%"=="25" (set "rtheme=HighSierra" & goto :continue.rtheme)
    if "%ask%"=="26" (set "rtheme=HMF" & goto :continue.rtheme)
    if "%ask%"=="27" (set "rtheme=iclover" & goto :continue.rtheme)
    if "%ask%"=="28" (set "rtheme=Leather" & goto :continue.rtheme)
    if "%ask%"=="29" (set "rtheme=MacOSX" & goto :continue.rtheme)
    if "%ask%"=="30" (set "rtheme=MavsStyle" & goto :continue.rtheme)
    if "%ask%"=="31" (set "rtheme=Mojave" & goto :continue.rtheme)
    if "%ask%"=="32" (set "rtheme=Neon" & goto :continue.rtheme)
    if "%ask%"=="33" (set "rtheme=Oceanix" & goto :continue.rtheme)
    if "%ask%"=="34" (set "rtheme=Pandora" & goto :continue.rtheme)
    if "%ask%"=="35" (set "rtheme=Red" & goto :continue.rtheme)
    if "%ask%"=="36" (set "rtheme=Shield" & goto :continue.rtheme)
    if "%ask%"=="37" (set "rtheme=SimpleGrey" & goto :continue.rtheme)
    if "%ask%"=="38" (set "rtheme=Simplicity" & goto :continue.rtheme)
    if "%ask%"=="39" (set "rtheme=Smooth" & goto :continue.rtheme)
    if "%ask%"=="40" (set "rtheme=Sphere" & goto :continue.rtheme)
    if "%ask%"=="41" (set "rtheme=Universe" & goto :continue.rtheme)
    if "%ask%"=="42" (set "rtheme=Woody" & goto :continue.rtheme)
    color 4f & echo. & echo %_lang0003_% & timeout /t 15 >nul & goto :rEFIndtheme
    
    :continue.rtheme
    cd /d "%tmp%"
        if not exist rEFInd_themes (mkdir rEFInd_themes)
    cd /d "%bindir%"
        call :colortool
        7za x "rEFInd_themes\%rtheme%.7z" -o"%tmp%\rEFInd_themes" -aoa -y >nul
    cd /d "%tmp%\rEFInd_themes\%rtheme%\icons"
        >"%ducky%\BOOT\rEFInd" (echo %rtheme%)
        echo. & echo %_lang0402_%
        if exist "%ducky%\EFI\CLOVER\*.*" (
            xcopy "cloverx64.png" "%ducky%\EFI\CLOVER\" /e /z /r /y /q >nul
        )
        copy "grubx64.png" "%ducky%\EFI\BOOT\grubx64.png" /y >nul
        copy "grubx64.png" "%ducky%\EFI\BOOT\grubia32.png" /y >nul
        copy "winsetupx64.png" "%ducky%\EFI\BOOT\winsetupx64.png" /y >nul
        copy "winsetupx64.png" "%ducky%\EFI\BOOT\winsetupia32.png" /y >nul
        copy "xorbootx64.png" "%ducky%\EFI\BOOT\xorbootx64.png" /y >nul
    cd /d "%tmp%\rEfind_themes\%rtheme%\icons\"
        xcopy "others" "%ducky%\EFI\BOOT\" /e /g /h /r /y /q >nul
    cd /d "%bindir%"
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
    rem >> Install rEFind theme
    set "source=%tmp%\rEFInd_themes\%rtheme%"
    %partassist% /hd:%disk% /whide:%refindpart% /src:%source% /dest:EFI\BOOT\themes
    rem >> Copy icon to secure boot partition
    set "source=%tmp%\rEFInd_themes\%rtheme%\icons\others"
    if not "%secureboot%"=="n" (
        %partassist% /hd:%disk% /whide:%securepart% /src:%source% /dest:EFI\BOOT
    )
    call :clean.bye
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
        color 4f & echo %_lang0103_% & timeout /t 15 > nul & cls
        goto :easeconvertdisk
    )
    if "%usb%"=="true" goto :option.convert
    if "%externaldisk%"=="true" goto :option.convert
    color 4f & echo. & echo %_lang0104_% & timeout /t 15 > nul & goto :easeconvertdisk
    
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
        start warning.vbs
    
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
        rem do not change the errorlevel order in the two lines above
        taskkill /f /im wscript.exe /t /fi "status eq running">nul
        del /s /q "%tmp%\warning.vbs" >nul
    
    echo.
    choice /c yn /cs /n /m "%_lang0818_%"
        if errorlevel 2 call :colortool & goto :option.convert
        if errorlevel 1 goto :continue.convert
    
    :continue.convert
    for /l %%i in (5,-1,0) do (
        cls & echo.
        echo ^> Goodbye your data in %%i seconds...
        timeout /t 1 >nul
    )
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
    cd /d "%ducky%\BOOT"
        if exist "secureboot" (
            for /f "tokens=*" %%b in (secureboot) do set "secureboot=%%b"
        )
    echo.
    echo            ^	^>^> MINI WINDOWS BOOT MANAGER EDITOR ^<^<
    echo                 --------------------------------------
    echo.
    cd /d "%bindir%"
    choice /c yn /cs /n /m "%_lang0800_%"
        if errorlevel 2 goto :option.pe
        if errorlevel 1 call bcdautomenu.bat
    
    :option.pe
    echo.
    choice /c 12 /cs /n /m "*               [ 1 ] Legacy mode  [ 2 ] UEFI mode > "
        if errorlevel 2 goto :uefi3264bit
        if errorlevel 1 goto :legacy3264bit
    
    :legacy3264bit
    set "source=%ducky%\BOOT\bootmgr\B84"
    echo.
    echo ^*               Source^: %source%
    "%bindir%\bootice.exe" /edit_bcd /easymode /file=%source%
    call :colortool
    call :clean.bye
    
    :uefi3264bit
    cd /d "%bindir%"
        call :checkdisktype
        if "%virtualdisk%"=="true" goto :external.pe
        if "%harddisk%"=="true" goto :external.pe
        if "%usb%"=="true" goto :removable.pe
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
    rem >> open Configuration BCD file...
    if "%secureboot%"=="n" (
        set "source=%ducky%\EFI\Microsoft\Boot\bcd"
    ) else (
        set "source=%bindir%\secureboot\EFI\Microsoft\Boot\bcd"
    )
    echo.
    echo ^*               Source^: %source%
    "%bindir%\bootice.exe" /edit_bcd /easymode /file="%source%"
    rem >> copy Configuration BCD file to the destination...
    if not "%secureboot%"=="n" (
        call "%bindir%\bcdautoset.bat"
        %partassist% /hd:%disk% /whide:%securepart% /src:%source% /dest:EFI\Microsoft\Boot
    )
    call :colortool
    call :clean.bye
exit /b 0

:editwinsetupfromUSB
    if not exist "%ducky%\WINSETUP\" (
        color 4f & echo.
        echo ^>^> Please install winsetup module before running me
        timeout /t 15 >nul & exit
    )
    
    :option.winsetup
    echo                ^	^>^> WINSETUP BOOT MANAGER EDITOR  ^<^<
    echo                -------------------------------------
    echo.
    set mode=
    set /P mode= ^*              [ 1 ] Legacy mode - [ 2 ] UEFI mode ^> 
    if "%mode%"=="1" goto :legacy.winsetup
    if "%mode%"=="2" goto :uefi.winsetup
    color 4f & echo. & echo ^>^>  Invalid Input. & timeout /t 15 >nul & goto :option.winsetup
    
    :legacy.winsetup
    "%bindir%\bootice.exe" /edit_bcd /easymode /file=%ducky%\BOOT\bcd
    call :clean.bye
    
    :uefi.winsetup
    "%bindir%\bootice.exe" /edit_bcd /easymode /file=%ducky%\EFI\MICROSOFT\Boot\bcd
    call :clean.bye
exit /b 0

:fixbootloader
    cd /d "%ducky%\BOOT"
        if exist "secureboot" (
            for /f "tokens=*" %%b in (secureboot) do set "secureboot=%%b"
        )
    cd /d "%ducky%"
        if exist boot (ren boot BOOT > nul)
    cd /d "%ducky%\boot"
        if exist grub_old (rename grub_old grub)
        if exist efi (rename efi EFI > nul)
    cd /d "%ducky%\EFI"
        if exist boot (rename boot BOOT > nul)
        if exist microsoft (rename microsoft MICROSOFT > nul)
    if exist "%ducky%\WINSETUP" (
        goto :winsetup.fix
    ) else (
        goto :grub.fix
    )
    
    :winsetup.fix
    cd /d "%ducky%\efi\boot"
        copy /y backup\WinSetup\winsetupx64.efi %ducky%\efi\boot\ > nul
        copy /y backup\WinSetup\winsetupia32.efi %ducky%\efi\boot\ > nul
        xcopy /y /q /h /r %ducky%\BOOT\grub\menu.lst %ducky%\ > nul
        if exist %ducky%\winsetup.lst (del /S /Q /F %ducky%\winsetup.lst > nul)
    
    :grub.fix
    echo.
    choice /c yn /cs /n /m "%_lang0837_%"
        if errorlevel 2 goto :grub2.fix
        if errorlevel 1 goto :grub4dos.fix
    
    :grub4dos.fix
    cd /d "%bindir%"
        7za x "wget.7z" -o"%tmp%" -aoa -y >nul
    cd /d "%tmp%"
        wget -q -O g4dtemp.log  http://grub4dos.chenall.net > nul
        for /f "tokens=2,3 delims=/" %%a in ('type "g4dtemp.log" ^| findstr /i "<h1.*.7z" ^| find /n /v "" ^| find "[1]"') do (
                set "ver=%%b"
                set "sourcelink=http://dl.grub4dos.chenall.net/%%b.7z"
        )
        echo ^  Updating %ver%...
        wget -q -O grub4dos.7z %sourcelink% >nul
        del g4dtemp.log
    cd /d "%bindir%\extra-modules"
        "%bindir%\7za.exe" e -ogrub4dos -aoa "%tmp%\grub4dos.7z" grub4dos-0.4.6a/grldr grub4dos-0.4.6a/grub.exe grub4dos0.4.6a/grldr_cd.bin >nul
        del /s /q "%tmp%\grub4dos.7z" > nul
        xcopy "grub4dos\grldr" "%ducky%\" /e /g /h /r /y /q > nul
    
    :grub2.fix
    echo.
    choice /c yn /cs /n /m "%_lang0503_%"
        if errorlevel 2 goto :config.fix
        if errorlevel 1 (
        cd /d "%bindir%"
            echo %_lang0504_%
            silentcmd grub2installer.bat MULTIBOOT
            rem wscript invisiblecmd.vbs grub2installer.bat MULTIBOOT
        )
    
    :config.fix
    cd /d "%ducky%\BOOT\"
        for /f "tokens=*" %%b in (lang) do set "lang=%%b"
    cd /d "%ducky%\BOOT\grub\themes"
        for /f "tokens=*" %%b in (theme) do set "gtheme=%%b"
    cd /d "%bindir%\config\"
        call "main.bat"
    cd /d "%ducky%\EFI\Microsoft\Boot"
        call "%bindir%\bcdautoset.bat" bcd
    rem >> install Syslinux Bootloader
    "%bindir%\syslinux.exe" --force --directory /BOOT/syslinux %ducky% %ducky%\BOOT\syslinux\syslinux.bin
    rem >> install Syslinux Bootloader
    if exist "%ducky%\DLC1" (
    "%bindir%\syslinux.exe" --force --directory /DLC1/Boot %ducky% %ducky%\DLC1\Boot\syslinux.bin
    )
    rem --------------------------------------------------------------------
    "%bindir%\7za.exe" x "%bindir%\config\%lang%.7z" -o"%ducky%\" -aoa -y > nul
    cd /d "%bindir%\extra-modules"
        "%bindir%\7za.exe" x "grub2-filemanager.7z" -o"%ducky%\BOOT\grub\" -aoa -y >nul
        >"%ducky%\BOOT\grub\lang.sh" (echo export lang=%langfm%;)
    rem set "source=%bindir%\secureboot"
    rem if not "%secureboot%"=="n" (
    rem     %partassist% /hd:%disk% /whide:0 /src:%source% /dest:
    rem ) else (
    rem     cd /d "%bindir%"
    rem         xcopy "secureboot" "%ducky%\" /e /g /h /r /y /q > nul
    rem )
    call :clean.bye
exit /b 0

:grub2-filemanager
    cls
    echo.
    echo ^> Downloading grub2-filemanager...
    cd /d "%bindir%\extra-modules"
        "%bindir%\7za.exe" x "%bindir%\curl.7z" -o"%tmp%" -aos -y > nul
        "%tmp%\curl\curl.exe" -L -s -o master.zip https://github.com/a1ive/grub2-filemanager/archive/master.zip
        "%bindir%\7za.exe" x "%bindir%\extra-modules\master.zip" -o"%bindir%\extra-modules\" -y >nul
        del "master.zip" /s /q /f >nul
    cd /d "%bindir%\extra-modules\grub2-filemanager-master\boot\
        xcopy "grub" "%bindir%\extra-modules\grub2-filemanager\" /e /y /q >nul
    cd /d "%bindir%\extra-modules\"
        rmdir "grub2-filemanager-master" /s /q >nul
    
    echo.
    echo ^> Setting grub2-filemanager config...
    rem > insert backdoor
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
    
    rem >> store grub2-filemanager to archive
    cd /d "%bindir%\extra-modules"
        "%bindir%\7za.exe" a grub2-filemanager.7z .\grub2-filemanager\* >nul
        if exist "grub2-filemanager" (rd /s /q "grub2-filemanager" >nul)
        if "%offline%"=="0" call :clean.bye
        echo.
        echo ^> Updating grub2-filemanager to MultibootUSB...
        "%bindir%\7za.exe" x "grub2-filemanager.7z" -o"%ducky%\BOOT\grub\" -aoa -y >nul
        timeout /t 3 >nul
        call :clean.bye
exit /b 0

:setdefaultboot
    cd /d "%ducky%\BOOT"
        if not exist "secureboot" goto :option.default
        for /f "tokens=*" %%b in (secureboot) do set "secureboot=%%b"
        set "Grub2=%bindir%\secureboot\EFI\Boot\backup\Grub2"
        set "rEFInd=%bindir%\secureboot\EFI\Boot\backup\rEFInd"
        set "WinPE=%bindir%\secureboot\EFI\Boot\backup\WinPE"
    
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
    set /P mode= %_lang0905_% ^> 
        if "%mode%"=="1" set "option=Secure_rEFInd" & goto :checkdisk.default
        if "%mode%"=="2" set "option=Secure_Grub2" & goto :checkdisk.default
        if "%mode%"=="3" set "option=rEFInd" & goto :checkdisk.default
        if "%mode%"=="4" set "option=Grub2" & goto :checkdisk.default
        color 4f & echo. & echo %_lang0104_% & timeout /t 15 >nul & goto :option.default
    
    :checkdisk.default
    cd /d "%bindir%"
        call :checkdisktype
        if "%virtualdisk%"=="true" goto :external.default
        if "%harddisk%"=="true" goto :option.default
        if "%usb%"=="true" goto :removable.default
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
    if "%option%"=="Secure_Grub2" cls & goto :option.default
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
            if exist bootx64.efi (del bootx64.efi /s /f /q >nul)
            if exist bootia32.efi (del bootia32.efi /s /f /q >nul)
    )
    if "%option%"=="Secure_Grub2" (
        %partassist% /hd:%disk% /whide:%securepart% /src:%WinPE% /dest:\EFI\BOOT
        %partassist% /hd:%disk% /whide:%refindpart% /src:%Grub2% /dest:\EFI\BOOT
    )
    if "%option%"=="rEFInd" (
        %partassist% /hd:%disk% /unhide:%securepart%
        %partassist% /hd:%disk% /setletter:%securepart% /letter:X
        cd /d "X:\EFI\BOOT\"
            if exist bootx64.efi (del bootx64.efi /s /f /q >nul)
            if exist bootia32.efi (del bootia32.efi /s /f /q >nul)
            if exist winpeia32.efi (del winpeia32.efi /s /f /q >nul)
            if exist winpex64.efi (del winpex64.efi /s /f /q >nul)
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
    rem >> Preparing files...
    cd /d "%ducky%\BOOT"
        for /f "tokens=*" %%b in (lang) do set "lang=%%b"
        echo. & echo ^>^>  Current language: %lang%
        for /f "tokens=*" %%b in (rEFInd) do set "rtheme=%%b"
            if not defined rtheme (
                set rtheme=Universe
            ) else (
                echo. & echo %_lang0400_% %rtheme%
            )
        if exist secureboot (
            for /f "tokens=*" %%b in (secureboot) do set "secureboot=%%b"
        )
    
    cd /d "%ducky%\BOOT\grub\themes"
        for /f "tokens=*" %%b in (theme) do set "gtheme=%%b"
            if not defined gtheme (
                set gtheme=Breeze-5
            ) else (
                echo. & echo ^>^>  %_lang0300_% %gtheme%
            )
    
    cd /d "%bindir%"
        7za x "grub2.7z" -o"%tmp%" -aos -y >nul
        7za x "rEFInd_themes\%rtheme%.7z" -o"%tmp%\rEFInd_themes" -aoa -y > nul
        7za x "refind.7z" -o"%tmp%" -aoa -y > nul
    
    echo.
    echo ---------------------------------------------------------------------
    echo.          [ 1 ] Update config only   [ 2 ] Update full data
    echo ---------------------------------------------------------------------
    echo.
    choice /c 123 /cs /n /m "#   Choose your option [ ? ] > "
        if errorlevel 2 goto :updatefull
        if errorlevel 1 goto :updateconfig
    
    :updatefull
    cd /d "%bindir%"
        echo. & echo ^> Updating data...
        "%bindir%\7za.exe" x "data.7z" -o"%ducky%\" -aoa -y >nul
        xcopy /y "version" "%ducky%\EFI\BOOT\" > nul
    cd /d "%bindir%"
        7za x "wincdemu.7z" -o"%ducky%\ISO\" -aoa -y >nul
    cd /d "%bindir%\secureboot\BOOT"
        xcopy "boot.sdi" "%ducky%\BOOT\" /e /g /h /r /y /q > nul
    cd /d "%bindir%\extra-modules"
        xcopy "grub4dos\grldr" "%ducky%\" /e /g /h /r /y /q >nul
    cd /d "%bindir%\extra-modules"
        "%bindir%\7za.exe" x "grub2-filemanager.7z" -o"%ducky%\BOOT\grub\" -aoa -y > nul
    
    rem >> install Syslinux Bootloader
    cd /d "%bindir%"
        syslinux --force --directory /BOOT/syslinux %ducky% %ducky%\BOOT\syslinux\syslinux.bin
    
    rem >> install grub2 Bootloader
    cd /d "%bindir%"
        echo.
        echo %_lang0116_%
        silentcmd grub2installer.bat MULTIBOOT
    cd /d "%bindir%"
        7za x "%bindir%\config\%lang%.7z" -o"%ducky%\" -aoa -y > nul
    cd /d "%tmp%\rEfind_themes\%rtheme%\icons"
        copy "grubx64.png" "%ducky%\EFI\BOOT\grubx64.png" > nul
        copy "grubx64.png" "%ducky%\EFI\BOOT\grubia32.png" > nul
        copy "winsetupx64.png" "%ducky%\EFI\BOOT\winsetupx64.png" > nul
        copy "winsetupx64.png" "%ducky%\EFI\BOOT\winsetupia32.png" > nul
        copy "xorbootx64.png" "%ducky%\EFI\BOOT\xorbootx64.png" > nul
    cd /d "%tmp%\rEfind_themes\%rtheme%\icons"
        xcopy "others" "%ducky%\EFI\BOOT\" /e /g /h /r /y /q > nul
    cd /d "%bindir%"
        7za x "%bindir%\grub2_themes\%gtheme%.7z" -o"%ducky%\BOOT\grub\themes\" -aoa -y > nul
    cd /d "%ducky%\EFI\Microsoft\Boot"
        call "%bindir%\bcdautoset.bat" bcd
    
    :updateconfig
    cd /d "%bindir%\config"
        call "main.bat"
        timeout /t 2 >nul
        call :clean.bye
exit /b 0

:unhidedatapartition
    %partassist% /list
    echo.
    set /p disk= %_lang0101_%
    set /a disk=%disk%+0
    cd /d "%bindir%"
        call :checkdisktype
        if "%virtualdisk%"=="true"  goto :continue.unhide
        if "%harddisk%"=="true"     goto :unhidedatapartition
        if "%usb%"=="true"          goto :continue.unhide
        if "%externaldisk%"=="true" goto :continue.unhide
        color 4f & echo. & echo %_lang0104_% & timeout /t 15 > nul & goto :unhidedatapartition
    
    :continue.unhide
    for /f %%b in ('wmic volume get driveletter^, label ^| findstr /i "MULTIBOOT"') do set "ducky=%%b"
        set /a partition=0
        if exist "%ducky%\EFI\BOOT\mark" (
            goto :break.unhide
        ) else (
            goto :unhidepartition
        )
    
    :unhidepartition
    %partassist% /hd:%disk% /unhide:%partition%
    %partassist% /hd:%disk% /setletter:%partition% /letter:auto
    for /f %%b in ('wmic volume get driveletter^, label ^| findstr /i "MULTIBOOT"') do set "ducky=%%b"
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
    cd /d "%bindir%"
        7za x "driveprotect.7z" -o"%tmp%" -aos -y > nul
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
    cls & echo.
    echo ^>^> Cleaning up trash, wait a minute...
    echo.
    cd /d "%tmp%"
        del "%tmp%\*.*" /s /q /f > nul
        for /d %%i in ("%tmp%\*.*") do rmdir "%%i" /s /q >nul
        cls
    cd /d "%bindir%"
        7za x "qemu.7z" -o"%tmp%" -aoa -y > nul
    cd /d "%tmp%"
        start qemuboottester.exe
        exit
exit /b 0

:cloverinstaller
    if "%PROCESSOR_ARCHITECTURE%"=="x86" (
        set gdisk=gdisk32.exe
        ) else (
        set gdisk=gdisk64.exe
    )
    for /f "tokens=4 delims=\" %%b in ('wmic os get name') do set "harddisk=%%b"
        set "harddisk=%harddisk:~8,1%"
        set /a "harddisk=%harddisk%+0"
    for /f "tokens=2" %%b in ('wmic path Win32_diskpartition get type ^, diskindex ^| find /i "%harddisk%"') do set "GPT=%%b"
        if /i "%GPT%" NEQ "GPT:" (
            color 4f & echo. & echo %_lang0001_%
            echo %_lang0002_%
            set structure=MBR
            timeout /t 15 >nul
        )
    
    :clover
    cls 
    call :cloverinterface
    choice /c yn /cs /n /m "%_lang0700_% > "
        if errorlevel 2 goto :cloverconfig
        if errorlevel 1 goto :download.clover
    
    :download.clover
    cd /d "%bindir%"
        mkdir clover
        7za x "clover.7z" -o"clover" -aoa -y >nul
        7za x "wget.7z" -o"%tmp%" -aoa -y >nul
    rem >> get clover iso file
    cd /d "%tmp%"
        rem get the lastest version name
        set "sourcelink=https://sourceforge.net/projects/cloverefiboot/files/Bootable_ISO/"
        wget -q -O "clover.log" %sourcelink%
        for /f delims^=^"^ tokens^=2  %%a in ('type "clover.log" ^| findstr /i "<tr.*.lzma" ^| find /n /v "" ^| find "[1]"') do (set "name=%%a") >nul
        rem download clover
        cls
        call :cloverinterface
        echo ^>^> downloading %name%...
        set "sourcelink=https://sourceforge.net/projects/cloverefiboot/files/Bootable_ISO/%name%/download"
        wget -q --show-progress -O "%name%" %sourcelink%
        del "clover.log" /s /q /f >nul
        rem extract clover iso
        if exist "*CloverISO*.tar.lzma" (
            "%bindir%\7za.exe" x "*CloverISO*.tar.lzma" -o"%tmp%" -y >nul
            del "*CloverISO*.tar.lzma" /s /q /f >nul
            "%bindir%\7za.exe" x "*CloverISO*.tar" -o"%tmp%" -y >nul
            del "*CloverISO*.tar" /s /q /f >nul
            ren Clover-*.iso clover.iso
        )
    rem >> mount clover iso and copy file
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
    rem >> delete non-necessary file
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
    rem make config for clover
    call "%bindir%\config\clover.conf.bat"
    rem use rEFInd driver for clover
    "%bindir%\7za.exe" x "%bindir%\refind.7z" -o"%tmp%" -aoa -y >nul
    if exist "%tmp%\rEFInd\drivers_x64" (
        xcopy "%tmp%\rEFInd\drivers_x64" "%bindir%\clover\drivers64UEFI" /s /z /y /q >nul
    )
    
    cd /d "%tmp%"
        if exist "EFI" (rd /s /q "EFI")
        if exist "clover.iso" (del /s /q "clover.iso" >nul)
    
    rem cd /d "%tmp%" & del "%tmp%\*.*" /s /q /f >nul
    rem for /d %%i in ("%tmp%\*.*") do rmdir "%%i" /s /q >nul
    
    rem >> store clover to archive
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
    7za x "gdisk.7z" -o"%tmp%" -aos -y > nul
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
    if "%offline%"=="1" goto :option.clover
    call :colortool
    echo.
    echo %_lang0712_%
    cd /d "%ducky%\BOOT\"
        for /f "tokens=*" %%b in (rEFInd) do set "rtheme=%%b"
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
        cls & color 4f & echo.
        echo %_lang0713_% & timeout /t 15 >nul & goto :option.clover
    )
    echo.
    choice /c yn /cs /n /m "%_lang0714_%"
        if errorlevel 2 goto :option.clover
        if errorlevel 1 call :colortool
    rem installing Clover to ESP
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
rem clover function
:cloverinterface
    echo.
    echo ----------------------------------------------------------------------
    echo                          ^> Clover Installer ^<                       
    echo ----------------------------------------------------------------------
    echo.
exit /b 0

:rEFIndinstaller
    for /f "tokens=4 delims=\" %%b in ('wmic os get name') do set "harddisk=%%b"
        set "harddisk=%harddisk:~8,1%"
        set /a "harddisk=%harddisk%+0"
    for /f "tokens=2" %%b in ('wmic path Win32_diskpartition get type ^, diskindex ^| find /i "%harddisk%"') do set "GPT=%%b"
        if /i "%GPT%" NEQ "GPT:" (
            color 4f & echo. & echo %_lang0001_%
            echo %_lang0002_%
            set "structure=MBR"
            timeout /t 15 >nul
        )
    
    cd /d "%ducky%\BOOT\"
        for /f "tokens=*" %%b in (secureboot) do set "secureboot=%%b"
    
    :refind
    call :rEFIndinterface
    choice /c yn /cs /n /m "%_lang0600_% > "
        if errorlevel 2 goto :option.rEFInd
        if errorlevel 1 goto :download.rEFInd
    
    :download.rEFInd
    cd /d "%bindir%"
        if not exist rEFInd mkdir rEFInd
        7za x "wget.7z" -o"%tmp%" -aoa -y >nul
    cd /d "%tmp%"
        rem >> download the last rEFInd
        set "sourcelink=https://sourceforge.net/projects/refind/files/latest/download"
        wget -q --show-progress -O refind-bin.zip %sourcelink%
        rem >> extract data
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
        rename "refind_ia32.efi" "bootia32.efi"
        rename "refind_x64.efi" "bootx64.efi"
    
    cd /d "%tmp%\refind-bin"
        xcopy "refind" "%bindir%\rEFInd\" /s /z /y /q
        call "%bindir%\config\refind.conf.bat"
    
    cd /d "%tmp%"
        if exist "refind-bin" (rd /S /Q "refind-bin" >nul)
    
    rem >> store refind to archive
    cd /d "%bindir%"
        7za a refind.7z rEFInd\ -sdel >nul
        if exist "rEFInd" (rd /s /q "rEFInd" >nul)
    
    :option.rEFInd
    set "rtheme=Universe"
    rem preparing file...
    if not exist rEFInd_themes (mkdir rEFInd_themes)
    cd /d "%tmp%"
        "%bindir%\7za.exe" x "%bindir%\refind.7z" -o"%tmp%" -aoa -y >nul
        "%bindir%\7za.exe" x "%bindir%\rEFInd_themes\%rtheme%.7z" -o"rEFInd_themes" -aoa -y >nul
    rem make option
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
    if "%offline%"=="1" goto :option.rEFInd
    rem detected USB
    wmic diskdrive get name, mediatype | find /i "Removable Media" | find /i "\\.\physicaldrive%disk%" > nul
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
        cls & color 4f & echo.
        echo %_lang0608_% & timeout /t 15 >nul & goto :option.rEFInd
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
rem >> rEFInd functions
:rEFIndinterface
    call :colortool
    echo.
    echo ----------------------------------------------------------------------
    echo                          ^> rEFInd Installer ^<                       
    echo ----------------------------------------------------------------------
    echo.
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

:clean.bye
cd /d "%bindir%"
    call colortool.bat
    for /f "delims=" %%f in (hide.list) do (
        if exist "%ducky%\%%f" (attrib +s +h "%ducky%\%%f")
        if exist "%ducky%\ISO\%%f" (attrib +s +h "%ducky%\ISO\%%f")
        if exist "%ducky%\WIM\%%f" (attrib +s +h "%ducky%\WIM\%%f")
    )
cd /d "%tmp%\partassist"
    if "%processor_architecture%"=="x86" (
        SetupGreen32.exe -u > nul
        LoadDrv_Win32.exe -u > nul
    ) else (
        SetupGreen64.exe -u > nul
        LoadDrv_x64.exe -u > nul
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
    start thanks.vbs
    timeout /t 3 >nul
    del /s /q thanks.vbs >nul
    exit
exit /b 0

rem >> end function

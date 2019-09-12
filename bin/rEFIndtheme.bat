@echo off

rem >> https://niemtin007.blogspot.com
rem >> The batch file is written by niemtin007.
rem >> Thank you for using Multiboot Toolkit.

title %~nx0
pushd "%cd%"

:install
cd /d "%bindir%"
    call colortool.bat
    mode con lines=18 cols=70
echo.
cd /d "%ducky%\BOOT\"
    for /f "tokens=*" %%b in (rEFInd) do set "rtheme=%%b"
    if exist secureboot (
        for /f "tokens=*" %%b in (secureboot) do set "secureboot=%%b"
    )
echo %_lang0400_% %rtheme%
echo ======================================================================
echo 01 = Apocalypse   12 = CloverBootcamp 23 = GoldClover  34 = Pandora   
echo 02 = BGM          13 = Clovernity     24 = Gothic      35 = Red       
echo 03 = BGM256       14 = Clover-X       25 = HighSierra  36 = Shield    
echo 04 = black        15 = CrispyOSX      26 = HMF         37 = SimpleGrey
echo 05 = Bluemac      16 = Crystal        27 = iclover     38 = Simplicity
echo 06 = Buttons      17 = Dark           28 = Leather     39 = Smooth    
echo 07 = Carbon       18 = DarkBoot       29 = MacOSX      40 = Sphere    
echo 08 = Catalina     19 = DarkBootX      30 = MavsStyle   41 = Universe  
echo 09 = Chrome       20 = ElCapitan      31 = Mojave      42 = Woody     
echo 10 = Circla       21 = Emerald        32 = Neon                       
echo 11 = ClassicMacOS 22 = Glassy         33 = Oceanix                    
echo ======================================================================
echo.
set /P ask= %_lang0401_% [ ? ]  = 
if "%ask%"=="1" (set "rtheme=Apocalypse" & goto :continue)
if "%ask%"=="2" (set "rtheme=BGM" & goto :continue)
if "%ask%"=="3" (set "rtheme=BGM256" & goto :continue)
if "%ask%"=="4" (set "rtheme=black" & goto :continue)
if "%ask%"=="5" (set "rtheme=Bluemac" & goto :continue)
if "%ask%"=="6" (set "rtheme=Buttons" & goto :continue)
if "%ask%"=="7" (set "rtheme=Carbon" & goto :continue)
if "%ask%"=="8" (set "rtheme=Catalina" & goto :continue)
if "%ask%"=="9" (set "rtheme=Chrome" & goto :continue)
if "%ask%"=="10" (set "rtheme=Circla" & goto :continue)
if "%ask%"=="11" (set "rtheme=ClassicMacOS" & goto :continue)
if "%ask%"=="12" (set "rtheme=CloverBootcamp" & goto :continue)
if "%ask%"=="13" (set "rtheme=Clovernity" & goto :continue)
if "%ask%"=="14" (set "rtheme=Clover-X" & goto :continue)
if "%ask%"=="15" (set "rtheme=CrispyOSX" & goto :continue)
if "%ask%"=="16" (set "rtheme=Crystal" & goto :continue)
if "%ask%"=="17" (set "rtheme=Dark" & goto :continue)
if "%ask%"=="18" (set "rtheme=DarkBoot" & goto :continue)
if "%ask%"=="19" (set "rtheme=DarkBootX" & goto :continue)
if "%ask%"=="20" (set "rtheme=ElCapitan" & goto :continue)
if "%ask%"=="21" (set "rtheme=Emerald" & goto :continue)
if "%ask%"=="22" (set "rtheme=Glassy" & goto :continue)
if "%ask%"=="23" (set "rtheme=GoldClover" & goto :continue)
if "%ask%"=="24" (set "rtheme=Gothic" & goto :continue)
if "%ask%"=="25" (set "rtheme=HighSierra" & goto :continue)
if "%ask%"=="26" (set "rtheme=HMF" & goto :continue)
if "%ask%"=="27" (set "rtheme=iclover" & goto :continue)
if "%ask%"=="28" (set "rtheme=Leather" & goto :continue)
if "%ask%"=="29" (set "rtheme=MacOSX" & goto :continue)
if "%ask%"=="30" (set "rtheme=MavsStyle" & goto :continue)
if "%ask%"=="31" (set "rtheme=Mojave" & goto :continue)
if "%ask%"=="32" (set "rtheme=Neon" & goto :continue)
if "%ask%"=="33" (set "rtheme=Oceanix" & goto :continue)
if "%ask%"=="34" (set "rtheme=Pandora" & goto :continue)
if "%ask%"=="35" (set "rtheme=Red" & goto :continue)
if "%ask%"=="36" (set "rtheme=Shield" & goto :continue)
if "%ask%"=="37" (set "rtheme=SimpleGrey" & goto :continue)
if "%ask%"=="38" (set "rtheme=Simplicity" & goto :continue)
if "%ask%"=="39" (set "rtheme=Smooth" & goto :continue)
if "%ask%"=="40" (set "rtheme=Sphere" & goto :continue)
if "%ask%"=="41" (set "rtheme=Universe" & goto :continue)
if "%ask%"=="42" (set "rtheme=Woody" & goto :continue)
color 4f & echo. & echo %_lang0003_% & timeout /t 15 >nul & goto :install
:continue
cd /d "%bindir%"
    call colortool.bat
cd /d "%tmp%"
    if not exist rEFInd_themes (mkdir rEFInd_themes)
cd /d "%bindir%"
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

rem >> check Virtual Disk
wmic diskdrive get name, model | find /i "Msft Virtual Disk SCSI Disk Device" | find /i "\\.\physicaldrive%disk%" >nul
    if not errorlevel 1 set "virtualdisk=true" & goto :External
wmic diskdrive get name, model | find /i "Microsoft Virtual Disk" | find /i "\\.\physicaldrive%disk%" >nul
    if not errorlevel 1 set "virtualdisk=true" & goto :External
rem >> check Internal Hard Drives
wmic diskdrive get name, mediatype | find /i "Fixed hard disk media" | find /i "\\.\physicaldrive%disk%" >nul
    if not errorlevel 1 (
        echo. & echo. & echo %_lang0102_%
        color 4f & echo %_lang0103_% & timeout /t 15 >nul & cls & goto :EOF
    )
rem >> check USB disk
wmic diskdrive get name, mediatype | find /i "Removable Media" | find /i "\\.\physicaldrive%disk%" >nul
    if not errorlevel 1 set "usb=true" & goto :Removable
rem >> check External Portable Hard Drives
wmic diskdrive get name, mediatype | find /i "External hard disk media" | find /i "\\.\physicaldrive%disk%" >nul
    if not errorlevel 1 goto :External

:Removable
if "%secureboot%"=="n" (
    set refindpart=1
    goto :installtheme
) else (
    set refindpart=2
    set securepart=1
    goto :installtheme
)
:External
if "%secureboot%"=="n" (
    set refindpart=0
    goto :installtheme
) else (
    set refindpart=1
    set securepart=0
    goto :installtheme
)
:installtheme
rem >> Install rEFind theme
set "source=%tmp%\rEFInd_themes\%rtheme%"
%partassist% /hd:%disk% /whide:%refindpart% /src:%source% /dest:EFI\BOOT\themes
rem >> Copy icon to secure boot partition
set "source=%tmp%\rEFInd_themes\%rtheme%\icons\others"
if not "%secureboot%"=="n" (
    %partassist% /hd:%disk% /whide:%securepart% /src:%source% /dest:EFI\BOOT
)
call "%bindir%\exit.bat"


















































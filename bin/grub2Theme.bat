@echo off

rem >> https://niemtin007.blogspot.com
rem >> The batch file is written by niemtin007.
rem >> Thank you for using Multiboot Toolkit.

title %~nx0

:install
cd /d "%bindir%"
    call colortool.bat
echo.
cd /d "%ducky%\BOOT\grub\themes"
    for /f "tokens=*" %%b in (theme) do set "gtheme=%%b"
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
if "%ask%"=="1"  (set "gtheme=Aero" & goto :continue)
if "%ask%"=="2"  (set "gtheme=Air_Vision" & goto :continue)
if "%ask%"=="3"  (set "gtheme=Alienware" & goto :continue)
if "%ask%"=="4"  (set "gtheme=Archlinux" & goto :continue)
if "%ask%"=="5"  (set "gtheme=Ask-larry" & goto :continue)
if "%ask%"=="6"  (set "gtheme=Aurora" & goto :continue)
if "%ask%"=="7"  (set "gtheme=Axiom" & goto :continue)
if "%ask%"=="8"  (set "gtheme=Bluec4d" & goto :continue)
if "%ask%"=="9"  (set "gtheme=Breeze-1" & goto :continue)
if "%ask%"=="10" (set "gtheme=Breeze_dark" & goto :continue)
if "%ask%"=="11" (set "gtheme=Breeze-5" & goto :continue)
if "%ask%"=="12" (set "gtheme=Dark_Colors" & goto :continue)
if "%ask%"=="13" (set "gtheme=Dark_squares" & goto :continue)
if "%ask%"=="14" (set "gtheme=Devuan" & goto :continue)
if "%ask%"=="15" (set "gtheme=Eternity" & goto :continue)
if "%ask%"=="16" (set "gtheme=FagiadaBue" & goto :continue)
if "%ask%"=="17" (set "gtheme=Gentoo" & goto :continue)
if "%ask%"=="18" (set "gtheme=Grau" & goto :continue)
if "%ask%"=="19" (set "gtheme=Huayra-limbo" & goto :continue)
if "%ask%"=="20" (set "gtheme=Journey" & goto :continue)
if "%ask%"=="21" (set "gtheme=Monochrome" & goto :continue)
if "%ask%"=="22" (set "gtheme=Oxygen" & goto :continue)
if "%ask%"=="23" (set "gtheme=Plasma-dark" & goto :continue)
if "%ask%"=="24" (set "gtheme=Powerman" & goto :continue)
if "%ask%"=="25" (set "gtheme=RainbowDash" & goto :continue)
if "%ask%"=="26" (set "gtheme=Raindrops" & goto :continue)
if "%ask%"=="27" (set "gtheme=SolarizedDark" & goto :continue)
if "%ask%"=="28" (set "gtheme=Solstice" & goto :continue)
if "%ask%"=="29" (set "gtheme=Steam" & goto :continue)
if "%ask%"=="30" (set "gtheme=StylishDark" & goto :continue)
if "%ask%"=="31" (set "gtheme=Tela" & goto :continue)
if "%ask%"=="32" (set "gtheme=Ubuntu-lucid" & goto :continue)
color 4f & echo. & echo %_lang0003_% & timeout /t 15 >nul & goto :install

:continue
if not exist "%ducky%\BOOT\grub\themes\%gtheme%" (
    "%bindir%\7za.exe" x "%bindir%\grub2_themes\%gtheme%.7z" -o"%ducky%\BOOT\grub\themes\" -aoa -y >nul
)

>"%ducky%\BOOT\grub\themes\theme" (echo %gtheme%)
for /f "tokens=*" %%b in (%ducky%\BOOT\lang) do set "lang=%%b"
call "%bindir%\config\main.bat"
call "%bindir%\exit.bat"


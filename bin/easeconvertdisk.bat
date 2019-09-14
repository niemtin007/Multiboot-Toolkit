@echo off

rem >> https://niemtin007.blogspot.com
rem >> The batch file is written by niemtin007.
rem >> Thank you for using Multiboot Toolkit.

title %~nx0
cd /d "%bindir%"
mode con lines=15 cols=70

:Select
call "%bindir%\colortool.bat"
%partassist% /list
echo. & set /p disk= %_lang0101_%
set /a disk=%disk%+0
call :check.partitiontable
call :check.virtualdisk
    if "%virtualdisk%"=="true" goto :option
call :check.harddisk
    if "%harddisk%"=="true" goto :Select
call :check.usbdisk
    if "%usb%"=="true" goto :option
call :check.externaldisk
    if "%externaldisk%"=="true" goto :option
color 4f & echo. & echo %_lang0104_% & timeout /t 15 > nul & goto :Select

:option
cd /d "%bindir%"
    call colortool.bat
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
echo                                WARNING^!
echo ---------------------------------------------------------------------
echo    These features will delete all partition on your External Drive
echo     Please backup your data on the External Drive before continue
echo.
echo               [ 1 ] Press 1 to Initialize a disk as GPT
echo               [ 2 ] Press 2 to Initialize a disk as MBR
echo ---------------------------------------------------------------------
echo.
choice /c 12 /cs /n /m "*  %_lang0905_% [ ? ] = "
    if errorlevel 1 set "option=1"
    if errorlevel 2 set "option=2"
    rem do not change the errorlevel order in the two lines above
    taskkill /f /im wscript.exe /t /fi "status eq running">nul
    del /s /q "%tmp%\warning.vbs" >nul
echo.
choice /c yn /cs /n /m "*  Do you understand the warning? [ y/n ] > "
    if errorlevel 2 goto :option
    if errorlevel 1 goto :continue
:continue
for /l %%i in (5,-1,0) do (
    cls & echo.
    echo ^> Goodbye your data in %%i seconds...
    timeout /t 1 >nul
)
if "%option%"=="1" cls & goto :GPT
if "%option%"=="2" cls & goto :MBR

:GPT
%partassist% /hd:%disk% /del:all
%partassist% /init:%disk% /gpt
timeout /t 2 >nul & goto :exit

:MBR
%partassist% /hd:%disk% /del:all
%partassist% /init:%disk%
timeout /t 2 >nul

:exit
call "%bindir%\exit.bat"



rem >> begin functions
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
rem >> end functions

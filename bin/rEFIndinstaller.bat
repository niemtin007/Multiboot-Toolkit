@echo off

rem >> https://niemtin007.blogspot.com
rem >> The batch file is written by niemtin007.
rem >> Thank you for using Multiboot Toolkit.

cd /d "%bindir%"
    call colortool.bat
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
    if errorlevel 2 goto :option
    if errorlevel 1 goto :download

:download
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

:option
set "rtheme=Universe"
rem preparing file...
if not exist rEFInd_themes (mkdir rEFInd_themes)
cd /d "%tmp%"
    "%bindir%\7za.exe" x "%bindir%\refind.7z" -o"%tmp%" -aoa -y >nul
    "%bindir%\7za.exe" x "%bindir%\rEFInd_themes\%rtheme%.7z" -o"rEFInd_themes" -aoa -y >nul
rem make option
cd /d "%bindir%"
    call colortool.bat
echo.
echo ----------------------------------------------------------------------
echo %_lang0603_%
echo %_lang0604_%
echo ----------------------------------------------------------------------
echo.
choice /c 12 /cs /n /m "%_lang0605_% [ ? ] > "
    if errorlevel 2 goto :MultibootOS
    if errorlevel 1 goto :MultibootUSB

:MultibootUSB
if "%offline%"=="1" goto :option
rem detected USB
wmic diskdrive get name, mediatype | find /i "Removable Media" | find /i "\\.\physicaldrive%disk%" > nul
    if not errorlevel 1 (goto :Removable) else (goto :External)
    :Removable
    if "%secureboot%"=="n" (
        set refindpart=1
        goto :installrEFInd
    ) else (
        set refindpart=2
        set securepart=1
        goto :installrEFInd
    )
    :External
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
goto :EasyUEFI

:MultibootOS
if "%structure%"=="MBR" (
    cls & color 4f & echo.
    echo %_lang0608_% & timeout /t 15 >nul & goto :option
)
echo.
choice /c yn /cs /n /m "%_lang0609_%"
    if errorlevel 2 goto :option
    if errorlevel 1 call "%bindir%\colortool.bat"
mountvol s: /s
cd /d "%tmp%"
    xcopy "rEFInd" "s:\EFI\refind\" /e /y /q >nul
    xcopy "rEFInd_themes\%rtheme%" "s:\EFI\rEFInd\themes" /e /y /q >nul
    timeout /t 2 >nul
mountvol s: /d
echo.
echo %_lang0610_%
timeout /t 2 >nul
goto :EasyUEFI

:EasyUEFI
"%bindir%\7za.exe" x "%bindir%\extra-modules\EasyUEFI.7z" -o"%tmp%" -y >nul
call :rEFIndinterface
echo.
choice /c yn /cs /n /m "%_lang0611_%"
    if errorlevel 2 call "%bindir%\exit.bat"
    if errorlevel 1 (
        cd /d "%tmp%\EasyUEFI"
            start EasyUEFIPortable.exe
            call "%bindir%\exit.bat"
    )



:rEFIndinterface
call "%bindir%\colortool.bat"
echo.
echo ----------------------------------------------------------------------
echo                          ^> rEFInd Installer ^<                       
echo ----------------------------------------------------------------------
echo.
exit /b 0

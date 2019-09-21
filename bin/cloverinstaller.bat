@echo off

rem >> https://niemtin007.blogspot.com
rem >> The batch file is written by niemtin007.
rem >> Thank you for using Multiboot Toolkit.

title %~nx0
cd /d "%bindir%"

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
    if errorlevel 1 goto :download

:download
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
call "%bindir%\colortool.bat"
if "%structure%"=="MBR" goto :option
cls 
call :cloverinterface
choice /c yn /cs /n /m "%_lang0702_% > "
    if errorlevel 2 goto :option
    if errorlevel 1 goto :gdisk
:gdisk
cd /d "%bindir%"
    call "colortool.bat"
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

:option
call "%bindir%\colortool.bat"
echo.
echo ----------------------------------------------------------------------
echo %_lang0708_%
echo %_lang0709_%
echo ----------------------------------------------------------------------
echo.
choice /c 12 /cs /n /m "%_lang0605_% [ ? ] > "
    if errorlevel 2 goto :MultibootOS
    if errorlevel 1 goto :MultibootUSB
:MultibootUSB
if "%offline%"=="1" goto :option
call "%bindir%\colortool.bat"
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
goto :EasyUEFI

:MultibootOS
if "%structure%"=="MBR" (
    cls & color 4f & echo.
    echo %_lang0713_% & timeout /t 15 >nul & goto :option
)
echo.
choice /c yn /cs /n /m "%_lang0714_%"
    if errorlevel 2 goto :option
    if errorlevel 1 call "%bindir%\colortool.bat"
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
goto :EasyUEFI

:EasyUEFI
cls
call :cloverinterface
"%bindir%\7za.exe" x "%bindir%\extra-modules\EasyUEFI.7z" -o"%tmp%" -y >nul
echo.
choice /c yn /cs /n /m "%_lang0716_%"
    if errorlevel 2 call "%bindir%\exit.bat"
    if errorlevel 1 (
        cd /d "%tmp%\EasyUEFI"
            start EasyUEFIPortable.exe
            call "%bindir%\exit.bat"
    )




:cloverinterface
echo.
echo ----------------------------------------------------------------------
echo                          ^> Clover Installer ^<                       
echo ----------------------------------------------------------------------
echo.
exit /b 0

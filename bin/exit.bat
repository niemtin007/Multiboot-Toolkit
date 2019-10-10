@echo off

rem >> https://niemtin007.blogspot.com
rem >> The batch file is written by niemtin007.
rem >> Thank you for using Multiboot Toolkit.

> "%tmp%\thanks.vbs" (
    echo Dim Message, Speak
    echo Set Speak=CreateObject^("sapi.spvoice"^)
    echo Speak.Speak "Successful! Thank you for using Multiboot Toolkit"
)

rem >> clean up the trash and exit
cd /d "%bindir%"
    call colortool.bat
    for /f "delims=" %%f in (hide.list) do (
        if exist "%ducky%\%%f" (attrib +s +h "%ducky%\%%f")
        if exist "%ducky%\ISO\%%f" (attrib +s +h "%ducky%\ISO\%%f")
        if exist "%ducky%\WIM\%%f" (attrib +s +h "%ducky%\WIM\%%f")
    )
    if exist "log" (rd /s /q "log" >nul)
    if exist "LogLogInfo.log" (del /s /q "LogLogInfo.log" >nul)
    if exist ".wget-hsts" (del /s /q ".wget-hsts" >nul)
    if exist "MULTIBOOT" (rd /s /q "MULTIBOOT")
cd /d "%tmp%\partassist"
    if "%processor_architecture%"=="x86" (
        SetupGreen32.exe -u > nul
        LoadDrv_Win32.exe -u > nul
    ) else (
        SetupGreen64.exe -u > nul
        LoadDrv_x64.exe -u > nul
    )
cd /d "%tmp%"
    if exist "colortool" (rd /s /q "colortool")
    if exist "grub2" (rd /s /q "grub2" >nul)
    if exist "curl" (rd /s /q "curl" >nul)
    if exist "driveprotect" (rd /s /q "driveprotect" >nul)
    if exist "gdisk" (rd /s /q "gdisk" >nul)
    if exist "rEFInd" (rd /s /q "rEFInd" >nul)
    if exist "rEFInd_themes" (rd /s /q "rEFInd_themes" >nul)
    if exist "partassist" (rd /s /q "partassist" >nul)
    if exist "QemuBootTester" (rd /s /q "QemuBootTester" >nul)
    if exist "hide.vbs" (del /s /q "hide.vbs" >nul)
    if exist "Output.log" (del /s /q "Output.log" >nul)
    if exist "SilentCMD.log" (del /s /q "SilentCMD.log" >nul)
    if exist "qemuboottester.exe" (del /s /q "qemuboottester.exe" >nul)
    if exist "wget.exe" (del /s /q "wget.exe" >nul)
    if exist "wincdemu.exe" (del /s /q "wincdemu.exe" >nul)
cls
echo.
echo %_lang0012_%
echo %_lang0013_%
cd /d "%tmp%" & start thanks.vbs
timeout /t 3 >nul
del /s /q "%tmp%\thanks.vbs" >nul
exit
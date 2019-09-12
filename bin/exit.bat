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
    mode con lines=18 cols=70
    if exist "log" (rd /S /Q "log" >nul)
    if exist "LogLogInfo.log" (del /S /Q "LogLogInfo.log" >nul)
    if exist ".wget-hsts" (del /S /Q ".wget-hsts" >nul)
    if exist "MULTIBOOT" (rd /S /Q "MULTIBOOT")
cd /d "%tmp%\partassist"
    if "%processor_architecture%"=="x86" (
        SetupGreen32.exe -u > nul
        LoadDrv_Win32.exe -u > nul
    ) else (
        SetupGreen64.exe -u > nul
        LoadDrv_x64.exe -u > nul
    )
cd /d "%tmp%"
    if exist "colortool" (rd /S /Q "colortool")
    if exist "grub2" (rd /S /Q "grub2" >nul)
    if exist "curl" (rd /S /Q "curl" >nul)
    if exist "driveprotect" (rd /S /Q "driveprotect" >nul)
    if exist "gdisk" (rd /S /Q "gdisk" >nul)
    if exist "rEFInd" (rd /S /Q "rEFInd" >nul)
    if exist "rEFInd_themes" (rd /S /Q "rEFInd_themes" >nul)
    if exist "partassist" (rd /S /Q "partassist" >nul)
    if exist "QemuBootTester" (rd /S /Q "QemuBootTester" >nul)
    if exist "hide.vbs" (del /S /Q "hide.vbs" >nul)
    if exist "Output.log" (del /S /Q "Output.log" >nul)
    if exist "SilentCMD.log" (del /S /Q "SilentCMD.log" >nul)
    if exist "qemuboottester.exe" (del /S /Q "qemuboottester.exe" >nul)
    if exist "wget.exe" (del /S /Q "wget.exe" >nul)
    if exist "wincdemu.exe" (del /S /Q "wincdemu.exe" >nul)
cls
echo.
echo %_lang0012_%
echo %_lang0013_%
cd /d "%tmp%" & start thanks.vbs
timeout /t 3 >nul
del /s /q "%tmp%\thanks.vbs" >nul
exit
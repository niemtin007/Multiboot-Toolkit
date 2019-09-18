@echo off

rem >> https://niemtin007.blogspot.com
rem >> The batch file is written by niemtin007.
rem >> Thank you for using Multiboot Toolkit.

title %~nx0
mode con lines=15 cols=80
cd /d "%bindir%"
    call colortool.bat
    set "Grub2=%bindir%\secureboot\EFI\Boot\backup\Grub2"
    set "rEFInd=%bindir%\secureboot\EFI\Boot\backup\rEFInd"
    set "WinPE=%bindir%\secureboot\EFI\Boot\backup\WinPE"
cd /d "%ducky%\BOOT"
    if not exist "secureboot" goto :option
    for /f "tokens=*" %%b in (secureboot) do set "secureboot=%%b"

:option
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
    if "%mode%"=="1" set "option=Secure_rEFInd" & goto :checkdisk
    if "%mode%"=="2" set "option=Secure_Grub2" & goto :checkdisk
    if "%mode%"=="3" set "option=rEFInd" & goto :checkdisk
    if "%mode%"=="4" set "option=Grub2" & goto :checkdisk
    color 4f & echo. & echo %_lang0104_% & timeout /t 15 >nul & goto :option

:checkdisk
cd /d "%bindir%"
    call checkdisktype.bat
    if "%virtualdisk%"=="true" goto :External
    if "%harddisk%"=="true" goto :option
    if "%usb%"=="true" goto :Removable
    if "%externaldisk%"=="true" goto :External

:Removable
if "%secureboot%"=="n" (
    set refindpart=1
    goto :nonsecure
) else (
    set refindpart=2
    set securepart=1
    goto :secure
)
:External
if "%secureboot%"=="n" (
    set refindpart=0
    goto :nonsecure
) else (
    set refindpart=1
    set securepart=0
    goto :secure
)
:nonsecure
if "%option%"=="Secure_rEFInd" cls & goto :option
if "%option%"=="Secure_Grub2" cls & goto :option
if "%option%"=="rEFInd" (
    %partassist% /hd:%disk% /whide:%refindpart% /src:%rEFInd% /dest:\EFI\BOOT
)
if "%option%"=="Grub2" (
    %partassist% /hd:%disk% /whide:%refindpart% /src:%Grub2% /dest:\EFI\BOOT
    >"%ducky%\EFI\BOOT\WindowsGrub2" (echo true)
)
call "%bindir%\exit.bat"

:secure
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
call "%bindir%\exit.bat"

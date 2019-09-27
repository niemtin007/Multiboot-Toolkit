@echo off

rem >> https://niemtin007.blogspot.com
rem >> The batch file is written by niemtin007.
rem >> Thank you for using Multiboot Toolkit.

cd /d "%bindir%"
    call colortool.bat
    for /f "tokens=*" %%b in (version) do set /a "cur_version=%%b"
        set /a cur_a=%cur_version:~0,1%
        set /a cur_b=%cur_version:~1,1%
        set /a cur_c=%cur_version:~2,1%

:English
cd /d "%tmp%"
    > welcome.vbs (
        echo Dim Message, Speak
        echo Set Speak=CreateObject^("sapi.spvoice"^)
        echo Speak.Speak "Welcome to Multiboot Toolkit %cur_a%.%cur_b%.%cur_c%"
        echo WScript.Sleep 1
        echo Speak.Speak "Multiboot Toolkit is the open-source software."
        echo Speak.Speak "It's released under General Public Licence."
        echo Speak.Speak "You can use, modify and redistribute if you wish."
        echo Speak.Speak "Choose a default language to continue..."
    )
    echo ^  __  __      _ _   _ _              _     _____         _ _   _ _   
    echo ^ ^|  \/  ^|_  _^| ^| ^|_^(_^) ^|__  ___  ___^| ^|_  ^|_   _^|__  ___^| ^| ^|_^(_^) ^|_ 
    echo ^ ^| ^|\/^| ^| ^|^| ^| ^|  _^| ^| '_ \/ _ \/ _ \  _^|   ^| ^|/ _ \/ _ \ ^| / / ^|  _^|
    echo ^ ^|_^|  ^|_^|\_,_^|_^|\__^|_^|_.__/\___/\___/\__^|   ^|_^|\___/\___/_^|_\_\_^|\__^|
    echo ^                                                                %cur_a%.%cur_b%.%cur_c%
    echo.
    echo ^  License:
    echo ^  Multiboot Toolkit is the open-source software. It's released under
    echo ^  General Public Licence ^(GPL^). You can use, modify and redistribute
    echo ^  if you wish. You can download from my blog niemtin007.blogspot.com
    echo.
    echo ^  ------------------------------------------------------------------
    echo ^  Thanks to Ha Son, Tayfun Akkoyun, anhdv, lethimaivi, Hoang Duch2..
    echo ^  ------------------------------------------------------------------
    start welcome.vbs
    echo.
    echo ^  [ 1 ] = English  [ 2 ] = Vietnam  [ 3 ] = Turkish  [ 4 ] = Chinese
    echo.
    choice /c 1234a /cs /n /m "> Choose a default language [ ? ] = "
        if errorlevel 1 set "lang=English"
        if errorlevel 2 set "lang=Vietnam"
        if errorlevel 3 set "lang=Turkish"
        if errorlevel 4 set "lang=SimplifiedChinese"
        if errorlevel 5 set "lang=autodetect"
    taskkill /f /im wscript.exe /t /fi "status eq running">nul
    del /s /q welcome.vbs >nul

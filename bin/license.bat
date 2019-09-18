@echo off

rem >> https://niemtin007.blogspot.com
rem >> The batch file is written by niemtin007.
rem >> Thank you for using Multiboot Toolkit.

cd /d "%bindir%"
    for /f "tokens=*" %%b in (version) do set /a "cur_version=%%b"
        set /a cur_a=%cur_version:~0,1%
        set /a cur_b=%cur_version:~1,1%
        set /a cur_c=%cur_version:~2,1%

:English
> "%tmp%\welcome.vbs" (
    echo Dim Message, Speak
    echo Set Speak=CreateObject^("sapi.spvoice"^)
    echo Speak.Speak "Welcome to Multiboot Toolkit %cur_a%.%cur_b%.%cur_c%"
    echo WScript.Sleep 1
    echo Speak.Speak "Multiboot Toolkit is the open-source software. It's released under General Public Licence. You can use, modify and redistribute if you wish. Choose a default language to continue..."
)
call colortool.bat
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
cd /d "%tmp%" & start welcome.vbs
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
del /s /q "%tmp%\welcome.vbs" >nul
goto :EOF

:Vietnam
echo.
echo ^  __  __      _ _   _ _              _     _____         _ _   _ _   
echo ^ ^|  \/  ^|_  _^| ^| ^|_^(_^) ^|__  ___  ___^| ^|_  ^|_   _^|__  ___^| ^| ^|_^(_^) ^|_ 
echo ^ ^| ^|\/^| ^| ^|^| ^| ^|  _^| ^| '_ \/ _ \/ _ \  _^|   ^| ^|/ _ \/ _ \ ^| / / ^|  _^|
echo ^ ^|_^|  ^|_^|\_,_^|_^|\__^|_^|_.__/\___/\___/\__^|   ^|_^|\___/\___/_^|_\_\_^|\__^|
echo ^                                                                %cur_a%.%cur_b%.%cur_c%
echo.
echo ^  Giấy phép:
echo ^  Multiboot Toolkit là một sản phẩm mã nguồn mở. Được phát hành dưới
echo ^  giấy phép công cộng ^(GPL^). Bạn có thể sử dụng, tùy chỉnh hoặc phân
echo ^  phối lại nếu muốn. Bạn có thể tải tại blog niemtin007.blogspot.com
echo.
echo ^  ------------------------------------------------------------------
echo ^  Cám ơn Hà Sơn, Tayfun Akkoyun, anhdv, lethimaivi, Hoang Duch2  ...
echo ^  ------------------------------------------------------------------
echo.
echo ^  ^>^> bấm phím bất kỳ để tiếp tục...& timeout /t 15 > nul & cls
goto :EOF

:Turkish
echo.
echo ^  __  __      _ _   _ _              _     _____         _ _   _ _   
echo ^ ^|  \/  ^|_  _^| ^| ^|_^(_^) ^|__  ___  ___^| ^|_  ^|_   _^|__  ___^| ^| ^|_^(_^) ^|_ 
echo ^ ^| ^|\/^| ^| ^|^| ^| ^|  _^| ^| '_ \/ _ \/ _ \  _^|   ^| ^|/ _ \/ _ \ ^| / / ^|  _^|
echo ^ ^|_^|  ^|_^|\_,_^|_^|\__^|_^|_.__/\___/\___/\__^|   ^|_^|\___/\___/_^|_\_\_^|\__^|
echo ^                                                                %cur_a%.%cur_b%.%cur_c%
echo.
echo ^  Lisans:
echo ^  Multiboot Toolkit açık kaynaklı bir yazılımdır. Genel Kamu Lisansı 
echo ^  altında yayımlandı ^(GPL^). Kullanabilir, değiştirebilir ve yeniden 
echo ^  dağıtabilirsiniz. Şuradan indirebilirsiniz niemtin007.blogspot.com
echo.
echo ^  ------------------------------------------------------------------
echo ^  Sayesinde Ha Son, Tayfun Akkoyun, anhdv, lethimaivi, Hoang Duch2..
echo ^  ------------------------------------------------------------------
echo.
echo ^  ^>^> Devam etmek için herhangi bir tuşa basın...& timeout /t 15 > nul & cls
goto :EOF

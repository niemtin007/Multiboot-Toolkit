@echo off

rem >> https://niemtin007.blogspot.com
rem >> The batch file is written by niemtin007.
rem >> Thank you for using Multiboot Toolkit.

cd /d "%~dp0"
    for /f "delims=" %%f in (hide.list) do (
        cd /d "%ducky%\"
        if exist "%%f" (attrib +s +h "%%f")
        cd /d "%ducky%\ISO\"
        if exist "%%f" (attrib +s +h "%%f")
        cd /d "%ducky%\WIM\"
        if exist "%%f" (attrib +s +h "%%f")
        cd /d "%~dp0"
    )
cls

@echo off

rem >> https://niemtin007.blogspot.com
rem >> The batch file is written by niemtin007.
rem >> Thank you for using Multiboot Toolkit.

cd /d "%bindir%"
    for /f "delims=" %%f in (hide.list) do (
        if exist "%ducky%\%%f" (attrib +s +h "%ducky%\%%f")
        if exist "%ducky%\ISO\%%f" (attrib +s +h "%ducky%\ISO\%%f")
        if exist "%ducky%\WIM\%%f" (attrib +s +h "%ducky%\WIM\%%f")
    )


@echo off

set screenresolution=1920x1080
rem set /p screenresolution= Input your screen resolution [ default 1920x1080 ] ^> 
set theme=BGM256
rem set /p theme= Input your theme             [ default BGM256    ] ^> 

cd /d "%bindir%\clover"

> "config.plist" (
echo ^<?xml version="1.0" encoding="UTF-8"?^>
echo ^<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd"^>
echo ^<plist version="1.0"^>
echo   ^<dict^>
echo     ^<key^>GUI^</key^>
echo     ^<dict^>
echo       ^<key^>Language^</key^>
echo       ^<string^>en:0^</string^>
echo       ^<key^>ScreenResolution^</key^>
echo       ^<string^>%screenresolution%^</string^>
echo       ^<key^>Theme^</key^>
echo       ^<string^>%theme%^</string^>
echo       ^<key^>Scan^</key^>
echo       ^<dict^>
echo         ^<key^>Kernel^</key^>
echo         ^<string^>Last^</string^>
echo         ^<key^>Linux^</key^>
echo         ^<true/^>
echo         ^<key^>Legacy^</key^>
echo         ^<false/^>
echo       ^</dict^>
echo     ^</dict^>
echo   ^</dict^>
echo ^</plist^>
)

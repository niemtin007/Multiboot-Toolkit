@echo off

ver | findstr /i "6\.1\." > nul
    if %errorlevel% equ 0 set "windows=7"

if not "%windows%"=="7" chcp 65001 > nul

rem >> code check permissions take from E2B. Thanks to Steve Si.

:check_Permissions
set randname=%random%%random%%random%%random%%random%
md "%windir%\%randname%" 2>nul
if %errorlevel%==0 goto :end
if %errorlevel%==1 (
    echo.& echo ^>^> Please use right click - Run as administrator
    color 4f& timeout /t 15 >nul
    Set ADMIN=FAIL
    goto :end
)
goto :check_Permissions

:end
rd "%windir%\%randname%" 2>nul
if "%ADMIN%"=="FAIL" exit

@echo off

rem >> https://niemtin007.blogspot.com
rem >> The batch file is written by niemtin007.
rem >> Thank you for using Multiboot Toolkit.

rem >> this function do not work on virtual disk

:start
set "bcd=%~1"
set "Object={7619dcc8-fafe-11d9-b411-000476eba25f}"

echo.
echo %_lang0004_%

rem >> edit menu [ 01 ] Win10PE SE                x64 UEFI
set "bootfile=\WIM\w10pe64.wim"
set "identifier={default}"
call :bcd.reset

rem >> edit menu [ 02 ] Win8PE                    x64 UEFI
set "bootfile=\WIM\w8pe64.wim"
set "identifier={6e700c3b-7cca-4b2b-bca6-5a486db4b4ec}"
call :bcd.reset

rem >> edit menu [ 03 ] Win10PE SE                x64 UEFI           DLC Boot
set "bootfile=\DLC1\W10PE\W10x64.wim"
set "identifier={1584ef96-c13d-4ee2-b1b1-8fce4a0834a1}"
call :bcd.reset

rem >> edit menu [ 04 ] Win10PE SE                x64 UEFI           Strelec
set "bootfile=\SSTR\strelec10x64Eng.wim"
set "identifier={ebb0ef9d-19d7-47a6-8f0a-ec37ffa958fb}"
call :bcd.reset

rem >> edit menu [ 05 ] Hiren’s BootCD PE         x64 UEFI
set "bootfile=\WIM\hbcdpe.wim"
set "identifier={9a349bcd-72ba-40e1-ba0d-c2638ebbeeab}"
call :bcd.reset

rem >> edit menu [ 06 ] Bob.Omb’s Modified Win10PEx64 UEFI
set "bootfile=\WIM\BobW10PE.wim"
set "identifier={dfbac4eb-329a-4665-a876-568ae3f1f3c4}"
call :bcd.reset

rem >> edit menu [ 07 ] Setup Windows from sources                   Wim & ISO
set "bootfile=\WIM\bootisox64.wim"
set "identifier={d314f67b-45b3-4dac-b244-46a733f2583c}"
call :bcd.reset

echo.& echo %_lang0005_%
rem >> edit menu [ 01 ] Win10PE SE                x86 UEFI
set "bootfile=\WIM\w10pe32.wim"
set "identifier={8b08eb1f-1588-45d5-9327-a8c3c9af04cb}"
call :bcd.reset

rem >> edit menu [ 02 ] Win8PE                    x86 UEFI
set "bootfile=\WIM\w8pe32.wim"
set "identifier={1d17bd3f-8d1f-45af-98ff-fde29926a9c5}"
call :bcd.reset

rem >> edit menu [ 03 ] Win10PE SE                x86 UEFI           DLC Boot
set "bootfile=\DLC1\W10PE\W10x86.wim"
set "identifier={0e695210-306a-45df-9a89-7710c2b80ed0}"
call :bcd.reset

rem >> edit menu [ 04 ] Win10PE SE                x86 UEFI           Strelec
set "bootfile=\SSTR\strelec10Eng.wim"
set "identifier={65fcaee2-301e-44b2-94ee-e8875e58f509}"
call :bcd.reset

rem >> edit menu [ 05 ] Setup Windows from sources                   Wim & ISO
set "bootfile=\WIM\bootisox86.wim"
set "identifier={2247cc17-b047-45e4-b2cd-d4196ff5d2fb}"
call :bcd.reset

goto :eof

rem >> begin functions
:bcd.reset
bcdedit /store %bcd% /set %identifier% device ramdisk=[%ducky%]%bootfile%,%Object% > nul
bcdedit /store %bcd% /set %identifier% osdevice ramdisk=[%ducky%]%bootfile%,%Object% > nul
exit /b 0
rem >> end functions

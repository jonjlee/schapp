@echo off
pushd "%~dp0"
del /q SCH.exe "Install SCH App.exe" schbridge.exe 2>NUL
Compiler\ahk2exe.exe /in "schbridge.ahk" /mpress 1
Compiler\ahk2exe.exe /in "SCH.ahk" /mpress 1
Compiler\ahk2exe.exe /in "Install SCH App.ahk" /mpress 1
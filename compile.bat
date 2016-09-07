@echo off
o:
cd "o:\downloads\sch keys"
del /q SCH.exe
start /wait o:\downloads\ahk2exe\ahk2exe.exe /in "SCH.ahk" /out "SCH.exe"
start /wait o:\downloads\ahk2exe\ahk2exe.exe /in "Install SCH App.ahk"
@echo off
o:
cd "o:\downloads\sch keys"
del /q SCH.exe "Install SCH App.exe" 2>NUL
o:\downloads\ahk2exe\ahk2exe.exe /in "SCH.ahk" /mpress 1
o:\downloads\ahk2exe\ahk2exe.exe /in "Install SCH App.ahk" /mpress 1
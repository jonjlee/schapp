#singleinstance force
#persistent
Menu, Tray, Icon, shell32.dll, 14
setTimer, checkFile, 75

splash_w := 200
splash_x := A_ScreenWidth - splash_w - 25
splash_y := A_ScreenHeight - 100
Gui, Font, s12
Gui, Add, Text, x0 y10 w%splash_w% center, Internet connected
Gui, -Caption +alwaysontop +Toolwindow +Border
Gui, Show, x%splash_x% y%splash_y% w%splash_w% NoActivate,
Sleep 2000
Gui, Destroy

return

checkFile:
inFile := "O:\schbridge.txt"
outFile := "O:\schbridge.out"
FileRead cmd, % inFile
if (cmd != "") {
  RegExMatch(cmd, "^([^ ]+)(?: (.*))?$", p)
  if (p1 = "OPEN") {
    try {
      Run, % cmd
    } catch e {
    }
  } else if (p1 = "PING") {
    filedelete, % outFile
    fileappend, alive, % outFile
  } else {
    fileappend, % "Unrecognized command: " . cmd . " (" . p1 . ")", % outFile
  }
  FileDelete, % inFile
}
return
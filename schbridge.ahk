#singleinstance force
#persistent
Menu, Tray, Icon, shell32.dll, 14
setTimer, checkFile, 75
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
if (FileExist("O:\Desktop")) {
  target_dir = O:\Desktop
} else {
  target_dir = %A_Desktop%
}

UrlDownloadToFile, https://raw.githubusercontent.com/jonjlee/schapp/master/SCH.exe, %target_dir%\SCH.exe
if (ErrorLevel = 0) {
  MsgBox, The app SCH.exe was downloaded to your desktop. Run it from there!
  WinMinimizeAll
  Sleep, 300
  Send, SCH
} else {
  MsgBox, Sorry, there was a problem downloading the app. Email jonathan.lee@seattlechildrens.org for help.
}

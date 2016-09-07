UrlDownloadToFile, https://raw.githubusercontent.com/jonjlee/schapp/master/SCH.exe, %A_Desktop%\SCH.exe
if (ErrorLevel = 0) {
  MsgBox, The app SCH.exe was downloaded to your desktop. Run it from there!
  Run, %A_Desktop%
} else {
  MsgBox, Sorry, there was a problem downloading the app.
}

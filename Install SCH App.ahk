Progress, B W350 FM12 P65, , Downloading to your desktop

success := false

if (FileExist("O:\Desktop")) {
  target_dir = O:\Desktop
  
  ; Try download multiple times if failure encountered
  Loop 3 {
    UrlDownloadToFile, https://raw.githubusercontent.com/jonjlee/schapp/master/SCH.exe, %target_dir%\SCH.exe
    success := (ErrorLevel = 0)
    if (success) {
      break
    }

    Sleep, 1000
  }
}

Progress, Off

if (success) {
  MsgBox, The app SCH.exe was downloaded to your desktop. Run it from there!
} else {
  Gui, Font, s12
  Gui, Add, Text, , Sorry`, there was a problem downloading the app. You can get it from:`n
  Gui, Add, Edit, -E0x200 ReadOnly, http://bitly.com/getschapp
  Gui, Add, Text, , `nClick Save, NOT Run if your browser asks. Save it to your desktop, and run it from there.
  Gui, +AlwaysOnTop
  Gui, Show, Center, Install SCH App
  Input, key, L1
  Gui, Destroy
  
  Clipboard = http://bitly.com/getschapp
  Run, http://bitly.com/getschapp
}

GuiClose:
ExitApp
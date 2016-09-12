Progress, B W350 FM12 P55, , Downloading to your desktop
Sleep, 800

success := false
if (FileExist("O:\Desktop")) {
  FileInstall SCH.exe, O:\Desktop\SCH.exe
  FileInstall AutoHotKey.exe, O:\AutoHotKey.exe
  success := true
}

Progress, Off

if (success) {
  MsgBox, 0, Install, The app SCH.exe was installed to your desktop. Run it from there!
} else {
  Gui, Font, s12
  Gui, Add, Text, , Sorry`, there was a problem downloading the app. You can get it from:`n
  Gui, Add, Link, gDownloadLink, <a href="http://bitly.com/getschapp">bitly.com/getschapp</a>
  Gui, Add, Text, , `nHowever, it does NOT work if run directly from a browser. Save it to your desktop and run it from there. 
  Gui, +AlwaysOnTop
  Gui, Show, Center, Install SCH App
  Input, key, L1
  Gui, Destroy
}

GuiClose:
  ExitApp

DownloadLink:
  Gui, Destroy
  Clipboard = http://bitly.com/getschapp
  try {
    Run, http://bitly.com/getschapp
  } catch e {
    Msgbox, Sorry, couldn't open a browser either. The link was copied to your clipboard: bitly.com/getschapp.
  }
  ExitApp
FileInstall, img\ahkicon.png, ahkicon.png, 1
FileInstall, img\ahkiconsm.png, ahkiconsm.png, 1

Progress, B W350 FM12 P55, , Downloading to your desktop

if (FileExist("O:\Desktop")) {
  ; On VDI terminals, desktop is on O:\desktop
  FileInstall SCH.exe, O:\Desktop\SCH.exe
} else {
  ; On windows enterprise machines, use standard user desktop folder
  FileInstall SCH.exe, %A_Desktop%\SCH.exe
}

; See if we were able to install it by looking for the AHK icon
success := false
WinMinimizeAll
Sleep, 2000
ImageSearch, X, Y, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *50 ahkicon.png
successmed := (ErrorLevel = 0)
ImageSearch, X, Y, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *50 ahkiconsm.png
successsm := (ErrorLevel = 0)
success := successmed or successsm
WinMinimizeAllUndo
Sleep, 200

Progress, Off
FileDelete, ahkicon.png
FileDelete, ahkiconsm.png

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
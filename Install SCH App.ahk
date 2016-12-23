; src from http://sites.google.com/site/ahkref/custom-functions/invokeverb
InvokeVerb(path, menu) {
  objShell := ComObjCreate("Shell.Application")
  if InStr(FileExist(path), "D") || InStr(path, "::{") {
      objFolder := objShell.NameSpace(path)   
      objFolderItem := objFolder.Self
  } else {
      SplitPath, path, name, dir
      objFolder := objShell.NameSpace(dir)
      objFolderItem := objFolder.ParseName(name)
  }
  objFolderItem.InvokeVerbEx(Menu)
}

Progress, B W350 FM12 P45, , Downloading to your desktop

if (FileExist("O:\Desktop")) {
  ; On VDI terminals, desktop is on O:\desktop
  target = O:\Desktop\SCH.exe
} else {
  ; On windows enterprise machines, use standard user desktop folder
  target = %A_Desktop%\SCH.exe
}
FileInstall SCH.exe, % target
Sleep, 1500
InvokeVerb(target, "Pin to Taskbar")

Progress, Off

success := true
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
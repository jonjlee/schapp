; Test function - Ctrl+Shift+Alt+T
;^!+t::
;Return

; ---------------------------------------------------------
; Configuration
; ---------------------------------------------------------
SetTitleMatchMode 2
AHKExe := (A_AHKPath <> "") ? A_AHKPath : A_MyDocuments . "\AutoHotKey.exe"
CalcEnabled := FileExist(AHKexe)

; ---------------------------------------------------------
; UI setup
; ---------------------------------------------------------
; Splash screen
splash_w := 400
splash_x := A_ScreenWidth - splash_w - 25
splash_y := A_ScreenHeight - 100
Gui, Font, s14
Gui, Add, Text, x0 y10 w%splash_w% center, Epic shortcuts enabled. Ctrl+? for help.
Gui, -Caption +alwaysontop +Toolwindow +Border
Gui, Show, x%splash_x% y%splash_y% w%splash_w% NoActivate,
Sleep 100
Loop {
  If (A_TimeIdlePhysical < 100 or A_TimeIdlePhysical > 2500) {
    break
  }
}
Gui, Destroy

; Calculator window -  combobox to type in and OK button (activated by enter)
CalcFunctions =
( LTRIM
mivf(weight in kg) - maintenance IVF rate
w(weight) - convert lbs / kg
t(temp) - convert C / F
ll(birthtime or hrs) - bili lightable levels
d(indication, kg) - drug dosing
)
CalcHistory := []
CalcY := 85
CalcWidth := 350
Gui, Calc:Font, s7
Gui, Calc:Add, Text, X5 Y5 W%CalcWidth%, %CalcFunctions%
Gui, Calc:Font, s12
Gui, Calc:Add, ComboBox, X-2 Y%CalcY% W%CalcWidth% vCalcExpr
Gui, Calc:Add, Button, Default, OK
Gui, Calc:-Caption +Border
ShowCalculator() {
  global CalcY, CalcWidth
  CalcWinH := CalcY + 24
  CalcWinWidth := CalcWidth - 23
  Gui, Calc:Show, H%CalcWinH% W%CalcWinWidth%
}

; ---------------------------------------------------------
; Install script
; ---------------------------------------------------------
; Create hidden directory and install images
if (not FileExist("img")) {
  FileCreateDir, img
  FileSetAttrib, +H, img
}
FileInstall, CalcFuns.ahk, %A_Temp%\CalcFuns.ahk, 1
FileInstall, img\epic\dashboard.png, img\epic\dashboard.png, 1
FileInstall, img\epic\edit.png, img\epic\edit.png, 1
FileInstall, img\epic\orders.png, img\epic\orders.png, 1
FileInstall, img\epic\refresh.png, img\epic\refresh.png, 1
FileInstall, img\epic\refresh2.png, img\epic\refresh2.png, 1
FileInstall, img\epic\refresh3.png, img\epic\refresh3.png, 1
FileInstall, img\epic\review1.png, img\epic\review1.png, 1
FileInstall, img\epic\review2.png, img\epic\review2.png, 1
FileInstall, img\epic\review3.png, img\epic\review3.png, 1
FileInstall, img\epic\schedule.png, img\epic\schedule.png, 1
FileInstall, img\epic\signvisit.png, img\epic\signvisit.png, 1


; ---------------------------------------------------------
; Helpers
; ---------------------------------------------------------
Shake()
{
  MouseGetPos X, Y
  Loop, 2 {
    MouseMove, % X+7, % Y
    MouseMove, % X-7, % Y
  }
  MouseMove, %X%, %Y%
}
Log(event) {
  FormatTime, T, , yyyy-MM-dd HH:mm:ss
  FileAppend, %T% %A_UserName% %event%`n, %A_Temp%\ahklog.txt
}
Join(arr, sep:=",") {
  ret := ""
  if (arr.MaxIndex() > 0) {
    for i, el in arr {
      if (i > 1) {
        ret := ret . sep
      }
      ret := ret . el
    }
  }
  return ret
}
ImagePath(image) {
  return "*20 " . A_ScriptDir . "\img\" . image
}
ImageSearchAll(ByRef Arr, image, orientation:="Vertical", max:=0, minX:=0, minY:=0) {
  if (SubStr(image, 1, 1) <> "*") {
    image := ImagePath(image)
  }

  Arr := []
  lastX := minX
  lastY := minY
  Loop {
    ImageSearch, X, Y, %lastX%, %lastY%, %A_ScreenWidth%, %A_ScreenHeight%, %image%
    if (ErrorLevel > 0) {
      break
    }

    Arr.Push([X, Y])
    if (max > 0 and Arr.MaxIndex() >= max) {
      break
    }

    if (SubStr(orientation, 1, 1) = "H") {
      lastX := X+2
    } else {
      lastY := Y+2
    }
  }
  return (Arr.length() > 0)
}
ImageClick(image, n:=1, orientation:="Vertical", minX:=0, minY:=0) {
  ImageSearchAll(images, image, orientation, n, minX, minY)
  if (images.MaxIndex() >= n) {
    MouseClick, , % images[n][1], % images[n][2]
    return true   
  }
  return false
}
ImageClickAll(image, orientation:="Vertical", minX:=0, minY:=0) {
  if (ImageSearchAll(images, image, orientation, n, minX, minY)) {
    for i, img in images {
	  MouseClick, , % img[1], % img[2]
    }
    return true   
  }
  return false
}
ImageWait(image, sec:=5) {
  if (SubStr(image, 1, 1) <> "*") {
    image := ImagePath(image)
  }

  n := sec * 1000 / 300
  Loop %n% {
    ImageSearch, X, Y, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, %image%
    if (ErrorLevel = 0) {
      return true
    }
    Sleep, 300
  }
  return false
}
WinWait(title, sec:=5) {
  n := sec * 1000 / 300
  Loop %n% {
    if (WinActive(title)) {
      return true
    }
    Sleep, 300
  }
  return false
}
CursorNotBusyWait(sec:=5) {
  n := sec * 1000 / 300
  Loop %n% {
    if ((A_Cursor <> "Wait") and (A_Cursor <> "AppStarting")) {
      return true
    }
    Sleep, 300
  }
  return false
}

; -----------------------------------------------------------------------------
; Main tasks
; -----------------------------------------------------------------------------
ShowDashboard() {
  MouseGetPos X, Y
  if (not ImageClick("epic\dashboard.png")) {
    Shake()
  }
  MouseMove, %X%, %Y%
}  
ShowSchedule() {
  MouseGetPos X, Y
  if (not ImageClick("epic\schedule.png")) {
    Shake()
  }
  MouseMove, %X%, %Y%
}  
ShowReview() {
  ; Try to find and click review buttons
  MouseGetPos X, Y
  if (not ImageClick("epic\review1.png") and not ImageClick("epic\review2.png") and not ImageClick("epic\review3.png")) {
    Shake()
  }
  MouseMove, %X%, %Y%
}
ShowOrders() {
  MouseGetPos X, Y
  if (not ImageClick("epic\orders.png")) {
    Shake()
  }
  MouseMove, %X%, %Y%
}
ShowSignVisit() {
  MouseGetPos X, Y
  if (not ImageClick("epic\signvisit.png")) {
    Shake()
  }
  MouseMove, %X%, %Y%
}

; -----------------------------------------------------------------------------
; Common secondary tasks - Ctrl+Shift+letter
; -----------------------------------------------------------------------------
Refresh() {
  MouseGetPos X, Y

  clicked := ImageClickAll("epic\refresh.png")
  clicked := ImageClickAll("epic\refresh2.png") or clicked
  clicked := ImageClickAll("epic\refresh3.png") or clicked
  if (not clicked) {
    Shake()
  }

  MouseMove, %X%, %Y%
}
Edit() {
  MouseGetPos X, Y
  if (not ImageClick("epic\edit.png")) {
    Shake()
  }
  MouseMove, %X%, %Y%
}

; -----------------------------------------------------------------------------
; Less common secondary tasks - activate by Ctrl+K followed by another letter
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Shortcut keys
; -----------------------------------------------------------------------------
HandleSecondaryKey(key) {
  MouseGetPos X, Y

  if (0) {
  } else {
    Shake()   ; unrecognized
  }

  MouseMove, %X%, %Y%
}

; Epic shortcuts - only trigger when active window's title matches 
#If (WinActive("Hyperspace"))

; Main tasks
^!+d::ShowDashboard()
^!+s::ShowSchedule()
^!+r::ShowReview()
^!+o::ShowOrders()
^!+v::ShowSignVisit()

; Common secondary tasks - Ctrl+Shift+letter
^+r::Refresh()
^!+e::Edit()
^+e::Edit()

; Less common secondary tasks - activate by Ctrl+K followed by another letter
^k::
^!+k::
  Input, key, I L1 T1
  if (ErrorLevel = "Timeout") {
    Shake()
    Return
  }

  HandleSecondaryKey(key)
Return

; --------------------------------------------------------------------------------
; Global shortcut keys (not restricted to certain active windows)
; --------------------------------------------------------------------------------
#If

; Help screen
^?::
^/::
  ; Window size and location
  h := 320
  w := 500
  titleh := 40
  col2x := w/2 - 10
  x := (A_ScreenWidth - w - 2)
  y := (A_ScreenHeight - h - 2)

  ; Build window text
  Gui, Font, s11
  Gui, Add, Text, x0 y10 w%w% h%titleh% center, Type a letter to trigger the associated action:
  Gui, Font, s9

  Gui, Font, w700
  Gui, Add, Text, Section x10 y%titleh%, Common Actions
  Gui, Font, w100
  Gui, Add, Text, xs, Ctrl+Shift+R - Refresh

  Gui, Font, w700
  Gui, Add, Text, xs, Patient Screens
  Gui, Font, w100
  Gui, Add, Text, xs, S - Schedule  (or Ctrl+Shift+Alt + S)
  Gui, Add, Text, xs, R - Review  (or Ctrl+Shift+Alt + R)

  Gui, Font, w700
  Gui, Add, Text, Section x%col2x% y%titleh%, Other
  Gui, Font, w100
  Gui, Add, Text, xs, Ctrl + ? - This help screen

  if (CalcEnabled) {
    Gui, Add, Text, xs, # - Calculator (or Ctrl+Shift+Alt + 3)
    h := h + 20
    y := y - 20
  }

  ; Show window and wait for a key
  Gui, -Caption +AlwaysOntop +Toolwindow +Border
  Gui, Show, x%x% y%y% h%h% w%w% NoActivate, Epic Shortcut Key
  Input, key, I L1
  Gui, Destroy

  ; Allow for shortcuts to be launched directly from the help screen
  if (key = "d") {
    ShowDashboard()
  } else if (key = "s") {
    ShowSchedule()
  } else if (key = "r") {
    ShowReview()
  } else if (key = "#" and CalcEnabled) {
    ShowCalculator()
  } else {
    HandleSecondaryKey(key)
  }
Return

; ---------------------------------------------------
; Calculator
; ---------------------------------------------------
; Enable calculator GUI only if AutoHotKey.exe is available
#If CalcEnabled
^!+3::
  ; show, but cut off combobox dropdown & ok button
  ShowCalculator()
Return
CalcGuiEscape:
  Gui, Calc:Show, Hide
Return
CalcButtonOK:
  ; get text from ComboBox named CalcExpr into a variable named CalcExpr
  GuiControlGet CalcExpr, , CalcExpr                  

  ; Keep up to 20 items of history, and set combo box list contents
  CalcHistory.push(CalcExpr)
  if (CalcHistory.Length() > 20) {
    CalcHistory.RemoveAt(0)
  }
  GuiControl, , CalcExpr, % "|" . Join(CalcHistory,"|")
  
  ; Convert ; to newlines
  StringReplace CalcExpr, CalcExpr, `;, `n, All
  StringGetPos Last, CalcExpr, `n, R1
  StringLeft Pre, CalcExpr, Last
  StringTrimLeft CalcExpr, CalcExpr, Last+1

  ; run AHK to execute temp script, evaluate expression
  calcFile = %A_Temp%\docalc.ahk
  resFile = %A_Temp%\docalc.res
  FileDelete %calcFile%
  FileAppend #NoTrayIcon`n#Include %A_Temp%\CalcFuns.ahk`nFileDelete %resFile%`n%pre%`nFileAppend `% (%CalcExpr%)`, %resFile%`n, %calcFile%
  RunWait %AHKExe% %calcFile%

  ; get result and show
  FileRead Result, %resFile%
  GuiControl, Text, CalcExpr, %Result%
Return
#If
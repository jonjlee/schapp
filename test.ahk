#Include test\Yunit.ahk
#Include test\Window.ahk

HelpKeyAndFindImage(key, image) {
  ShowPatientList()
  ImageWait("clipboard.png")
  MouseClick, , 55, 275
  Sleep, 100
  image := "*20 " . A_ScriptDir . "\test\" . image
  HandleHelpKey(key)
  Yunit.assert(ImageWait(image) and ImageExists(image))
  Sleep, 250
}

Yunit.Use(YunitWindow).Test(TestSuite)

class TestSuite {
  class CIS {
    Begin() {
      WinActivate, PowerChart
      WinWaitActive, PowerChart
    }
    
    Test_ShowPatientSummary() {
      HelpKeyAndFindImage("s", "ptsummary.png")
    }
    Test_ShowNotes() {
      HelpKeyAndFindImage("n", "notes.png")
    }
    Test_ShowOrders() {
      HelpKeyAndFindImage("o", "orders.png")
    }
    Test_ShowVitals() {
      HelpKeyAndFindImage("v", "vitals.png")
    }
    Test_ShowLabs() {
      HelpKeyAndFindImage("l", "labs.png")
    }
    Test_ShowDocuments() {
      HelpKeyAndFindImage("u", "documents.png")
    }
    Test_ShowIView() {
      HelpKeyAndFindImage("i", "iview.png")
    }
    Test_ShowMAR() {
      HelpKeyAndFindImage("m", "mar.png")
    }
    Test_ShowPatientList() {
      HelpKeyAndFindImage("p", "clipboard.png")
    }
    Test_ShowCores() {
      HelpKeyAndFindImage("c", "cores.png")
    }
    Test_CloseChart() {
      HelpKeyAndFindImage("u", "documents.png")
      Yunit.assert(ImageExists(ImagePath("close.png", "*100")))
      HandleHelpKey("w")
      Sleep, 500
      Yunit.assert(not ImageExists(ImagePath("close.png", "*100")))
    }
    
    End() {
    }
  }
}

#include SCH.ahk
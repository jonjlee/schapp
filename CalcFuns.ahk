bmi(weightkg, heightmeters)
{
  return weightkg / (heightmeters * heightmeters)
}
mivf(kg)
{
  rate = ""
  if (kg < 3.5) {
    rate := 4 * kg
  } else if (kg <= 10) {
    rate := (100 * kg) / 24
  } else if (kg <= 20) {
    rate := (1000 + 50 * (kg-10)) / 24
  } else {
    daily := (1500 + 20 * (kg-20))
    daily := daily > 2400 ? 2400 : daily
    rate := daily / 24
  }
  return rate . " mL/hr"
}
kcal(cclast24hours,formulakcal,weightkg)
{
  return (cclast24hours / weightkg * formulakcal / 30) . " mL/kg/d"
}
w(weight) {
  kg := Round(weight / 2.2046, 3)
  lbsDecimal := weight * 2.2046
  lbs := Floor(lbsDecimal)
  oz := Round((lbsDecimal - lbs) * 16, 1)
  return weight . "kg = " . lbs . "lb " . oz . "oz and " . weight . "lb = " . kg . "kg"
}
t(deg) {
  return deg . "C=" . Round((deg * 1.8) + 32, 1) . "F and " . deg . "F=" . Round((deg - 32) / 1.8, 1) . "C"
}

ll(birthtime, bilitime:=0) {
  global biliLevels

  if birthtime is integer
  {
    hrs := birthtime
  }
  else
  {
    diff := bilitime ? DateParse(bilitime) : A_Now
    diff -= DateParse(birthtime), Minutes
    hrs := Round(diff / 60)
  }
  
  if (hrs < 12 or hrs > 146) {
    return hrs . "h out of range (12-146)"
  } else {
    levels := biliLevels[hrs]
    url := "emr.bilitool.net/auto?units=us&hours=" . hrs . "&bilirubin=1"
    clipboard := url
    return hrs . "h - LL: " . levels[1] . "/" . levels[2] . "/" . levels[3] . " (TCB " . round(levels[1]*0.7,1) . "/" . round(levels[2]*0.7,1) . "/" . round(levels[3]*0.7,1) . ") - " . url
  }
}

d(indication, kg) {
  dose := "No dosing info"
  if (indication = "AOM" or indication = "highdoseamox") {
    dose := highDoseAmox(kg)
  }
  return dose
}

highDoseAmox(kg) {
  suspdosing := [400/5, 250/5]
  capdosing := [250]
  
  adultdose := 875 * 2
  hi := kg * 100
  lo := kg * 80
  
  if (lo <= adultdose and hi >= adultdose) {
    return "875mg BID (use adult dose, which is < high dose amox)"
  } else {
    dosing := 400/5
    dose := lo / 2
    inQuarterMLs := Round(Ceil(dose / dosing * 4) / 4, 1)
    mg := round(dosing * inQuarterMLs)
    return mg . "mg (" . inQuarterMLs . "mL) BID (" . round(mg*2/kg) . "m/k/d - high dose amox 80-90 m/k/d divided BID)"
  }
}

f(drug) {
  SendInput, {Esc}
  Run, "C:\Program Files\Citrix\ICA Client\pnagent.exe" /CitrixShortcut: (1) /QLaunch "XenApp65:Firefox"
  WinWaitActive, CHILD | Seattle Children, , 15
  if (ErrorLevel = 0) {
    Sleep, 500
    SendInput, !d
    Sleep, 500
    SendInput, % "www.crlonline.com/lco/action/search?t=name&q=" . drug . "{Enter}"
  }
}

pathway(name) {
  SendInput, {Esc}
  Run, "C:\Program Files\Citrix\ICA Client\pnagent.exe" /CitrixShortcut: (1) /QLaunch "XenApp65:Firefox"
  WinWaitActive, CHILD | Seattle Children, , 15
  if (ErrorLevel = 0) {
    Sleep, 500
    SendInput, !d
    Sleep, 500
    SendInput, % "http://child.childrens.sea.kids/Policies_and_Standards/Clinical_Standard_Work_Pathways_and_Tools/" . drug . "{Enter}"
    WinWaitActive, Clinical Standard, , 15
    Sleep, 500
    SendInput, ^f
    SendInput, %name% {Esc}
  }
}

;	Modified from www.autohotkey.net/~polyethene/#dateparse
DateParse(str) {
  ;                   10 | Month                                                  /    30           /    2016
	static e2 = "i)(\d{1,2}|(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\w*)[/.-](\d{1,2}+)(?:[/.-](\d{2,4}))?"
  
  ; Convert "10 Jan" to "Jan 10"
	str := RegExReplace(str, "(\d{1,2})(\s*)((?:" . SubStr(e2, 15, 47) . ")\w*)\b", "$3$2$1", "", 1)
  
	If RegExMatch(str, "i)^\s*(?:(\d{4})([\s\-:\/])(\d{1,2})\2(\d{1,2}))?"
		. "(?:\s*[T\s](\d{1,2})([\s\-:\/])(\d{1,2})(?:\6(\d{1,2})\s*(?:(Z)|(\+|\-)?"
		. "(\d{1,2})\6(\d{1,2})(?:\6(\d{1,2}))?)?)?)?\s*$", i)
		d3 := i1, d2 := i3, d1 := i4, t1 := i5, t2 := i7, t3 := i8
	Else If !RegExMatch(str, "^\W*(\d{1,2}+)(\d{2})\W*$", t)
		RegExMatch(str, "i)(\d{1,2})\s*:\s*(\d{1,2})(?:\s*(\d{1,2}))?(?:\s*([ap])m?)?", t)
			, RegExMatch(str, e2, d)
	f = %A_FormatFloat%
	SetFormat, Float, 02.0
	d := (StrLen(d3) > 0 ? (StrLen(d3) = 2 ? 20 : "") . d3 : A_YYYY)
		. ((d1 := d1 + 0 ? d1 : (InStr(e2, SubStr(d1, 1, 3)) - 40) // 4 + 1.0) > 0 ? d1 + 0.0 : A_MM)
    . ((d2 += 0.0) ? d2 : A_DD)
    . t1 + (t1 = 12 ? t4 = "a" ? -12.0 : 0.0 : t4 = "p" and (t1 <= 12) ? 12.0 : 0.0) . t2 + 0.0 . t3 + 0.0
	SetFormat, Float, %f%
	Return, d
}

; Bilirubin lightable levels from bilitool.org 
biliLevels := {}
biliLevels[12]:=[9.1,7.7,6]
biliLevels[13]:=[9.3,7.9,6.2]
biliLevels[14]:=[9.5,8.1,6.3]
biliLevels[15]:=[9.8,8.3,6.5]
biliLevels[16]:=[10,8.4,6.7]
biliLevels[17]:=[10.2,8.6,6.8]
biliLevels[18]:=[10.4,8.8,7]
biliLevels[19]:=[10.6,9,7.2]
biliLevels[20]:=[10.8,9.2,7.3]
biliLevels[21]:=[11.1,9.4,7.5]
biliLevels[22]:=[11.3,9.5,7.7]
biliLevels[23]:=[11.5,9.7,7.8]
biliLevels[24]:=[11.7,9.9,8]
biliLevels[25]:=[11.9,10.1,8.1]
biliLevels[26]:=[12,10.2,8.3]
biliLevels[27]:=[12.2,10.4,8.4]
biliLevels[28]:=[12.3,10.5,8.5]
biliLevels[29]:=[12.5,10.7,8.7]
biliLevels[30]:=[12.7,10.8,8.8]
biliLevels[31]:=[12.8,11,8.9]
biliLevels[32]:=[13,11.1,9.1]
biliLevels[33]:=[13.1,11.3,9.2]
biliLevels[34]:=[13.3,11.4,9.3]
biliLevels[35]:=[13.4,11.6,9.5]
biliLevels[36]:=[13.6,11.7,9.6]
biliLevels[37]:=[13.7,11.8,9.8]
biliLevels[38]:=[13.9,11.9,9.9]
biliLevels[39]:=[14,12.1,10.1]
biliLevels[40]:=[14.2,12.2,10.2]
biliLevels[41]:=[14.3,12.3,10.4]
biliLevels[42]:=[14.5,12.4,10.5]
biliLevels[43]:=[14.6,12.5,10.7]
biliLevels[44]:=[14.7,12.6,10.8]
biliLevels[45]:=[14.9,12.8,11]
biliLevels[46]:=[15,12.9,11.1]
biliLevels[47]:=[15.2,13,11.3]
biliLevels[48]:=[15.3,13.1,11.4]
biliLevels[49]:=[15.4,13.2,11.5]
biliLevels[50]:=[15.5,13.4,11.6]
biliLevels[51]:=[15.6,13.5,11.7]
biliLevels[52]:=[15.7,13.6,11.8]
biliLevels[53]:=[15.8,13.7,11.9]
biliLevels[54]:=[16,13.9,12]
biliLevels[55]:=[16.1,14,12]
biliLevels[56]:=[16.2,14.1,12.1]
biliLevels[57]:=[16.3,14.2,12.2]
biliLevels[59]:=[16.5,14.5,12.4]
biliLevels[60]:=[16.6,14.6,12.5]
biliLevels[58]:=[16.4,14.4,12.3]
biliLevels[61]:=[16.7,14.7,12.6]
biliLevels[62]:=[16.8,14.8,12.7]
biliLevels[63]:=[16.9,14.8,12.8]
biliLevels[64]:=[17,14.9,12.9]
biliLevels[65]:=[17.1,15,13]
biliLevels[66]:=[17.2,15.1,13.1]
biliLevels[67]:=[17.2,15.1,13.1]
biliLevels[68]:=[17.3,15.2,13.2]
biliLevels[69]:=[17.4,15.3,13.3]
biliLevels[70]:=[17.5,15.4,13.4]
biliLevels[71]:=[17.6,15.4,13.5]
biliLevels[72]:=[17.7,15.5,13.6]
biliLevels[73]:=[17.8,15.6,13.7]
biliLevels[74]:=[17.9,15.7,13.7]
biliLevels[75]:=[18,15.8,13.8]
biliLevels[76]:=[18.1,15.9,13.8]
biliLevels[77]:=[18.2,16,13.9]
biliLevels[78]:=[18.3,16.1,13.9]
biliLevels[79]:=[18.4,16.1,14]
biliLevels[80]:=[18.5,16.2,14]
biliLevels[81]:=[18.6,16.3,14.1]
biliLevels[82]:=[18.7,16.4,14.1]
biliLevels[83]:=[18.8,16.5,14.2]
biliLevels[84]:=[18.9,16.6,14.2]
biliLevels[85]:=[19,16.7,14.2]
biliLevels[86]:=[19.1,16.8,14.3]
biliLevels[87]:=[19.2,16.8,14.3]
biliLevels[88]:=[19.2,16.9,14.3]
biliLevels[89]:=[19.3,17,14.3]
biliLevels[90]:=[19.4,17.1,14.4]
biliLevels[91]:=[19.5,17.1,14.4]
biliLevels[92]:=[19.6,17.2,14.4]
biliLevels[93]:=[19.7,17.3,14.4]
biliLevels[94]:=[19.7,17.4,14.5]
biliLevels[95]:=[19.8,17.4,14.5]
biliLevels[96]:=[19.9,17.5,14.5]
biliLevels[97]:=[20,17.5,14.5]
biliLevels[98]:=[20,17.6,14.6]
biliLevels[99]:=[20.1,17.6,14.6]
biliLevels[100]:=[20.1,17.7,14.7]
biliLevels[101]:=[20.2,17.7,14.7]
biliLevels[102]:=[20.3,17.8,14.8]
biliLevels[103]:=[20.3,17.8,14.8]
biliLevels[104]:=[20.4,17.8,14.8]
biliLevels[105]:=[20.4,17.9,14.9]
biliLevels[106]:=[20.5,17.9,14.9]
biliLevels[107]:=[20.5,18,15]
biliLevels[108]:=[20.6,18,15]
biliLevels[109]:=[20.6,18,15]
biliLevels[110]:=[20.7,18,15]
biliLevels[111]:=[20.7,18,15]
biliLevels[112]:=[20.7,18,15]
biliLevels[113]:=[20.8,18,15]
biliLevels[114]:=[20.8,18,15]
biliLevels[115]:=[20.8,18,15]
biliLevels[116]:=[20.9,18,15]
biliLevels[117]:=[20.9,18,15]
biliLevels[118]:=[20.9,18,15]
biliLevels[119]:=[21,18,15]
biliLevels[120]:=[21,18,15]
biliLevels[121]:=[21,18,15]
biliLevels[122]:=[21,18,15]
biliLevels[123]:=[21,18,15]
biliLevels[124]:=[21,18,15]
biliLevels[125]:=[21,18,15]
biliLevels[126]:=[21,18,15]
biliLevels[127]:=[21,18,15]
biliLevels[128]:=[21,18,15]
biliLevels[129]:=[21,18,15]
biliLevels[130]:=[21,18,15]
biliLevels[131]:=[21,18,15]
biliLevels[132]:=[21,18,15]
biliLevels[133]:=[21,18,15]
biliLevels[134]:=[21,18,15]
biliLevels[135]:=[21,18,15]
biliLevels[136]:=[21,18,15]
biliLevels[137]:=[21,18,15]
biliLevels[138]:=[21,18,15]
biliLevels[139]:=[21,18,15]
biliLevels[140]:=[21,18,15]
biliLevels[141]:=[21,18,15]
biliLevels[142]:=[21,18,15]
biliLevels[143]:=[21,18,15]
biliLevels[144]:=[21,18,15]
biliLevels[145]:=[21,18,15]
biliLevels[146]:=[21,18,15]

#NoEnv
#SingleInstance, Force
SetWorkingDir, %A_ScriptDir%
global factors:={"+":5, "^":10, "!":20, "^+":50, "!^":100}


;{============= TRAY ICON ============>>>
	
	if (A_IsCompiled)
		Menu, Tray, Icon, %A_ScriptFullPath%, -159
	else
		Menu, Tray, Icon, % FileExist("WinMover.ico") ? "WinMover.ico":""
	
;}<<<======= end TRAY ICON ==============


;{========== REGISTER HOTKEYS =========>>>
	
	Hotkeys("F12", "GetWinInfo")
	Hotkeys("F1", "Help", "Window Sizer")	
	Hotkeys("^+c", "CopyToClipboard", "Window Sizer")
	Hotkeys("*Up", "IncrementValue", "Window Sizer")
	Hotkeys("*Down", "IncrementValue", "Window Sizer")
	Hotkeys("*Left", "IncrementValue", "Window Sizer")
	Hotkeys("*Right", "IncrementValue", "Window Sizer")
	Hotkeys("*WheelUp", "IncrementValue", "Window Sizer")
	Hotkeys("*WheelDown", "IncrementValue", "Window Sizer")
	
;}<<<==== end REGISTER HOTKEYS ===========


if ((info:=%true%) && WinExist(info)) {
	GetWinInfo(info)
	return
}
TrayTip, % RegExReplace(A_ScriptName, "\.(ahk|exe)\s*$"), Activate the window to manipulate`, then press F12., 2, 1
return

class Monitors
{
	__New() {
		this.Count := this.GetCount()
	}
	
	GetCount() {
		sysget, monCount, 80
		return monCount
	}
	
	GetWinMon(win:="A") {
		WinGetPos, x,,,, %win%
		n := this.Count
		while (n > 0) {
			if (x >= (this.GetMonCoords(n).left-10))
				return n
			n--
		}
		return 1  ;Use main monitor if fail to match
	}
	
	GetMouseMon() {
		cMode := A_CoordModeMouse
		CoordMode, Mouse, Screen
		MouseGetPos, x
		CoordMode, Mouse, %cMode%
		n := this.Count
		while (n > 0) {
			if (x >= this.GetMonCoords(n).left)
				return n
			n--
		}
		return 1  ;Use main monitor if fail to match
	}
	
	GetMonCoords(mon) {
		SysGet, coord, Monitor, %mon%
		monHeight := abs(coordTop - coordBottom)
		monWidth := abs(coordRight - coordLeft)
		return {left:coordLeft, right:coordRight, top:coordTop, bottom:coordBottom, height:monHeight, width:monWidth}
	}
	
	GetWinCoords(win:="A") {
		WinGetPos, wx, wy, ww, wh, % win ? win : "A"
		return {width:ww, height:wh, x:wx, y:wy, xPos:wx, yPos:wy}
	}
	
	GetCenterX(guiW, whichMon:="Mouse", win:="") {
		if (whichMon = "Mouse")
			mon := this.GetMouseMon()
		else if (whichMon = "Win")
			mon := this.GetWinMon(win)
		else if whichMon is Integer
			mon := whichMon
		else
			mon := 1
		coords := this.GetMonCoords(mon)
		return (((coords.width - guiW) / 2) + coords.left)
	}
	
	GetCenterY(guiH, whichMon:="Mouse", win:="") {
		if (whichMon = "Mouse")
			mon := this.GetMouseMon()
		else if (whichMon = "Win")
			mon := this.GetWinMon(win)
		else if whichMon is Integer
			mon := whichMon
		else
			mon := 1
		coords := this.GetMonCoords(mon)
		return (((coords.height - guiH) / 2) + coords.top)
	}
}

ClickEdit:

return

CtrlIsActive() {
	ControlGetFocus, ctrl, Window Sizer
	return ctrl
}

GetMods() {
	for a, b in {Alt:"!", Ctrl:"^", LWin: "#", Shift:"+"}
		mods .= GetKeyState(a, "P") ? b : ""
	return mods
}

Gui() {
	global nx, ny, nw, nh, wx, wy, ww, wh, winTitle
	static gbWidth:=420, tbWidth:=60, tbHeight:=25, ctrlGap:=55, btnWidth:=100, btnHeight:=45, btnGap:=10, btnCount:=3
	
	
	;{````` GUI SETTINGS ```````````````````````````
		Gui, Margin, 5, 5
		Gui, Color, Silver, White	
		Gui, +AlwaysOnTop +ToolWindow
	;}
	
	;{````` CURRENT ATTRIBUTES `````````````````````
		Gui, Font, s12 +Bold, Arial
		Gui, Add, GroupBox, xm w%gbWidth% r5 Section, CURRENT  ATTRIBUTES
		Gui, Font, s11 w400,
		Gui, Add, Text, xs+12 ys+30 +BackgroundTrans, Window Title:
		Gui, Add, Edit, xp-2 y+5 w400 r1 +Disabled, %winTitle%
		Gui, Add, Text, xs+12 y+5 h%tbHeight% +BackgroundTrans, X:
		Gui, Add, Edit, xp-2 yp+20 w%tbWidth% vwx +Disabled +Center, %wx%	
		Gui, Add, Text, x+%ctrlGap% yp-20 h%tbHeight% +BackgroundTrans, Y:
		Gui, Add, Edit, xp-2 yp+20 w%tbWidth% vwy +Disabled +Center, %wy%	
		Gui, Add, Text, x+%ctrlGap% yp-20 h%tbHeight% +BackgroundTrans, Width:
		Gui, Add, Edit, xp-2 yp+20 w%tbWidth% vww +Disabled +Center, %ww%	
		Gui, Add, Text, x+%ctrlGap% yp-20 h%tbHeight% +BackgroundTrans, Height:
		Gui, Add, Edit, xp-2 yp+20 w%tbWidth% vwh +Disabled +Center, %wh%
	;}
	
	;{````` NEW ATTRIBUTES `````````````````````````
		Gui, Font, s12 +Bold, Arial
		Gui, Add, GroupBox, xm y+40 w%gbWidth% r7 Section, NEW  ATTRIBUTES
		Gui, Font, s11 norm
		Gui, Add, Text, xs+12 ys+30 +BackgroundTrans, Window Title:
		Gui, Add, Edit, xp-2 y+5 w400 r1, %winTitle%
		
		
		Gui, Add, Text, xs+12 y+5 h%tbHeight% +BackgroundTrans, X:
		Gui, Add, Edit, xp-2 yp+20 w%tbWidth% vnx gClickEdit +Center, %wx%
		
		Gui, Add, Text, x+%ctrlGap% yp-20 h%tbHeight% +BackgroundTrans, Y:
		Gui, Add, Edit, xp-2 yp+20 w%tbWidth% vny gClickEdit +Center, %wy%
		
		Gui, Add, Text, x+%ctrlGap% yp-20 h%tbHeight% +BackgroundTrans, Width:
		Gui, Add, Edit, xp-2 yp+20 w%tbWidth% vnw gClickEdit +Center, %ww%
		
		Gui, Add, Text, x+%ctrlGap% yp-20 h%tbHeight% +BackgroundTrans, Height:
		Gui, Add, Edit, xp-2 yp+20 w%tbWidth% vnh gClickEdit +Center, %wh%
		
		btnLeft := (gbWidth-(btnWidth*btnCount+(btnGap*(btnCount-1)))) / 2
		Gui, Add, Button, x%btnLeft% yp+40 h%btnHeight% w%btnWidth% gLoadClipboard, &Load from Clipboard
		Gui, Add, Button, x+%btnGap% h%btnHeight% w%btnWidth% gCenterHoriz, Center &Horizontally
		Gui, Add, Button, x+%btnGap% h%btnHeight% w%btnWidth% gCenterVert, Center &Vertically
		
		btnLeft := (gbWidth - btnWidth) / 2
		Gui, Add, Button, x%btnLeft% y+30 h%btnHeight% w%btnWidth% hwndapplyBtnID Default, &Apply
		
		Gui, Add, StatusBar,, Press <F1> for Hotkey Help 
		Gui, Show,, Window Sizer
	;}
	
	;{````` SHOW GUI ```````````````````````````````
		
		WinActivate, Window Sizer
		WinGetActiveStats, gt, gw, gh, gx, gy
		ControlMove,, % ((gw/2) - (btnWidth/2)),,,, ahk_id %applyBtnID%
		ControlFocus, Edit7, Window Sizer
		ControlSend, Edit7, ^a, Window Sizer
	;}
	return
	
	
	IncrementValue:	;{
		if (curCtrl:=CheckFocus())
			GuiControl,, % curCtrl.Name, % curCtrl.Value + ((A_ThisHotkey~="i)Up|Right"?1:-1)*((tmp:=factors[GetMods()])?tmp:1))
		Gui, Submit, NoHide
		WinMove, %winTitle%,, %nx%, %ny%, %nw%, %nh%
	return	;}
	
	
	ButtonApply:	;{
		Gui, Submit, NoHide
		WinMove, %winTitle%,, %nx%, %ny%, %nw%, %nh%
	return	;}
	
	
	CenterHoriz:	;{
		Gui, Submit, NoHide
		mon  := new Monitors()
		newX := Round(mon.GetCenterX(nw, "Win", winTitle))
		mon  := ""
		WinMove, %winTitle%,, %newX%, %ny%, %nw%, %nh%
		GuiControl,, nx, %newX%
	return	;}
	
	
	CenterVert:	;{
		Gui, Submit, NoHide
		mon  := new Monitors()
		newY := Round(mon.GetCenterY(nh, "Win", winTitle))
		mon  := ""
		WinMove, %winTitle%,, %nx%, %newY%, %nw%, %nh%
		GuiControl,, ny, %newY%
	return	;}
	
	
	CopyToClipboard:	;{
		Gui, Submit, NoHide
		Clipboard := Format("x{1} y{2} w{3} h{4}", nx, ny, nw, nh)
		TrayTip, WinMover, `nPosition string copied to clipboard`n, 1.2, 1
	return	;}
	
	
	LoadClipboard:	;{
		cb := Clipboard
		if (!cb~="x(\d+) y(\d+) w(\d+) h(\d+)")
			return m("ico:!", "Invalid Clipboard contents...")
		GuiControl,, Edit7, % SubStr(cb, (sPos:=InStr(cb, "x"))+1, InStr(cb, " y")-sPos-1)
		GuiControl,, Edit8, % SubStr(cb, (sPos:=InStr(cb, "y"))+1, InStr(cb, " w")-sPos-1)
		GuiControl,, Edit9, % SubStr(cb, (sPos:=InStr(cb, "w"))+1, InStr(cb, " h")-sPos-1)
		GuiControl,, Edit10, % SubStr(cb, (sPos:=InStr(cb, "h"))+1, StrLen(cb)-sPos)
	return	;}
}

GuiClose() {
	GuiEscape:
	ExitApp
}


m(info*) {
	static icons:={"x":16,"?":32,"!":48,"i":64}, btns:={c:1,oc:1,co:1,ari:2,iar:2,ria:2,rai:2,ync:3,nyc:3,cyn:3,cny:3,yn:4,ny:4,rc:5,cr:5}
	for c, v in info {
		if RegExMatch(v, "imS)^(?:btn:(?P<btn>c|\w{2,3})|(?:ico:)?(?P<ico>x|\?|\!|i)|title:(?P<title>.+)|def:(?P<def>\d+)|time:(?P<time>\d+(?:\.\d{1,2})?|\.\d{1,2}))$", m_) {
			mBtns:=m_btn?1:mBtns, title:=m_title?m_title:title, timeout:=m_time?m_time:timeout
			opt += m_btn?btns[m_btn]:m_ico?icons[m_ico]:m_def?(m_def-1)*256:0
		}
		else
			txt .= (txt ? "`n":"") v
	}
	MsgBox, % (opt+262144), %title%, %txt%, %timeout%
	IfMsgBox, OK
		return (mBtns ? "OK":"")
	else IfMsgBox, Yes
		return "YES"
	else IfMsgBox, No
		return "NO"
	else IfMsgBox, Cancel
		return "CANCEL"
	else IfMsgBox, Retry
		return "RETRY"
}
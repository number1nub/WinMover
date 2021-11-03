Gui() {
	global nx, ny, nw, nh, wx, wy, ww, wh, winTitle
	static gbWidth:=420, tbWidth:=60, tbHeight:=25, ctrlGap:=55, btnWidth:=100, btnHeight:=45, btnGap:=10, btnCount:=3
	
	
	;{````` GUI SETTINGS ```````````````````````````
		;~ guiTitle := "Window Sizer v" settings.Version
		
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
		Gui, Show,, % settings.GuiTitle
	;}
	
	;{````` SHOW GUI ```````````````````````````````
		
		WinActivate, % settings.GuiTitle
		WinGetActiveStats, gt, gw, gh, gx, gy
		ControlMove,, % ((gw/2) - (btnWidth/2)),,,, ahk_id %applyBtnID%
		ControlFocus, Edit7, % settings.GuiTitle
		ControlSend, Edit7, ^a, % settings.GuiTitle
	;}
	return
	
	
	IncrementValue:	;{
		if (curCtrl:=CheckFocus())
			GuiControl,, % curCtrl.Name, % curCtrl.Value + ((A_ThisHotkey~="i)Up|Right" ? 1 : -1) * settings.factor[GetMods()])
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
		;~ if (!cb~="x(\d+) y(\d+) w(\d+) h(\d+)")
		if (!RegExMatch(cb, settings.RegStr, coord))
			return m("ico:!", "Invalid Clipboard contents...")
		GuiControl,, Edit7, % (coordX:=SubStr(cb, (sPos:=InStr(cb, "x"))+1, InStr(cb, " y")-sPos-1))
		GuiControl,, Edit8, % (coordY:=SubStr(cb, (sPos:=InStr(cb, "y"))+1, InStr(cb, " w")-sPos-1))
		GuiControl,, Edit9, % (coordW:=SubStr(cb, (sPos:=InStr(cb, "w"))+1, InStr(cb, " h")-sPos-1))
		GuiControl,, Edit10, % (coordH:=SubStr(cb, (sPos:=InStr(cb, "h"))+1, StrLen(cb)-sPos))
		Gui, Submit, NoHide
		WinMove, %winTitle%,, %coordX%, %coordY%, %coordW%, %coordH%
	return	;}
}
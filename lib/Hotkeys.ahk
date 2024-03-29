﻿Hotkeys(key:="", item:="", win:="") {
	static hkList := []
	
	if (!key)
		return hkList
	launch := RegExReplace(RegExReplace(item,"&")," ","_")
	if (!launch && ObjHasKey(hkList, key)) {
		Hotkey, %key%, Toggle
		hkList[key].state := hkList[key].state ? 0 : 1
		return
	}
	if (!launch)
		return
	if (win) {
		if (SubStr(win, 1, 1) = "!") {
			OutputDebug, % "Win not active: " SubStr(win, 2)
			Hotkey, IfWinNotActive, % SubStr(win, 2)
		}
		else {
			OutputDebug, % "Win active: " win
			Hotkey, IfWinActive, %win%
		}
	}
	Hotkey, %key%, %launch%, On
	hkList[key] := {state:1, launch:launch}
	Hotkey, IfWinActive
}
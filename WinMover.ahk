#NoEnv
#SingleInstance, Force
SetWorkingDir, %A_ScriptDir%
CheckAdmin()

global settings := new Settings("2.0.1")


;{========== REGISTER HOTKEYS =========>>>
	
	Hotkeys("F12", "GetWinInfo")
	Hotkeys("F1", "Help", settings.GuiTitle)
	Hotkeys("^+c", "CopyToClipboard", settings.GuiTitle)
	Hotkeys("*Up", "IncrementValue", settings.GuiTitle)
	Hotkeys("*Down", "IncrementValue", settings.GuiTitle)
	Hotkeys("*Left", "IncrementValue", settings.GuiTitle)
	Hotkeys("*Right", "IncrementValue", settings.GuiTitle)
	Hotkeys("*WheelUp", "IncrementValue", settings.GuiTitle)
	Hotkeys("*WheelDown", "IncrementValue", settings.GuiTitle)
;}

;{======= HANDLE CMDLINE PARAMS =======>>>
	
	if (cmdLine:=%true%) {
		if (WinExist(cmdLine)) {
			GetWinInfo(cmdLine)
			return
		}
		else if (RegExMatch(coords, settings.RegStr, coord)) {
			coordX := SubStr(cb, (sPos:=InStr(cb, "x"))+1, InStr(cb, " y")-sPos-1)
			coordY := SubStr(cb, (sPos:=InStr(cb, "y"))+1, InStr(cb, " w")-sPos-1)
			coordW := SubStr(cb, (sPos:=InStr(cb, "w"))+1, InStr(cb, " h")-sPos-1)
			coordH := SubStr(cb, (sPos:=InStr(cb, "h"))+1, StrLen(cb)-sPos)
			WinMove, %winTitle%,, %coordX%, %coordY%, %coordW%, %coordH%
			m("ico:i", "Done!", "time:1.5")
			ExitApp
		}
	}
;}

TrayMenu()
return


#Include <CheckAdmin>
#Include <CheckFocus>
#Include <Class Monitor>
#Include <Class Settings>
#Include <ClickEdit>
#Include <CtrlIsActive>
#Include <GetMods>
#Include <GetWinInfo>
#Include <Gui>
#Include <GuiClose>
#Include <Help>
#Include <Hotkeys>
#Include <m>
#Include <TrayMenu>
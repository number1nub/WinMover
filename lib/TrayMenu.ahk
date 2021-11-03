TrayMenu() {
	Menu, Tray, Icon, % A_IsCompiled ? A_ScriptFullPath 
							: FileExist(ico:=(A_ScriptDir "\res\" settings.AppName ".ico")) ? ico : "", % A_IsCompiled ? -159:""
	
	Menu, Tray, Tip, % settings.GuiTitle (A_IsAdmin ? "As Admin":"") "..."
	TrayTip, % settings.GuiTitle " is Running " (A_IsAdmin ? "As Admin" : ""), Activate a window and press <F12> to move & resize it, 1.5, 1
}
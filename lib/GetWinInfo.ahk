GetWinInfo(win:="") {
	global
	if (win) {
		WinActivate, %win%
		WinWaitActive, %win%,, 1
		if (ErrorLevel) {
			m("ico:!", "Couldn't activate given window:`n", win)
			return
		}
	}
	WinGetActiveStats, winTitle, ww, wh, wx, wy
	Gui, Destroy
	Gui()
}
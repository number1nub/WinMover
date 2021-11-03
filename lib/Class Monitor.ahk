class Monitors
{
	__New() {
		;~ this.Count := this.GetCount()
	}
	
	Count[] {
		get {
			sysget, monCount, 80
			return monCount
		}
		set {
			this._Count := value
		}
	}
	
	;~ GetCount() {
		;~ sysget, monCount, 80
		;~ return monCount
	;~ }
	
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
Class Settings
{
	static _appName := RegExReplace(A_ScriptName, "\.(ahk|exe)\s*$")
	
	_version := ""
	
	
	__New(scriptVer:="") {
		this._version := scriptVer ? scriptVer : this._version ? this._version : "2.0.001"
	}
	
	AppName[] {
		get {
			return this._appName
		}
		set {
			return
		}
	}
	
	Factor[sym:=""] {
		get {
			tmpFactors := {"+":5, "^":10, "!":20, "^+":50, "!^":100}
			tmp := tmpFactors[sym]
			return (tmp ? tmp : 1)
		}
		set {
			return
		}
	}
	
	GuiTitle[] {
		get {
			return this._appName " v" this._version
		}
		set {
			return
		}
	}
	
	RegStr[] {
		get {
			return "i)x?(?P<X>-?\d+) y?(?P<Y>-?\d+) w?(?P<W>-?\d+) h?(?P<H>-?\d+)"
		}
		set {
			return
		}
	}
	
	Version[] {
		get {
			return this._version
		}
		set {
			return
		}
	}
	
}
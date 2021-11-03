CheckFocus() {
	static ctrlList := "7,8,9,10"
	
	ControlGetFocus, ctrl, % settings.GuiTitle
	RegExMatch(ctrl, "i)Edit(\d+)", m)
	if m1 in %ctrlList%
	{
		GuiControlGet, curVal,, %ctrl%
		return {Name:ctrl, Value:curVal}
	}
}
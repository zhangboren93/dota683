function OnCareerIconPressed() {
	$.Msg("OnCareerIconPressed")
	let parentPanel = $.GetContextPanel().GetParent(); // the root panel of the current XML context
	let fwdPanel = parentPanel.FindChildrenWithClassTraverse("career-panel")
	if (fwdPanel.length > 0) {
		fwdPanel[0].visible = true
		fwdPanel[0].RemoveClass("panel-hidden")
	}
}

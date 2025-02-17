function OnFWDIconPressed() {
	let parentPanel = $.GetContextPanel().GetParent(); // the root panel of the current XML context
	let fwdPanel = parentPanel.FindChildrenWithClassTraverse("fwd-panel")
	fwdPanel[0].visible = true
	fwdPanel[0].RemoveClass("panel-hidden")
}

function showFWDButton() {
	let map_name = Game.GetMapInfo().map_name

	if (map_name == "maps/dota.vpk" && Game.GetAllPlayerIDs().length == 1) {
		$.GetContextPanel().visible = true
		$.GetContextPanel().RemoveClass("panel-hidden")
	} else {
		$.GetContextPanel().visible = false
	}
	$.Schedule(1, showFWDButton)
}

function OnMSMouseOver() {
	$("#ms-icon-hero-effect-tooltip").visible=true
}

function OnMSMouseOut() {
	$("#ms-icon-hero-effect-tooltip").visible=false
}

(function() {
	$.Schedule(1, showFWDButton);
})();


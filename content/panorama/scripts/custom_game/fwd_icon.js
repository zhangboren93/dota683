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

function OnMSIconPressed() {
	$.Msg("OnMSIconPressed");
	let parentPanel = $.GetContextPanel().GetParent(); // the root panel of the current XML context
	let fwdPanel = parentPanel.FindChildrenWithClassTraverse("magic-stick-panel")
	fwdPanel[0].visible = !fwdPanel[0].visible;
	if (fwdPanel[0].visible) {
		let hero_id = Players.GetSelectedHeroID(Players.GetLocalPlayer());
		$.Msg("Hero id: " + hero_id)
		if (hero_id == 8) {
			// juggernaut
			$.Msg("Finds juggernaut.")
			let children = fwdPanel[0].Children()
			children[1].visible = false;
		}
	}
}

(function() {
	$.Schedule(1, showFWDButton);
})();


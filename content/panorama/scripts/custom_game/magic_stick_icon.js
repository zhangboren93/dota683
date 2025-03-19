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
	if (fwdPanel[0].BHasClass("panel-hidden")) {
		fwdPanel[0].visible = true
		fwdPanel[0].RemoveClass("panel-hidden")
		let hero_id = Players.GetSelectedHeroID(Players.GetLocalPlayer());
		$.Msg("Hero id: " + hero_id)
		let children = fwdPanel[0].Children()
		if (hero_id == 8) {
			// juggernaut
			$.Msg("Finds juggernaut.")
			//children[1].visible = false;
			children[2].visible = true;
		} else if (hero_id == 1) {
			// antimage
			//children[1].visible = false;
			children[3].visible = true;
		} else if (hero_id == 71) {
			// spirit breaker
			//children[1].visible = false;
			children[4].visible = true;
		} else if (hero_id == 81) {
			// chaos knight
			children[5].visible = true;
		} else if (hero_id == 69) {
			// doom bringer
			children[6].visible = true;
		} else if (hero_id == 12) {
			// phantom lancer
			children[7].visible = true;
		} else if (hero_id == 93) {
			// slark
			children[8].visible = true;
		} else if (hero_id == 23) {
			// kunkka
			children[9].visible = true;
		} else if (hero_id == 104) {
			// lc
			children[10].visible = true;
		} else if (hero_id == 109) {
			// tb
			children[11].visible = true;
		} else if (hero_id == 11) {
			// sf
			children[12].visible = true;
		} else if (hero_id == 70) {
			// ursa
			children[13].visible = true;
		} else if (hero_id == 2) {
			// axe
			children[14].visible = true;
		}
	//	else if (hero_id == 17) {
	//		// storm spirit
	//		children[7].visible = true;
	//	}
	} else {
		fwdPanel[0].AddClass("panel-hidden")
		fwdPanel[0].visible = false
	}
}

function showMSButton() {
	let map_name = Game.GetMapInfo().map_name

	if (map_name == "maps/dota.vpk") {
		$.GetContextPanel().visible = true
		$.GetContextPanel().RemoveClass("panel-hidden")
	} else {
		$.GetContextPanel().visible = false
	}
	$.Schedule(1, showMSButton)
}
(function() {
	$.Schedule(1, showMSButton);
})();

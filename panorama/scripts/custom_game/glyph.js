function OnGlyphButtonPressed() {
	Game.PrepareUnitOrders({
		"OrderType": dotaunitorder_t.DOTA_UNIT_ORDER_GLYPH 
	})
}

function handleTeamGlyphCDTick(event) {
	if (event.cd <= 0) {
		$("#glyph-button-label").text = "";
	} else {
		$("#glyph-button-label").text = event.cd;
	}
}

GameEvents.Subscribe("team_glyph_cooldown_tick", handleTeamGlyphCDTick)

function pollFlippedHudStatus() {
	let panel = $.GetContextPanel();
	let rootHud = panel.GetParent().GetParent().GetParent();
	if (rootHud.BHasClass("HUDFlipped")) {
		if (!panel.BHasClass("RootHudFlipped")) {
			panel.AddClass("RootHudFlipped");
		}
	} else {
		if (panel.BHasClass("RootHudFlipped")) {
			panel.RemoveClass("RootHudFlipped");
		}
	}
	$.Schedule(1, pollFlippedHudStatus);
}
(function(){
	$.Schedule(1, pollFlippedHudStatus)
})()

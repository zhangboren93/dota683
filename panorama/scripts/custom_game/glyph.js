function OnGlyphButtonPressed() {
	Game.PrepareUnitOrders({
		"OrderType": dotaunitorder_t.DOTA_UNIT_ORDER_GLYPH 
	})
}

function handleTeamGlyphCDTick(event) {
	$("#glyph-button-label").text = event.cd;
}

GameEvents.Subscribe("team_glyph_cooldown_tick", handleTeamGlyphCDTick)
GameEvents.Subscribe("game_mode_selected_from_server", OnGameModeSelectedFromServer);

function handleModeSelect(mode) {
	$.Msg("handle mode select " + mode)
	GameEvents.SendCustomGameEventToServer("game_mode_select", { pid: Players.GetLocalPlayer(), gm: mode})
}

function OnGameModeSelectedFromServer(data) {
	$.Msg("OnGameModeSelectedFromServer")
	$.Msg(data)
	if (data.pid != Players.GetLocalPlayer()) {
		if (data.sp != null) {
			$.Msg("Other Client changed sp option " + data.sp)
			if (data.sp == 1) {
				$("#sp").SetSelected(true)
			} else {
				$("#sp").SetSelected(false)
			}
			return 
		}
		if (data.gm == "ap") {
			$("#ap").checked = true
		} else if (data.gm == "dm") {
			$("#dm").checked = true
		} else if (data.gm == "rd") {
			$("#rd").checked = true
		}
	}
}

function handleSamePickToggle() {
	$.Msg("handleSamePickToggle")
	$.Msg($("#sp").IsSelected())
	let sp = $("#sp").IsSelected()
	GameEvents.SendCustomGameEventToServer("game_mode_select", { pid: Players.GetLocalPlayer(), sp: sp})
}

(function() {
	let mapname = Game.GetMapInfo().map_name
	$.Msg("Map name: " + mapname)
	if (mapname == 'maps/custom.vpk') {
		$("#ModeSelect").visible = true
		$("#ap").checked = true
	}
})()

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
		} else if (data.sf != null) {
			$.Msg("Other Client changed sf option " + data.sf)
			if (data.sf == 1) {
				$("#sf").SetSelected(true)
			} else {
				$("#sf").SetSelected(false)
			}
			return 
		}
		if (data.gm == "ap") {
			$("#ap").checked = true
		} else if (data.gm == "dm") {
			$("#dm").checked = true
		} else if (data.gm == "rd") {
			$("#rd").checked = true
		} else if (data.gm == "js") {
			$("#js").checked = true
		}
	}
}

function handleSamePickToggle() {
	$.Msg("handleSamePickToggle")
	$.Msg($("#sp").IsSelected())
	let sp = $("#sp").IsSelected()
	GameEvents.SendCustomGameEventToServer("game_mode_select", { pid: Players.GetLocalPlayer(), sp: sp})
}

function handleShufflePlayers() {
	$.Msg("handleShufflePlayers")
	$.Msg($("#sf").IsSelected())
	let sf = $("#sf").IsSelected()
	GameEvents.SendCustomGameEventToServer("game_mode_select", { pid: Players.GetLocalPlayer(), sf: sf})
}

(function() {
	let mapname = Game.GetMapInfo().map_name
	$.Msg("Map name: " + mapname)
	if (mapname == 'maps/custom.vpk') {
		$("#ModeSelect").visible = true
		$("#ap").checked = true
	}
})()

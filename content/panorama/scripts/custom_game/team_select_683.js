GameEvents.Subscribe("game_mode_selected_from_server", OnGameModeSelectedFromServer);
GameEvents.Subscribe("team_select_player_stats", OnTeamSelectPlayerStats);

function OnTeamSelectPlayerStats(data) {
	$.Msg("OnTeamSelectPlayerStats")
	$.Msg(data)
	let radi_players = data.rp
	let dire_players = data.dp
	for(i=1;i<=5;i++) {
		let player = radi_players[""+i]
		if (player == null) {
			break;
		}
		let steam_id = player.sid
		let mmr = player.mmr
		$("#rank-team-radi-"+i+"-avatar").steamid = steam_id
		$("#rank-team-radi-"+i+"-name").steamid = steam_id
		$.Msg("Setting steam id to " + steam_id)
		$("#rank-team-radi-"+i+"-mmr").text = mmr
	}
	for(i=1;i<=5;i++) {
		let player = dire_players[""+i]
		if (player == null) {
			break;
		}
		let steam_id = player.sid
		let mmr = player.mmr
		$("#rank-team-dire-"+i+"-avatar").steamid = steam_id
		$("#rank-team-dire-"+i+"-name").steamid = steam_id
		$("#rank-team-dire-"+i+"-mmr").text = mmr
	}
	$("#RankTeamsList").visible = true
	$("#TeamsList").visible = false
}

function handleModeSelect(mode) {
	$.Msg("handle mode select " + mode)
	GameEvents.SendCustomGameEventToServer("game_mode_select", { pid: Players.GetLocalPlayer(), gm: mode})
}

function handleFirstPick(team) {
	$.Msg("handle first pick " + team)
	GameEvents.SendCustomGameEventToServer("game_mode_select", { fp: team })
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
		} else if (data.fp != null) {
			$.Msg("Other Client changed fp option " + data.fp)
			if (data.fp == "random") {
				$("#random").checked = true
			} else if (data.fp == "rad") {
				$("#rad").checked = true
			} else {
				$("#dire").checked = true
			}
			return 
		} else if (data.mv != null) {
			$.Msg("Other Client changed mv option " + data.mv)
			if (data.mv == "683") {
				$("#683").checked = true
			} else if (data.mv == "688") {
				$("#688").checked = true
			}
			return;
		}
		if (data.gm == "ap") {
			$("#ap").checked = true
		} else if (data.gm == "dm") {
			$("#dm").checked = true
		} else if (data.gm == "rd") {
			$("#rd").checked = true
		} else if (data.gm == "js") {
			$("#js").checked = true
		} else if (data.gm == "sp") {
			$("#sp").checked = true
		} else if (data.gm == "cm") {
			$("#cm").checked = true
		} else if (data.gm == "cd") {
			$("#cd").checked = true
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

function handleMetaVersion(version) {
	$.Msg("handle meta version " + version)
	GameEvents.SendCustomGameEventToServer("game_mode_select", { mv: version })
}

function handleJoinSpectTeam() {
	$.Msg("handle Join SpectTeam");
	Game.PlayerJoinTeam(DOTATeam_t.DOTA_TEAM_CUSTOM_1)
	$("#referee_slot_1").text = Players.GetPlayerName(Players.GetLocalPlayer())
	$("#referee_slot_1").AddClass("referee_slot_occupied")
	// TODO send join team event to other players
}

(function() {
	let mapname = Game.GetMapInfo().map_name
	$.Msg("Map name: " + mapname)
	if (mapname == 'maps/dota.vpk' || mapname == 'maps/dota_688g.vpk') {
		$("#ModeSelect").visible = true
		$("#ap").checked = true
		$("#random").checked = true
		//$("#683").checked = true
		local_player_info = Game.GetLocalPlayerInfo()
		if (local_player_info["player_has_host_privileges"]) {
			$("#mode_select_block_button").visible = false
		}
	} else if (mapname == 'maps/rank.vpk') {
		$('#ShuffleTeamAssignmentButton').visible = false
		$('#UnassignedPlayerPanel').visible = false
		$("#mode_select_block_button").visible = false
	} else if (mapname == 'maps/tour.vpk') {
		$("#mode_select_block_button").visible = false
//		$("#SpectTeamsList").visible = true
	} 
})()

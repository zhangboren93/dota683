GameEvents.Subscribe( "history-panel-scores", OnHistoryPanelScores);

function OnHistoryPanelCloseClicked() {
	$.GetContextPanel().visible=false;
	$.GetContextPanel().AddClass("panel-hidden")
}

function OnHistoryPanelScores(data) {
	$.Msg(data)
	let team = DOTATeam_t.DOTA_TEAM_GOODGUYS
	let pref = "r";
	let radi_players = Game.GetPlayerIDsOnTeam(team);
	for (let i = 0; i < radi_players.length; i++) {
		let pid = radi_players[i]
		if (pid >= data.length) {
			continue;
		}
		let player_info = Game.GetPlayerInfo(pid)
		$.Msg(player_info)
		let steamid = player_info["player_steamid"];
		let hero = Players.GetPlayerSelectedHero(pid)
		let score = data[pid+1]['1']
		let game = parseInt(data[pid+1]['2']) + parseInt(data[pid+1]['3'])
    	$("#"+pref+"count"+(i+1)).text = game;
		if (game == 0) {
			game = 1;
		}
		let winr = Math.floor(parseInt(data[pid+1]['2']) * 100 / game) + "%";
    	$("#"+pref+"score"+(i+1)).text = score;
    	$("#"+pref+"winr" +(i+1)).text = winr;
		$("#"+pref+"dhi"  +(i+1)).heroname = hero;
		$("#"+pref+"dun"  +(i+1)).steamid = steamid;
	}
	team = DOTATeam_t.DOTA_TEAM_BADGUYS;
	pref = "d";
	radi_players = Game.GetPlayerIDsOnTeam(team);
	for (let i = 0; i < radi_players.length; i++) {
		let pid = radi_players[i]
		if (pid >= data.length) {
			continue;
		}
		let player_info = Game.GetPlayerInfo(pid)
		$.Msg(player_info)
		let steamid = player_info["player_steamid"];
		let hero = Players.GetPlayerSelectedHero(pid)
		let score = data[pid+1]['1']
		let game = parseInt(data[pid+1]['2']) + parseInt(data[pid+1]['3'])
    	$("#"+pref+"count"+(i+1)).text = game;
		if (game == 0) {
			game = 1;
		}
		let winr = Math.floor(parseInt(data[pid+1]['2']) * 100 / game) + "%";
    	$("#"+pref+"score"+(i+1)).text = score;
    	$("#"+pref+"winr" +(i+1)).text = winr;
		$("#"+pref+"dhi"  +(i+1)).heroname = hero;
		$("#"+pref+"dun"  +(i+1)).steamid = steamid;
	}
}

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
	for (int i = 0; i < radi_players.length; i++) {
		let pid = radi_players[i]
		if (pid >= data.length) {
			continue;
		}
		let player_info = Game.GetPlayerInfo(pid)
		$.Msg(player_info)
		let hero = Players.GetPlayerSelectedHero(pid)
		let score = radi_players[i][0]
		let game = radi_players[i][1] + radi_players[i][2]
		let winr = Math.floor(radi_players[i][1] * 100 / game) + "%";
    	$("#"+pref+"score"+(i+1)).text = score;
    	$("#"+pref+"count"+(i+1)).text = game;
    	$("#"+pref+"winr" +(i+1)).text = winr;
		$("#"+pref+"dhi"  +(i+1)).heroname = hero;
	}
}

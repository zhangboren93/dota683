GameEvents.Subscribe("career_player_stats", handleCareerPlayerStats);

function handleCareerPlayerStats(event) {
	$.Msg("handleCareerPlayerStats");
	$.Msg(event)
	if (event.pid == Players.GetLocalPlayer()) {
		let mmr = event['mmr']
		let trg = event['trg']
		let trwg = event['trwg']
		if (mmr) {
			$("#mmr").text = mmr
		}
		if (trg) {
			$("#games").text = trg
		}
		if (trg > 0) {
			let win_rate = (trwg * 100 / trg) + "%"
			$("#wins").text = win_rate
		}
	}
}

function careerCloseButtonPressed() {
	$.GetContextPanel().visible = false;
	$.GetContextPanel().AddClass("panel-hidden")
}

(function(){
	$("#local-player-name").text = Players.GetPlayerName(Players.GetLocalPlayer());
})();

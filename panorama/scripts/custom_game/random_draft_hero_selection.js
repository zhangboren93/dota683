GameEvents.Subscribe("random_draft_start", OnRandomDraftStart)
GameEvents.Subscribe("random_draft_player_start", OnRandomDraftPlayerStart)

function OnRandomDraftStart(data) {
	$.Msg(data)
	if (data.spid == Players.GetLocalPlayer()) {
		return
	}
	let team = Players.GetTeam(Players.GetLocalPlayer())
	let playerIdsInTeam = Game.GetPlayerIDsOnTeam(team)
	let team_idx = -1
	for (let i = 0; i < playerIdsInTeam.length; i++) {
		if (playerIdsInTeam[i] == Players.GetLocalPlayer()) {
			team_idx = i;
			break;
		}
	}
	if (team == DOTATeam_t.DOTA_TEAM_GOODGUYS) {
		if (team_idx <= 2) {
			$("#turn-to-pick-time-label").text = "1:20";
		} else {
			$("#turn-to-pick-time-label").text = "0:40";
		}
	} else {
		if (team_idx == 0) {
			$("#turn-to-pick-time-label").text = "1:40";
		} else if (team_idx <= 2) {
			$("#turn-to-pick-time-label").text = "1:00";
		} else {
			$("#turn-to-pick-time-label").text = "0:20";
		}
	}
	$.GetContextPanel().RemoveClass("random-draft-panel-hide")
	for (let i = 1; i < 25; i++) {
		$("#hero-image-str-" + i).heroname = data['sh'][i.toString()]
	}
}

function OnRandomDraftPlayerStart(data) {
	if (data.spid == Players.GetLocalPlayer()) {
		$.GetContextPanel().visible = false
	}
}


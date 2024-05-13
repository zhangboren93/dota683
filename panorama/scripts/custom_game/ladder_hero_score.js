GameEvents.Subscribe("hero_select_player_ladder_scores", OnHeroPickPlayerLadderScore);

function OnHeroPickPlayerLadderScore(data) {
	$.Msg("OnHeroPickPlayerLadderScore")
	$.Msg(data)
	scoreTeam2LabelPrefix(data, DOTATeam_t.DOTA_TEAM_GOODGUYS, "#rad_player_");
	scoreTeam2LabelPrefix(data, DOTATeam_t.DOTA_TEAM_BADGUYS, "#dir_player_");
	$.GetContextPanel().RemoveClass("hidden");
}

function scoreTeam2LabelPrefix(data, team, prefix) {
	let rad_ids = Game.GetPlayerIDsOnTeam(team)
	$.Msg(rad_ids)
	for (let i = 0; i < rad_ids.length; i++) {
		let score = data[rad_ids[i]]
		if (score >= 0) {
			$(prefix + (i+1) + "_score").text = score
		}
	}
}

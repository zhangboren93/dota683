(function () {
	var radiant_players = Game.GetPlayerIDsOnTeam(DOTATeam_t.DOTA_TEAM_GOODGUYS)
	$.Msg("Radiant player count " + radiant_players.length)
	for (var i = 0; i < radiant_players.length; i++) {
		$("#hero-image-" + i).heroname = Players.GetPlayerSelectedHero(radiant_players[i]);
		$("#player-name-" + i).text = Players.GetPlayerName(radiant_players[i]);
		$("#level-" + i).text = Players.GetLevel(radiant_players[i]);
		$("#kill-" + i).text = Players.GetKills(radiant_players[i]);
		$("#death-" + i).text = Players.GetDeaths(radiant_players[i]);
		$("#assist-" + i).text = Players.GetAssists(radiant_players[i]);
		$("#last-hit-" + i).text = Players.GetLastHits(radiant_players[i]) + "/" + Players.GetDenies(radiant_players[i]);
		$("#gxpm-" + i).text = Math.floor(Players.GetGoldPerMin(radiant_players[i])) + "/" + Math.floor(Players.GetXPPerMin(radiant_players[i]));
		var player_hero = Players.GetPlayerHeroEntityIndex(radiant_players[i])
		for (var j = 0; j < 6; j++) {
			var item = Entities.GetItemInSlot(player_hero, j);
			if (item !== -1) {
				$("#item-p" + i + "-i" + j).itemname = 	Abilities.GetAbilityName(item);
			}
		}
	}

	//dire players
	radiant_players = Game.GetPlayerIDsOnTeam(DOTATeam_t.DOTA_TEAM_BADGUYS)
	$.Msg("Dire player count " + radiant_players.length)
	for (var i = 5; i < 5 + radiant_players.length; i++) {
		$("#hero-image-" + i).heroname = Players.GetPlayerSelectedHero(radiant_players[i-5]);
		$("#player-name-" + i).text = Players.GetPlayerName(radiant_players[i-5]);
		$("#level-" + i).text = Players.GetLevel(radiant_players[i-5]);
		$("#kill-" + i).text = Players.GetKills(radiant_players[i-5]);
		$("#death-" + i).text = Players.GetDeaths(radiant_players[i-5]);
		$("#assist-" + i).text = Players.GetAssists(radiant_players[i-5]);
		$("#last-hit-" + i).text = Players.GetLastHits(radiant_players[i-5]) + "/" + Players.GetDenies(radiant_players[i-5]);
		$("#gxpm-" + i).text = Math.floor(Players.GetGoldPerMin(radiant_players[i-5])) + "/" + Math.floor(Players.GetXPPerMin(radiant_players[i-5]));
		var player_hero = Players.GetPlayerHeroEntityIndex(radiant_players[i-5])
		for (var j = 0; j < 6; j++) {
			var item = Entities.GetItemInSlot(player_hero, j);
			if (item !== -1) {
				$.Msg(i + " " + j)
				$("#item-p" + i + "-i" + j).itemname = 	Abilities.GetAbilityName(item);
			}
		}
	}
})();

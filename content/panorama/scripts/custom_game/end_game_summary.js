function formatDamage(damage) {
	if (damage < 1000) {
		return Math.floor(damage).toString();
	}
	let hundreds = Math.floor((damage / 100) % 10);
	return Math.floor(damage/1000) + "." + hundreds + "k";
}


function fillExtraSummaryInfo(players, slot, titles) {
	for (var i = 0; i < players.length; i++) {
		let heroDamage = Players.extraPlayerStats.psm[players[i].toString()].hd
		if (heroDamage) {
			$("#hero-damage-" + (i+slot)).text = formatDamage(heroDamage)
		}
		let netWorth = Players.extraPlayerStats.psm[players[i].toString()].nw
		if (netWorth) {
			$("#networth-" + (i+slot)).text = formatDamage(netWorth);
		}
		let buildingDamage = Players.extraPlayerStats.psm[players[i].toString()].bd
		if (buildingDamage) {
			$("#building-damage-" + (i+slot)).text = formatDamage(buildingDamage);
		}

		if (titles.mvp == players[i]) {
			$("#kda-" + (i+slot)).text = "MVP";
		}
	}
}

function fillExtraSummaryInfoForAll() {
	let radiant_players = Game.GetPlayerIDsOnTeam(DOTATeam_t.DOTA_TEAM_GOODGUYS)
	let dire_players = Game.GetPlayerIDsOnTeam(DOTATeam_t.DOTA_TEAM_BADGUYS)

	let all_players = []
	for (let i=0;i<radiant_players.length;i++) {
		all_players.push(radiant_players[i])
	}
	for (let i=0;i<dire_players.length;i++) {
		all_players.push(dire_players[i])
	}
	let mvp_player_id = -1
	let mvp_score = -1
	let winning_players = []
	if (Game.GetGameWinner() == DOTATeam_t.DOTA_TEAM_GOODGUYS) {
		winning_players = radiant_players
	} else {
		winning_players = dire_players
	}
	for (let i=0;i<winning_players.length;i++) {
		let kill = Players.GetKills(winning_players[i]);
		let death = Players.GetDeaths(winning_players[i]);
		let assist = Players.GetAssists(winning_players[i]);
		// TODO compare kill streak if kda same
		if (kill + assist - death > mvp_score) {
			mvp_player_id = winning_players[i]
			mvp_score = kill + assist - death
		}
	}
	$.Msg("MVP is player " + mvp_player_id + " with score " + mvp_score)
	
	fillExtraSummaryInfo(radiant_players, 0, { mvp: mvp_player_id });
	fillExtraSummaryInfo(dire_players, 5, { mvp: mvp_player_id });
}

(function () {
	let radiant_players = Game.GetPlayerIDsOnTeam(DOTATeam_t.DOTA_TEAM_GOODGUYS)
	$.Msg("Radiant player count " + radiant_players.length)
	for (var i = 0; i < radiant_players.length; i++) {
		$("#hero-image-" + i).heroname = Players.GetPlayerSelectedHero(radiant_players[i]);
		$("#player-name-" + i).text = Players.GetPlayerName(radiant_players[i]);
		$("#level-" + i).text = Players.GetLevel(radiant_players[i]);
		$("#kill-" + i).text = Players.GetKills(radiant_players[i]);
		$("#death-" + i).text = Players.GetDeaths(radiant_players[i]);
		$("#assist-" + i).text = Players.GetAssists(radiant_players[i]);
		$("#last-hit-" + i).text = Players.GetLastHits(radiant_players[i]) + "/" + Players.GetDenies(radiant_players[i]);
		$("#gxpm-" + i).text = formatDamage(Players.GetGoldPerMin(radiant_players[i])) + "/" + formatDamage(Players.GetXPPerMin(radiant_players[i]));
		var player_hero = Players.GetPlayerHeroEntityIndex(radiant_players[i])
		for (var j = 0; j < 6; j++) {
			var item = Entities.GetItemInSlot(player_hero, j);
			if (item !== -1) {
				$("#item-p" + i + "-i" + j).itemname = 	Abilities.GetAbilityName(item);
			}
		}
	}

	//dire players
	let dire_players = Game.GetPlayerIDsOnTeam(DOTATeam_t.DOTA_TEAM_BADGUYS)
	$.Msg("Dire player count " + dire_players.length)
	for (var i = 5; i < 5 + dire_players.length; i++) {
		$("#hero-image-" + i).heroname = Players.GetPlayerSelectedHero(dire_players[i-5]);
		$("#player-name-" + i).text = Players.GetPlayerName(dire_players[i-5]);
		$("#level-" + i).text = Players.GetLevel(dire_players[i-5]);
		$("#kill-" + i).text = Players.GetKills(dire_players[i-5]);
		$("#death-" + i).text = Players.GetDeaths(dire_players[i-5]);
		$("#assist-" + i).text = Players.GetAssists(dire_players[i-5]);
		$("#last-hit-" + i).text = Players.GetLastHits(dire_players[i-5]) + "/" + Players.GetDenies(dire_players[i-5]);
		$("#gxpm-" + i).text = formatDamage(Players.GetGoldPerMin(dire_players[i-5])) + "/" + formatDamage(Players.GetXPPerMin(dire_players[i-5]));
		var player_hero = Players.GetPlayerHeroEntityIndex(dire_players[i-5])
		for (var j = 0; j < 6; j++) {
			var item = Entities.GetItemInSlot(player_hero, j);
			if (item !== -1) {
				$.Msg(i + " " + j)
				$("#item-p" + i + "-i" + j).itemname = 	Abilities.GetAbilityName(item);
			}
		}
	}

	$.Msg("Global player stat is " + Players.extraPlayerStats);
	if (Players.extraPlayerStats == undefined) {
		$.Schedule(3, fillExtraSummaryInfoForAll);
	} else {
		fillExtraSummaryInfoForAll()
	}
})();

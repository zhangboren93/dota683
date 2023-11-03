GameEvents.Subscribe("player_ladder_scores", OnPlayerLadderScores);
GameEvents.Subscribe("end_game_summary_stats", OnEndGameStats);
function OnPlayerLadderScores(event) {
	$.Msg("player ladder scores");
	$.Msg(event);
	$.Schedule(1, function() {
		replaceLadderScoreboard(event);
	});
}
function replaceLadderScoreboard(player2score) {
	var PanelHUD = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements");
	let mapName = Game.GetMapInfo().map_display_name;
	if (mapName == "rank") {
		let scoreboard = PanelHUD.FindChildTraverse("scoreboard");
		for(let i = 0;i < 5;i++) {
			let playerScore = scoreboard.FindChildTraverse("RadiantPlayer" + i);
			if (playerScore == null) {
				$.Schedule(1, function() {
					replaceLadderScoreboard(player2score);
				});
				return;
			}
			if (playerScore) {
				playerScore.FindChildTraverse("TalentTree").visible = false;
				let lsid = "ls_rad_" + i;
				if (!playerScore.FindChildTraverse(lsid)) {
					let newChildPanel = $.CreatePanel( "Panel", playerScore, lsid);
					newChildPanel.BLoadLayout("file://{resources}/layout/custom_game/ladder_score.xml", false, false);
					let score = player2score[(i+1).toString()]
					if (score >= 0) {
						newChildPanel.FindChildTraverse("ladder_score_label").text = score;
					}
					playerScore.MoveChildBefore(newChildPanel, playerScore.GetChild(2));
				}
			}
		}
		for(let i = 0;i < 5;i++) {
			let playerScore = scoreboard.FindChildTraverse("DirePlayer" + i);
			if (playerScore) {
				playerScore.FindChildTraverse("TalentTree").visible = false;
				let lsid = "ls_dir_" + i;
				if (!playerScore.FindChildTraverse(lsid)) {
					let newChildPanel = $.CreatePanel( "Panel", playerScore, lsid);
					newChildPanel.BLoadLayout("file://{resources}/layout/custom_game/ladder_score.xml", false, false);
					let score = player2score[(i+6).toString()]
					if (score >= 0) {
						newChildPanel.FindChildTraverse("ladder_score_label").text = score;
					}
					playerScore.MoveChildBefore(newChildPanel, playerScore.GetChild(2));
				}
			}
		}
	}
}

function OnEndGameStats(event) {
	$.Msg("OnEndGameStats")
	$.Msg(event)
	Players.extraPlayerStats = event;
}
(function() {
	var PanelHUD = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements");
	var RadarButton = PanelHUD.FindChildTraverse("RadarButton");
	RadarButton.style.visibility = "collapse";
	var CenterBlock = PanelHUD.FindChildTraverse("center_block");
	CenterBlock.FindChildTraverse("inventory_composition_layer_container").style.visibility = "collapse";
	GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_PROTECT, false);
	GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_COURIER, false);

    let combat_events = PanelHUD.FindChildTraverse("combat_events");
    combat_events.visible = false;
})();


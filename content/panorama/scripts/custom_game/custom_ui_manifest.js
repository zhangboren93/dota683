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
        let radiantPlayers = Game.GetPlayerIDsOnTeam(DOTATeam_t.DOTA_TEAM_GOODGUYS)
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
                    let score = 0
                    if (i < radiantPlayers.length) {
                        score = player2score[radiantPlayers[i].toString()]
                    }
                    if (score >= 0) {
                        newChildPanel.FindChildTraverse("ladder_score_label").text = score;
                    }
                    playerScore.MoveChildBefore(newChildPanel, playerScore.GetChild(2));
                }
            }
        }
        let direPlayers = Game.GetPlayerIDsOnTeam(DOTATeam_t.DOTA_TEAM_BADGUYS)
        for(let i = 0;i < 5;i++) {
            let playerScore = scoreboard.FindChildTraverse("DirePlayer" + i);
            if (playerScore) {
                playerScore.FindChildTraverse("TalentTree").visible = false;
                let lsid = "ls_dir_" + i;
                if (!playerScore.FindChildTraverse(lsid)) {
                    let newChildPanel = $.CreatePanel( "Panel", playerScore, lsid);
                    newChildPanel.BLoadLayout("file://{resources}/layout/custom_game/ladder_score.xml", false, false);
                    let score = 0;
                    if (i < direPlayers.length) {
                        score = player2score[direPlayers[i].toString()]
                    }
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

    let LowerTalentArea = PanelHUD.FindChildTraverse("LowerTalentArea");
    let oldStatOption = LowerTalentArea.FindChildTraverse("StatUpgradeOption");
    oldStatOption.visible = false;

    let newStatOption = $.CreatePanel("Panel", LowerTalentArea, "StatUpgradeOption");
    newStatOption.BLoadLayout("file://{resources}/layout/custom_game/custom_talent_tree.xml", false, false);
    LowerTalentArea.MoveChildBefore(newStatOption, LowerTalentArea.GetChild(1));

    let backpack_list = PanelHUD.FindChildTraverse("inventory_backpack_list");
    backpack_list.visible = false;

    var StatBranch = PanelHUD.FindChildTraverse("StatBranchColumn");
    StatBranch.visible = false;
    StatBranch = PanelHUD.FindChildTraverse("LevelColumn");
    StatBranch.visible = false;

    var ShardBlock = PanelHUD.FindChildTraverse("AghsStatusShard");
    ShardBlock.visible = false;
    ShardBlock = PanelHUD.FindChildTraverse("AghsStatusShardScene");
    ShardBlock.visible = false;
    ShardBlock = PanelHUD.FindChildTraverse("AghsShardStatusConversion");
    ShardBlock.visible = false;
})();


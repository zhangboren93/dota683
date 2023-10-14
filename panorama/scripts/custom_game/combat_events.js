GameEvents.Subscribe("player_kill_custom_bonus", OnPlayerKillCustomBonus);
GameEvents.Subscribe("player_killed_by_creep_bonus", OnPlayerKilledByCreepBonus);

function OnPlayerKillCustomBonus(event) {
	$.Msg("OnPlayerKillCustomBonus " + event.kpid + " " + event.vpid + " " + event.gold);
	let parentPanel = $.GetContextPanel()
	let newChildPanel = $.CreatePanel( "Panel", parentPanel, "pke_" + event.kpid + "x" + event.vpid + "g" + event.gold);
	newChildPanel.BLoadLayout("file://{resources}/layout/custom_game/combat_event_hero_kill.xml", false, false);
	newChildPanel.FindChildTraverse("label_gold_amount").text = event.gold
	newChildPanel.FindChildTraverse("killer_hero").heroname = Players.GetPlayerSelectedHero(event.kpid);
	newChildPanel.FindChildTraverse("killer_player_name").text = Players.GetPlayerName(event.kpid);
	newChildPanel.FindChildTraverse("victim_hero").heroname = Players.GetPlayerSelectedHero(event.vpid);
	newChildPanel.FindChildTraverse("victim_player_name").text = Players.GetPlayerName(event.vpid);
	combatEventCommon(parentPanel, newChildPanel, event)
}

function OnPlayerKilledByCreepBonus(event) {
	let parentPanel = $.GetContextPanel()
	let newChildPanel = $.CreatePanel( "Panel", parentPanel, "pkc_" + event.vpid + "g" + event.gold);
	newChildPanel.BLoadLayout("file://{resources}/layout/custom_game/combat_event_creep_kill.xml", false, false);
	newChildPanel.FindChildTraverse("label_gold_amount").text = event.gold
	newChildPanel.FindChildTraverse("victim_hero").heroname = Players.GetPlayerSelectedHero(event.vpid);
	newChildPanel.FindChildTraverse("victim_player_name").text = Players.GetPlayerName(event.vpid);
	if (Players.GetTeam(event.vpid) == DOTATeam_t.DOTA_TEAM_GOODGUYS) {
		newChildPanel.FindChildTraverse("label_radiant_killer").visible = false;
	} else {
		newChildPanel.FindChildTraverse("label_dire_killer").visible = false;
	}

	combatEventCommon(parentPanel, newChildPanel, event)
}

function combatEventCommon(parentPanel, newChildPanel, event) {
	if (parentPanel.GetChildCount() > 1) {
		parentPanel.MoveChildBefore(newChildPanel, parentPanel.GetChild(0));
	}
	if (Players.GetTeam(event.vpid) == Players.GetTeam(Players.GetLocalPlayer())) {
		newChildPanel.AddClass("combat_event_hostile");
	} else {
		newChildPanel.AddClass("combat_event_friendly");
	}
	$.Schedule(10, function() { newChildPanel.DeleteAsync(0); });
}

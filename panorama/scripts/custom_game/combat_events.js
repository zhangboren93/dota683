GameEvents.Subscribe("player_kill_custom_bonus", OnPlayerKillCustomBonus);
GameEvents.Subscribe("player_killed_by_creep_bonus", OnPlayerKilledByCreepBonus);
GameEvents.Subscribe("player_denied", OnPlayerDenied);
GameEvents.Subscribe("player_killed_by_neutral", OnPlayerKilledByNeutral);
GameEvents.Subscribe("team_bounty_building_destroyed", OnTeamBountyBuildingDestroyed);

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

function OnPlayerDenied(event) {
	let parentPanel = $.GetContextPanel()
	if (event.kpid == event.vpid) {
		let newChildPanel = $.CreatePanel( "Panel", parentPanel, "ps_" + event.vpid);
		newChildPanel.BLoadLayout("file://{resources}/layout/custom_game/combat_event_hero_suicide.xml", false, false);
		newChildPanel.FindChildTraverse("victim_hero").heroname = Players.GetPlayerSelectedHero(event.vpid);
		newChildPanel.FindChildTraverse("victim_player_name").text = Players.GetPlayerName(event.vpid);
		combatEventCommon(parentPanel, newChildPanel, event)
	} else {
		let newChildPanel = $.CreatePanel( "Panel", parentPanel, "pd_" + event.kpid + "x" + event.vpid);
		newChildPanel.BLoadLayout("file://{resources}/layout/custom_game/combat_event_player_denied.xml", false, false);
		newChildPanel.FindChildTraverse("killer_hero").heroname = Players.GetPlayerSelectedHero(event.kpid);
		newChildPanel.FindChildTraverse("killer_player_name").text = Players.GetPlayerName(event.kpid);
		newChildPanel.FindChildTraverse("victim_hero").heroname = Players.GetPlayerSelectedHero(event.vpid);
		newChildPanel.FindChildTraverse("victim_player_name").text = Players.GetPlayerName(event.vpid);
		combatEventCommon(parentPanel, newChildPanel, event)
	}

}

function OnPlayerKilledByNeutral(event) {
	let parentPanel = $.GetContextPanel()
	let newChildPanel = $.CreatePanel( "Panel", parentPanel, "pkn_" + event.vpid);
	newChildPanel.BLoadLayout("file://{resources}/layout/custom_game/combat_event_hero_killed_by_neutral.xml", false, false);
	newChildPanel.FindChildTraverse("victim_hero").heroname = Players.GetPlayerSelectedHero(event.vpid);
	newChildPanel.FindChildTraverse("victim_player_name").text = Players.GetPlayerName(event.vpid);
	combatEventCommon(parentPanel, newChildPanel, event)
}

function OnTeamBountyBuildingDestroyed(event) {
	let parentPanel = $.GetContextPanel()
	let newChildPanel = $.CreatePanel( "Panel", parentPanel, "tbbd_" + event.kpid + "x" + event.bname + "g" + event.gold);
	newChildPanel.BLoadLayout("file://{resources}/layout/custom_game/combat_event_building_destroyed.xml", false, false);
	let buildingTeam = getBuildingTeam(event.bname);
	if (event.pkid == -1) {
		if (buildingTeam == DOTATeam_t.DOTA_TEAM_GOODGUYS) {
			newChildPanel.FindChildTraverse("killer_name").text = "天灾军团";
		} else {
			newChildPanel.FindChildTraverse("killer_name").text = "近卫军团";
		}
	} else {
		newChildPanel.FindChildTraverse("killer_name").text = Players.GetPlayerName(event.kpid);
		newChildPanel.FindChildTraverse("killer_hero").heroname = Players.GetPlayerSelectedHero(event.kpid);
	}
	//TODO buildingType image
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

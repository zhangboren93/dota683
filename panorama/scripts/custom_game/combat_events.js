GameEvents.Subscribe("player_kill_custom_bonus", OnPlayerKillCustomBonus);
GameEvents.Subscribe("player_killed_by_creep_bonus", OnPlayerKilledByCreepBonus);
GameEvents.Subscribe("player_denied", OnPlayerDenied);
GameEvents.Subscribe("player_killed_by_neutral", OnPlayerKilledByNeutral);
GameEvents.Subscribe("team_bounty_building_destroyed", OnTeamBountyBuildingDestroyed);
GameEvents.Subscribe("dota_buyback", OnBuyback);
GameEvents.Subscribe("combat_event_roshan_killed", OnRoshanKilled);
GameEvents.Subscribe("aegis_picked_up", OnAegisPickedUp);
GameEvents.Subscribe("courier_killed", OnCourierKilled);
GameEvents.Subscribe("player_rune_activated", OnPlayerRuneActivated);
GameEvents.Subscribe("player_rune_denied", OnPlayerRuneDenied);
GameEvents.Subscribe("player_ward_killed", OnPlayerWardKilled);
GameEvents.Subscribe("player_kill_streak", OnPlayerKillStreak);
GameEvents.Subscribe("player_streak_shutdown", OnPlayerStreakShutdown);

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

BUILDING_NAME_2_TYPE_ID = {
	dota_goodguys_tower1_top: "上1塔",
	dota_goodguys_tower1_mid: "中1塔",
	dota_goodguys_tower1_bot: "下1塔",
	dota_goodguys_tower2_top: "上2塔",
	dota_goodguys_tower2_mid: "中2塔",
	dota_goodguys_tower2_bot: "下2塔",
	dota_goodguys_tower3_top: "上3塔",
	dota_goodguys_tower3_mid: "中3塔",
	dota_goodguys_tower3_bot: "下3塔",
	dota_goodguys_tower4_top: "上4塔",
	dota_goodguys_tower4_bot: "下4塔",
	dota_badguys_tower1_top: "上1塔",
	dota_badguys_tower1_mid: "中1塔",
	dota_badguys_tower1_bot: "下1塔",
	dota_badguys_tower2_top: "上2塔",
	dota_badguys_tower2_mid: "中2塔",
	dota_badguys_tower2_bot: "下2塔",
	dota_badguys_tower3_top: "上3塔",
	dota_badguys_tower3_mid: "中3塔",
	dota_badguys_tower3_bot: "下3塔",
	dota_badguys_tower4_top: "上4塔",
	dota_badguys_tower4_bot: "下4塔",
	good_rax_melee_top: "上路近战兵营",
	good_rax_melee_mid: "中路近战兵营",
	good_rax_melee_bot: "下路近战兵营",
	bad_rax_melee_top: "上路近战兵营",
	bad_rax_melee_mid: "中路近战兵营",
	bad_rax_melee_bot: "下路近战兵营",
	good_rax_range_top: "上路远程兵营",
	good_rax_range_mid: "中路远程兵营",
	good_rax_range_bot: "下路远程兵营",
	bad_rax_range_top: "上路远程兵营",
	bad_rax_range_mid: "中路远程兵营",
	bad_rax_range_bot: "下路远程兵营",
	dota_badguys_fort: "基地",
	dota_goodguys_fort: "基地"
}
function getBuildingTeam(bname) {
	return bname.includes("good") ? DOTATeam_t.DOTA_TEAM_GOODGUYS : DOTATeam_t.DOTA_TEAM_BADGUYS; 
}
function OnTeamBountyBuildingDestroyed(event) {
	$.Msg("OnTeamBountyBuildingDestroyed " + event.bname + " " + BUILDING_NAME_2_TYPE_ID[event.bname]);
	let buildingTeam = getBuildingTeam(event.bname);
	if(event.kpid == -1 || buildingTeam != Players.GetTeam(event.kpid)) {
		let parentPanel = $.GetContextPanel()
		let newChildPanel = $.CreatePanel( "Panel", parentPanel, "tbbd_" + event.kpid + "x" + event.bname + "g" + event.gold);
		newChildPanel.BLoadLayout("file://{resources}/layout/custom_game/combat_event_building_destroyed.xml", false, false);
		if (event.kpid == -1) {
			if (buildingTeam == DOTATeam_t.DOTA_TEAM_GOODGUYS) {
				newChildPanel.FindChildTraverse("killer_name").text = "天灾军团";
			} else {
				newChildPanel.FindChildTraverse("killer_name").text = "近卫军团";
			}
			newChildPanel.FindChildTraverse("killer_hero").visible = false;
		} else {
			newChildPanel.FindChildTraverse("killer_name").text = Players.GetPlayerName(event.kpid);
			newChildPanel.FindChildTraverse("killer_hero").heroname = Players.GetPlayerSelectedHero(event.kpid);
		}
		newChildPanel.FindChildTraverse("label_gold_amount").text = event.gold
		newChildPanel.FindChildTraverse("victim_tower").text = BUILDING_NAME_2_TYPE_ID[event.bname];

		victeamAndKillerIcon(buildingTeam, newChildPanel)
		if (parentPanel.GetChildCount() > 1) {
			parentPanel.MoveChildBefore(newChildPanel, parentPanel.GetChild(0));
		}
		let validUntil = Game.GetGameTime() + 10;
		newChildPanel.SetAttributeInt("ValidUntil", Math.floor(validUntil));
	}
}

function OnBuyback(event) {
	let parentPanel = $.GetContextPanel()
	let newChildPanel = $.CreatePanel( "Panel", parentPanel, "bb_" + event.player_id);
	newChildPanel.BLoadLayout("file://{resources}/layout/custom_game/combat_event_buyback.xml", false, false);
	newChildPanel.FindChildTraverse("hero_icon").heroname = Players.GetPlayerSelectedHero(event.player_id);
	newChildPanel.FindChildTraverse("killer_name").text = Players.GetPlayerName(event.player_id);
	if (parentPanel.GetChildCount() > 1) {
		parentPanel.MoveChildBefore(newChildPanel, parentPanel.GetChild(0));
	}
	if (Players.GetTeam(event.player_id) != Players.GetTeam(Players.GetLocalPlayer())) {
		newChildPanel.AddClass("combat_event_hostile");
	} else {
		newChildPanel.AddClass("combat_event_friendly");
	}
	let validUntil = Game.GetGameTime() + 10;
	newChildPanel.SetAttributeInt("ValidUntil", Math.floor(validUntil));
}

function OnRoshanKilled(event) {
	let kpid = event.kpid
	let parentPanel = $.GetContextPanel()
	let newChildPanel = $.CreatePanel( "Panel", parentPanel, "rk_" + kpid);
	newChildPanel.BLoadLayout("file://{resources}/layout/custom_game/combat_event_roshan_killed.xml", false, false);
	newChildPanel.FindChildTraverse("killer_hero").heroname = Players.GetPlayerSelectedHero(kpid);
	newChildPanel.FindChildTraverse("killer_player_name").text = Players.GetPlayerName(kpid);
	killteamAndKillerIcon(Players.GetTeam(kpid), newChildPanel)
	if (parentPanel.GetChildCount() > 1) {
		parentPanel.MoveChildBefore(newChildPanel, parentPanel.GetChild(0));
	}
	let validUntil = Game.GetGameTime() + 10;
	newChildPanel.SetAttributeInt("ValidUntil", Math.floor(validUntil));
}

function OnAegisPickedUp(event) {
	let kpid = event.kpid
	let parentPanel = $.GetContextPanel()
	let newChildPanel = $.CreatePanel( "Panel", parentPanel, "ap_" + kpid);
	newChildPanel.BLoadLayout("file://{resources}/layout/custom_game/combat_event_aegis.xml", false, false);
	newChildPanel.FindChildTraverse("killer_hero").heroname = Players.GetPlayerSelectedHero(kpid);
	newChildPanel.FindChildTraverse("killer_player_name").text = Players.GetPlayerName(kpid);
	if (parentPanel.GetChildCount() > 1) {
		parentPanel.MoveChildBefore(newChildPanel, parentPanel.GetChild(0));
	}
	if (Players.GetTeam(kpid) != Players.GetTeam(Players.GetLocalPlayer())) {
		newChildPanel.AddClass("combat_event_hostile");
	} else {
		newChildPanel.AddClass("combat_event_friendly");
	}
	let validUntil = Game.GetGameTime() + 10;
	newChildPanel.SetAttributeInt("ValidUntil", Math.floor(validUntil));
}

function OnCourierKilled(event) {
	let kpid = event.kpid	
	let courier_team = Entities.GetTeamNumber(parseInt(event.id))
	let parentPanel = $.GetContextPanel()
	let newChildPanel = $.CreatePanel( "Panel", parentPanel, "ck_" + kpid + "x" + event.id);
	newChildPanel.BLoadLayout("file://{resources}/layout/custom_game/combat_event_courier_killed.xml", false, false);
	if (kpid == -1) {
		newChildPanel.FindChildTraverse("killer_hero").visible = false
		if (courier_team == DOTATeam_t.DOTA_TEAM_GOODGUYS) {
			newChildPanel.FindChildTraverse("killer_player_name").text = "天灾军团";
		} else {
			newChildPanel.FindChildTraverse("killer_player_name").text = "近卫军团";
		}
	} else {
		newChildPanel.FindChildTraverse("killer_hero").heroname = Players.GetPlayerSelectedHero(kpid);
		newChildPanel.FindChildTraverse("killer_player_name").text = Players.GetPlayerName(kpid);
	}
	
	victeamAndKillerIcon(courier_team, newChildPanel)

	if (parentPanel.GetChildCount() > 1) {
		parentPanel.MoveChildBefore(newChildPanel, parentPanel.GetChild(0));
	}
	let validUntil = Game.GetGameTime() + 10;
	newChildPanel.SetAttributeInt("ValidUntil", Math.floor(validUntil));
}

function OnPlayerRuneActivated(event) {
	let pid = event.pid;
	let rune_type = event.rune_type;
	$.Msg("Rune " + rune_type + " picked up by " + pid);
	let parentPanel = $.GetContextPanel()
	let newChildPanel = $.CreatePanel( "Panel", parentPanel, "pra_" + pid + "x" + rune_type);
	newChildPanel.BLoadLayout("file://{resources}/layout/custom_game/combat_event_rune_activated.xml", false, false);
	newChildPanel.FindChildTraverse("killer_hero").heroname = Players.GetPlayerSelectedHero(pid);
	newChildPanel.FindChildTraverse("killer_player_name").text = Players.GetPlayerName(pid);

	for (let i = 0; i < 6; i++) {
		if (i != rune_type) {
			newChildPanel.FindChildTraverse("icon_rune_type_" + i).visible = false;
		}
	}

	if (parentPanel.GetChildCount() > 1) {
		parentPanel.MoveChildBefore(newChildPanel, parentPanel.GetChild(0));
	}
	let validUntil = Game.GetGameTime() + 10;
	newChildPanel.SetAttributeInt("ValidUntil", Math.floor(validUntil));
}
function OnPlayerRuneDenied(event)
{
	let pid = event.pid;
	let rune_type = event.rune_type;
	$.Msg("Rune " + rune_type + " picked up by " + pid);
	let parentPanel = $.GetContextPanel()
	let newChildPanel = $.CreatePanel("Panel", parentPanel, "pra_" + pid + "x" + rune_type);
	newChildPanel.BLoadLayout("file://{resources}/layout/custom_game/combat_event_rune_denied.xml", false, false);
	newChildPanel.FindChildTraverse("killer_hero").heroname = Players.GetPlayerSelectedHero(pid);
	newChildPanel.FindChildTraverse("killer_player_name").text = Players.GetPlayerName(pid);

	for(let i = 0; i < 6; i++)
	{
		if(i != rune_type)
		{
			newChildPanel.FindChildTraverse("icon_rune_type_" + i).visible = false;
		}
	}

	if(parentPanel.GetChildCount() > 1)
	{
		parentPanel.MoveChildBefore(newChildPanel, parentPanel.GetChild(0));
	}
	let validUntil = Game.GetGameTime() + 10;
	newChildPanel.SetAttributeInt("ValidUntil", Math.floor(validUntil));
}

function OnPlayerWardKilled(event) {
	let kpid = event.kpid;
	let ward = event.ward;
	let parentPanel = $.GetContextPanel()
	let newChildPanel = $.CreatePanel( "Panel", parentPanel, "pwk_" + kpid + "x" + ward);
	newChildPanel.BLoadLayout("file://{resources}/layout/custom_game/combat_event_player_ward_killed.xml", false, false);
	newChildPanel.FindChildTraverse("killer_hero").heroname = Players.GetPlayerSelectedHero(kpid);
	newChildPanel.FindChildTraverse("killer_player_name").text = Players.GetPlayerName(kpid);
	if (ward == "npc_dota_ward_base") {
		newChildPanel.FindChildTraverse("sentry").visible = false;
	} else {
		newChildPanel.FindChildTraverse("observer").visible = false;
		newChildPanel.FindChildTraverse("gold_icon").visible = false;
		newChildPanel.FindChildTraverse("label_gold_amount").visible = false;
	}

	killteamAndKillerIcon(Players.GetTeam(kpid), newChildPanel)

	if (parentPanel.GetChildCount() > 1) {
		parentPanel.MoveChildBefore(newChildPanel, parentPanel.GetChild(0));
	}
	let validUntil = Game.GetGameTime() + 10;
	newChildPanel.SetAttributeInt("ValidUntil", Math.floor(validUntil));
}

function OnPlayerKillStreak(event) {
	$.Msg("OnPlayerKillStreak " + event.pid + " " + event.streak)
	let pid = event.pid;
	let streak = event.streak;
	let parentPanel = $.GetContextPanel()
	let newChildPanel = $.CreatePanel( "Panel", parentPanel, "pks_" + pid + "x" + streak);
	newChildPanel.BLoadLayout("file://{resources}/layout/custom_game/combat_event_player_kill_streak.xml", false, false);
	newChildPanel.FindChildTraverse("killer_hero").heroname = Players.GetPlayerSelectedHero(pid);
	newChildPanel.FindChildTraverse("killer_player_name").text = Players.GetPlayerName(pid);
	newChildPanel.FindChildTraverse("streak").text = streak;

	let team = Players.GetTeam(pid);
	if (team == Players.GetTeam(Players.GetLocalPlayer())) {
		newChildPanel.AddClass("combat_event_friendly");
	} else {
		newChildPanel.AddClass("combat_event_hostile");
	}

	if (parentPanel.GetChildCount() > 1) {
		parentPanel.MoveChildBefore(newChildPanel, parentPanel.GetChild(0));
	}
	let validUntil = Game.GetGameTime() + 10;
	newChildPanel.SetAttributeInt("ValidUntil", Math.floor(validUntil));
}

function OnPlayerStreakShutdown(event) {
	$.Msg("OnPlayerStreakShutdown " + event.pid + " " + event.streak)
	let pid = event.pid;
	let streak = event.streak;
	let parentPanel = $.GetContextPanel()
	let newChildPanel = $.CreatePanel( "Panel", parentPanel, "pss_" + pid + "x" + streak);
	newChildPanel.BLoadLayout("file://{resources}/layout/custom_game/combat_event_player_streak_shutdown.xml", false, false);
	newChildPanel.FindChildTraverse("killer_hero").heroname = Players.GetPlayerSelectedHero(pid);
	newChildPanel.FindChildTraverse("killer_player_name").text = Players.GetPlayerName(pid);
	newChildPanel.FindChildTraverse("streak").text = streak;

	let team = Players.GetTeam(pid);
	if (team == Players.GetTeam(Players.GetLocalPlayer())) {
		newChildPanel.AddClass("combat_event_hostile");
	} else {
		newChildPanel.AddClass("combat_event_friendly");
	}

	if (parentPanel.GetChildCount() > 1) {
		parentPanel.MoveChildBefore(newChildPanel, parentPanel.GetChild(0));
	}
	let validUntil = Game.GetGameTime() + 10;
	newChildPanel.SetAttributeInt("ValidUntil", Math.floor(validUntil));
}

function victeamAndKillerIcon(team, newChildPanel) {
	if (team == Players.GetTeam(Players.GetLocalPlayer())) {
		newChildPanel.AddClass("combat_event_hostile");
		newChildPanel.FindChildTraverse("killer_icon").AddClass("EnemyKillIcon");
	} else {
		newChildPanel.AddClass("combat_event_friendly");
		newChildPanel.FindChildTraverse("killer_icon").AddClass("AllyKillIcon");
	}
}

function killteamAndKillerIcon(team, newChildPanel) {
	if (team == Players.GetTeam(Players.GetLocalPlayer())) {
		newChildPanel.AddClass("combat_event_friendly");
		newChildPanel.FindChildTraverse("killer_icon").AddClass("AllyKillIcon");
	} else {
		newChildPanel.AddClass("combat_event_hostile");
		newChildPanel.FindChildTraverse("killer_icon").AddClass("EnemyKillIcon");
	}
}

function combatEventCommon(parentPanel, newChildPanel, event) {
	if (parentPanel.GetChildCount() > 1) {
		parentPanel.MoveChildBefore(newChildPanel, parentPanel.GetChild(0));
	}
	let icon = newChildPanel.FindChildTraverse("killer_icon");
	if (Players.GetTeam(event.vpid) == Players.GetTeam(Players.GetLocalPlayer())) {
		newChildPanel.AddClass("combat_event_hostile");
		if (icon) {
			icon.AddClass("EnemyKillIcon");
		}
	} else {
		newChildPanel.AddClass("combat_event_friendly");
		if (icon) {
			icon.AddClass("AllyKillIcon");
		}
	}

	let validUntil = Game.GetGameTime() + 10;
	newChildPanel.SetAttributeInt("ValidUntil", Math.floor(validUntil));
}

function cleanCombatEventsRegularly() {
	cleanCombatEventsRegularlyInternal();
	$.Schedule(1, function() {
		cleanCombatEventsRegularly();
	});
}

function cleanCombatEventsRegularlyInternal() {
	let parentPanel = $.GetContextPanel();
	let children = $.GetContextPanel().Children();
	for (let i = 0; i < children.length; i++) {
		let validUntil = children[i].GetAttributeInt("ValidUntil", 0)
		if (validUntil < Game.GetGameTime()) {
			children[i].DeleteAsync(0);
		}
	}
}

(function() {
	cleanCombatEventsRegularly();
})();

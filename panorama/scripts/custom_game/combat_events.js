GameEvents.Subscribe("player_kill_custom_bonus", OnPlayerKillCustomBonus);

function OnPlayerKillCustomBonus(event) {
	$.Msg("OnPlayerKillCustomBonus " + event.kpid + " " + event.vpid + " " + event.gold);
	let parentPanel = $.GetContextPanel()
	let newChildPanel = $.CreatePanel( "Panel", parentPanel, "pke_" + event.kpid + "x" + event.vpid + "g" + event.gold);
	newChildPanel.BLoadLayout("file://{resources}/layout/custom_game/combat_event_hero_kill.xml", false, false);
	newChildPanel.FindChildTraverse("label_gold_amount").text = event.gold
	//TODO schedule removing panel
}

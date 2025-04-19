function handleHeroBarBlockClick(num) {
	$.Msg("handleHeroBarBlockClick " + num);
	if (GameUI.IsAltDown()) {
		//GameEvents.SendCustomGameEventToServer("custom_ping_hero_missing", { num: num, snd: Players.GetLocalPlayer() })
	}
}

function HideWhenAltIsDown() {
	if (GameUI.IsAltDown()) {
		$("#hero-bar-block-buttons").visible = false;
	} else {
		$("#hero-bar-block-buttons").visible = true;
	}
	$.Schedule(0.1, HideWhenAltIsDown)
}
(function ()
{
	if (Players.GetTeam(Players.GetLocalPlayer()) === DOTATeam_t.DOTA_TEAM_GOODGUYS) {
		$("#hero-bar-block-buttons").AddClass("dire-block");
		$("#hero-bar-block-buttons").visible = true
	} else if (Players.GetTeam(Players.GetLocalPlayer()) === DOTATeam_t.DOTA_TEAM_BADGUYS) {
		$("#hero-bar-block-buttons").AddClass("radiant-block");
		$("#hero-bar-block-buttons").visible = true
	}
	$.Schedule(0.1, HideWhenAltIsDown)
})();

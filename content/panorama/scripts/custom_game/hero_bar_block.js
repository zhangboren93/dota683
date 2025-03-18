function handleHeroBarBlockClick(num) {
	$.Msg("handleHeroBarBlockClick " + num);
	if (GameUI.IsAltDown()) {
		GameEvents.SendCustomGameEventToServer("custom_ping_hero_missing", { num: num, snd: Players.GetLocalPlayer() })
	}
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
})();

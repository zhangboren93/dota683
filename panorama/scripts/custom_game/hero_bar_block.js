(function() {
	if (Players.GetTeam(Players.GetLocalPlayer()) === DOTATeam_t.DOTA_TEAM_GOODGUYS) {
		$("#hero-bar-block-buttons").AddClass("dire-block");
	}
})();

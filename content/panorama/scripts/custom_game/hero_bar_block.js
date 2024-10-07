
function TrackAltPressed(panel)
{
	panel.SetHasClass("AltPressed", IsDotaAltPressed());
	$.Schedule(0.0, () => TrackAltPressed(panel));
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
	TrackAltPressed($("#hero-bar-block-buttons"));
})();

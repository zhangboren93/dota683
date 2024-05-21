
function TrackAltPressed(panel)
{
	panel.SetHasClass("AltPressed", IsDotaAltPressed());
	$.Schedule(0.0, () => TrackAltPressed(panel));
}

(function ()
{
	if (Players.GetTeam(Players.GetLocalPlayer()) === DOTATeam_t.DOTA_TEAM_GOODGUYS) {
		$("#hero-bar-block-buttons").AddClass("dire-block");
	}
	TrackAltPressed($("#hero-bar-block-buttons"));
})();

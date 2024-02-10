function pingMiss(player_idx) 
{
	//	$.Msg("Player " + player_idx + " mis.");
	//	$.Mvar player_id = 0;
	//	$.Mif (Players.GetTeam(Players.GetLocalPlayer()) === DOTATeam_t.DOTA_TEAM_GOODGUYS) {
	//	$.M	player_id = Game.GetPlayerIDsOnTeam(DOTATeam_t.DOTA_TEAM_BADGUYS)[player_idx];
	//	$.M} else {
	//	$.M	player_id = Game.GetPlayerIDsOnTeam(DOTATeam_t.DOTA_TEAM_GOODGUYS)[player_idx];
	//	$.M}	
	//	$.Mif (!player_id) {
	//	$.M	return;
	//	$.M}
	//	$.M$.Msg("Player id " + player_id + " mis.");
	//	$.MGameEvents.SendCustomGameEventToServer("hero_bar_ping_miss", {mpid: player_id, pid: Players.GetLocalPlayer()});
}

(function() {
	if (Players.GetTeam(Players.GetLocalPlayer()) === DOTATeam_t.DOTA_TEAM_GOODGUYS) {
		$("#hero-bar-block-buttons").AddClass("dire-block");
	}
})();
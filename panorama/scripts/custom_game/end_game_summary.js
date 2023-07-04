GameEvents.Subscribe("dota_game_state_change", OnDotaGameStateChange);
function OnDotaGameStateChange(old_state, new_state) {
	$.Msg("New game state " + new_state);
	if (new_state == DOTA_GAMERULES_STATE_POST_GAME) {
		$.GetContextPanel().RemoveClass("end-game-summary-panel-hidden")
	}
}

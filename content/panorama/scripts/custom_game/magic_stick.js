function OnMSPanelCloseClicked() {
	$.GetContextPanel().visible=false;
}
function OnJuggWESelected(style) {
	$.Msg("OnJuggWESelected " + style);
	GameEvents.SendCustomGameEventToServer("magic-stick-command-issue", {
		pid: Players.GetLocalPlayer(),
		slot: "we",
		style: style
	})
}
(function(){
	$.Schedule(1, function() {
		$.GetContextPanel().visible=false;
	});
})();

function OnMSPanelCloseClicked() {
	$.GetContextPanel().visible=false;
	$.GetContextPanel().AddClass("panel-hidden")
}
function OnJuggWESelected(style) {
	$.Msg("OnJuggWESelected " + style);
	GameEvents.SendCustomGameEventToServer("magic-stick-command-issue", {
		pid: Players.GetLocalPlayer(),
		slot: "we",
		style: style
	})
}
function OnAuraSelected(type) {
	GameEvents.SendCustomGameEventToServer("magic-stick-command-issue", {
		pid: Players.GetLocalPlayer(),
		slot: "ar",
		style: type
	})
}
(function(){
	$.Schedule(1, function() {
		$.GetContextPanel().visible=false;
	});
})();

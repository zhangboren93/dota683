function OnGearPanelCloseClicked() {
	$.GetContextPanel().visible=false;
	$.GetContextPanel().AddClass("panel-hidden")
}
function OnAASelected(value) {
	$.Msg("OnAASelected " + value);
	GameEvents.SendCustomGameEventToServer("gear-setting-command-issue", {
		pid: Players.GetLocalPlayer(),
		slot: "aa",
		style: value
	})
}
(function(){
	$.Schedule(1, function() {
		$.GetContextPanel().visible=false;
	});
})();

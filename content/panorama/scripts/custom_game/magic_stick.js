function OnMSPanelCloseClicked() {
	$.GetContextPanel().visible=false;
}
function OnJuggWESelected(style) {
	$.Msg("OnJuggWESelected " + style);
}
(function(){
	$.Schedule(1, function() {
		$.GetContextPanel().visible=false;
	});
})();

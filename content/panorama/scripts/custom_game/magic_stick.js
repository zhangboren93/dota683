function OnMSPanelCloseClicked() {
	$.GetContextPanel().visible=false;
}
(function(){
	$.Schedule(1, function() {
		$.GetContextPanel().visible=false;
	});
})();

GameEvents.Subscribe("captain_draft_start", OnCaptainDraftStart);

function OnCaptainDraftStart(event) {
	$.Msg("OnCaptainDraftStart")
	$.GetContextPanel().RemoveClass("captain-selection-ban-panel-hide")
}

function handleHeroClicked(button) {
	$.Msg(button)
	$.("#hi_" + button).AddClass("hi_selected")
}
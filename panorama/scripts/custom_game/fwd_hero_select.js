function fwdCloseButtonPressed() {
	$.GetContextPanel().visible = false;
	$.GetContextPanel().AddClass("panel-hidden")
	$.GetContextPanel().GetParent().FindChildrenWithClassTraverse("fwd-item-select-panel")[0].visible = false
	$.GetContextPanel().GetParent().FindChildrenWithClassTraverse("fwd-item-select-panel")[0].AddClass("panel-hidden")
	$.GetContextPanel().GetParent().FindChildrenWithClassTraverse("fwd-hero-select-panel")[0].visible = false
	$.GetContextPanel().GetParent().FindChildrenWithClassTraverse("fwd-hero-select-panel")[0].AddClass("panel-hidden")
}

function fwdHeroSelectPressed() {
	let p = $.GetContextPanel().GetParent().FindChildrenWithClassTraverse("fwd-hero-select-panel")[0]
	p.visible = true
	p.RemoveClass("panel-hidden")
	$.GetContextPanel().GetParent().FindChildrenWithClassTraverse("fwd-item-select-panel")[0].visible = false
}

function fwdItemSelectPressed() {
	let p = $.GetContextPanel().GetParent().FindChildrenWithClassTraverse("fwd-item-select-panel")[0]
	p.visible = true
	p.RemoveClass("panel-hidden")
	$.GetContextPanel().GetParent().FindChildrenWithClassTraverse("fwd-hero-select-panel")[0].visible = false
}

function fwdHeroSelectHeroPressed(heroname) {
	let p = $.GetContextPanel().GetParent().FindChildrenWithClassTraverse("fwd-panel")[0]
	let image = p.FindChildrenWithClassTraverse("hero-selector-image")[0]
	image.heroname = heroname
	fwdCloseButtonPressed()
}

function OnItemSelectItemPressed(itemname) {
	let p = $.GetContextPanel().GetParent().FindChildrenWithClassTraverse("fwd-panel")[0]
	let image = p.FindChildrenWithClassTraverse("item-selector-image")[0]
	image.itemname = itemname
	fwdCloseButtonPressed()
}

function fwdSpawnAllyPressed() {
	let heroname = $("#hero-selector-image").heroname
	GameEvents.SendCustomGameEventToServer("fwd-command-issue", {
		type: 'ally',
		heroname: heroname,
		position: GameUI.GetCameraLookAtPosition(),
		playerid: Players.GetLocalPlayer()
	})
}

function fwdSpawnEnemyPressed() {
	let heroname = $("#hero-selector-image").heroname
	GameEvents.SendCustomGameEventToServer("fwd-command-issue", {
		type: 'enem',
		heroname: heroname,
		position: GameUI.GetCameraLookAtPosition(),
		playerid: Players.GetLocalPlayer()
	})
}

function fwdRunePressed(runeIdx) {
	GameEvents.SendCustomGameEventToServer("fwd-command-issue", {
		type: 'rune',
		position: GameUI.GetCameraLookAtPosition(),
		rune: runeIdx
	})
}

function fwdGiveItemPressed() {
	let itemname = $("#item-selector-image").itemname
	let entities = Players.GetSelectedEntities(Players.GetLocalPlayer())
	GameEvents.SendCustomGameEventToServer("fwd-command-issue", {
		type: 'item',
		itemname: itemname,
		entities: entities
	})
}

function fwdLevelUpPressed() {
	let entities = Players.GetSelectedEntities(Players.GetLocalPlayer())
	GameEvents.SendCustomGameEventToServer("fwd-command-issue", {
		type: 'lvlup',
		entities: entities
	})
}

function fwdLevelMaxPressed() {
	let entities = Players.GetSelectedEntities(Players.GetLocalPlayer())
	GameEvents.SendCustomGameEventToServer("fwd-command-issue", {
		type: 'lvlmax',
		entities: entities
	})
}

function OnCooldownToggled() {
	GameEvents.SendCustomGameEventToServer("fwd-command-issue", {
		type: 'nocd',
		state: $("#global-cooldown-toggle").checked
	})
}

(function () {
	$.GetContextPanel().visible = false;
})();


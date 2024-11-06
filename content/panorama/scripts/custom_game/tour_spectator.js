minimap_units = []
function customMinimapPrint() {
	customMinimapPrintInner();
	$.Schedule(1, customMinimapPrint)
}

function customMinimapPrintInner() {
	let heroes = Entities.GetAllHeroEntities()
	let parentPanel = $.GetContextPanel()
	for (let i = 0; i < minimap_units.length; i++) {
		minimap_units[i].RemoveAndDeleteChildren();
	}
	minimap_units = []
	for (let i = 0; i < heroes.length; i++) {
		let team = Entities.GetTeamNumber(heroes[i])
		if (team == DOTATeam_t.DOTA_TEAM_CUSTOM_1) {
			continue;
		}
		let childPanel = $.CreatePanel("Panel", parentPanel, "minimap_hero_" + heroes[i])
		childPanel.BLoadLayout("file://{resources}/layout/custom_game/minimap_hero.xml", false, false);
		let childImage = childPanel.FindChildTraverse("killer_hero")
		childImage.heroname = Entities.GetUnitName(heroes[i]);
		let position = Entities.GetAbsOrigin(heroes[i])
		childPanel.SetPositionInPixels(position[0] / 60 + 110, 110 - position[1] / 60, 0);

		minimap_units.push(childPanel)
	}

}

(function() {
	$.Schedule(1, customMinimapPrint);
})();

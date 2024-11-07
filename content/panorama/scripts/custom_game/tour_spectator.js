minimap_units = []
function customMinimapPrint() {
	customMinimapPrintInner();
	$.Schedule(0.2, customMinimapPrint)
}

function customMinimapPrintInner() {
	for (let i = 0; i < minimap_units.length; i++) {
		minimap_units[i].DeleteAsync(0);
	}
	minimap_units = []

	let parentPanel = $.GetContextPanel()

//	let heroes = Entities.GetAllHeroEntities()
//	for (let i = 0; i < heroes.length; i++) {
//		let team = Entities.GetTeamNumber(heroes[i])
//		if (team == DOTATeam_t.DOTA_TEAM_CUSTOM_1 || !Entities.IsAlive(heroes[i])) {
//			continue;
//		}
//		let childPanel = $.CreatePanel("Panel", parentPanel, "minimap_hero_" + heroes[i])
//		childPanel.BLoadLayout("file://{resources}/layout/custom_game/minimap_hero.xml", false, false);
//		let childImage = childPanel.FindChildTraverse("killer_hero")
//		childImage.heroname = Entities.GetUnitName(heroes[i]);
//		let position = Entities.GetAbsOrigin(heroes[i])
//		childPanel.SetPositionInPixels(position[0] / 60 + 110, 110 - position[1] / 60, 0);
//
//		minimap_units.push(childPanel)
//	}

	let creeps = Entities.GetAllEntities()
	for (let i = 0; i < creeps.length; i++) {
		let team = Entities.GetTeamNumber(creeps[i])
		if (team != DOTATeam_t.DOTA_TEAM_GOODGUYS) { // && team != DOTATeam_t.DOTA_TEAM_BADGUYS) {
			continue;
		}
		if (!Entities.IsCreep(creeps[i]) || !Entities.IsAlive(creeps[i]) || Entities.NotOnMinimap(creeps[i])) {
			continue;
		}
		let childPanel = $.CreatePanel("Panel", parentPanel, "minimap_lane_creep_" + creeps[i])
		childPanel.BLoadLayout("file://{resources}/layout/custom_game/minimap_lane_creep_team_" + team + ".xml", false, false);
		let position = Entities.GetAbsOrigin(creeps[i])
		childPanel.SetPositionInPixels(position[0] / 60 + 120, 120 - position[1] / 60, 0);

		minimap_units.push(childPanel)
	}

}

(function() {
	let map_name = Game.GetMapInfo().map_name
	if (map_name !== "maps/tour.vpk" || Players.GetTeam(Players.GetLocalPlayer()) != DOTATeam_t.DOTA_TEAM_CUSTOM_1) {
		$.GetContextPanel().visible = false
	} else {
		$.Schedule(1, customMinimapPrint);
	}
})();

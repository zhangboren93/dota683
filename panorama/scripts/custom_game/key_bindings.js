GameEvents.Subscribe("courier_start_transfer", OnCourierStartTransfer);
GameEvents.Subscribe("courier_end_transfer", OnCourierEndTransfer);
GameEvents.Subscribe("courier_respawn_time", OnCourierRespawnTime);

function OnCustomeGameSelectCourier()
{
    let entities = Entities.GetAllEntitiesByName("npc_dota_courier");
    for (let i = 0; i < entities.length; i++) {
        if (Entities.GetTeamNumber(entities[i]) == Players.GetTeam(Players.GetLocalPlayer())) {
            GameUI.SelectUnit(entities[i], false);
            break;
        }
    }
}

function OnCustomGameCourierSend()
{
    let entities = Entities.GetAllEntitiesByName("npc_dota_courier");
    for (let i = 0; i < entities.length; i++) {
        if (Entities.GetTeamNumber(entities[i]) == Players.GetTeam(Players.GetLocalPlayer())) {
            let courier = entities[i]
            GameUI.SelectUnit(courier, false);
            let sendItemAbility = Entities.GetAbilityByName(courier, "courier_transfer_items")
            Abilities.ExecuteAbility(sendItemAbility, courier, false)
            GameUI.SelectUnit(Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer()), false);
            break;
        }
    }
}

function OnCourierStartTransfer() {
	$("#courier-ip").RemoveClass("image-hidden")
}

function OnCourierEndTransfer() {
	$("#courier-ip").AddClass("image-hidden")
}

function OnCourierRespawnTime(event) {
	if (event.respawned == 1) {
		$("#courier-respawn-remaining").text = "";
	} else {
		var minutes = event.time % 60
		if (minutes >= 10) {
			$("#courier-respawn-remaining").text = Math.floor(event.time / 60) + ":" + event.time % 60;
		} else {
			$("#courier-respawn-remaining").text = Math.floor(event.time / 60) + ":0" + event.time % 60;
		}
	}
}

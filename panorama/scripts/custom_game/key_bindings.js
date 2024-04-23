GameEvents.Subscribe("courier_start_transfer", OnCourierStartTransfer);
GameEvents.Subscribe("courier_end_transfer", OnCourierEndTransfer);
GameEvents.Subscribe("courier_spawned", OnCourierSpawned);
GameEvents.Subscribe("courier_killed", OnCourierKilled);

my_team_couriers = {}
current_courier_id = -1;
last_select_courier_time = -1;
courier_dead_interval = -1;
function OnCustomeGameSelectCourier()
{
	if (current_courier_id == -1) {
		return;
	}
	let courierId = parseInt(current_courier_id)
	GameUI.SelectUnit(courierId, false);
	$.Msg("OnCustomeGameSelectCourier")
	$.Msg(last_select_courier_time)
	if (last_select_courier_time != -1) {
		if (Game.GetGameTime() - last_select_courier_time < 1) {
			// is double click
			GameUI.MoveCameraToEntity(courierId)
		}
	}
	last_select_courier_time = Game.GetGameTime()
}

function heroHasItemInStash() {
	for (let i = 9; i <= 14; i++) {
		let item = Entities.GetItemInSlot(Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer()), i);
		if (item !== -1) {
			return true;
		}
	}
	return false;
}

function OnCustomGameCourierSend()
{
	if (current_courier_id == -1) {
		return;
	}
	let courier = parseInt(current_courier_id)
    GameUI.SelectUnit(courier, false);
	// if hero has item from inventory, trigger take stash, else transferitem
	if (heroHasItemInStash()) {
    	let sendItemAbility = Entities.GetAbilityByName(courier, "courier_take_stash_items_lua")
    	Abilities.ExecuteAbility(sendItemAbility, courier, false)
		$.Schedule(0.03, function() { 
    		GameUI.SelectUnit(Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer()), false);
		});
	} else {
    	let sendItemAbility2 = Entities.GetAbilityByName(courier, "courier_transfer_items_lua")
    	Abilities.ExecuteAbility(sendItemAbility2, courier, false)
		$.Schedule(0.03, function() { 
 	   		GameUI.SelectUnit(Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer()), false);
		});
	}
}

function OnCourierStartTransfer(event) {
	let courier_id = event.id 
	let player_id = event.player_id
	if (!(courier_id in my_team_couriers)) {
		$.Msg("[WARNING] courier " + courier_id + " not found.");
		return;
	}
	my_team_couriers[courier_id].is_transfering = true;
	if (courier_id == current_courier_id) {
		$("#courier-ip").RemoveClass("image-hidden")
		$("#courier-target-hero").visible = true
		$("#courier-target-hero").heroname = Players.GetPlayerSelectedHero(player_id)
		$("#courier-send-image").visible = false
	}
}

function OnCourierEndTransfer(event) {
	let courier_id = event.id 
	if (!(courier_id in my_team_couriers)) {
		$.Msg("[WARNING] courier " + courier_id + " not found.");
		return;
	}
	my_team_couriers[courier_id].is_transfering = false;
	if (courier_id == current_courier_id) {
		$("#courier-ip").AddClass("image-hidden")
		$("#courier-target-hero").visible = false
		$("#courier-send-image").visible = true
	}
}

function OnCustomGameSelectNextCourier() {
	$.Msg("OnCustomGameSelectNextCourier")
	$.Msg(current_courier_id)
	let keys = Object.keys(my_team_couriers)
	if (keys.length == 0) {
		return
	}
	let currentCourierIndex = keys.indexOf(current_courier_id)
	$.Msg(currentCourierIndex)
	if (currentCourierIndex == -1) {
		return
	}
	let nextCourierIndex = currentCourierIndex + 1;
	if (nextCourierIndex >= keys.length) {
		nextCourierIndex = 0;
	}
	$.Msg(nextCourierIndex)
	current_courier_id = keys[nextCourierIndex];
	$("#current-courier-owner-image").heroname = my_team_couriers[current_courier_id].owner_name
	if (my_team_couriers[current_courier_id].is_transfering) {
		$("#courier-ip").RemoveClass("image-hidden")
	} else {
		$("#courier-ip").AddClass("image-hidden")
	}
	if (my_team_couriers[current_courier_id].is_dead) {
		showCourierKilled();
	} else {
		showCourierSpawned();
	}
}

function OnCourierSpawned(event) {
	$.Msg("OnCourierSpawned " + event.id + " owner " + event.owner_name)
	if (event.respawn == 1) {
		my_team_couriers[event.id].is_dead = false;
		if (event.id == current_courier_id) {
			showCourierSpawned();
		}
		return;
	}
	my_team_couriers[event.id] = {
		is_dead: false,
		dead_time: -1,
		owner_name: event.owner_name,
		is_transfering: false
	}
	if (current_courier_id == -1) {
		$.Msg("First courier")
		current_courier_id = event.id
		$("#courier-select-button").RemoveClass("button-hidden")
		$("#courier-send-button").RemoveClass("button-hidden")
		$("#courier-select-next-button").RemoveClass("button-hidden")
		$("#current-courier-owner-image").heroname = event.owner_name
		$.Schedule(1, function() { 
			updateCourierRespawnTimeLoop(); 
		});
	}
}

function updateCourierRespawnTimeLoop() {
	updateCourierRespawnTime();
	$.Schedule(1, function() {
		updateCourierRespawnTimeLoop()
	});
}

function OnCourierKilled(event) {
	$.Msg("OnCourierKilled " + event.id + " " + event.respawn);
	let courier_id = event.id;
	if (!(courier_id in my_team_couriers)) {
		$.Msg("[WARNING] Courier not found " + courier_id);
		return;
	}
	my_team_couriers[courier_id].is_dead = true;
	my_team_couriers[courier_id].dead_time = event.respawn;
	my_team_couriers[courier_id].is_transfering = false;
	if (courier_id == current_courier_id) {
		showCourierKilled();
	}
}

function updateCourierRespawnTime() {
	if (!my_team_couriers[current_courier_id].is_dead) {
		$("#courier-respawn-remaining").text = "";
		return;
	}
	my_team_couriers[current_courier_id].dead_time = my_team_couriers[current_courier_id].dead_time - 1
	let time = my_team_couriers[current_courier_id].dead_time;
	$("#courier-respawn-remaining").text = Math.floor(time).toString();
}

function showCourierKilled() {
	$("#courier-ip").AddClass("image-hidden");
	$("#courier-respawn-remaining").RemoveClass("label-hidden");
	$("#courier-select-button").AddClass("button-hidden");
	let time = my_team_couriers[current_courier_id].dead_time;
	$("#courier-respawn-remaining").text = Math.floor(time).toString();
}

function showCourierSpawned() {
	$("#courier-respawn-remaining").AddClass("label-hidden");
	$("#courier-select-button").RemoveClass("button-hidden");
}

function conflictWithAbilityKB(key) {
	let hero = Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer())
	if (hero == -1) {
		return false
	}
	for (let i = 0; i < 6; i++) {
		let ability = Entities.GetAbility(hero, i)
		if (Abilities.GetKeybind(ability) === key) {
			return true
		}
	}
	return false
}

function initCustomCourierKB() {
	let hero = Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer())
	if (hero == -1) {
		$.Schedule(1, initCustomCourierKB);
		return
	}

	let courier_select = Game.GetKeybindForCommand(DOTAKeybindCommand_t.DOTA_KEYBIND_COURIER_SELECT);
	let courier_deliver = Game.GetKeybindForCommand(DOTAKeybindCommand_t.DOTA_KEYBIND_COURIER_DELIVER);

	if (!conflictWithAbilityKB(courier_select)) {
		let new_courier_select_command = "CustomGameCourierSelect" + Math.floor(Math.random() * 100000);
		Game.AddCommand(new_courier_select_command, OnCustomeGameSelectCourier, "", 0);
		Game.CreateCustomKeyBind(courier_select, new_courier_select_command );
	}

	if (!conflictWithAbilityKB(courier_deliver)) {
		let new_courier_deliver_command = "CustomGameCourierDeliver" + Math.floor(Math.random() * 100000);
		Game.AddCommand(new_courier_deliver_command, OnCustomGameCourierSend, "", 0);
		Game.CreateCustomKeyBind(courier_deliver, new_courier_deliver_command );
	}

}

(function() {
	initCustomCourierKB()

	let couriers = Entities.GetAllEntitiesByName("npc_dota_courier")
	for (let i = 0; i < couriers.length; i++) {
		let courier = couriers[i]
		if (Entities.GetTeamNumber(courier) == Players.GetTeam(Players.GetLocalPlayer())) {
			let ownerId = Entities.GetPlayerOwnerID(courier)
			let hero = Players.GetPlayerHeroEntityIndex(ownerId)
			let courier_spawned = {
				id: courier,
				owner_name: Entities.GetUnitName(hero)
			}
			OnCourierSpawned(courier_spawned)
		}
	}
})()

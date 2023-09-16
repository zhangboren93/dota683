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

function OnCustomGameCourierSend()
{
	if (current_courier_id == -1) {
		return;
	}
	let courier = parseInt(current_courier_id)
    GameUI.SelectUnit(courier, false);
    let sendItemAbility = Entities.GetAbilityByName(courier, "courier_transfer_items")
    Abilities.ExecuteAbility(sendItemAbility, courier, false)
    GameUI.SelectUnit(Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer()), false);
}

function OnCourierStartTransfer(event) {
	let courier_id = event.id 
	if (!(courier_id in my_team_couriers)) {
		$.Msg("[WARNING] courier " + courier_id + " not found.");
		return;
	}
	my_team_couriers[courier_id].is_transfering = true;
	if (courier_id == current_courier_id) {
		$("#courier-ip").RemoveClass("image-hidden")
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

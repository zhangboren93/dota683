GameEvents.Subscribe("courier_start_transfer", OnCourierStartTransfer);
GameEvents.Subscribe("courier_end_transfer", OnCourierEndTransfer);
GameEvents.Subscribe("courier_spawned", OnCourierSpawned);
GameEvents.Subscribe("courier_killed", OnCourierKilled);

my_team_couriers = {}
current_courier_id = -1;
last_select_courier_time = -1;
courier_dead_interval = -1;
ITEM_RECIPE_RULES = [
    ["item_poor_mans_shield", "item_slippers", "item_slippers", "item_stout_shield" ],
    ["item_necronomicon_datadriven", "item_belt_of_strength", "item_staff_of_wizardry", "item_recipe_necronomicon_datadriven" ],
    ["item_necronomicon_2_datadriven", "item_recipe_necronomicon_datadriven", "item_necronomicon_datadriven" ],
    ["item_necronomicon_3_datadriven", "item_recipe_necronomicon_datadriven", "item_necronomicon_2_datadriven" ],
    ["item_magic_wand", "item_branches", "item_branches", "item_branches", "item_magic_stick", "item_recipe_magic_wand"],
    ["item_travel_boots_datadriven", "item_boots", "item_recipe_travel_boots_datadriven"],
    ["item_phase_boots", "item_boots", "item_blades_of_attack", "item_blades_of_attack"],
    ["item_hand_of_midas_datadriven", "item_gloves", "item_recipe_hand_of_midas_datadriven"],
    ["item_wraith_band_datadriven", "item_circlet", "item_slippers", "item_recipe_wraith_band_datadriven"],
    ["item_ring_of_basilius_datadriven", "item_sobi_mask_datadriven", "item_ring_of_protection"],
    ["item_ring_of_aquila_lua", "item_wraith_band_datadriven", "item_ring_of_basilius_datadriven"],
    ["item_vladmir_2", "item_ring_of_regen", "item_ring_of_basilius_datadriven", "item_lifesteal_datadriven", "item_recipe_vladmir_2"],
    ["item_buckler_2", "item_chainmail", "item_branches", "item_recipe_buckler_2"],
    ["item_headdress_datadriven", "item_ring_of_regen", "item_branches", "item_recipe_headdress_datadriven"],
    ["item_mekansm_2", "item_headdress_datadriven", "item_buckler_2", "item_recipe_mekansm_2"],
    ["item_hood_of_defiance_datadriven", "item_ring_of_health", "item_cloak", "item_ring_of_regen", "item_ring_of_regen"],
    ["item_pipe", "item_hood_of_defiance_datadriven", "item_headdress_datadriven", "item_recipe_pipe"],
    ["item_urn_of_shadows_datadriven", "item_sobi_mask_datadriven", "item_gauntlets", "item_gauntlets", "item_recipe_urn_of_shadows_datadriven"],
    ["item_sheepstick", "item_mystic_staff", "item_ultimate_orb", "item_void_stone_datadriven"],
    ["item_pers_datadriven", "item_ring_of_health", "item_void_stone_datadriven"],
    ["item_bfury_datadriven", "item_broadsword", "item_claymore", "item_pers_datadriven"],
    ["item_oblivion_staff_datadriven", "item_quarterstaff", "item_sobi_mask_datadriven", "item_robe"],
    ["item_orchid", "item_oblivion_staff_datadriven", "item_oblivion_staff_datadriven", "item_recipe_orchid"],
    ["item_refresher_datadriven", "item_pers_datadriven", "item_oblivion_staff_datadriven", "item_recipe_refresher_datadriven"],
    ["item_sphere", "item_ultimate_orb", "item_pers_datadriven", "item_recipe_sphere"],
    ["item_cyclone", "item_staff_of_wizardry", "item_void_stone_datadriven", "item_sobi_mask_datadriven", "item_recipe_cyclone"],
    ["item_force_staff_datadriven", "item_staff_of_wizardry", "item_ring_of_regen", "item_recipe_force_staff_datadriven"],
    ["item_null_talisman_datadriven", "item_circlet", "item_mantle", "item_recipe_null_talisman_datadriven"],
    ["item_dagon_datadriven", "item_staff_of_wizardry", "item_null_talisman_datadriven", "item_recipe_dagon_datadriven"],
    ["item_dagon_2_datadriven", "item_recipe_dagon_datadriven", "item_dagon_datadriven"],
    ["item_dagon_3_datadriven", "item_recipe_dagon_datadriven", "item_dagon_2_datadriven"],
    ["item_dagon_4_datadriven", "item_recipe_dagon_datadriven", "item_dagon_3_datadriven"],
    ["item_dagon_5_datadriven", "item_recipe_dagon_datadriven", "item_dagon_4_datadriven"],
    ["item_veil_of_discord_datadriven", "item_helm_of_iron_will", "item_null_talisman_datadriven", "item_recipe_veil_of_discord_datadriven"],
    ["item_assault", "item_platemail", "item_chainmail", "item_hyperstone", "item_recipe_assault"],
    ["item_heart_datadriven", "item_vitality_booster", "item_reaver", "item_recipe_heart_datadriven"],
    ["item_black_king_bar_datadriven", "item_ogre_axe", "item_mithril_hammer", "item_recipe_black_king_bar_datadriven"],
    ["item_shivas_guard", "item_platemail", "item_mystic_staff", "item_recipe_shivas_guard"],
    ["item_vanguard_lua", "item_ring_of_health", "item_vitality_booster"],
    ["item_crimson_guard_lua", "item_vanguard_lua", "item_buckler_2", "item_recipe_crimson_guard_lua"],
    ["item_blade_mail", "item_broadsword", "item_chainmail", "item_robe"],
    ["item_monkey_king_bar_datadriven", "item_demon_edge", "item_javelin_datadriven", "item_javelin_datadriven"],
    ["item_radiance", "item_relic", "item_recipe_radiance"],
    ["item_butterfly_datadriven", "item_eagle", "item_talisman_of_evasion", "item_quarterstaff"],
    ["item_lesser_crit", "item_broadsword", "item_blades_of_attack", "item_recipe_lesser_crit"],
    ["item_greater_crit", "item_lesser_crit", "item_demon_edge", "item_recipe_greater_crit"],
    ["item_armlet", "item_helm_of_iron_will", "item_gloves", "item_blades_of_attack", "item_recipe_armlet"],
    ["item_invis_sword", "item_shadow_amulet_datadriven", "item_claymore"],
    ["item_sange_datadriven", "item_ogre_axe", "item_belt_of_strength", "item_recipe_sange_datadriven"],
	["item_yasha", "item_blade_of_alacrity", "item_boots_of_elves", "item_recipe_yasha"],
    ["item_manta", "item_yasha", "item_ultimate_orb", "item_recipe_manta"],
    ["item_sange_and_yasha_datadriven", "item_yasha", "item_sange_datadriven"],
    ["item_heavens_halberd_datadriven", "item_sange_datadriven", "item_talisman_of_evasion"],
    ["item_helm_of_the_dominator_datadriven", "item_helm_of_iron_will", "item_lifesteal_datadriven"],
    ["item_satanic_datadriven", "item_helm_of_the_dominator_datadriven", "item_reaver", "item_recipe_satanic_datadriven"],
    ["item_maelstrom_datadriven", "item_gloves", "item_mithril_hammer", "item_recipe_maelstrom_datadriven"],
    ["item_mjollnir_datadriven", "item_maelstrom_datadriven", "item_hyperstone", "item_recipe_mjollnir_datadriven"],
    ["item_skadi_datadriven", "item_ultimate_orb", "item_ultimate_orb", "item_point_booster", "item_orb_of_venom"],
    ["item_desolator_datadriven", "item_mithril_hammer", "item_mithril_hammer", "item_recipe_desolator_datadriven"],
    ["item_mask_of_madness_datadriven", "item_lifesteal_datadriven", "item_recipe_mask_of_madness_datadriven"],
    ["item_diffusal_blade_datadriven", "item_blade_of_alacrity", "item_blade_of_alacrity", "item_robe", "item_recipe_diffusal_blade_datadriven"],
    ["item_diffusal_blade_2_datadriven", "item_recipe_diffusal_blade_datadriven", "item_diffusal_blade_datadriven"],
    ["item_ethereal_blade", "item_eagle", "item_ghost"],
    ["item_soul_ring_datadriven", "item_sobi_mask_datadriven", "item_ring_of_regen", "item_recipe_soul_ring_datadriven"],
    ["item_soul_booster_datadriven", "item_energy_booster", "item_vitality_booster", "item_point_booster"],
    ["item_bloodstone_datadriven", "item_soul_ring_datadriven", "item_soul_booster_datadriven", "item_recipe_bloodstone_datadriven"],
    ["item_arcane_boots", "item_boots", "item_energy_booster"],
    ["item_medallion_of_courage", "item_chainmail", "item_sobi_mask_datadriven", "item_recipe_medallion_of_courage"],
    ["item_rod_of_atos_datadriven", "item_staff_of_wizardry", "item_staff_of_wizardry", "item_vitality_booster"],
    ["item_basher", "item_javelin_datadriven", "item_belt_of_strength", "item_recipe_basher"],
    ["item_abyssal_blade", "item_basher", "item_relic"],
    ["item_tranquil_boots_datadriven", "item_boots", "item_ring_of_regen", "item_ring_of_protection"],
    ["item_bracer_datadriven", "item_circlet", "item_gauntlets", "item_recipe_bracer_datadriven"],
    ["item_ancient_janggo_datadriven", "item_bracer_datadriven", "item_robe", "item_recipe_ancient_janggo_datadriven"],
    ["item_ancient_janggo_datadriven", "item_recipe_ancient_janggo_datadriven", "item_ancient_janggo_datadriven"],
    ["item_power_treads", "item_boots", "item_gloves", "item_belt_of_strength"],
    ["item_power_treads", "item_boots", "item_gloves", "item_boots_of_elves"],
    ["item_power_treads", "item_boots", "item_gloves", "item_robe"],
    ["item_ultimate_scepter", "item_point_booster", "item_ogre_axe", "item_blade_of_alacrity", "item_staff_of_wizardry"],
    ["item_rapier", "item_demon_edge", "item_relic"],
	//688
	["item_bloodthorn_lua", "item_recipe_bloodthorn_lua", "item_orchid", "item_lesser_crit"],
	["item_silver_edge_datadriven", "item_recipe_silver_edge_datadriven", "item_invis_sword", "item_ultimate_orb"],
	["item_iron_talon_lua", "item_recipe_iron_talon_lua", "item_quelling_blade_lua", "item_ring_of_protection"]
]
ITEMNAME_2_ITEMID = {
	"item_blink": 1,
	"item_blades_of_attack": 2,
	"item_broadsword": 3,
	"item_chainmail": 4,
	"item_claymore": 5,
	"item_helm_of_iron_will": 6,
	"item_javelin_datadriven": 1207,
	"item_mithril_hammer": 8,
	"item_platemail": 9,
	"item_quarterstaff": 10,
	"item_quelling_blade_lua": 1211,
	"item_ring_of_protection": 12,
	"item_gauntlets": 13,
	"item_slippers": 14,
	"item_mantle": 15,
	"item_branches": 16,
	"item_belt_of_strength": 17,
	"item_boots_of_elves": 18,
	"item_robe": 19,
	"item_circlet": 20,
	"item_ogre_axe": 21,
	"item_blade_of_alacrity": 22,
	"item_staff_of_wizardry": 23,
	"item_ultimate_orb": 24,
	"item_gloves": 25,
	"item_lifesteal_datadriven": 1226,
	"item_ring_of_regen": 27,
	"item_sobi_mask_datadriven": 1228,
	"item_boots": 29,
	"item_gem": 30,
	"item_cloak": 31,
	"item_talisman_of_evasion": 32,
	"item_magic_stick": 34,
	"item_recipe_magic_wand": 35,
	"item_ghost": 37,
	"item_clarity": 38,
	"item_flask_datadriven": 1239,
	"item_dust_datadriven": 1240,
	"item_bottle": 41,
	"item_ward_observer": 42,
	"item_ward_sentry": 43,
	"item_tango"		:44,
	"item_courier_2": 1245,
	"item_recipe_flying_courier_datadriven": 1486,
	"item_tpscroll": 46,
	"item_recipe_travel_boots_datadriven": 47,
	"item_demon_edge": 51,
	"item_eagle": 52,
	"item_reaver": 53,
	"item_relic": 54,
	"item_hyperstone": 55,
	"item_ring_of_health": 56,
	"item_void_stone_datadriven": 1257,
	"item_mystic_staff": 58,
	"item_energy_booster": 59,
	"item_point_booster": 60,
	"item_vitality_booster": 61,
	"item_recipe_hand_of_midas_datadriven": 1264,
	"item_recipe_bracer": 72,
	"item_recipe_wraith_band_datadriven": 1274,
	"item_recipe_null_talisman": 1276,
	"item_recipe_mekansm_2": 1278,
	"item_recipe_vladmir": 1280,
	"item_recipe_buckler_2": 1285,
	"item_recipe_pipe": 89,
	"item_recipe_urn_of_shadows_datadriven": 1291,
	"item_recipe_headdress_datadriven": 1293,
	"item_recipe_orchid":	97,
	"item_recipe_cyclone": 99,
	"item_recipe_force_staff": 1301,
	"item_recipe_dagon_datadriven":	1303,
	"item_recipe_necronomicon": 1305,
	"item_recipe_refresher": 1309,
	"item_recipe_assault": 111,
	"item_recipe_heart_datadriven": 1313,
	"item_recipe_black_king_bar_datadriven"		: 1315,
	"item_recipe_shivas_guard"		: 118,
	"item_recipe_bloodstone_datadriven"		:1320,
	"item_recipe_sphere"		:122,
	"item_recipe_crimson_guard"		:1443,
	"item_recipe_blade_mail"		:126,
	"item_recipe_radiance"		:136,
	"item_recipe_greater_crit"		:140,
	"item_recipe_basher"		:142,
	"item_recipe_manta"		:146,
	"item_recipe_lesser_crit"		:148,
	"item_recipe_armlet"		:150,
	"item_recipe_satanic_datadriven"		:1355,
	"item_recipe_mjollnir_datadriven"		:1357,
	"item_recipe_sange_datadriven"		:1361,
	"item_recipe_maelstrom_datadriven"		:1365,
	"item_recipe_desolator_datadriven"		:1367,
	"item_recipe_yasha"		:169,
	"item_recipe_mask_of_madness_datadriven"		:1371,
	"item_recipe_diffusal_blade_datadriven"		:1373,
	"item_recipe_soul_ring"		:1377,
	"item_orb_of_venom": 181,
	"item_stout_shield": 182,
	"item_recipe_ancient_janggo_datadriven"		:1384,
	"item_recipe_medallion_of_courage"		:186,
	"item_smoke_of_deceit"		:188,
	"item_recipe_veil_of_discord_datadriven"		:1389,
	"item_shadow_amulet_datadriven"		:1415,
	"item_recipe_bloodthorn_lua"	 	:1445,
	"item_recipe_silver_edge_datadriven"	:1448,
	"item_recipe_iron_talon_lua"	:1438
}

SIDE_SHOP_ITEMS = ["item_ring_of_health", "item_energy_booster"]
SECRET_SHOP_ITEMS = [
	"item_energy_booster",
	"item_vitality_booster",
	"item_point_booster",
	"item_hyperstone",
	"item_demon_edge",
	"item_mystic_staff",
	"item_reaver",
	"item_eagle",
	"item_relic",
	"item_void_stone_datadriven",
	"item_ring_of_health",
	"item_orb_of_venom"]

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
	// if hero has item from inventory, trigger take stash, else transferitem
	if (heroHasItemInStash()) {
		Game.PrepareUnitOrders({
			"OrderType": dotaunitorder_t.DOTA_UNIT_ORDER_CAST_NO_TARGET,
			"OrderIssuer": PlayerOrderIssuer_t.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY,
			"UnitIndex": courier,
			"AbilityIndex": Entities.GetAbilityByName(courier, "courier_take_stash_items_lua")
		});
	} else {
		Game.PrepareUnitOrders({
			"OrderType": dotaunitorder_t.DOTA_UNIT_ORDER_CAST_NO_TARGET,
			"OrderIssuer": PlayerOrderIssuer_t.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY,
			"UnitIndex": courier,
			"AbilityIndex": Entities.GetAbilityByName(courier, "courier_transfer_items_lua")
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
		$("#courier-panel-inv").RemoveClass("button-hidden")
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
		// if courier inventory panel is shown
		if ($("#courier-inv-toggle-label").text === ">") {
			let courierId = parseInt(current_courier_id)
			for (let i = 0; i < 6; i++) {
				let item = Entities.GetItemInSlot(courierId, i)
				if (item > 0) {
					$("#item_image_"+i).itemname = Abilities.GetAbilityName(item);
				} else {
					$("#item_image_"+i).itemname = "";
				}
			}
		}
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
	let quickbuy_kb = Game.GetKeybindForCommand(DOTAKeybindCommand_t.DOTA_KEYBIND_PURCHASE_QUICKBUY);

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

	if (!conflictWithAbilityKB(quickbuy_kb)) {
		let quickbuy_command = "CustomGameQuickBuy" + Math.floor(Math.random() * 100000);
		Game.AddCommand(quickbuy_command, markQuickBuyItemsAsPurchased, "", 0);
		Game.CreateCustomKeyBind(quickbuy_kb, quickbuy_command);
	}


}

function findItemRecipe(itemname) {
	for (let i = 0; i < ITEM_RECIPE_RULES.length; i++) {
		if (ITEM_RECIPE_RULES[i][0] == itemname) {
			return ITEM_RECIPE_RULES[i].slice(1)
		}
	}
	return []
}

function IsItemCombined(itemname) {
	return findItemRecipe(itemname).length > 0
}

function quickBuySubItem(all_hero_items, itemname) {
	let item_recipe_components = findItemRecipe(itemname)
	let hero = Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer())
	// purchase the first item not owned by hero
	for (let i = 0; i < item_recipe_components.length; i++) {
		let item_index = all_hero_items.indexOf(item_recipe_components[i])
		if (item_index == -1) {
			let buying_unit = findBuyingUnit(itemname, hero);
			if (buying_unit == null) {
				continue;
			}
			Game.PrepareUnitOrders({
				"OrderType": dotaunitorder_t.DOTA_UNIT_ORDER_PURCHASE_ITEM,
				"TargetIndex": hero,
				"OrderIssuer": PlayerOrderIssuer_t.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY,
				"UnitIndex": buying_unit,
				"AbilityIndex": ITEMNAME_2_ITEMID[item_recipe_components[i]]
			});
			return;
		} else {
			// Remove item from all_hero_items
			all_hero_items.splice(item_index, 1)
		}
	}
}

function findBuyingUnit(itemname, hero) {
	let buying_unit_candidates = [ hero ]
	let couriers = Entities.GetAllEntitiesByName("npc_dota_courier")
	for (i in couriers) {
		if (Entities.GetTeamNumber(couriers[i]) == Entities.GetTeamNumber(hero)) {
			buying_unit_candidates.push(couriers[i])
		}
	}
	if (SECRET_SHOP_ITEMS.indexOf(itemname) >= 0) {
		for (i in buying_unit_candidates) {
			if (Entities.IsInRangeOfShop(buying_unit_candidates[i], DOTA_SHOP_TYPE.DOTA_SHOP_SECRET, true)) {
				return buying_unit_candidates[i];
			}
		}
	}
	if (SIDE_SHOP_ITEMS.indexOf(itemname) >= 0) {
		for (i in buying_unit_candidates) {
			if (Entities.IsInRangeOfShop(buying_unit_candidates[i], DOTA_SHOP_TYPE.DOTA_SHOP_SIDE, true)) {
				return buying_unit_candidates[i];
			}
		}
	}
	if (SECRET_SHOP_ITEMS.indexOf(itemname) < 0) {
		return hero
	}
	return null
}

function markQuickBuyItemsAsPurchased() {
    var quickbuy_item = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("QuickBuyInset0");
	$.Msg("markQuickBuyItemsAsPurchased quickbuy_item " + quickbuy_item.itemname)
	$.Msg(quickbuy_item)
	if (quickbuy_item.itemname == "") {
		$.Msg("No quick buy item.")
		return
	}
	// find item recipes
	let item_recipe_components = findItemRecipe(quickbuy_item.itemname)
	let hero = Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer())
	//combinenable item, get next component to purchase, considering items carried in any courier
	let all_hero_items = []
	for (let i = 0; i < 6; i++) {
		let item = Entities.GetItemInSlot(hero, i)
		if (item != -1) {
			all_hero_items.push(Abilities.GetAbilityName(item))
		}
	}
	for (let i = 9; i < 15; i++) {
		let item = Entities.GetItemInSlot(hero, i)
		if (item != -1) {
			all_hero_items.push(Abilities.GetAbilityName(item))
		}
	}
	let couriers = Entities.GetAllEntitiesByName("npc_dota_courier")
	for (let i = 0; i < couriers.length; i++) {
		if (Entities.GetTeamNumber(couriers[i]) != Entities.GetTeamNumber(hero)) {
			continue;
		}
		for (let j = 0; j < 6; j++) {
			let item = Entities.GetItemInSlot(couriers[i], j)
			if (item != -1 && Items.GetPurchaser(item) == hero) {
				all_hero_items.push(Abilities.GetAbilityName(item))
			}
		}
	}
	
	$.Msg("All hero items " + all_hero_items)

	while(true) {
		let hasCombinedItem = false
		// combine hero's all items
		for (let i = 0; i < ITEM_RECIPE_RULES.length; i++) {
			// deep copy all hero items
			let all_hero_items_copy = all_hero_items.slice()
			let currentItem = ITEM_RECIPE_RULES[i][0]
			let canCombineItem = false
			for (let j = 1; j < ITEM_RECIPE_RULES[i].length; j++) {
				let item_index = all_hero_items_copy.indexOf(ITEM_RECIPE_RULES[i][j]);
				if (item_index == -1) {
					// cannot combine current item
					break;
				}
				if (j == ITEM_RECIPE_RULES[i].length - 1) {
					canCombineItem = true
					break;
				}
				all_hero_items_copy.splice(item_index, 1)
			}
			if (canCombineItem) {
				$.Msg("Can combine item " + currentItem);
				all_hero_items.push(currentItem);
				for (let j = 1; j < ITEM_RECIPE_RULES[i].length; j++) {
					all_hero_items.splice(all_hero_items.indexOf(ITEM_RECIPE_RULES[i][j]), 1)
				}
				hasCombinedItem = true
			}
		}
		if (!hasCombinedItem) {
			break;
		}
	}
	$.Msg("All hero items combined " + all_hero_items);

	if (all_hero_items.indexOf(quickbuy_item.itemname) >= 0) {
		$.Msg("Already has the item, skipping quick buy")
		return;
	}
	
	if (item_recipe_components.length == 0) {
		//basic item, just purchase the current item
		$.Msg("buying basic item " + quickbuy_item.itemname)
		if (all_hero_items.indexOf(quickbuy_item.itemname) == -1) {
			let buying_unit = findBuyingUnit(quickbuy_item.itemname, hero)
			if (buying_unit != null) {
				Game.PrepareUnitOrders({
					"OrderType": dotaunitorder_t.DOTA_UNIT_ORDER_PURCHASE_ITEM,
					"TargetIndex": hero,
					"OrderIssuer": PlayerOrderIssuer_t.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY,
					"UnitIndex": buying_unit,
					"AbilityIndex": ITEMNAME_2_ITEMID[quickbuy_item.itemname]
				})
			} else {
				$.Msg("Hero or courier not near secret or side shop")
			}
		} else {
			$.Msg("Hero already has this item")
		}
		return;
	}
	// purchase the first item not owned by hero
	for (let i = 0; i < item_recipe_components.length; i++) {
		let item_index = all_hero_items.indexOf(item_recipe_components[i])
		if (item_index == -1) {
			if (!IsItemCombined(item_recipe_components[i])) {
				$.Msg("Buying basic component " + item_recipe_components[i])
				let buying_unit = findBuyingUnit(item_recipe_components[i], hero);
				if (buying_unit == null) {
					continue;
				}
				Game.PrepareUnitOrders({
					"OrderType": dotaunitorder_t.DOTA_UNIT_ORDER_PURCHASE_ITEM,
					"TargetIndex": hero,
					"OrderIssuer": PlayerOrderIssuer_t.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY,
					"UnitIndex": buying_unit,
					"AbilityIndex": ITEMNAME_2_ITEMID[item_recipe_components[i]]
				});
				return;
			} else {
				// change item recipe component to the sub item, rerun quick buy
				quickBuySubItem(all_hero_items, item_recipe_components[i])
				return;
			}
		} else {
			// Remove item from all_hero_items
			all_hero_items.splice(item_index, 1)
		}
	}
}

function OnCourierInvToggle() {
	let text = $("#courier-inv-toggle-label").text
	$.Msg("Toggle text is " + text)
	if (text === ">") {
		$("#courier-inv-toggle-label").text = '<';
		$("#courier-panel-inv").AddClass("inv-panel-collapsed");
		$("#courier_inventory_panel_label").visible = false;
		$("#courier-panel-inv-inner").visible = false;
	} else {
		$("#courier-inv-toggle-label").text = '>';
		$("#courier-panel-inv").RemoveClass("inv-panel-collapsed");
		$("#courier_inventory_panel_label").visible = true;
		$("#courier-panel-inv-inner").visible = true;
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

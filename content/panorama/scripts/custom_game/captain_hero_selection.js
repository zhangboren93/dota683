GameEvents.Subscribe("captain_draft_start", OnCaptainDraftStart);
GameEvents.Subscribe("captain_hero_pick_s2c", OnCaptainHeroPickS2C);
GameEvents.Subscribe("captain_player_pick_start", OnCaptainPlayerPickStart);
GameEvents.Subscribe("captain_pick_timer", OnCaptainPickTimer);

selected_hero = "";
pick_phase = 0;
function OnCaptainDraftStart(event) {
	$.Msg("OnCaptainDraftStart");
	$.GetContextPanel().RemoveClass("captain-selection-ban-panel-hide");
}

function OnCaptainHeroPickS2C(event) {
	$.Msg("OnCaptainHeroPickS2C " + event.pp + " " + event.sh);
	if (pick_phase > event.pp) {
		return
	}
	$("#hero-pick-" + event.pp).heroname = event.sh;
	for (var i = 0; i < 20; i++) {
		if (i == event.pp + 1) {
			$("#hpp-" + i).AddClass("hero-picked-panel-active");
		} else {
			$("#hpp-" + i).RemoveClass("hero-picked-panel-active");
		}
	}
	if (event.pp == 0 || event.pp == 2 || event.pp == 4 || event.pp == 6 || event.pp == 8 || event.pp == 10 || event.pp == 12 || event.pp == 14 || event.pp == 15 || event.pp == 18) {
		$("#pick-phase-radiant").AddClass("label-hide");
		$("#pick-phase-dire").RemoveClass("label-hide");
	} else {
		$("#pick-phase-dire").AddClass("label-hide");
		$("#pick-phase-radiant").RemoveClass("label-hide");
	}
	if ((event.pp >= 3 && event.pp <= 6) || (event.pp >= 11 && event.pp <= 14) || event.pp >= 17) {
		$("#pick-phase-ban").AddClass("label-hide");
		$("#pick-phase-pick").RemoveClass("label-hide");
	} else {
		$("#pick-phase-pick").AddClass("label-hide");
		$("#pick-phase-ban").RemoveClass("label-hide");
	}

	$("#hi_" + event.sh).AddClass("hero_image_hidden")
	pick_phase = event.pp + 1;
}

function OnCaptainPlayerPickStart() {
	$.Msg("OnCaptainPlayerPickStart");
	$.GetContextPanel().AddClass("captain-selection-ban-panel-hide");
}

function OnCaptainPickTimer(event) {
	$("#pick-phase-time").text = event.nt;
	$("#pick-phase-extra-time").text = event.et;
}

function handleHeroClicked(button) {
	$.Msg(button);
	var hero_image = $("#hi_" + button);
	if (hero_image.BHasClass("hi_selected")) {
		hero_image.RemoveClass("hi_selected");
		$("#ban-button").AddClass("button-hidden");
		selected_hero = "";
	} else {
		for (var i = 0; i < hero_names.length; i++) {
			//$.Msg(hero_names[i]);
			$("#hi_" + hero_names[i]).RemoveClass("hi_selected");
		}
		$("#hi_" + button).AddClass("hi_selected");
		selected_hero = button;
		$("#ban-button").RemoveClass("button-hidden");
	}
}

function handleBanClicked() {
	if (selected_hero != "") {
		GameEvents.SendCustomGameEventToServer(
			"captain_client_pick", { pp: pick_phase, sh: selected_hero, pid: Players.GetLocalPlayer() });
	}
	for (var i = 0; i < hero_names.length; i++) {
		//$.Msg(hero_names[i]);
		$("#hi_" + hero_names[i]).RemoveClass("hi_selected");
	}
	selected_hero = "";
}

hero_names = [
	"abaddon"				,
	"ancient_apparition"	 ,
	"antimage"			,
	"arc_warden"			,
	"axe"					,
	"bane"				,
	"beastmaster"			,
	"brewmaster"			,
	"centaur"				,
	"chaos_knight"		,
	"crystal_maiden"		,
	"dazzle"				,
	"dragon_knight"		,
	"drow_ranger"			,
	"earthshaker"			,
	"faceless_void"		,
	"juggernaut"			,
	"leshrac"				,
	"lich"				,
	"life_stealer"		,
	"lina"				,
	"lion"				,
	"luna"				,
	"lycan"				,
	"magnataur"			,
	"medusa"				,
	"morphling"			,
	"naga_siren"			,
	"nevermore"			,
	"night_stalker"		,
	"nyx_assassin"		,
	"obsidian_destroyer"	,
	"ogre_magi"			,
	"omniknight"			,
	"oracle"				,
	"pugna"				,
	"rattletrap"			,
	"razor"				,
	"shadow_demon"		,
	"shadow_shaman"		,
	"skeleton_king"		,
	"skywrath_mage"		,
	"slardar"				,
	"slark"				,
	"sniper"				,
	"spirit_breaker"		,
	"sven"				,
	"terrorblade"			,
	"tidehunter"			,
	"troll_warlord"		,
	"tusk"				,
	"vengefulspirit"		,
	"viper"				,
	"visage"				,
	"warlock"				,
	"weaver"				,
	"windrunner"			,
	"witch_doctor"		,
	"abyssal_underlord"	,
	"alchemist"			,
	"bounty_hunter"		,
	"clinkz"				,
	"death_prophet"		,
	"disruptor"			,
	"earth_spirit"		,
	"elder_titan"			,
	"ember_spirit"		,
	"enigma"				,
	"gyrocopter"			,
	"huskar"				,
	"invoker"				,
	"jakiro"				,
	"keeper_of_the_light"	,
	"phantom_assassin"	,
	"phoenix"				,
	"sand_king"			,
	"shredder"			,
	"silencer"			,
	"tinker"				,
	"tiny"				,
	"treant"				,
	"venomancer"			,
	"winter_wyvern"		,
	"bristleback"			,
	"storm_spirit"		,
	"wisp"				,
	"dark_seer"			,
	"lone_druid"			,
	"mirana"				,
	"necrolyte"			,
	"puck"				,
	"pudge"				,
	"queenofpain"			,
	"riki"				,
	"rubick"				,
	"techies"				,
	"templar_assassin"	,
	"zuus"				,
	"batrider"			,
	"bloodseeker"			,
	"broodmother"			,
	"chen"				,
	"doom_bringer"		,
	"enchantress"			,
	"furion"				,
	"kunkka"				,
	"legion_commander"	,
	"meepo"				,
	"phantom_lancer"		,
	"spectre"				,
	"undying"				,
	"ursa"	
]

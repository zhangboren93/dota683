GameEvents.Subscribe("captain_ddraft_start", OnCaptainDraftStart);
GameEvents.Subscribe("captain_draft_hero_pick_s2c", OnCaptainDraftHeroPick);

DEBUG = false
draft_state = 0
draft_start_team = DOTATeam_t.DOTA_TEAM_GOODGUYS
radiant_timer = 150
dire_timer = 150

function getTeamFromPhase(phase) {
	if (phase == 1 ||
		phase == 3 ||
		phase == 5 ||
		phase == 7 ||
		phase == 10 ||
		phase == 11 ||
		phase == 14 ||
		phase == 15) {
		return draft_start_team
	} else if (draft_start_team == DOTATeam_t.DOTA_TEAM_GOODGUYS) {
		return DOTATeam_t.DOTA_TEAM_BADGUYS
	} else {
		return DOTATeam_t.DOTA_TEAM_GOODGUYS
	}
}

function countDownTimer() {
	let team = getTeamFromPhase(draft_state)
	if (team == DOTATeam_t.DOTA_TEAM_GOODGUYS) {
		radiant_timer = radiant_timer - 1
		if (radiant_timer < 0) {
			radiant_timer = 0
		}
		$("#pick-phase-time").text = radiant_timer
	} else {
		dire_timer = dire_timer - 1
		if (dire_timer < 0) {
			dire_timer = 0
		}
		$("#pick-phase-time").text = dire_timer
	}
	if (draft_state <= 16) {
		$.Schedule(1, countDownTimer)
	}
}
function OnCaptainDraftStart(data) {
	$.Msg("OnCaptainDraftStart")
	$.Msg(data)
	for (let i=1; i <=27; i++) {
		$("#hero-image-str-"+i).heroname = data.sh[i.toString()]
	}
	if (data.st == DOTATeam_t.DOTA_TEAM_BADGUYS) {
		draft_start_team = DOTATeam_t.DOTA_TEAM_BADGUYS;
		$("#pick-phase-radiant").visible = false
		$("#pick-phase-dire").visible = true
	}
	$.GetContextPanel().RemoveClass("captain_draft_panel_hide")
	draft_state = 1
	$.Schedule(1, countDownTimer)
}

function handleHeroClicked(hero_idx) {
	if ($("#hero-image-str-"+hero_idx).BHasClass("hero-selected")) {
		$("#hero-image-str-"+hero_idx).RemoveClass("hero-selected")
	} else {
		$("#hero-image-str-"+hero_idx).AddClass("hero-selected")
		for (let i=1; i <=27; i++) {
			if (i != hero_idx) {
				$("#hero-image-str-"+i).RemoveClass("hero-selected")
			}
		}
	}
}

function handleBanButtonClicked() {
	// verify is my turn to pick
	let my_player = Players.GetLocalPlayer()
	let my_team = Players.GetTeam(my_player)
	let is_my_team_ban_phase = false
	if (my_team == draft_start_team) {
		if (draft_state == 1 || draft_state == 3 || draft_state == 5) {
			is_my_team_ban_phase = true
		}
	} else {
		if (draft_state == 2 || draft_state == 4 || draft_state == 6) {
			is_my_team_ban_phase = true
		}
	}
	if (!is_my_team_ban_phase && !DEBUG) {
		$.Msg("Not my team to ban.")
		return
	}
	// find hero selected
	let hero_selected = ""
	for (let i=1;i<28;i++) {
		let hero_image = $("#hero-image-str-"+i)
		if (hero_image.BHasClass("hero-selected")) {
			hero_selected = hero_image.heroname 
		}
	}
	if (hero_selected.length == 0) {
		$.Msg("No hero selected.")
		return
	}
	GameEvents.SendCustomGameEventToServer(
		"captain_client_pick", { pp: draft_state, sh: hero_selected });
}

function OnCaptainDraftHeroPick(data) {
	$.Msg("OnCaptainDraftHeroPick")
	$.Msg(data);
	// only handles update with greater phase
	if (data.pp < draft_state) {
		return
	}
	let hero_image_history_id = "#"
	
	if (getTeamFromPhase(data.pp) == DOTATeam_t.DOTA_TEAM_GOODGUYS) {
		hero_image_history_id += "radiant"
	} else {
		hero_image_history_id += "dire"
	}
	if (data.pp <= 6) {
		hero_image_history_id += "-ban-"
	} else {
		hero_image_history_id += "-pick-"
	}
	// find a element with no heroname
	let hero_image_history = null;
	for (let i = 1; i <= 5; i++) {
		let hero_image = $(hero_image_history_id + i)
		if (hero_image != null && hero_image.heroname.length == 0) {
			hero_image_history = hero_image;
			break;
		}
	}
	if (hero_image_history != null) {
		hero_image_history.heroname = data.sh;
	}

	// Hide the hero in the left selection panel
	for (let i = 1; i <= 27; i++) {
		let hero_image = $("#hero-image-str-" + i)
		if (hero_image.heroname == data.sh) {
			hero_image.RemoveClass("hero-selected")
			hero_image.visible = false
			break;
		}
	}
	
	draft_state = data.pp + 1;
	if (draft_state == 17) {
		// Hides Panel in 2s
		$.Schedule(2, function() {
			$.GetContextPanel().visible = false;
		})
	} else {
		let current_team = getTeamFromPhase(draft_state)
		if (current_team == DOTATeam_t.DOTA_TEAM_GOODGUYS) {
			$("#pick-phase-radiant").visible = true
			$("#pick-phase-dire").visible = false
		} else {
			$("#pick-phase-radiant").visible = false
			$("#pick-phase-dire").visible = true
		}
		if (draft_state == 7) {
			$("#pick-phase-pick").visible = true
			$("#pick-phase-ban").visible = false
		}
	}
	let my_player = Players.GetLocalPlayer()
	let my_team = Players.GetTeam(my_player)
	if (   (draft_state == 6 && my_team == draft_start_team) 
		|| (draft_state == 7 && my_team != draft_start_team)) {
		// Hide ban button, enable pick button
		$("#ban_hero_button").visible = false
		$("#select_hero_button").RemoveClass("button_hidden")
	}
}

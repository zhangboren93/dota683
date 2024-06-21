require("ladder_game_mode")
require("hero_types")
DEBUG = false
captain_draft_hero_pool = {}

-- if start team is radiant, 1rb 2db 3rb 4db 5rb 6db 7rp 8dp 9dp 10rp 11rp 12dp 13dp 14rp 15rp 16dp 17dp 18rp
captain_draft_pick_phase = 1
captain_draft_start_team = DOTA_TEAM_GOODGUYS
captain_draft_team_pick = {{}, {}} -- radiant, dire
team_timer_remaining = {150, 150}

local function removeFromTable(heroname)
	for i=1,#captain_draft_hero_pool do
		if captain_draft_hero_pool[i] == heroname then
			table.remove(captain_draft_hero_pool, i)
			break;
		end
	end
end

function initCaptainDraft()
	local heroes = str_heroes
	-- shuffles
	for i=1,9 do
		local j=RandomInt(i,#heroes)
		local tmp = heroes[i]; heroes[i] = heroes[j]; heroes[j] = tmp;
		table.insert(captain_draft_hero_pool, heroes[i])
	end
	heroes = agi_heroes 
	for i=1,9 do
		local j=RandomInt(i,#heroes)
		local tmp = heroes[i]; heroes[i] = heroes[j]; heroes[j] = tmp;
		table.insert(captain_draft_hero_pool, heroes[i])
	end
	heroes = intellect_heroes
	for i=1,9 do
		local j=RandomInt(i,#heroes)
		local tmp = heroes[i]; heroes[i] = heroes[j]; heroes[j] = tmp;
		table.insert(captain_draft_hero_pool, heroes[i])
	end
	--send all heroes backed up to the clients
	-- TODO pick start team
	CustomGameEventManager:Send_ServerToAllClients("captain_ddraft_start", {sh = captain_draft_hero_pool})
end

local function getTeamToPickFromPickPhase(pick_phase)
	if     pick_phase == 1
		or pick_phase == 3
		or pick_phase == 5
		or pick_phase == 7
		or pick_phase == 10
		or pick_phase == 11
		or pick_phase == 14
		or pick_phase == 15 then
		return captain_draft_start_team
	else
		if captain_draft_start_team == DOTA_TEAM_GOODGUYS then
			return DOTA_TEAM_BADGUYS
		else
			return DOTA_TEAM_GOODGUYS
		end
	end
end

local function endsCDPicks()
	for i=1,5 do
		local playerId = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_GOODGUYS, i)
		if playerId >= 0 then
			for j=1,#captain_draft_team_pick[1] do
				GameRules:AddHeroToPlayerAvailability(playerId, DOTAGameManager:GetHeroIDByName(captain_draft_team_pick[1][j]))
				if same_ability_heroes["npc_dota_hero_"..captain_draft_team_pick[1][j]] ~= nil then
					GameRules:AddHeroToPlayerAvailability(playerId, DOTAGameManager:GetHeroIDByName(same_ability_heroes["npc_dota_hero_"..captain_draft_team_pick[1][j]]))
				end
			end
		end
		playerId = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_BADGUYS, i)
		if playerId >= 0 then
			for j=1,#captain_draft_team_pick[2] do
				GameRules:AddHeroToPlayerAvailability(playerId, DOTAGameManager:GetHeroIDByName(captain_draft_team_pick[2][j]))
				if same_ability_heroes["npc_dota_hero_"..captain_draft_team_pick[2][j]] ~= nil then
					GameRules:AddHeroToPlayerAvailability(playerId, DOTAGameManager:GetHeroIDByName(same_ability_heroes["npc_dota_hero_"..captain_draft_team_pick[2][j]]))
				end
			end
		end
	end
end

function handleCaptainDraftPickEvent(event)
	local playerId = event.PlayerID
	local team = PlayerResource:GetPlayer(playerId):GetTeam()
	local team_turn_to_pick = nil
	-- verity team match current turn
	local team_turn_to_pick = getTeamToPickFromPickPhase(captain_draft_pick_phase)
	if team ~= team_turn_to_pick and not DEBUG then
		print("Wrong team pick/ban.")
		return
	end
	-- if is ban phase remove hero from hero_list
	if captain_draft_pick_phase <= 6 then
		print("Baning "..event.sh)
		removeFromTable(event.sh)
	else
		print("Adding "..event.sh.." to team "..team)
		if team_turn_to_pick == DOTA_TEAM_GOODGUYS then
			table.insert(captain_draft_team_pick[1], event.sh)
		else
			table.insert(captain_draft_team_pick[2], event.sh)
		end
		removeFromTable(event.sh)
	end
	print("hero pool:")
	DeepPrintTable(captain_draft_hero_pool)
	print("teams pick:")
	DeepPrintTable(captain_draft_team_pick)
	CustomGameEventManager:Send_ServerToAllClients("captain_draft_hero_pick_s2c",
		{ pp = captain_draft_pick_phase, sh = event.sh, pt = team })
	captain_draft_pick_phase = captain_draft_pick_phase + 1

	if captain_draft_pick_phase == 17 then
		--Ends pick, Give each team its available heroes
		endsCDPicks()
		captain_draft_pick_phase = 18
	end
end

function countDownRDTeamTimer(interval)
	if captain_draft_pick_phase >= 17 then
		if captain_draft_pick_phase == 17 then
			endsCDPicks()
			captain_draft_pick_phase = 18
		end
		return
	end
	local team = getTeamToPickFromPickPhase(captain_draft_pick_phase)
	local skip_phase = false
	if team == DOTA_TEAM_GOODGUYS then
		team_timer_remaining[1] = team_timer_remaining[1] - interval
		if team_timer_remaining[1] <= 0 then
			print("Radiant team time expired.")
			skip_phase = true
		end
	else
		team_timer_remaining[2] = team_timer_remaining[2] - interval
		if team_timer_remaining[2] <= 0 then
			print("Dire team time expired.")
			skip_phase = true
		end
	end
	if skip_phase then
		-- bans an random hero
		local sh = captain_draft_hero_pool[RandomInt(1, #captain_draft_hero_pool)]
		removeFromTable(sh)
		sh = string.sub(sh, 15)
		if captain_draft_pick_phase > 6 then
			if team == DOTA_TEAM_GOODGUYS then
				table.insert(captain_draft_team_pick[1], sh)
			else
				table.insert(captain_draft_team_pick[2], sh)
			end
		end
		CustomGameEventManager:Send_ServerToAllClients("captain_draft_hero_pick_s2c",
			{ pp = captain_draft_pick_phase, sh = sh, pt = team })
		captain_draft_pick_phase = captain_draft_pick_phase + 1
	end
end

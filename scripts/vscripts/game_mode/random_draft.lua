require("hero_types")
--TODO Randomly picks a starting team
function initRDHeroSelection(game_mode)
	local heroes = unique_heroes
	-- shuffles
	for i=1,24 do
		local j=RandomInt(i,#heroes)
		local tmp = heroes[i];
		heroes[i] = heroes[j];
		heroes[j] = tmp;
		table.insert(game_mode.RandomDraftHeroPool, heroes[i])
	end
	--add all heroes to radiant 1st player's availability
	local radiantPlayerCount = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
	local playerId = -1
	if radiantPlayerCount > 0 then
		playerId = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_GOODGUYS, 1)
		for i=1,#game_mode.RandomDraftHeroPool do
			local heroid = DOTAGameManager:GetHeroIDByName(game_mode.RandomDraftHeroPool[i])
			print("Opening hero " .. heroid .. " to player " .. playerId)
			GameRules:AddHeroToPlayerAvailability(playerId, DOTAGameManager:GetHeroIDByName(game_mode.RandomDraftHeroPool[i]))
		end
	end
	--send all heroes backed up to the clients
	CustomGameEventManager:Send_ServerToAllClients("random_draft_start", {sh = game_mode.RandomDraftHeroPool, spid = playerId})
	game_mode.hero_selection_state = "RD_PICK_RAD_1"
end

local function RDPlayerPicksNext(team, idx)
	local direPlayerCount = PlayerResource:GetPlayerCountForTeam(team)
	if direPlayerCount >= idx then
		local playerId = PlayerResource:GetNthPlayerIDOnTeam(team, idx)
		for i=1,#GameRules.AddonTemplate.RandomDraftHeroPool do
			local heroid = DOTAGameManager:GetHeroIDByName(GameRules.AddonTemplate.RandomDraftHeroPool[i])
			print("Opening hero " .. heroid .. " to player " .. playerId)
			GameRules:AddHeroToPlayerAvailability(playerId, DOTAGameManager:GetHeroIDByName(GameRules.AddonTemplate.RandomDraftHeroPool[i]))
			CustomGameEventManager:Send_ServerToAllClients("random_draft_player_start", {spid = playerId})
		end
	end
end

local function RDPlayerRandomPick(team, idx)
	local radiantPlayerCount = PlayerResource:GetPlayerCountForTeam(team)
	if radiantPlayerCount >= idx then
		local playerId = PlayerResource:GetNthPlayerIDOnTeam(team, idx)
		local heroName = PlayerResource:GetSelectedHeroName(playerId)
		if heroName == "" then
			PlayerResource:GetPlayer(playerId):MakeRandomHeroSelection()
		 	heroName = PlayerResource:GetSelectedHeroName(playerId)
		end
		-- remove heroName from current pool
		for i = 1,#GameRules.AddonTemplate.RandomDraftHeroPool do
			if heroName == GameRules.AddonTemplate.RandomDraftHeroPool[i] then
				table.remove(GameRules.AddonTemplate.RandomDraftHeroPool, i)
				break
			end
		end
	end
end

function handleRDHeroTime(game_mode)
	if game_mode.hero_selection_state == "RD_PICK_RAD_1" then
		local time = GameRules:GetDOTATime(true, true)
		if time > -101 then
			RDPlayerRandomPick(DOTA_TEAM_GOODGUYS, 1)
			RDPlayerPicksNext(DOTA_TEAM_BADGUYS, 1)
			RDPlayerPicksNext(DOTA_TEAM_BADGUYS, 2)
			game_mode.hero_selection_state = "RD_PICK_DIR_1_2"
		end
	elseif game_mode.hero_selection_state == "RD_PICK_DIR_1_2" then
		local time = GameRules:GetDOTATime(true, true)
		if time > -81 then
			RDPlayerRandomPick(DOTA_TEAM_BADGUYS, 1)
			RDPlayerRandomPick(DOTA_TEAM_BADGUYS, 2)
			RDPlayerPicksNext(DOTA_TEAM_GOODGUYS, 2)
			RDPlayerPicksNext(DOTA_TEAM_GOODGUYS, 3)
			game_mode.hero_selection_state = "RD_PICK_RAD_2_3"
		end
	elseif game_mode.hero_selection_state == "RD_PICK_RAD_2_3" then
		local time = GameRules:GetDOTATime(true, true)
		if time > -61 then
			RDPlayerRandomPick(DOTA_TEAM_GOODGUYS, 2)
			RDPlayerRandomPick(DOTA_TEAM_GOODGUYS, 3)
			RDPlayerPicksNext(DOTA_TEAM_BADGUYS, 3)
			RDPlayerPicksNext(DOTA_TEAM_BADGUYS, 4)
			game_mode.hero_selection_state = "RD_PICK_DIR_3_4"
		end
	elseif game_mode.hero_selection_state == "RD_PICK_DIR_3_4" then
		local time = GameRules:GetDOTATime(true, true)
		if time > -41 then
			RDPlayerRandomPick(DOTA_TEAM_BADGUYS, 3)
			RDPlayerRandomPick(DOTA_TEAM_BADGUYS, 4)
			RDPlayerPicksNext(DOTA_TEAM_GOODGUYS, 4)
			RDPlayerPicksNext(DOTA_TEAM_GOODGUYS, 5)
			game_mode.hero_selection_state = "RD_PICK_RAD_4_5"
		end
	elseif game_mode.hero_selection_state == "RD_PICK_RAD_4_5" then
		local time = GameRules:GetDOTATime(true, true)
		if time > -21 then
			RDPlayerRandomPick(DOTA_TEAM_GOODGUYS, 4)
			RDPlayerRandomPick(DOTA_TEAM_GOODGUYS, 5)
			RDPlayerPicksNext(DOTA_TEAM_BADGUYS, 5)
			game_mode.hero_selection_state = "RD_PICK_DIR_5"
		end
	elseif game_mode.hero_selection_state == "RD_PICK_DIR_5" then
		local time = GameRules:GetDOTATime(true, true)
		if time > -1 then
			RDPlayerRandomPick(DOTA_TEAM_BADGUYS, 5)
			game_mode.hero_selection_state = "RD_PICK_ENDS"
		end
	end
end


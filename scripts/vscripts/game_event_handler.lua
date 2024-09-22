require('ladder_game_mode')
require('creepspawn')
require('death_match')
require('hero_types')

RANK_PLAYER_COUNT_REQ = 10

local function getPlayerScore(game_mode, playerIds)
	DeepPrintTable(playerIds)
	if #playerIds > 0 then
		local pid = playerIds[1][1]
		local accountId = playerIds[1][2]
		CreateHTTPRequest("GET", "http://"..LADDER_HOST.."/" .. accountId):Send(function(response)
			print("status code " .. response.StatusCode)
			if response.StatusCode == 200 then
				print("response " .. response.Body)
				local seperator_index = string.find(response.Body, ":")
				local score = string.sub(response.Body, seperator_index + 1)
				print("score " .. score)
				game_mode.playerId2LadderScore[pid] = tonumber(score)
				DeepPrintTable(game_mode.playerId2LadderScore)
				GameRules:SendCustomMessage("玩家"..pid..PlayerResource:GetPlayerName(pid).."排位分:"..score, -1, -1);
			else
				GameRules:SendCustomMessage("获取天梯分数失败，本次比赛将不会计算天梯分数！", -1, -1);
				GameRules.AddonTemplate.isValidRankedGame = false
				return
			end
			table.remove(playerIds, 1)
			getPlayerScore(game_mode, playerIds)
		end)
	end
end

local function getAllPlayerIds() 
	local playerIds = {}
	for i=1,PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS) do
		local player = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_GOODGUYS, i)
		table.insert(playerIds, {player, PlayerResource:GetSteamAccountID(player)})
	end
	for i=1,PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_BADGUYS) do
		local player = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_BADGUYS, i)
		table.insert(playerIds, {player, PlayerResource:GetSteamAccountID(player)})
	end
	for i=1,PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_NOTEAM) do
		local player = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_NOTEAM, i)
		table.insert(playerIds, {player, PlayerResource:GetSteamAccountID(player)})
	end
	return playerIds
end

local function getAllPlayerScores(game_mode)
	getPlayerScore(game_mode, getAllPlayerIds())
end

function HandleGameStateChange(game_mode, event)
	if event.new_state == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		local first_creep_spawned = false
		GameRules:GetGameModeEntity():SetThink(function()
			if first_creep_spawned then
				SpawnNeutralCreepSecondTime("neutralcamp_good_")
				SpawnNeutralCreepSecondTime("neutralcamp_evil_")
				return 60
			else
				first_creep_spawned = true
				SpawnNeutralCreepFirstTime("neutralcamp_good_")
				SpawnNeutralCreepFirstTime("neutralcamp_evil_")
				return 30
			end
		end, "spawn neutral creep", 30)
		if game_mode.isValidRankedGame and not game_mode.hasGameEnded then
			GameRules:GetGameModeEntity():SetThink(function()
				if game_mode.isValidRankedGame and not game_mode.hasGameEnded then
					uploadGameToServer(LADDER_HOST)
				end
			end, "validate rank game after 5 minutes", 300)
		end
	elseif event.new_state == DOTA_GAMERULES_STATE_HERO_SELECTION then
		CustomGameEventManager:Send_ServerToAllClients("player_ladder_scores", game_mode.playerId2LadderScore)
		if game_mode.game_mode == 'DM' then
			deathMatchGameRulesUpdate()
			-- randoms all player's hero selection
			local players = getAllPlayerIds()
			for i=1,#players do
				PlayerResource:GetPlayer(players[i][1]):MakeRandomHeroSelection()
				removeHeroFromDMPool(PlayerResource:GetSelectedHeroName(players[i][1]))
			end
		end
	elseif event.new_state == DOTA_GAMERULES_STATE_SCENARIO_SETUP then -- 2
		if game_mode.isValidRankedGame then
			local playerCount = PlayerResource:NumPlayers()
			print("Number of players is " .. playerCount)
			if playerCount ~= RANK_PLAYER_COUNT_REQ then
				GameRules:SendCustomMessage("天梯比赛需要10名玩家，本次对局不记录天梯分数!", -1, -1)
				game_mode.hasGameEnded = true
				game_mode.isValidRankedGame = false
				return
			end
			for i=1,#all_heroes do
				GameRules:AddHeroToBlacklist(all_heroes[i])
			end
			game_mode.game_mode = "LD"
			GameRules:GetGameModeEntity():SetThink(function()
				-- randomly assign player team start from either side
				local players = getAllPlayerIds()
				local startTeam = DOTA_TEAM_GOODGUYS
				while #players > 0 do
					local randomIndex = RandomInt(1, #players)
					local randomPlayer = players[randomIndex][1]
					GameRules:SendCustomMessage("Assigning " .. randomPlayer .. " to team " .. startTeam, -1, -1)
					PlayerResource:SetCustomTeamAssignment(randomPlayer, startTeam)
					table.remove(players, randomIndex)
					if startTeam == DOTA_TEAM_BADGUYS then
						startTeam = DOTA_TEAM_GOODGUYS
					else
						startTeam = DOTA_TEAM_BADGUYS
					end
				end
				getAllPlayerScores(game_mode)
			end, "Fetching player scores", 1)
		end
	end
end

local function getConnectedPlayerCount(team)
	local ret = 0
	for i=1,PlayerResource:GetPlayerCountForTeam(team) do
		local state = PlayerResource:GetConnectionState(PlayerResource:GetNthPlayerIDOnTeam(team, i))
		if state == DOTA_CONNECTION_STATE_CONNECTED or state == DOTA_CONNECTION_STATE_NOT_YET_CONNECTED then
			ret = ret + 1
		end
	end
	return ret
end

function handleGameInProgressTimer(game_mode, player2BuildingDamage)
	local time = GameRules:GetDOTATime(false, false) 

	-- give each player passive gold
	if time > 0 and IsServer() then
		local n = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
		for i=1,n do
			local playerid = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_GOODGUYS, i)
			PlayerResource:ModifyGold(playerid, 3, true, DOTA_ModifyGold_GameTick)

			local entity = PlayerResource:GetPlayer(playerid)
			if entity ~= nil then
				entity = entity:GetAssignedHero()
				local buyback_cost = 100 + entity:GetLevel() * entity:GetLevel() * 1.5 + GameRules:GetDOTATime(false, false) * 0.25
				PlayerResource:SetCustomBuybackCost(playerid, buyback_cost)
			end
		end
		local n = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_BADGUYS)
		for i=1,n do
			local playerid = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_BADGUYS, i)
			PlayerResource:ModifyGold(playerid, 3, true, DOTA_ModifyGold_GameTick)

			local entity = PlayerResource:GetPlayer(playerid)
			if entity ~= nil then
				entity = entity:GetAssignedHero()
				local buyback_cost = 100 + entity:GetLevel() * entity:GetLevel() * 1.5 + GameRules:GetDOTATime(false, false) * 0.25
				PlayerResource:SetCustomBuybackCost(playerid, buyback_cost)
			end
		end
	end

	if game_mode.nextRoshanTime ~= nil and time > game_mode.nextRoshanTime then
		print("Spawn next rosh")
		CreateUnitByName("npc_dota_roshan_datadriven", Vector(4320, -1824, 160), true, nil, nil, DOTA_TEAM_NEUTRALS)
		game_mode.nextRoshanTime = nil
	end

	-- respawn base trees in rank map
	if isMapRanked() then
		-- if all players from one team has disconnected from the game, call other team the winner.
		if game_mode.isValidRankedGame and not game_mode.hasGameEnded then
			if getConnectedPlayerCount(DOTA_TEAM_GOODGUYS) == 0 then
				sendEndGameStats(player2BuildingDamage)
				GameRules:SendCustomMessage("天灾军团胜利", -1, -1)
				game_mode.hasGameEnded = true
				GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
			elseif getConnectedPlayerCount(DOTA_TEAM_BADGUYS) == 0 then
				sendEndGameStats(player2BuildingDamage)
				GameRules:SendCustomMessage("近卫军团胜利", -1, -1)
				game_mode.hasGameEnded = true
				GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
			end
		end
	end
	
	local heroes = HeroList:GetAllHeroes()
	local currentTime = GameRules:GetGameTime()
	for i = 1,#heroes do
		local hero = heroes[i]
		if hero:IsRealHero() and hero:IsAlive() then
			hero.last_alive_time = currentTime
		end
	end
end

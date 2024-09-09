require('ladder_game_mode')
require('creepspawn')

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
	if event.new_state == 5 then
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
	elseif event.new_state == 4 then
		CustomGameEventManager:Send_ServerToAllClients("player_ladder_scores", game_mode.playerId2LadderScore)
	elseif event.new_state == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		if game_mode.isValidRankedGame then
			local playerCount = PlayerResource:NumPlayers()
			print("Number of players is " .. playerCount)
			if playerCount ~= RANK_PLAYER_COUNT_REQ then
				GameRules:SendCustomMessage("天梯比赛需要10名玩家，本次对局不记录天梯分数!", -1, -1)
				game_mode.hasGameEnded = true
				game_mode.isValidRankedGame = false
			else
				GameRules:GetGameModeEntity():SetThink(function()
					getAllPlayerScores(game_mode)
				end, "Fetching player scores", 1)
			end
			for i=1,#all_heroes do
				GameRules:AddHeroToBlacklist(all_heroes[i])
			end
			game_mode.game_mode = "LD"
		end
	end
end

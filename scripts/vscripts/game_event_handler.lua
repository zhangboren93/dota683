require('ladder_game_mode')
require('creepspawn')
require('death_match')
require('hero_types')
json = require('json')

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

local function sendPlayerStatsToUITeam(player2account_records, team)
	local radiant_players = {}	
	for i=1,PlayerResource:GetPlayerCountForTeam(team) do
		local player = PlayerResource:GetNthPlayerIDOnTeam(team, i)
		local steam_id = PlayerResource:GetSteamID(player)
		local record = player2account_records[tostring(player)]
		local mmr = 0
		if record ~= nil and record.mmr ~= nil then
			mmr = record.mmr
		end
		table.insert(radiant_players, {
			sid = steam_id,
			mmr = mmr
		})
	end
	--DeepPrintTable(radiant_players)
	return radiant_players
end
	
local function sendPlayerStatsToUI(player2account_records)
	local player_score_map = {}
	for i=1,#player2account_records / 2 do
		player_score_map[player2account_records[2 * i - 1]] = player2account_records[2 * i]
	end
	DeepPrintTable(player2account_records)
	local radi_players = sendPlayerStatsToUITeam(player_score_map, DOTA_TEAM_GOODGUYS)
	local dire_players = sendPlayerStatsToUITeam(player_score_map, DOTA_TEAM_BADGUYS)
	CustomGameEventManager:Send_ServerToAllClients(
		"team_select_player_stats", { rp = radi_players, dp = dire_players})
end

function shuffleTeam()
	print("shuffleTeam")
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
end

function assignPlayersWithNoTeam()
	local players = getAllPlayerIds()
	local startTeam = DOTA_TEAM_GOODGUYS
	while #players > 0 do
		local player = players[1][1]
		table.remove(players, 1)
		if PlayerResource:GetTeam(player) == DOTA_TEAM_NOTEAM then
			-- if radiant team has empty space, assign to radiant
			if PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS) < 5 then
				print("Assigning player " .. player .. " with no team to RADI.")
				PlayerResource:SetCustomTeamAssignment(player, DOTA_TEAM_GOODGUYS)
			elseif PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_BADGUYS) < 5 then
				print("Assigning player " .. player .. " with no team to DIRE.")
				PlayerResource:SetCustomTeamAssignment(player, DOTA_TEAM_BADGUYS)
			end
			-- if dire team has empty spaece, assign to dire
		end
	end
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
	--elseif event.new_state == DOTA_GAMERULES_STATE_HERO_SELECTION then
	elseif event.new_state == DOTA_GAMERULES_STATE_SCENARIO_SETUP then -- 2
		if game_mode.isValidRankedGame then
			local playerCount = PlayerResource:NumPlayers()
			print("Number of players is " .. playerCount)
			if playerCount ~= RANK_PLAYER_COUNT_REQ then
				GameRules:SendCustomMessage("天梯比赛需要10名玩家，本次对局不记录天梯分数!", -1, -1)
				game_mode.isValidRankedGame = false
			else
				--for i=1,#all_heroes do
				--	GameRules:AddHeroToBlacklist(all_heroes[i])
				--end
				game_mode.game_mode = "AP"
				GameRules:GetGameModeEntity():SetThink(function()
					-- randomly assign player team start from either side
					local players = getAllPlayerIds()
					for i=1,#players do
						PlayerResource:SetCustomTeamAssignment(players[i][1], DOTA_TEAM_NOTEAM)
					end
				end, "unassign default player teams", 3)
				GameRules:GetGameModeEntity():SetThink(function()
					--game_mode.radiant_team_mmr_total = 0
					--game_mode.dire_team_mmr_total = 0
					--for i=0,PlayerResource:GetPlayerCount() - 1 do
					--	local record = game_mode.player2account_records[tostring(i)]
					--	if record ~= nil and record.mmr ~= nil then
					--		if PlayerResource:GetTeam(i) == DOTA_TEAM_GOODGUYS then
					--			game_mode.radiant_team_mmr_total = game_mode.radiant_team_mmr_total + record.mmr
					--		elseif PlayerResource:GetTeam(i) == DOTA_TEAM_BADGUYS then
					--			game_mode.dire_team_mmr_total = game_mode.dire_team_mmr_total + record.mmr
					--		end
					--		game_mode.playerId2LadderScore[i] = record.mmr
					--	end
					--end
					--GameRules:SendCustomMessage("MMR: r" .. game_mode.radiant_team_mmr_total .. ", d" .. game_mode.dire_team_mmr_total, 0, 0)

					---- randomly assign player team start from either side
					----getAllPlayerScores(game_mode)
					--sendPlayerStatsToUI(game_mode.player2account_records)
					sendMatchStartEventToServer(game_mode)
				end, "Fetching player scores", 5)
			end
		end
		print("Reading game record")
		for i=0,PlayerResource:GetPlayerCount() - 1 do
			local record = GameRules:GetPlayerCustomGameAccountRecord(i)
			if record ~= nil then
				game_mode.player2account_records[tostring(i)] = record
			end
		end
	elseif event.new_state == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		local mode_id = 1
		if game_mode.game_mode == 'AP' then
			mode_id = 1
		elseif game_mode.game_mode == 'JS' or game_mode.game_mode == 'RD' then
			mode_id = 3
		elseif game_mode.game_mode == 'CM' then
			mode_id = 2
		elseif game_mode.game_mode == 'CD' then
			mode_id = 16
		elseif game_mode.game_mode == 'DM' then
			mode_id = 20
		end
		GameRules:GetAnnouncer(1):SpeakConcept({
			announce_gamemode = mode_id
		})

		if GetMapName() == "tour" then
			GameRules:GetGameModeEntity():SetThink(function()
				for i=1,PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_CUSTOM_1) do
					local player = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_CUSTOM_1, i)
					PlayerResource:GetPlayer(player):SetSelectedHero(ARCANA_HEROES[i])
				end
			end, "unassign spectator hero", 3)
		end
		if game_mode.game_mode == 'DM' then
			deathMatchGameRulesUpdate()
			-- randoms all player's hero selection
			local players = getAllPlayerIds()
			for i=1,#players do
				PlayerResource:GetPlayer(players[i][1]):MakeRandomHeroSelection()
				removeHeroFromDMPool(PlayerResource:GetSelectedHeroName(players[i][1]))
			end
		elseif game_mode.game_mode == 'BM' then
			GameRules:AddBotPlayerWithEntityScript("npc_dota_hero_nevermore", "Bot", DOTA_TEAM_BADGUYS, "ai/bot_nevermore.lua", true)
		end
	elseif event.new_state == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		if GetMapName() == "tour" then
			CreateUnitByNameAsync("npc_dummy_unit_spectator",
				Vector(-4000, 2026, 512), false, nil, nil, 
				DOTA_TEAM_CUSTOM_1, function(unit)
				unit:AddNewModifier(unit, nil, "modifier_spectator_dummy_unit_lua", {})
			end)
		end
		GameRules:GetGameModeEntity():SetThink(function()
			for i=0,PlayerResource:GetPlayerCount() - 1 do
				local record = game_mode.player2account_records[tostring(i)]
				if record ~= nil then
					local games = record.game
					local kda = 0
					local gpm = 0
					local tdmg = 0
					if games ~= nil and #games > 0 then
						for j=1,#games do
							local game = games[j]
							if game.play ~= nil and #game.play > 0 then
								for k = 1, #games.play do
									local play = games.play[k]
									if play.acnt == PlayerResource:GetSteamAccountID(i) then
										kda = kda + (play.kill + play.asst) / play.deth / #game.play
										gpm = gpm + play.netw / game.time / #game.play
										tdmg = tdmp + player.bdmg / #game.play
									end
								end
							end
						end
					end
 	   				CustomGameEventManager:Send_ServerToAllClients("career_player_stats", {
						pid 	= i,
						mmr 	= record.mmr,
						trg 	= record.trg,
						trwg 	= record.trwg,
						kda		= math.floor(kda * 10) / 10,
						gpm		= math.floor(gpm),
						tdmg	= math.floor(tdmg)
					})
				end
			end
			CustomGameEventManager:Send_ServerToAllClients("player_ladder_scores", game_mode.playerId2LadderScore)
		end, "send ladder score to clients", 3)
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
				if entity ~= nil then
					local buyback_cost = 100 + entity:GetLevel() * entity:GetLevel() * 1.5 + GameRules:GetDOTATime(false, false) * 0.25
					PlayerResource:SetCustomBuybackCost(playerid, buyback_cost)
				end
			end
		end
	end

	if game_mode.nextRoshanTime ~= nil and time > game_mode.nextRoshanTime then
		print("Spawn next rosh")
		CreateUnitByName("npc_dota_roshan_datadriven", Vector(4320, -1824, 160), true, nil, nil, DOTA_TEAM_NEUTRALS)
		game_mode.nextRoshanTime = nil
	end

	-- respawn base trees in rank map
	if      game_mode.game_winner == nil
		and ( 
			  (game_mode.isValidRankedGame and game_mode.firstBlood ~= nil)
			or game_mode.valid_normal_game
		) then
		local radiant_connected = getConnectedPlayerCount(DOTA_TEAM_GOODGUYS)
		local dire_connected = getConnectedPlayerCount(DOTA_TEAM_BADGUYS)
		if radiant_connected - dire_connected >= 4 then
			GameRules:SendCustomMessage("近卫军团胜利", -1, -1)
			game_mode.game_winner = DOTA_TEAM_GOODGUYS
			sendEndGameStats(game_mode, player2BuildingDamage, game_mode.player2assist, game_mode.game_winner)
		elseif dire_connected - radiant_connected >= 4 then
			GameRules:SendCustomMessage("天灾军团胜利", -1, -1)
			game_mode.game_winner = DOTA_TEAM_BADGUYS
			sendEndGameStats(game_mode, player2BuildingDamage, game_mode.player2assist, game_mode.game_winner)
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

function sendMatchStartEventToServer(game_mode)
	local player_count = PlayerResource:GetPlayerCount()
	local sids = {}
	local host_pid = -1
	for pid=0,player_count-1 do
		local sid = PlayerResource:GetSteamID(pid)
		table.insert(sids, sid:__tostring())
		if GameRules:PlayerHasCustomGameHostPrivileges(PlayerResource:GetPlayer(pid)) then
			host_pid = pid
		end
	end
	print("Host player id is " .. host_pid)
	--table.sort(sids, function(a, b) return a < b end);
	--local pskey = ''
	--for i=1,#sids do
	--	local sid = tostring(sids[i])
	--	sid = string.sub(sid, -4)
	--	pskey = pskey .. sid
	--end
	--print("pskey " .. pskey)
	--game_mode.pskey_orig = pskey
	local url = LADDER_HOST .. "register_game_ip?host_pid=" .. sids[host_pid + 1]
	print("Sending request to " .. url)
	CreateHTTPRequest("GET", url):Send(
		function(response)
			local status_code = response.StatusCode
			print("register_game_ip response " .. status_code)
			if status_code == 200 then
				local body = response.Body
				local teams = json.decode(body)
				print("Receiving team assignment")
				DeepPrintTable(teams)
				
				local has_invalid_player = false
				for i=0,PlayerResource:GetPlayerCount() - 1 do
					local pid = PlayerResource:GetSteamID(i):__tostring()
					print("Player " .. i .. " has pid " .. pid)
					local team = nil
					for j=1,#teams[1] do
						if teams[1][j] == pid then
							print("Assign player " .. i .. " to rad.")
							team = DOTA_TEAM_GOODGUYS
						end
					end
					for j=1,#teams[2] do
						if teams[2][j] == pid then
							print("Assign player " .. i .. " to dire.")
							team = DOTA_TEAM_BADGUYS
						end
					end
					if team then
						PlayerResource:SetCustomTeamAssignment(i, DOTA_TEAM_GOODGUYS)
					else
						print("Warning no team assignment")
						has_invalid_player = true
						break
					end
				end
				if has_invalid_player then
					GameRules:SendCustomMessage("发现乱入玩家，不会记录分数。", -1, -1);
					game_mode.isValidRankedGame = false
					assignPlayersWithNoTeam()
				else
					GameRules:SendCustomMessage("连接服务器成功。", -1, -1);
					game_mode.rankGameId = teams[4]
					sendPlayerStatsToUI(teams[3])
				end
			else 
				GameRules:SendCustomMessage("连接服务器失败，不会记录分数。", -1, -1);
				game_mode.isValidRankedGame = false
				shuffleTeam()
			end
		end)
end

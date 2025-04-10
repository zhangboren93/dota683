require("ladder_game_mode")
json = require("json")
local function getTeamPlayerIds(team) 
	local ret = {}
	for i=1,PlayerResource:GetPlayerCountForTeam(team) do
		table.insert(ret, PlayerResource:GetNthPlayerIDOnTeam(team, i))
	end
	return ret
end

local function getHeroDamage(player_id)
	local team = PlayerResource:GetTeam(player_id)
	local opposing_team = DOTA_TEAM_BADGUYS
	if team == DOTA_TEAM_BADGUYS then
		opposing_team = DOTA_TEAM_GOODGUYS
	end
	local opposingPlayers = getTeamPlayerIds(opposing_team)
	local heroDamage = 0
	for _,victimPlayerId in ipairs(opposingPlayers) do
		heroDamage = heroDamage + PlayerResource:GetDamageDoneToHero(player_id, victimPlayerId)
	end
	return heroDamage
end

function sendEndGameStats(game_mode, player2BuildingDamage, player2assist, game_winner)
	sendEndGameStatsToPanorama(game_mode, player2BuildingDamage, player2assist)
	sendEndGameStatsToServer(game_mode, player2BuildingDamage, player2assist, game_winner)
end

function calculateScoreDiff(game_mode)
	local winning_team_mmr_total, losing_team_mmr_total
	if game_mode.game_winner == DOTA_TEAM_GOODGUYS then
		winning_team_mmr_total = game_mode.radiant_team_mmr_total
		losing_team_mmr_total = game_mode.dire_team_mmr_total
	else
		winning_team_mmr_total = game_mode.dire_team_mmr_total
		losing_team_mmr_total = game_mode.radiant_team_mmr_total
	end
	if winning_team_mmr_total == nil then winning_team_mmr_total = 0 end
	if dire_team_mmr_total == nil then dire_team_mmr_total = 0 end
	local diff = math.floor(25 - (winning_team_mmr_total - losing_team_mmr_total) / 250)
	if diff < 0 then diff = 0 end
	if diff > 50 then diff = 50 end
	return diff
end

function sendEndGameStatsToPanorama(game_mode, player2BuildingDamage, player2assist)
	print("sendEndGameStats")
	local playerStatMap = {}

	local radiantPlayers = getTeamPlayerIds(DOTA_TEAM_GOODGUYS)
	local direPlayers = getTeamPlayerIds(DOTA_TEAM_BADGUYS)
	local diff = 0
	if game_mode.isValidRankedGame and game_mode.firstBlood then
		diff = calculateScoreDiff(game_mode)
	end
	for i=1,#radiantPlayers do
		local slot = i - 1
		local mainPlayerId = radiantPlayers[i]
		local heroDamage = 0
		for _,victimPlayerId in ipairs(direPlayers) do
			heroDamage = heroDamage + PlayerResource:GetDamageDoneToHero(
				mainPlayerId, victimPlayerId)
		end
		local assist = player2assist[mainPlayerId]
		if assist == nil then
			assist = 0
		end
		local score = 0
		if diff > 0 then
			local record = game_mode.player2account_records[mainPlayerId]
			if record then score = record.mmr end
			print("Game_mode winner")
			print(game_mode.game_winner)
			if game_mode.game_winner == DOTA_TEAM_GOODGUYS then
				score = score + diff
				score = score .. "(+" .. diff ..")"
			else 
				score = score - diff
				if score < 0 then score = 0 end
				score = score .. "(-" .. diff ..")"
			end
		end
		playerStatMap[mainPlayerId] = {
			hd = heroDamage,
			nw = PlayerResource:GetNetWorth(mainPlayerId),
			bd = player2BuildingDamage[mainPlayerId],
			tk = PlayerResource:GetTowerKills(mainPlayerId),
			as = assist,
			sc = score
		}
	end
	for i=1,#direPlayers do
		local slot = i + 4
		local mainPlayerId = direPlayers[i]
		local heroDamage = 0
		for _,victimPlayerId in ipairs(radiantPlayers) do
			heroDamage = heroDamage + PlayerResource:GetDamageDoneToHero(
				mainPlayerId, victimPlayerId)
		end
		local assist = player2assist[mainPlayerId]
		if assist == nil then
			assist = 0
		end
		local score = 0
		if diff > 0 then
			local record = game_mode.player2account_records[mainPlayerId]
			if record then score = record.mmr end
			if game_mode.game_winner == DOTA_TEAM_BADGUYS then
				score = score + diff
				score = score .. "(+" .. diff ..")"
			else 
				score = score - diff
				if score < 0 then score = 0 end
				score = score .. "(-" .. diff ..")"
			end
		end
		playerStatMap[mainPlayerId] = {
			hd = heroDamage,
			nw = PlayerResource:GetNetWorth(mainPlayerId),
			bd = player2BuildingDamage[mainPlayerId],
			tk = PlayerResource:GetTowerKills(mainPlayerId),
			as = assist,
			sc = score
		}
	end
	CustomGameEventManager:Send_ServerToAllClients("end_game_summary_stats", { psm = playerStatMap, dif = diff })	
end

GAME_STATS_SERVER = "localhost"
function sendEndGameStatsToServer(game_mode, player2BuildingDamage, player2assist, game_winner)
	local game = {}
	game.gwin = game_winner
	game.mtch = GameRules:Script_GetMatchID():__tostring()
	game.time = GameRules:GetDOTATime(false, false)
	game.radk = PlayerResource:GetTeamKills(DOTA_TEAM_GOODGUYS)
	game.dirk = PlayerResource:GetTeamKills(DOTA_TEAM_BADGUYS)
	local players = {}
	for i=1,PlayerResource:GetPlayerCount() do
		local player = {}
		local player_id = i-1
		player.acnt = PlayerResource:GetSteamAccountID(player_id)
		player.stid = PlayerResource:GetSteamID(player_id):__tostring()
		player.team = PlayerResource:GetTeam(player_id)
		player.kill = PlayerResource:GetKills(player_id)
		player.asst = player2assist[player_id]
		player.deth = PlayerResource:GetDeaths(player_id)
		player.netw = PlayerResource:GetNetWorth(player_id)
		player.ntxp = PlayerResource:GetTotalEarnedXP(player_id)
		player.hdmg = getHeroDamage(player_id)
		player.bdmg = player2BuildingDamage[player_id]
		player.lsth = PlayerResource:GetLastHits(player_id)
		player.deny = PlayerResource:GetDenies(player_id)
		player.levl = PlayerResource:GetLevel(player_id)
		player.hero = PlayerResource:GetSelectedHeroID(player_id)
		local hero = PlayerResource:GetPlayer(player_id):GetAssignedHero()
		local items = {}
		for j=DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_6 do
			local item = hero:GetItemInSlot(j)
			if item ~= nil then
				table.insert(items, item:GetName())
			end
		end
		player.item = items
		table.insert(players, player)
	end
	game.play = players
	if game_mode.rankGameId then
		print("Sending end game stats to server...")
		local request = CreateHTTPRequest("POST", LADDER_HOST.."submit_game_result")
		local requestPayload = {
			pskey = game_mode.rankGameId,
			result = game
		}
		request:SetHTTPRequestRawPostBody("application/json", json.encode(requestPayload))
		request:Send(function(response)
			print("submit game result status" .. response.StatusCode)
		end)
	end
	DeepPrintTable(game)
	return game
end

function sendEndGameStats()
	print("sendEndGameStats")
	local playerSlot2HeroDamage = {}
	local radiantPlayers = getTeamPlayerIds(DOTA_TEAM_GOODGUYS)
	local direPlayers = getTeamPlayerIds(DOTA_TEAM_BADGUYS)
	for i=1,#radiantPlayers do
		local slot = i - 1
		local mainPlayerId = radiantPlayers[i]
		local heroDamage = 0
		for _,victimPlayerId in ipairs(direPlayers) do
			heroDamage = heroDamage + PlayerResource:GetDamageDoneToHero(
				mainPlayerId, victimPlayerId)
		end
		playerSlot2HeroDamage[slot] = heroDamage
	end
	for i=1,#direPlayers do
		local slot = i + 4
		local mainPlayerId = direPlayers[i]
		local heroDamage = 0
		for _,victimPlayerId in ipairs(radiantPlayers) do
			heroDamage = heroDamage + PlayerResource:GetDamageDoneToHero(
				mainPlayerId, victimPlayerId)
		end
		playerSlot2HeroDamage[slot] = heroDamage
	end
	DeepPrintTable(playerSlot2HeroDamage)
	CustomGameEventManager:Send_ServerToAllClients("end_game_summary_stats", 
		{ heroDamage = playerSlot2HeroDamage })	
end

function getTeamPlayerIds(team) 
	local ret = {}
	for i=1,PlayerResource:GetPlayerCountForTeam(team) do
		table.insert(ret, PlayerResource:GetNthPlayerIDOnTeam(team, i))
	end
	return ret
end

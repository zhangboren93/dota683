function handleKillBonus(self, attacker, entity)
	local entity_player_id = entity:GetPlayerOwnerID()
	if attacker:GetTeam() == entity:GetTeam() then
		print("Denied, no gold/XP bonus")
		return
	end
	if attacker:IsCreep() and attacker:GetTeam() == DOTA_TEAM_NEUTRALS then
		print("killed by neutral, no gold/XP bonus")
		return
	end
	local assist_players = {}
	if entity.time_attacked ~= nil then
		local current_time = GameRules:GetDOTATime(true, false)
		for i,v in pairs(entity.time_attacked) do
			if current_time - v < 20 then
				table.insert(assist_players, i)
			end
		end
	end

	local goldRecord = {0, 0, 0}
	local teamname = "近卫"
	if attacker:GetTeam() == DOTA_TEAM_BADGUYS then
		teamname = "天灾"
	end
	local entityName = string.sub(entity:GetName(), 15)
	if attacker:IsOwnedByAnyPlayer() then
		local attacker_player_id = attacker:GetPlayerOwnerID()
		if self.firstBlood == nil then
			print("give gold first blood kill")
			PlayerResource:ModifyGold(attacker_player_id, 135, true, DOTA_ModifyGold_HeroKill)
			self.firstBlood = true
			goldRecord[1] = 135
		end
		
		--PlayerResource:IncrementStreak(attacker_player_id, 1)
		local killGold = 110 + playerStreakGold(attacker_player_id) + entity:GetLevel() * 9.9
		print("kill gold " .. killGold)
		PlayerResource:ModifyGold(attacker_player_id, killGold, true, DOTA_ModifyGold_HeroKill)
		-- shutdown gold
		local shutdownGold = playerShutdownGold(entity_player_id)
		print("shutdown gold " .. shutdownGold)
		PlayerResource:ModifyGold(attacker_player_id, shutdownGold, true, DOTA_ModifyGold_HeroKill)
		goldRecord[2] = killGold + shutdownGold 
	elseif attacker:IsBuilding() or attacker:IsCreep() then
		-- killed by building or creep
		if #assist_players == 0 then
			-- split to all
			local killGold = 110 + entity:GetLevel() * 9.9
			local shutdownGold = playerShutdownGold(entity_player_id)
			local playerCount = PlayerResource:GetPlayerCountForTeam(attacker:GetTeam())
			local goldPerPlayer = (killGold + shutdownGold) / playerCount
			print("feeds to building " .. goldPerPlayer)
			for i=1,playerCount do
				PlayerResource:ModifyGold(PlayerResource:GetNthPlayerIDOnTeam(attacker:GetTeam(), i), goldPerPlayer, true, DOTA_ModifyGold_HeroKill)
			end
			GameRules:SendCustomMessage(entityName .. "死了，".. teamname .. "玩家各获得" .. goldPerPlayer .. "金" , -1, -1)
		elseif #assist_players == 1 then
			-- credit kill
			print("credit to only 1 assist")
			local attacker_player_id = assist_players[1]
			if self.firstBlood == nil then
				print("give gold first blood kill")
				PlayerResource:ModifyGold(attacker_player_id, 135, true, DOTA_ModifyGold_HeroKill)
				self.firstBlood = true
				goldRecord[1] = 135
			end
		
			--PlayerResource:IncrementStreak(attacker_player_id, 1)
			local killGold = 110 + playerStreakGold(attacker_player_id) + entity:GetLevel() * 9.9
			print("kill gold " .. killGold)
			PlayerResource:ModifyGold(attacker_player_id, killGold, true, DOTA_ModifyGold_HeroKill)
			-- shutdown gold
			local shutdownGold = playerShutdownGold(entity_player_id)
			print("shutdown gold " .. shutdownGold)
			PlayerResource:ModifyGold(attacker_player_id, shutdownGold, true, DOTA_ModifyGold_HeroKill)
			goldRecord[2] = killGold + shutdownGold 
		else
			-- split kill amount assisters
			local killGold = 110 + entity:GetLevel() * 9.9
			local shutdownGold = playerShutdownGold(entity_player_id)
			local goldPerPlayer = (killGold + shutdownGold) / #assist_players
			print("Spliting kill gold for assisters " .. #assist_players .. " " .. goldPerPlayer)
			for i=1,#assist_players do
				PlayerResource:ModifyGold(assist_players[i], goldPerPlayer, true, DOTA_ModifyGold_HeroKill)
			end
			goldRecord[3] = math.floor(goldPerPlayer) 
		end
	end

	--TODO summoned units kill
	--if not attacker:IsRealHero() and attacker:GetOwner() ~= nil then
	--	print("Setting attacker to the owner of the summoned units")
	--	print(attacker:GetName())
	--	print(attacker:GetOwner():GetName())
	--	attacker = attacker:GetOwner()
	--end

	DeepPrintTable(assist_players)
	local assisterCount = #assist_players
	if assisterCount > 0 then
		local baseGold = assistGoldBase(assisterCount)
		local goldPerLevel = assistGoldPerLevel(assisterCount)
		local level = entity:GetLevel()
		local cbFactor = GetAssistGoldComebackFactor(entity:GetTeam())
		local cbfFactor = assistGoldCBFactor(assisterCount)
		local networth = PlayerResource:GetNetWorth(entity_player_id)
	
		local assist_gold = baseGold + goldPerLevel * level + cbFactor *cbfFactor * networth
		print("Assist gold = " .. baseGold .. "+" .. goldPerLevel .. "*" .. level .. "+" .. cbfFactor .. "*" .. cbFactor .. "*" .. networth .. "=" .. assist_gold)
		for i=1,#assist_players do
			PlayerResource:ModifyGold(assist_players[i], assist_gold, true, DOTA_ModifyGold_HeroKill)
		end
		goldRecord[3] = goldRecord[3] + math.floor(assist_gold) 
	end
	
	if goldRecord[1] + goldRecord[2] > 0 then
		local attackerName = string.sub(attacker:GetPlayerOwner():GetAssignedHero():GetName(), 15)
		GameRules:SendCustomMessage(attackerName .. "杀了" .. entityName .. "获得" .. (goldRecord[1] + goldRecord[2]) .. "金+助攻" .. goldRecord[3] .. "金" .. (assisterCount - 1) .. "人助攻" , -1, -1)
	elseif assisterCount > 0 then
		GameRules:SendCustomMessage(entityName .. "死了，" .. teamname 	.. assisterCount .. "人获得" .. goldRecord[3] .. "金" , -1, -1)
	end

	-- give experience
	local units = FindUnitsInRadius( entity:GetTeamNumber(), entity:GetAbsOrigin(), nil, 1300,
		DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
	local exp_entity_ids = {}
	for i=1,#units do
		exp_entity_ids[units[i]:GetEntityIndex()] = true
	end
	-- add attacker the XP if out of range 
	if attacker:IsAlive() and attacker:IsHero() then
		exp_entity_ids[attacker:GetEntityIndex()] = true
	end
	if attacker:IsOwnedByAnyPlayer() and attacker:GetPlayerOwner():GetAssignedHero():IsAlive() then
		exp_entity_ids[attacker:GetPlayerOwner():GetAssignedHero():GetEntityIndex()] = true
	end

	local tablen = 0
	for i,v in pairs(exp_entity_ids) do
		tablen = tablen + 1
	end
	DeepPrintTable(exp_entity_ids)
	print(tablen)
	local assist_exp = playerXPBase(tablen) * entity:GetLevel() +
		cbXPRate(tablen) * GetAssistXPComebackFactor(entity:GetTeam()) * entity:GetCurrentXP()
	print("Granting assist experience " .. assist_exp .. " to " .. tablen .. " players.")
	for i,v in pairs(exp_entity_ids) do
		print(EntIndexToHScript(i):GetName())
		EntIndexToHScript(i):AddExperience(assist_exp, DOTA_ModifyXP_HeroKill, false, false)
	end
end

function playerStreakGold(player_id)
	local streak = PlayerResource:GetStreak(player_id)
	print("killer Streak count " .. streak);
	if streak <=2 then
		return 0
	elseif streak > 10 then
		streak = 10
	end
	return 60 * (streak - 2)
end

function playerShutdownGold(player_id)
	local streak = PlayerResource:GetStreak(player_id)
	print("victim Streak count " .. streak);
	if streak <=2 then
		return 0
	elseif streak > 10 then
		streak = 10
	end
	return 35 * streak - 5
end

function assistGoldBase(count)
	if count < 1 then
		return 0
	elseif count < 5 then
		return 50 - 10 *count
	else
		return 10
	end
end

function assistGoldPerLevel(count)
	if count < 1 then
		return 0
	elseif count < 5 then
		return 8 - count
	else
		return 4
	end
end

function assistGoldCBFactor(count)
	if count < 1 then
		return 0
	elseif count < 2 then
		return 0.06
	elseif count < 6 then
		return (8 - count) * 0.01
	else
		return 0.03
	end
end

function GetAssistGoldComebackFactor(victim_team)
	local victim_team_total_gold = GetTeamTotalGold(victim_team)
	local attacker_team = DOTA_TEAM_BADGUYS
	if victim_team == DOTA_TEAM_BADGUYS then
		attacker_team = DOTA_TEAM_GOODGUYS
	end
	local attacker_team_total_gold = GetTeamTotalGold(attacker_team)
	local factor = victim_team_total_gold / attacker_team_total_gold - 1 
	print("Assist gold factor " .. factor)
	if factor < 0 then
		return 0
	elseif factor >= 1 then
		return 1
	else
		return factor
	end
end

function GetAssistXPComebackFactor(victim_team)
	local victim_team_total_gold = GetTeamTotalXP(victim_team)
	local attacker_team = DOTA_TEAM_BADGUYS
	if victim_team == DOTA_TEAM_BADGUYS then
		attacker_team = DOTA_TEAM_GOODGUYS
	end
	local attacker_team_total_gold = GetTeamTotalXP(attacker_team)
	--print(attacker_team_total_gold)
	--print(victim_team_total_gold)
	if attacker_team_total_gold + victim_team_total_gold == 0 then
		return 0
	end
	local factor = (victim_team_total_gold - attacker_team_total_gold) / (attacker_team_total_gold + victim_team_total_gold) 
	print("Assist exp factor " .. factor)
	if factor < 0 then
		return 0
	else
		return factor
	end
end

function playerXPBase(count) 
	if count <= 1 then
		return 20
	elseif count == 2 then
		return 15
	elseif count == 3 then
		return 10
	elseif count == 4 then
		return 7
	else
		return 5
	end
end

function cbXPRate(count)
	--0.138/0.138/0.12/0.09/0.072
	if count <= 2 then return 0.138
	elseif count == 3 then return 0.12
	elseif count == 4 then return 0.09
	else return 0.072 end
end

function GetTeamTotalGold(victim_team)
	local victim_team_total_gold = 0
	for i=1,PlayerResource:GetPlayerCountForTeam(victim_team) do
		local playerId = PlayerResource:GetNthPlayerIDOnTeam(victim_team, i)
		victim_team_total_gold = victim_team_total_gold + PlayerResource:GetNetWorth(playerId)
	end
	return victim_team_total_gold
end

function GetTeamTotalXP(victim_team)
	local victim_team_total_gold = 0
	for i=1,PlayerResource:GetPlayerCountForTeam(victim_team) do
		local playerId = PlayerResource:GetNthPlayerIDOnTeam(victim_team, i)
		victim_team_total_gold = victim_team_total_gold + PlayerResource:GetPlayer(playerId):GetAssignedHero():GetCurrentXP()
		--print(victim_team .. " " .. playerId .. " " .. victim_team_total_gold)
	end
	return victim_team_total_gold
end
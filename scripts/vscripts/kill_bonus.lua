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
	if attacker:IsOwnedByAnyPlayer() then
		local attacker_player_id = attacker:GetPlayerOwnerID()
		if self.firstBlood == nil then
			print("give gold first blood kill")
			PlayerResource:ModifyGold(attacker_player_id, 135, true, DOTA_ModifyGold_HeroKill)
			self.firstBlood = true
		end
		
		--PlayerResource:IncrementStreak(attacker_player_id, 1)
		local killGold = 110 + playerStreakGold(attacker_player_id) + entity:GetLevel() * 9.9
		print("kill gold " .. killGold)
		PlayerResource:ModifyGold(attacker_player_id, killGold, true, DOTA_ModifyGold_HeroKill)
		-- shutdown gold
		local shutdownGold = playerShutdownGold(entity_player_id)
		print("shutdown gold " .. shutdownGold)
		PlayerResource:ModifyGold(attacker_player_id, shutdownGold, true, DOTA_ModifyGold_HeroKill)
	end

	--TODO summoned units kill
	--if not attacker:IsRealHero() and attacker:GetOwner() ~= nil then
	--	print("Setting attacker to the owner of the summoned units")
	--	print(attacker:GetName())
	--	print(attacker:GetOwner():GetName())
	--	attacker = attacker:GetOwner()
	--end

	-- TODO give assist gold
	local assist_players = {}
	if entity.time_attacked ~= nil then
		local current_time = GameRules:GetDOTATime(true, false)
		for i,v in pairs(entity.time_attacked) do
			if current_time - v < 20 then
				table.insert(assist_players, i)
			end
		end
	end
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
	end

	---- give experience
	--local units = FindUnitsInRadius( entity:GetTeamNumber(), entity:GetAbsOrigin(), nil, 1500,
	--	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
	
	---- add attacker the XP if out of range 
	--if attacker:IsAlive() and attacker.IsHero ~= nil and attacker:IsHero() then
	--	local unitsContainsAttacker = false
	--	for i=1,#units do
	--		if units[i]:GetEntityIndex() == attacker:GetEntityIndex() then
	--			unitsContainsAttacker = true
	--			break
	--		end
	--	end
	--	if not unitsContainsAttacker then
	--		print("Adding attacker to xp bounty remotely")
	--		table.insert(units, attacker)
	--	end
	--end

	--local assist_exp = 7 * entity:GetLevel() + GetAssistXPComebackFactor(entity:GetTeam()) * PlayerResource:GetTotalEarnedXP(entity:GetPlayerID()) * 0.15
	--print("Granting assist experience " .. assist_exp .. " to " .. #units .. " units.")
	--for i=1,#units do
	--	if units[i].AddExperience ~= nil then
	--		print(units[i]:GetName())
	--		units[i]:AddExperience(assist_exp, DOTA_ModifyXP_HeroKill, false, false)
	--	end
	--end
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
	local factor = (victim_team_total_gold - attacker_team_total_gold) / (attacker_team_total_gold + attacker_team_total_gold) 
	print("Assist exp factor " .. factor)
	if factor < 0 then
		return 0
	else
		return factor
	end
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
		victim_team_total_gold = victim_team_total_gold + PlayerResource:GetTotalEarnedXP(playerId)
	end
	return victim_team_total_gold
end
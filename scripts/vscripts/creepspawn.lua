CREEP_ALERT_RADIUS = 540
CREEP_ALERT_RADIUS_RANGED = 632
CREEP_ALERT_RADIUS_SEIGE = 832
CREEP_ATTACK_RANGE = 140
CREEP_ATTACK_RANGE_RANGED = 532
CREEP_ATTACK_RANGE_SEIGE = 722
local radiantSpawners = {
	"lane_bot_goodguys_melee_spawner", 
	"lane_mid_goodguys_melee_spawner",
	"lane_top_goodguys_melee_spawner"}
local direSpawners = {
	"lane_bot_badguys_melee_spawner",
	"lane_mid_badguys_melee_spawner",
	"lane_top_badguys_melee_spawner"}
local radiantPathNames = { "gb", "gm", "gt"}
local direPathNames = { "bb", "bm", "bt"}
local direracks = {
	"bad_rax_melee_bot", 
	"bad_rax_melee_mid",
	"bad_rax_melee_top",
	"bad_rax_range_bot",
	"bad_rax_range_mid",
	"bad_rax_range_top"}
local radiantracks = {
	"good_rax_melee_bot",
	"good_rax_melee_mid",
	"good_rax_melee_top",
	"good_rax_range_bot",
	"good_rax_range_mid",
	"good_rax_range_top"}
function spawnCreepsLua()
	spawnCreepsFromSide(radiantSpawners, 
		radiantPathNames,
		{
			creepUpgradedName("npc_dota_creep_goodguys_melee", "bad_rax_melee_bot", direracks), 
			creepUpgradedName("npc_dota_creep_goodguys_melee", "bad_rax_melee_mid", direracks), 
			creepUpgradedName("npc_dota_creep_goodguys_melee", "bad_rax_melee_top", direracks)},
		{
			creepUpgradedName("npc_dota_creep_goodguys_ranged", "bad_rax_range_bot", direracks), 
			creepUpgradedName("npc_dota_creep_goodguys_ranged", "bad_rax_range_mid", direracks), 
			creepUpgradedName("npc_dota_creep_goodguys_ranged", "bad_rax_range_top", direracks)},
		{
			creepUpgradedName("npc_dota_goodguys_siege", "bad_rax_range_bot", direracks), 
			creepUpgradedName("npc_dota_goodguys_siege", "bad_rax_range_mid", direracks), 
			creepUpgradedName("npc_dota_goodguys_siege", "bad_rax_range_top", direracks)},
		DOTA_TEAM_GOODGUYS)
	spawnCreepsFromSide(direSpawners,
		direPathNames,
		{
			creepUpgradedName("npc_dota_creep_badguys_melee", "good_rax_melee_bot", radiantracks), 
			creepUpgradedName("npc_dota_creep_badguys_melee", "good_rax_melee_mid", radiantracks), 
			creepUpgradedName("npc_dota_creep_badguys_melee", "good_rax_melee_top", radiantracks)},
		{
			creepUpgradedName("npc_dota_creep_badguys_ranged", "good_rax_range_bot", radiantracks), 
			creepUpgradedName("npc_dota_creep_badguys_ranged", "good_rax_range_mid", radiantracks), 
			creepUpgradedName("npc_dota_creep_badguys_ranged", "good_rax_range_top", radiantracks)},
		{
			creepUpgradedName("npc_dota_badguys_siege", "good_rax_range_bot", radiantracks), 
			creepUpgradedName("npc_dota_badguys_siege", "good_rax_range_mid", radiantracks), 
			creepUpgradedName("npc_dota_badguys_siege", "good_rax_range_top", radiantracks)},
		DOTA_TEAM_BADGUYS)
end

function creepUpgradedName(prefix, raxName, megaraks)
	if shouldSpawnMegas(megaraks) then
		return prefix .. "_upgraded_mega"
	end
	local rax = Entities:FindByName(nil, raxName)
	if rax == nil or not rax:IsAlive() then
		return prefix .. "_upgraded"
	end
	return prefix
end

function shouldSpawnMegas(racks)
	for i=1,#racks do
		local rax = Entities:FindByName(nil, racks[i])
		if rax ~= nil and rax:IsAlive() then
			return false
		end
	end
	return true
end

function calculateNumMeleeCreep()
	return 3 + math.floor(GameRules:GetDOTATime(false, false) / (15 * 60))
end

function calculateNumRangedCreep()
	return 1 + math.floor(GameRules:GetDOTATime(false, false) / (45 * 60))
end

function spawnCreepsFromSide(spawners, pathNames, melee, ranged, seige, team)
	local numMeleeCreep = calculateNumMeleeCreep()
	local numRangedCreep = calculateNumRangedCreep()
	local shouldSpawnSeige = GameRules:GetDOTATime(false, false) > 60 and GameRules:GetDOTATime(false, false) % 300 < 10
	for i=1,#spawners do
		local spawner = Entities:FindByName(nil, spawners[i])
		local spawnVecter = spawner:GetAbsOrigin()
		local creepLevel = math.floor(GameRules:GetDOTATime(false, false) / 450)
		for j=1,numMeleeCreep do
			CreateUnitByNameAsync(melee[i], spawnVecter, true, nil, nil, team, function(spawnedUnit)
				spawnedUnit:SetIdleAcquire(false)
				spawnedUnit:AddNewModifier(nil, nil, "modifier_creep_ai", { 
					alertRadius = CREEP_ALERT_RADIUS, 
					pathName = pathNames[i], 
					seige = false,
					attackrange = CREEP_ATTACK_RANGE })
				if spawners[i] == "lane_bot_goodguys_melee_spawner" or spawners[i] == "lane_top_badguys_melee_spawner" then
					if not spawnedUnit:HasModifier("modifier_creep_safe_lane_move_speed_bonus") then
						spawnedUnit:AddNewModifier(nil, nil, "modifier_creep_safe_lane_move_speed_bonus", { }):SetDuration(25, true)
					end
				end
				if string.find(melee[i], "upgraded") == nil then
					spawnedUnit:AddNewModifier(nil, nil, "modifier_creep_health_bonus", { health = 10 * creepLevel, damage = 1 * creepLevel  })
					spawnedUnit:SetMaximumGoldBounty(spawnedUnit:GetMaximumGoldBounty() + creepLevel)
					spawnedUnit:SetMinimumGoldBounty(spawnedUnit:GetMinimumGoldBounty() + creepLevel)
				elseif string.find(melee[i], "mega") == nill then											  
					spawnedUnit:AddNewModifier(nil, nil, "modifier_creep_health_bonus", { health = 17 * creepLevel, damage = 2 * creepLevel  })
					spawnedUnit:SetMaximumGoldBounty(spawnedUnit:GetMaximumGoldBounty() + creepLevel * 2)
					spawnedUnit:SetMinimumGoldBounty(spawnedUnit:GetMinimumGoldBounty() + creepLevel * 2)
				end
				spawnedUnit:AddAbility("creep_alert_aura_datadriven"):SetLevel(1)
			end)
		end
		if team == DOTA_TEAM_GOODGUYS then
			spawnVecter[1] = spawnVecter[1] - 300
			spawnVecter[2] = spawnVecter[2] - 300
		else
			spawnVecter[1] = spawnVecter[1] + 300
			spawnVecter[2] = spawnVecter[2] + 300
		end
		for j=1,numRangedCreep do
			CreateUnitByNameAsync(ranged[i], spawnVecter, true, nil, nil, team, function(spawnedUnit)
				spawnedUnit:SetIdleAcquire(false)
				spawnedUnit:AddNewModifier(nil, nil, "modifier_creep_ai", {
					alertRadius = CREEP_ALERT_RADIUS_RANGED, 
					pathName = pathNames[i], 
					seige = false,
					attackrange = CREEP_ATTACK_RANGE_RANGED })
				if spawners[i] == "lane_bot_goodguys_melee_spawner" or spawners[i] == "lane_top_badguys_melee_spawner" then
					if not spawnedUnit:HasModifier("modifier_creep_safe_lane_move_speed_bonus") then
						spawnedUnit:AddNewModifier(nil, nil, "modifier_creep_safe_lane_move_speed_bonus", { }):SetDuration(25, true)
					end
				end
				if string.find(ranged[i], "upgraded") == nil then
					spawnedUnit:AddNewModifier(nil, nil, "modifier_creep_health_bonus", { health = 10 * creepLevel, damage = 2 * creepLevel })
					spawnedUnit:SetMaximumGoldBounty(spawnedUnit:GetMaximumGoldBounty() + creepLevel)
					spawnedUnit:SetMinimumGoldBounty(spawnedUnit:GetMinimumGoldBounty() + creepLevel)
				elseif string.find(ranged[i], "mega") == nill then
					spawnedUnit:AddNewModifier(nil, nil, "modifier_creep_health_bonus", { health = 16 * creepLevel, damage = 3 * creepLevel })
					spawnedUnit:SetMaximumGoldBounty(spawnedUnit:GetMaximumGoldBounty() + creepLevel * 2)
					spawnedUnit:SetMinimumGoldBounty(spawnedUnit:GetMinimumGoldBounty() + creepLevel * 2)
				end
				spawnedUnit:AddAbility("creep_alert_aura_datadriven"):SetLevel(1)
			end)
		end
		if shouldSpawnSeige then
			CreateUnitByNameAsync(seige[i], spawnVecter, true, nil, nil, team, function(spawnedUnit)
				spawnedUnit:SetIdleAcquire(false)
				spawnedUnit:AddNewModifier(nil, nil, "modifier_creep_ai", {
					alertRadius = CREEP_ALERT_RADIUS_SEIGE, 
					pathName = pathNames[i], 
					seige = true,
					attackrange = CREEP_ATTACK_RANGE_SEIGE })
				spawnedUnit:AddAbility("creep_alert_aura_datadriven"):SetLevel(1)
			end)
		end
	end
end
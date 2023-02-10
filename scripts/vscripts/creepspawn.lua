CREEP_ALERT_RADIUS = 500
CREEP_ALERT_RADIUS_RANGED = 600
CREEP_ALERT_RADIUS_SEIGE = 800
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
	local bonusHealth = 10 * math.floor(GameRules:GetDOTATime(false, false) / 450)
	for i=1,#spawners do
		local spawner = Entities:FindByName(nil, spawners[i])
		local spawnVecter = spawner:GetAbsOrigin()
		for j=1,numMeleeCreep do
	    	local spawnedUnit = CreateUnitByName(melee[i], spawnVecter, true, nil, nil, team)
	    	spawnedUnit:SetIdleAcquire(false)
	    	spawnedUnit:AddNewModifier(nil, nil, "modifier_creep_ai", { alertRadius = CREEP_ALERT_RADIUS, pathName = pathNames[i], seige = false })
			spawnedUnit:SetMaxHealth(spawnedUnit:GetMaxHealth() + bonusHealth)
			if spawners[i] == "lane_bot_goodguys_melee_spawner" or spawners[i] == "lane_top_badguys_melee_spawner" then
				spawnedUnit:AddNewModifier(nil, nil, "modifier_creep_safe_lane_move_speed_bonus", { })
			end
		end
		if team == DOTA_TEAM_GOODGUYS then
		    spawnVecter[1] = spawnVecter[1] - 300
		    spawnVecter[2] = spawnVecter[2] - 300
		else
		    spawnVecter[1] = spawnVecter[1] + 300
		    spawnVecter[2] = spawnVecter[2] + 300
		end
		for j=1,numRangedCreep do
	    	local spawnedUnit = CreateUnitByName(ranged[i], spawnVecter, true, nil, nil, team)
	    	spawnedUnit:SetIdleAcquire(false)
	    	spawnedUnit:AddNewModifier(nil, nil, "modifier_creep_ai", { alertRadius = CREEP_ALERT_RADIUS_RANGED, pathName = pathNames[i], seige = false })
			spawnedUnit:SetMaxHealth(spawnedUnit:GetMaxHealth() + bonusHealth)
			if spawners[i] == "lane_bot_goodguys_melee_spawner" or spawners[i] == "lane_top_badguys_melee_spawner" then
				spawnedUnit:AddNewModifier(nil, nil, "modifier_creep_safe_lane_move_speed_bonus", { })
			end
		end
		if shouldSpawnSeige then
	    	local spawnedUnit = CreateUnitByName(seige[i], spawnVecter, true, nil, nil, team)
	    	spawnedUnit:SetIdleAcquire(false)
	    	spawnedUnit:AddNewModifier(nil, nil, "modifier_creep_ai", { alertRadius = CREEP_ALERT_RADIUS_SEIGE, pathName = pathNames[i], seige = true })
		end
	end
end
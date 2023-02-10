CREEP_ALERT_RADIUS = 500
CREEP_ALERT_RADIUS_RANGED = 600
CREEP_ALERT_RADIUS_SEIGE = 800
function spawnCreepsLua()
	local spawner = Entities:FindByName(nil, "lane_bot_goodguys_melee_spawner")
	local spawnVecter = spawner:GetAbsOrigin()
	local numMeleeCreep = calculateNumMeleeCreep()
	local numRangedCreep = calculateNumRangedCreep()
	local shouldSpawnSeige = GameRules:GetDOTATime(false, false) > 60 and GameRules:GetDOTATime(false, false) % 300 < 10
	print("Spawning melee " .. numMeleeCreep .. " ranged " .. numRangedCreep .. " seige ")
	print(shouldSpawnSeige)
	for i=1,numMeleeCreep do
    	local spawnedUnit = CreateUnitByName("npc_dota_creep_goodguys_melee", spawnVecter, true, nil, nil, DOTA_TEAM_GOODGUYS)
    	spawnedUnit:SetIdleAcquire(false)
    	spawnedUnit:AddNewModifier(nil, nil, "modifier_creep_ai", { alertRadius = CREEP_ALERT_RADIUS, pathName = "gb", seige = false })
	end
	for i=1,numRangedCreep do
    	local spawnedUnit = CreateUnitByName("npc_dota_creep_goodguys_ranged", spawnVecter, true, nil, nil, DOTA_TEAM_GOODGUYS)
    	spawnedUnit:SetIdleAcquire(false)
    	spawnedUnit:AddNewModifier(nil, nil, "modifier_creep_ai", { alertRadius = CREEP_ALERT_RADIUS_RANGED, pathName = "gb", seige = false })
	end
	if shouldSpawnSeige then
    	local spawnedUnit = CreateUnitByName("npc_dota_goodguys_siege", spawnVecter, true, nil, nil, DOTA_TEAM_GOODGUYS)
    	spawnedUnit:SetIdleAcquire(false)
    	spawnedUnit:AddNewModifier(nil, nil, "modifier_creep_ai", { alertRadius = CREEP_ALERT_RADIUS_SEIGE, pathName = "gb", seige = true })
	end
end

function calculateNumMeleeCreep()
	return 3 + math.floor(GameRules:GetDOTATime(false, false) / (15 * 60))
end

function calculateNumRangedCreep()
	return 1 + math.floor(GameRules:GetDOTATime(false, false) / (45 * 60))
end
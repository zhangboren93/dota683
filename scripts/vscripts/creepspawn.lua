function spawnCreepsLua()
	local spawner = Entities:FindByName(nil, "lane_bot_goodguys_melee_spawner")
	local spawnVecter = spawner:GetAbsOrigin()
	local spawnedUnit = CreateUnitByName("npc_dota_creep_goodguys_melee", spawnVecter, true, nil, nil, DOTA_TEAM_GOODGUYS)
	spawnedUnit:SetIdleAcquire(false)
	spawnedUnit:AddNewModifier(nil, nil, "modifier_creep_ai", {})
end

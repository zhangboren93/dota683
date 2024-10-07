function handleSpellStart(event)
    local caster = event.caster
    local ability = event.ability
    local target_point = event.target_points[1]
    print(target_point)
    print(caster:GetAbsOrigin())
    if math.abs(target_point[1] - caster:GetAbsOrigin()[1]) + math.abs(target_point[2] - caster:GetAbsOrigin()[2]) < 100 then
        print("self cast")
        if caster:GetTeam() == DOTA_TEAM_GOODGUYS then
            target_point = Vector(-7132, -6633, 520)
        else
            target_point = Vector(7034, 6380, 520)
        end
    end
	local units = FindUnitsInRadius(caster:GetTeam(), target_point, nil, 100000,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
    if #units > 0 then
        local unit = units[1]
        print(unit:GetName())
        ability.teleportUnit = unit
        unit:EmitSound("Portal.Loop_Appear")
        ability.particleId = ParticleManager:CreateParticle("particles/items2_fx/teleport_end.vpcf", PATTACH_POINT_FOLLOW, unit)
        ParticleManager:SetParticleControlEnt(ability.particleId, 0, unit, PATTACH_POINT_FOLLOW, "attach_origin", unit:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(ability.particleId, 1, unit, PATTACH_POINT_FOLLOW, "attach_origin", unit:GetAbsOrigin(), true)
		-- remove particle when the unit is killed
		unit:AddNewModifier(caster, ability, "modifier_item_travel_boots_target_lua", { duration = 3 })
    end
end

function handleChannelSucceeded(event)
    local caster = event.caster
    local ability = event.ability
    EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Portal.Hero_Disappear", caster)
    caster:StopSound("Portal.Loop_Disappear")
    ability.teleportUnit:StopSound("Portal.Loop_Appear")
    if ability.teleportUnit:IsAlive() then
        FindClearSpaceForUnit(caster, ability.teleportUnit:GetAbsOrigin(), false)
        caster:StartGesture(ACT_DOTA_TELEPORT_END)
    end
    caster:SetThink(function()
        caster:EmitSound("Portal.Hero_Appear")
    end, "play arrive sound", 0.1)
end

function handleChannelInterrupted(event)
    local ability = event.ability
    local caster = event.caster
    caster:StopSound("Portal.Loop_Disappear")
    ability.teleportUnit:StopSound("Portal.Loop_Appear")
	if ability.particleId ~= nil then
		ParticleManager:DestroyParticle(ability.particleId, true)
		ability.particleId = nil
	end
end

function handleSpellStart(event)
    local caster = event.caster
    local ability = event.ability
    local target_point = event.target_points[1]
    print(target_point)
	local units = FindUnitsInRadius(caster:GetTeam(), target_point, nil, 100000,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
    if #units > 0 then
        local unit = units[1]
        print(unit:GetName())
        ability.teleportUnit = unit
        --TODO attach effect
		--target.ShieldParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_aphotic_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
        ability:ApplyDataDrivenModifier(caster, unit, "modifier_item_travel_boots_target_effect", {})
    end
end

function handleChannelSucceeded(event)
    local caster = event.caster
    local ability = event.ability
    if ability.teleportUnit:IsAlive() then
        FindClearSpaceForUnit(caster, ability.teleportUnit:GetAbsOrigin(), false)
    end
end
function handleAbilityExecuted(keys)
	local caster = keys.caster
	local event_ability = keys.event_ability
    if event_ability:GetName() == "nevermore_requiem" then
	    local units = FindUnitsInRadius(caster:GetTeam(),
            caster:GetAbsOrigin(), nil,
            700,
            DOTA_UNIT_TARGET_TEAM_ENEMY, 
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
            0, 0, false)
        for i=1,#units do
            units[i]:AddNewModifier(caster, event_ability, "modifier_requiem_slow_lua", { duration = 5})
        end
    end
end

function handleIntervalThink(event)
    local caster = event.caster
    if IsServer() and IsLocationVisible(caster:GetTeam(), caster:GetAbsOrigin()) then
        local units = FindUnitsInRadius(DOTA_TEAM_NEUTRALS,
            caster:GetAbsOrigin(),
            nil, 
            1000,
            DOTA_UNIT_TARGET_TEAM_FRIENDLY,
            DOTA_UNIT_TARGET_CREEP,
            DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_ANY_ORDER,
            false)
        if #units == 0 then
            caster:Destroy()
        end
    end
end

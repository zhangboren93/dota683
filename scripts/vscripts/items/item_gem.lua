function handleIntervalThink(event)
    local caster = event.caster
    if not caster:IsIllusion() then return end

    local units = FindUnitsInRadius(
        caster:GetTeam(),
        caster:GetAbsOrigin(),
        nil,
        1100,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        FIND_ANY_ORDER,
        false
    )
    for i=1,#units do
        if units[i]:IsInvisible() then
            units[i]:AddNewModifier(caster, event.abiltiy, "modifier_item_dustofappearance", { duration = 1 })
        end
    end
end
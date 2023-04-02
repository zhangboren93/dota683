function handleAbilityExecuted(keys)
    local unit = keys.unit
    local ability = keys.ability
    local event_ability = keys.event_ability
    local target = keys.target
    if event_ability:GetName() == "silencer_global_silence" and unit:HasScepter() then
        local curse = unit:FindAbilityByName("silencer_curse_of_the_silent_datadriven")
        if curse:GetLevel() > 0 then
            units = FindUnitsInRadius(unit:GetTeam(), unit:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
            for i=1,#units do
                curse:ApplyDataDrivenModifier(unit, units[i], "modifier_curse_debuff_datadriven", {})
            end
        end
    end
end
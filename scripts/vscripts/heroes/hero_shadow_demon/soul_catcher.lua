function handleAbilityExecuted(keys)
    local unit = keys.unit
    local ability = keys.ability
    local event_ability = keys.event_ability
    if event_ability:GetName() == "shadow_demon_soul_catcher" then
        ability:SetLevel(event_ability:GetLevel())
        unit:SetThink(function()
	        local units = FindUnitsInRadius(
                unit:GetTeam(), 
                unit:GetAbsOrigin(), nil,
                1200, 
                DOTA_UNIT_TARGET_TEAM_ENEMY, 
                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 
                0, 0, false)
            local catchedUnits = {}
            for i=1,#units do
                if units[i]:HasModifier("modifier_shadow_demon_soul_catcher") then
                    table.insert(catchedUnits, units[i])
                end
            end
            if #catchedUnits == 0 then
                return
            end
            local pickedUnit = catchedUnits[RandomInt(1, #catchedUnits)]
            ability:ApplyDataDrivenModifier(unit, pickedUnit, "modifier_sd_soul_catcher_debuff_datadriven", {})
            for i=1,#catchedUnits do
                if catchedUnits[i] ~= pickedUnit then
                    catchedUnits[i]:RemoveModifierByName("modifier_shadow_demon_soul_catcher")
                end
            end
        end, "soul catcher debuff", 0.1) 
    end
end
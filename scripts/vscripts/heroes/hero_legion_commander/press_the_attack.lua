require("../../root_modifiers")
function handleAbilityExecuted(keys)
    local unit = keys.unit
    local ability = keys.ability
    local event_ability = keys.event_ability
    local target = keys.target
    if event_ability:GetName() == "legion_commander_press_the_attack" then
        local bonus = unit:FindAbilityByName("legion_commander_press_the_attack_as_datadriven")
        bonus:SetLevel(event_ability:GetLevel())
        bonus:ApplyDataDrivenModifier(unit, target, "modifier_legion_press_active_datadriven", {})
    elseif event_ability:GetName() == "legion_commander_duel" then
        for i,v in pairs(ethereal_modifiers) do
            unit:RemoveModifierByName(i)
            target:RemoveModifierByName(i)
        end
        for i,v in pairs(disarm_modifiers) do
            unit:RemoveModifierByName(i)
            target:RemoveModifierByName(i)
        end
    end
end
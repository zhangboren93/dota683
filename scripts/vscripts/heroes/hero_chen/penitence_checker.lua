function handleAbilityExecuted(keys)
    local unit = keys.unit
    local ability = keys.ability
    local event_ability = keys.event_ability
    local target = keys.target
    if event_ability:GetName() == "chen_penitence" then
        local chen_penitence_active_datadriven = unit:FindAbilityByName("chen_penitence_active_datadriven")
        chen_penitence_active_datadriven:SetLevel(event_ability:GetLevel())
        chen_penitence_active_datadriven:ApplyDataDrivenModifier(unit, target, "modifier_chen_penitence_active_datadriven", {})
    elseif event_ability:GetName() == "chen_holy_persuasion" then
        if target:IsCreep() then
            target:SetThink(function()
                target:SetMaxHealth(target:GetMaxHealth() + event_ability:GetSpecialValueFor("health_bonus"))
                target:Heal(event_ability:GetSpecialValueFor("health_bonus"), unit)
            end, "health", 0.1)
            target:RemoveModifierByName("modifier_creep_ai")
        end
    end
end
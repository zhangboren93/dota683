function handleAbilityExecuted(keys)
    local unit = keys.unit
    local ability = keys.ability
    local event_ability = keys.event_ability
    local target = keys.target
    if event_ability:GetName() == "life_stealer_infest" then
        if target:IsNeutralUnitType() then
            unit:ModifyGold(target:GetGoldBounty(), false, DOTA_ModifyGold_CreepKill)
        end
        target:RemoveModifierByName("modifier_creep_ai")
    end
end

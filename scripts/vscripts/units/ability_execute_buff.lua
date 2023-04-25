function handleAbilityExecuted(keys)
    local unit = keys.unit
    local ability = keys.ability
    local event_ability = keys.event_ability
    local target_ability = keys.TargetAbility
    local modifier = keys.Modifier
    if event_ability:GetName() == target_ability then
		ability:SetLevel(event_ability:GetLevel())
		ability:ApplyDataDrivenModifier(unit, unit, modifier, {})
    end
end
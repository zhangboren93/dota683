function handleAbilityExecuted(keys)
    local unit = keys.unit
    local ability = keys.ability
    local event_ability = keys.event_ability
    local target = keys.target
    if event_ability:GetName() == "obsidian_destroyer_astral_imprisonment" then
		ability:SetLevel(event_ability:GetLevel())
		ability:ApplyDataDrivenModifier(unit, target, "modifier_od_imprison_int_steal", {})
		ability:ApplyDataDrivenModifier(unit, unit,   "modifier_od_imprison_int_gain", {})
    end
end
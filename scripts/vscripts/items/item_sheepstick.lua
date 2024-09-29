function handleAbilityExecuted(event)
    local event_ability = event.event_ability
    local ability = event.ability
    local target = event.target
    local caster = event.caster
    if event_ability:GetName() == "item_sheepstick" then
        ability:ApplyDataDrivenModifier(caster, target, "modifier_sheep_apply_break_active", {}):SetDuration(
            event_ability:GetSpecialValueFor("sheep_duration"), true)
    elseif event_ability:GetName() == "lion_voodoo" then
        ability:ApplyDataDrivenModifier(caster, target, "modifier_sheep_apply_break_active", {}):SetDuration(
            event_ability:GetSpecialValueFor("duration"), true)
    end
end
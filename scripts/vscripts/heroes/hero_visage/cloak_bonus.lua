function handleIntervalThink(event)
    local caster = event.caster
    local ability = event.ability
    local modifier = caster:FindModifierByName("modifier_visage_gravekeepers_cloak")
    if modifier == nil then 
        modifier = caster:FindModifierByName("modifier_visage_gravekeepers_cloak_secondary")
        if modifier == nil then 
            caster:RemoveAllModifiersOfName("modifier_cloak_bonus_datadriven")
            return
        end
        modifier = modifier:GetCaster():FindModifierByName("modifier_visage_gravekeepers_cloak")
    else
    end
    local caster2 = modifier:GetCaster()
    local cloak = caster2:FindAbilityByName("visage_gravekeepers_cloak")
    if cloak:GetLevel() == 0 then
        return
    end
    local cloak_bonus = caster:FindAbilityByName("visage_gravekeepers_cloak_bonus_active_datadriven")
    cloak_bonus:SetLevel(cloak:GetLevel())
    for i=1,modifier:GetStackCount() do
        cloak_bonus:ApplyDataDrivenModifier(caster2, caster, "modifier_cloak_bonus_datadriven", {})
    end
end
function handleAttackLanded(keys)
    local target = keys.target
    local attacker = keys.attacker
    local ability = keys.ability
    local modifier = target:FindModifierByNameAndCaster("meepo_geostrike_datadriven_active_modifier", attacker)
    if modifier == nil then
        ability:ApplyDataDrivenModifier(attacker, target, "meepo_geostrike_datadriven_active_modifier", {})
    else
        modifier:SetDuration(2, true)
    end
end
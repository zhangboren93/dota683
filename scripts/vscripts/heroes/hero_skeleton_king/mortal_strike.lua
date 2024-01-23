function handleAttackStart(event)
    local target = event.target
    local attacker = event.attacker
    local caster = event.caster
    local crit_modifier = event.CritModifier
    if not IsServer() then return end
    if attacker ~= caster then return end
    if target:GetClassname() == "dota_item_drop"
        or target:GetClassname() == "dota_item_rune"
        or target:IsBuilding()
        or target:GetTeam() == attacker:GetTeam()
        or target:GetName() == "npc_dota_unit_undying_tombstone"
        then return end
    attacker:RemoveModifierByName(event.crit_modifier)
    local ability = event.ability
    local crit_chance = ability:GetSpecialValueFor("crit_chance")
    if RandomInt(1, 100) > crit_chance then return end
    ability:ApplyDataDrivenModifier(caster, caster, crit_modifier, {})
end
function handleAbilityExecuted(keys)
    local unit = keys.unit
    local ability2 = keys.ability
    local event_ability = keys.event_ability
    local target = keys.target
    if target ~= nil and target:GetName() == "npc_dota_hero_razor" and not event_ability:IsItem() then
        local ability = target:FindAbilityByName("razor_unstable_current")
        unit:Purge(true, false, false, false, false)
        ability2:ApplyDataDrivenModifier(target, unit, "modifier_unstable_current_purge", {duration = ability:GetDuration()})
        if ability:GetLevel() > 0 then
            unit:EmitSound("Hero_Razor.UnstableCurrent.Target")
	        ApplyDamage({
                victim = unit,
                attacker = target,
                damage = ability:GetAbilityDamage(),
                damage_type = ability:GetAbilityDamageType()})
        end
    end
end
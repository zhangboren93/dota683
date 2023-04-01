function handleAbilityExecuted(keys)
    local unit = keys.unit
    local ability = keys.ability
    local event_ability = keys.event_ability
    local target = keys.target
    if event_ability:GetName() == "undying_flesh_golem" then
        ability:SetLevel(event_ability:GetLevel())
        ability:ApplyDataDrivenModifier(unit, unit, "modifier_undying_flesh_golem_aura_1_datadriven", {})
        ability:ApplyDataDrivenModifier(unit, unit, "modifier_undying_flesh_golem_aura_2_datadriven", {})
        ability:ApplyDataDrivenModifier(unit, unit, "modifier_undying_flesh_golem_aura_3_datadriven", {})
        ability:ApplyDataDrivenModifier(unit, unit, "modifier_undying_flesh_golem_aura_4_datadriven", {})
    end
end

function handleDeath(keys)
    local caster = keys.caster
    local unit = keys.unit
    local ability = keys.ability
    if unit:IsRealHero() then
        caster:Heal(caster:GetMaxHealth() * ability:GetSpecialValueFor("hero_death_regen_pct") / 100, ability)
    else
        caster:Heal(caster:GetMaxHealth() * ability:GetSpecialValueFor("creep_death_regen_pct") / 100, ability)
    end
end
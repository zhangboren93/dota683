function handleSpellStart(event)
    local target_entities = event.target_entities
    local ability = event.ability
    local caster = event.caster
    local heroCount = 0
    for i=1,#target_entities do
        if target_entities[i]:IsRealHero() then
            heroCount = heroCount + 1
        end
    end
    local creepCount = #target_entities - heroCount
    local damage = ability:GetSpecialValueFor("damage") + heroCount * ability:GetSpecialValueFor("damage_per_hero") + creepCount * ability:GetSpecialValueFor("damage_per_unit")
    for i=1,#target_entities do
		ApplyDamage({ victim = target_entities[i], attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
    end
    local movespeedCount = creepCount + heroCount * 3
    if movespeedCount > 0 then
        local buff = ability:ApplyDataDrivenModifier(caster, caster, "modifier_legion_odds_ms_datadriven", {})
        buff:SetStackCount(movespeedCount)
    end 
end
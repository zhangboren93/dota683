function updateHealModifier(event)
    local caster = event.caster
    local ability = event.ability
    if caster:HasModifier("modifier_slark_shadow_dance_passive_regen") then
        local shadow_dance = caster:FindAbilityByName("slark_shadow_dance")
        local regen = shadow_dance:GetSpecialValueFor("bonus_pct_regen") * caster:GetMaxHealth() / 100 / 5
        caster:Heal(regen, shadow_dance)
    end
end

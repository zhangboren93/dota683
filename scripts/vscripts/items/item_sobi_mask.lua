function item_sobi_mask_gen_mana(keys)
    local caster = keys.caster
    local ability = keys.ability
    local mana_gen = caster:GetManaRegen();
    local mana_gen_bonus = ability:GetSpecialValueFor("bonus_mana_regen")
    local bonus_mana = mana_gen * mana_gen_bonus / 100
    -- think interval is 0.5s
    bonus_mana = bonus_mana / 2
    caster:GiveMana(bonus_mana)
end
if modifier_enchantress_aghs_attack_range == nil then
    modifier_enchantress_aghs_attack_range = class({})
end

function modifier_enchantress_aghs_attack_range:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_enchantress_aghs_attack_range:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
    }
    return funcs
end

function modifier_enchantress_aghs_attack_range:IsHidden()
    return true
end

function modifier_enchantress_aghs_attack_range:GetModifierAttackRangeBonus()
    if self:GetParent():HasScepter() then
        return 165
    else
        return 0
    end
end
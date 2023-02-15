if modifier_pudge_flesh_magic_resist == nil then
    modifier_pudge_flesh_magic_resist = class({})
end

function modifier_pudge_flesh_magic_resist:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_pudge_flesh_magic_resist:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
    }
    return funcs
end

function modifier_pudge_flesh_magic_resist:IsHidden()
    return false
end

function modifier_pudge_flesh_magic_resist:GetModifierMagicalResistanceBonus()
    return self:GetAbility():GetSpecialValueFor("magic_resistance")
end

function modifier_pudge_flesh_magic_resist:GetTexture()
    return "pudge_flesh_heap"
end
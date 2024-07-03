if modifier_cloak_bonus == nil then
    modifier_cloak_bonus = class({})
end

function modifier_cloak_bonus:OnCreated(kv)
    self.kv = kv
end

function modifier_cloak_bonus:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_cloak_bonus:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
    }
    return funcs
end

function modifier_cloak_bonus:IsHidden()
    return true
end

function modifier_cloak_bonus:GetModifierPhysicalArmorBonus()
    local owner = self:GetParent()
    if owner:HasModifier("modifier_visage_gravekeepers_cloak") then
        return self:GetAbility():GetSpecialValueFor("bonus_armor") * owner:GetModifierStackCount("modifier_visage_gravekeepers_cloak", owner)
    else
        return 0
    end
end

function modifier_cloak_bonus:GetModifierMagicalResistanceBonus()
    local owner = self:GetParent()
    if owner:HasModifier("modifier_visage_gravekeepers_cloak") then
        return self:GetAbility():GetSpecialValueFor("bonus_resist") * owner:GetModifierStackCount("modifier_visage_gravekeepers_cloak", owner)
    else
        return 0
    end
end
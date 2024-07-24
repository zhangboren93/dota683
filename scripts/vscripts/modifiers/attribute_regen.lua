if modifier_attribute_regen_adjust == nil then
    modifier_attribute_regen_adjust = class({})
end

function modifier_attribute_regen_adjust:OnCreated(kv)
    self.kv = kv
end

function modifier_attribute_regen_adjust:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_attribute_regen_adjust:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT
    }
    return funcs
end

function modifier_attribute_regen_adjust:IsHidden()
    return true
end

function modifier_attribute_regen_adjust:GetModifierConstantManaRegen()
    return self:GetParent():GetIntellect(true) * (-0.01)
end

function modifier_attribute_regen_adjust:GetModifierConstantHealthRegen()
    return self:GetParent():GetStrength() * (-0.07)
end

function modifier_attribute_regen_adjust:GetModifierMagicalResistanceBonus()
    return 1 + self:GetParent():GetIntellect(true) * (-0.16)
end

function modifier_attribute_regen_adjust:GetModifierMoveSpeed_Limit()
    local parent = self:GetParent()
    if parent:HasModifier("modifier_spirit_breaker_charge_of_darkness") then
        return self:GetParent():FindAbilityByName("spirit_breaker_charge_of_darkness"):GetSpecialValueFor("movement_speed")
    elseif parent:HasModifier("modifier_lycan_shapeshift_speed") then
        return 650
    elseif parent:HasModifier("modifier_faceless_void_chronosphere_speed") then
        return 1000
    end
    return 522
end

function modifier_attribute_regen_adjust:GetTexture()
    return "attributes_regen"
end

function modifier_attribute_regen_adjust:IsDebuff()
    return true
end

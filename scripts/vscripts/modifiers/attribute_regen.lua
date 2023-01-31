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
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS,
    }
    return funcs
end
function modifier_attribute_regen_adjust:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_attribute_regen_adjust:IsHidden()
    return false
end

function modifier_attribute_regen_adjust:GetModifierConstantManaRegen()
    return self:GetParent():GetIntellect() * (-0.01)
end
function modifier_attribute_regen_adjust:GetModifierConstantHealthRegen()
    return self:GetParent():GetStrength() * (-0.07)
end
function modifier_attribute_regen_adjust:GetTexture()
    return "attributes_regen"
end

function modifier_attribute_regen_adjust:IsDebuff()
    return true
end

function modifier_attribute_regen_adjust:GetModifierHealthBonus()
    return -50
end

function modifier_attribute_regen_adjust:GetModifierManaBonus()
    return -75
end
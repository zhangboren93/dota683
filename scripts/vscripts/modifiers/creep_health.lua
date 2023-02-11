if modifier_creep_health_bonus == nil then
    modifier_creep_health_bonus = class({})
end

function modifier_creep_health_bonus:OnCreated(kv)
    self.kv = kv
end

function modifier_creep_health_bonus:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_creep_health_bonus:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
    }
    return funcs
end

function modifier_creep_health_bonus:IsHidden()
    return false
end

function modifier_creep_health_bonus:GetModifierExtraHealthBonus()
    return self.kv.health
end

function modifier_creep_health_bonus:GetModifierBaseAttack_BonusDamage()
    return self.kv.damage
end
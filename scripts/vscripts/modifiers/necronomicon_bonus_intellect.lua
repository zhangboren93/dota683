if modifier_necronomicon_bonus_intellect == nil then
    modifier_necronomicon_bonus_intellect = class({})
end
function modifier_necronomicon_bonus_intellect:OnCreated(kv)
    self.kv = kv
end

function modifier_necronomicon_bonus_intellect:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_necronomicon_bonus_intellect:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
    }
    return funcs
end

function modifier_necronomicon_bonus_intellect:IsHidden()
    return true
end

function modifier_necronomicon_bonus_intellect:GetModifierBonusStats_Intellect()
    return self.kv.bonus_intellect
end
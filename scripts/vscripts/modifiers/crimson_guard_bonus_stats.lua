if modifier_crimson_guard_stats_lua == nil then
    modifier_crimson_guard_stats_lua = class({})
end
function modifier_crimson_guard_stats_lua:OnCreated(kv)
    self.kv = kv
end
function modifier_crimson_guard_stats_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
    }
    return funcs
end
function modifier_crimson_guard_stats_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_crimson_guard_stats_lua:IsHidden()
    return true
end

function modifier_crimson_guard_stats_lua:GetModifierBonusStats_Strength()
    return self.kv.bonus_all_stats
end
function modifier_crimson_guard_stats_lua:GetModifierBonusStats_Agility()
    return self.kv.bonus_all_stats
end
function modifier_crimson_guard_stats_lua:GetModifierBonusStats_Intellect()
    return self.kv.bonus_all_stats
end
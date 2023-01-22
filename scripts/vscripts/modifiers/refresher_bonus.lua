if modifier_refresher_bonus_lua == nil then
    modifier_refresher_bonus_lua = class({})
end
function modifier_refresher_bonus_lua:OnCreated(kv)
    self.kv = kv
end
function modifier_refresher_bonus_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
    }
    return funcs
end

function modifier_refresher_bonus_lua:IsHidden()
    return true
end

function modifier_refresher_bonus_lua:GetModifierPreAttack_BonusDamage()
    return self.kv.bonus_damage
end

function modifier_refresher_bonus_lua:GetModifierAttackSpeedBonus_Constant() 
    return self.kv.bonus_attack_speed
end
function modifier_refresher_bonus_lua:GetModifierBonusStats_Intellect()
    return self.kv.bonus_intellect
end
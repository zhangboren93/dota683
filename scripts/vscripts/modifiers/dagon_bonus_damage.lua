if modifier_dagon_damage_lua == nil then
    modifier_dagon_damage_lua = class({})
end
function modifier_dagon_damage_lua:OnCreated(kv)
    self.kv = kv
end

function modifier_dagon_damage_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_dagon_damage_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }
    return funcs
end

function modifier_dagon_damage_lua:IsHidden()
    return true
end

function modifier_dagon_damage_lua:GetModifierPreAttack_BonusDamage()
    return self.kv.bonus_damage
end
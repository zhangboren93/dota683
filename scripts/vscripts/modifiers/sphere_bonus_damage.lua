if modifier_sphere_bonus_damage_lua == nil then
    modifier_sphere_bonus_damage_lua = class({})
end

function modifier_sphere_bonus_damage_lua:OnCreated(kv)
    self.kv = kv
    print(kv.bonus_damage)
end

function modifier_sphere_bonus_damage_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_sphere_bonus_damage_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }
    return funcs
end

function modifier_sphere_bonus_damage_lua:IsHidden()
    return false
end

function modifier_sphere_bonus_damage_lua:GetModifierPreAttack_BonusDamage()
    return self.kv.bonus_damage
end
if modifier_maelstrom_as_lua == nil then
    modifier_maelstrom_as_lua = class({})
end

function modifier_maelstrom_as_lua:OnCreated(kv)
    self.kv = kv
end

function modifier_maelstrom_as_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_maelstrom_as_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
    return funcs
end

function modifier_maelstrom_as_lua:IsHidden()
    return false
end

function modifier_maelstrom_as_lua:GetModifierAttackSpeedBonus_Constant()
    return self.kv.bonus_attack_speed
end
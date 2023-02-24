if modifier_item_shadow_amulet_attack_speed == nil then
    modifier_item_shadow_amulet_attack_speed = class({})
end

function modifier_item_shadow_amulet_attack_speed:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_item_shadow_amulet_attack_speed:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
    return funcs
end

function modifier_item_shadow_amulet_attack_speed:IsHidden()
    return true
end

function modifier_item_shadow_amulet_attack_speed:GetModifierAttackSpeedBonus_Constant()
    return 30
end
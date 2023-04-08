if modifier_creep_safe_lane_move_speed_bonus == nil then
    modifier_creep_safe_lane_move_speed_bonus = class({})
end

function modifier_creep_safe_lane_move_speed_bonus:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_creep_safe_lane_move_speed_bonus:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    }
    return funcs
end

function modifier_creep_safe_lane_move_speed_bonus:IsHidden()
    return false
end

function modifier_creep_safe_lane_move_speed_bonus:GetModifierMoveSpeedBonus_Constant()
    return 70
end
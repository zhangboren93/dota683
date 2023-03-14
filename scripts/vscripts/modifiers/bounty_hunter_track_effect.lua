if modifier_bounty_hunter_track_effect_lua == nil then
    modifier_bounty_hunter_track_effect_lua = class({})
end

function modifier_bounty_hunter_track_effect_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_bounty_hunter_track_effect_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
    return funcs
end

function modifier_bounty_hunter_track_effect_lua:IsHidden()
    return false
end

function modifier_bounty_hunter_track_effect_lua:GetModifierMoveSpeedBonus_Percentage()
    return 20
end
function modifier_bounty_hunter_track_effect_lua:GetTexture()
    return "bounty_hunter_track"
end

function modifier_bounty_hunter_track_effect_lua:IsDebuff()
    return false
end
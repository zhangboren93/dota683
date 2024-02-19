if modifier_disable_item_orb == nil then
    modifier_disable_item_orb = class({})
end

function modifier_disable_item_orb:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_disable_item_orb:IsHidden()
    return true
end

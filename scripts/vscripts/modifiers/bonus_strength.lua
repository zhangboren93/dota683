if modifier_bonus_strength_lua == nil then
    modifier_bonus_strength_lua = class({})
end

function modifier_bonus_strength_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_bonus_strength_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
    }
    return funcs
end

function modifier_bonus_strength_lua:IsHidden()
    return false
end

function modifier_bonus_strength_lua:GetModifierBonusStats_Strength()
    local hero = self:GetParent()
    if hero == nil then
        return 0
    end
    local item = hero:FindItemInInventory("item_urn_of_shadows");
    if item == nil then
        return 0
    end
    return item:GetSpecialValueFor("bonus_strength")
end

function modifier_bonus_strength_lua:GetTexture()
    return "item_urn_of_shadows"
end
if item_medallion_regen_percentage_modifier == nil then
    item_medallion_regen_percentage_modifier = class({})
end

function item_medallion_regen_percentage_modifier:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function item_medallion_regen_percentage_modifier:IsHidden()
    return true
end

function item_medallion_regen_percentage_modifier:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    }
    return funcs
end

function item_medallion_regen_percentage_modifier:GetModifierConstantManaRegen()
	return 0.01 * self:GetStackCount()
end
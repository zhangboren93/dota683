if item_pct_mana_regen_modifier_lua == nil then
    item_pct_mana_regen_modifier_lua = class({})
end

function item_pct_mana_regen_modifier_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 
end

function item_pct_mana_regen_modifier_lua:IsHidden()
    return true
end

function item_pct_mana_regen_modifier_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    }
    return funcs
end

function item_pct_mana_regen_modifier_lua:GetModifierConstantManaRegen()
	return 0.01 * self:GetStackCount()
end
modifier_attribute_regen_688_lua = class({
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
	DeclareFunctions = function() return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS
	} end,
	GetModifierHealthBonus = function() return 50 end,
	GetModifierManaBonus = function() return 50 end,
	IsHidden = function() return true end
})

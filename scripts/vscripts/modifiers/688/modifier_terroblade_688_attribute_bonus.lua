modifier_terroblade_688_attribute_bonus = class({
	IsHidden = function() return true end,
	DeclareFunctions = function() return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	} end,
	GetModifierPhysicalArmorBonus = function(self) return 3 end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT end
})

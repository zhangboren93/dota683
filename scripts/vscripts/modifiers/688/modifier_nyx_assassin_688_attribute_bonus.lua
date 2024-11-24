modifier_nyx_assassin_688_attribute_bonus = class({
	IsHidden = function() return true end,
	DeclareFunctions = function() return {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	} end,
	GetModifierConstantHealthRegen = function(self) return 1 end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT end
})

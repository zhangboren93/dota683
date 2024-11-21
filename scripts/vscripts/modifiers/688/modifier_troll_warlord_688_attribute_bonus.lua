modifier_troll_warlord_688_attribute_bonus = class({
	IsHidden = function() return true end,
	DeclareFunctions = function() return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
	} end,
	GetModifierBonusStats_Strength = function(self) return 3 end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT end
})

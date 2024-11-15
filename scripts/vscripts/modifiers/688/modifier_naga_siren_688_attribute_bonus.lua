modifier_naga_siren_688_attribute_bonus = class({
	IsHidden = function() return true end,
	DeclareFunctions = function() return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	} end,
	GetModifierBonusStats_Strength = function(self) return (self:GetParent():GetLevel() - 1) / 5 end,
	GetModifierBonusStats_Intellect = function(self) return 3 end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT end
})

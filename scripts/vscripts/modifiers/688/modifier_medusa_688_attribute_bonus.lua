modifier_medusa_688_attribute_bonus = class({
	IsHidden = function() return true end,
	DeclareFunctions = function() return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	} end,
	GetModifierBonusStats_Intellect = function(self) return (self:GetParent():GetLevel() - 1) / 4 end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT end
})

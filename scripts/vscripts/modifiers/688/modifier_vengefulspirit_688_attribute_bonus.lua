modifier_vengefulspirit_688_attribute_bonus = class({
	IsHidden = function() return true end,
	DeclareFunctions = function() return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS
	} end,
	GetModifierBonusStats_Agility = function(self) return (self:GetParent():GetLevel() - 1) / 2 end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT end
})

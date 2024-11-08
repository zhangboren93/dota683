modifier_luna_688_attribute_bonus = class({
	IsHidden = function() return true end,
	DeclareFunctions = function() return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	} end,
	GetModifierBonusStats_Strength = function(self) return (self:GetParent():GetLevel() - 1) * 3 / 10 end,
	GetModifierBonusStats_Agility = function(self) return (self:GetParent():GetLevel() - 1) * 5 / 10 end,
	GetModifierPhysicalArmorBonus = function(self) return 1 end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT end
})

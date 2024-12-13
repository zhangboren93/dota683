modifier_jakiro_688_attribute_bonus = class({
	IsHidden = function() return true end,
	DeclareFunctions = function() return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	} end,
	GetModifierPreAttack_BonusDamage = function(self) return 7 end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT end
})

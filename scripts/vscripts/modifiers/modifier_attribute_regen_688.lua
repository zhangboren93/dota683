modifier_attribute_regen_688_lua = class({
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
	DeclareFunctions = function() return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACK_RANGE_BASE_OVERRIDE
	} end,
	GetModifierHealthBonus = function(self) return self:GetParent():GetStrength() end,
	GetModifierManaBonus = function(self) return 0 - self:GetParent():GetIntellect(false) end,
	GetModifierSpellAmplify_Percentage = function(self) return self:GetParent():GetIntellect(false) / 16.0 end,
	GetModifierAttackRangeOverride = function(self) if not self:GetParent():IsRangedAttacker() then return 150 end end,
	IsHidden = function() return true end
})

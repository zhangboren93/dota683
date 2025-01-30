modifier_item_assault_buff_lua = class({
	GetAttributes = function() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
	DeclareFunctions = function() return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	} end,
	GetModifierAttackSpeedBonus_Constant = function(self)
		return self:GetAbility():GetSpecialValueFor("aura_attack_speed")
	end,
	GetModifierPhysicalArmorBonus = function(self)
		return self:GetAbility():GetSpecialValueFor("aura_positive_armor")
	end
})

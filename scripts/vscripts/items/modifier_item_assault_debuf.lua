modifier_item_assault_debuf_lua = class({
	GetAttributes = function() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
	DeclareFunctions = function() return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	} end,
	GetModifierPhysicalArmorBonus = function(self)
		return self:GetAbility():GetSpecialValueFor("aura_negative_armor")
	end
})

modifier_item_ring_of_basilius_aura_lua = class({
	DeclareFunctions = function() return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT 
	} end,
	GetModifierPhysicalArmorBonusUnique = function() return 2 end,
	GetModifierConstantManaRegen = function() return 0.65 end
})

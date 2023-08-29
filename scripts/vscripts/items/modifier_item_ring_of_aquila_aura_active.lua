modifier_item_ring_of_aquila_aura_active_lua = class({})

function modifier_item_ring_of_aquila_aura_active_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, 
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
	}
end

function modifier_item_ring_of_aquila_aura_active_lua:GetModifierPhysicalArmorBonus()
	return 2
end

function modifier_item_ring_of_aquila_aura_active_lua:GetModifierConstantManaRegen()
	return 0.65
end

function modifier_item_ring_of_aquila_aura_active_lua:GetAbilityTextureName()
	return "item_ring_of_aquila"
end

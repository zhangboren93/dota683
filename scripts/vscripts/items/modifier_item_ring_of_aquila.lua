modifier_item_ring_of_aquila_lua = class({})

function modifier_item_ring_of_aquila_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 
end

function modifier_item_ring_of_aquila_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

function modifier_item_ring_of_aquila_lua:OnCreated()
	if not IsServer() then return end
	if not self:GetParent():HasModifier("modifier_item_ring_of_aquila_aura_lua") then
		self:GetParent():AddNewModifier(
			self:GetParent(),
			self:GetAbility(),
			"modifier_item_ring_of_aquila_aura_lua",
			{})
	end
end

function modifier_item_ring_of_aquila_lua:GetModifierPreAttack_BonusDamage()
	return 9
end

function modifier_item_ring_of_aquila_lua:GetModifierBonusStats_Strength()
	return 3
end

function modifier_item_ring_of_aquila_lua:GetModifierBonusStats_Agility()
	return 9
end

function modifier_item_ring_of_aquila_lua:GetModifierBonusStats_Intellect()
	return 3
end

function modifier_item_ring_of_aquila_lua:GetModifierPhysicalArmorBonus()
	return 1
end

function modifier_item_ring_of_aquila_lua:IsHidden()
	return true
end

modifier_item_crimson_guard_lua = class({
	DeclareFunctions = function() return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	} end,
	GetModifierHealthBonus = function() return 250 end,
	GetModifierConstantHealthRegen = function() return 6 end,
	GetModifierPhysicalArmorBonus = function() return 5 end,
	GetModifierBonusStats_Strength = function() return 2 end,
	GetModifierBonusStats_Agility = function() return 2 end,
	GetModifierBonusStats_Intellect = function() return 2 end,
	IsHidden = function() return true end,
	GetModifierPhysical_ConstantBlock = function(self, event)
		local parent = self:GetParent()
		if parent:IsIllusion() then return 0 end

		if bit.band(event.damage_flags, DOTA_DAMAGE_FLAG_BYPASSES_PHYSICAL_BLOCK) ~= 0 then return end

		if RollPseudoRandomPercentage(67, DOTA_PSEUDO_RANDOM_ITEM_CRIMSON_GUARD, parent) then
			if parent:IsRangedAttacker() then
				return 20
			else
				return 40
			end
		end
	end
})

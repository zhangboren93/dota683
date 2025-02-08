item_octarine_core_lua = class({
	GetIntrinsicModifierName = function() return "modifier_item_octarine_core_lua" end
})

modifier_item_octarine_core_lua = class({
	GetAttributes = function() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
	IsHidden = function() return true end,
	DeclareFunctions = function() return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE 
	} end,
	GetModifierHealthBonus = function() return 425 end,
	GetModifierManaBonus = function() return 425 end,
	GetModifierBonusStats_Intellect = function() return 25 end,
	GetModifierConstantManaRegen = function(self) return self:GetParent():GetIntellect(false) / 50 end,
	GetModifierPercentageCooldown = function() return 25 end,
	OnTakeDamage = function(self, event)
		local parent = self:GetParent()
		if event.attacker ~= parent then return end
		if inflictor == nil then return end
		local lifesteal = 25
		local unit = event.unit
		if unit:IsCreep() then
			lifesteal = 5
		end
		parent:Heal(event.damage * lifesteal / 100, self:GetAbility())
	end
})

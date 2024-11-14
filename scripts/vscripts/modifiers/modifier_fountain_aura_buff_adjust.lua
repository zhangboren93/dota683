modifier_fountain_aura_buff_adjust_lua = class({
	DeclareFunctions = function() 
		return {
			MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
			MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
		}
	end,
	GetModifierConstantHealthRegen = function(self)
		return -1 * self:GetParent():GetMaxHealth() / 100
	end,
	GetModifierConstantManaRegen = function(self)
		return 14 - self:GetParent():GetMana() / 50
	end,
	OnCreated = function(self)
		self:StartIntervalThink(0.1)
	end,
	OnIntervalThink = function(self)
		if not IsServer() then return end
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_fountain_aura_buff") then
			parent:RemoveModifierByName("modifier_fountain_aura_buff_adjust_lua")
		end
	end,
	IsHidden = function() return true end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
})

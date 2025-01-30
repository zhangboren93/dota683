modifier_item_assault_lua = class({
	OnCreated = function(self)
		if not IsServer() then return end
		local parent = self:GetParent()
		local ability = self:GetAbility()
		if not parent:HasModifier("modifier_item_assault_buff_aura_lua") then
			parent:AddNewModifier(parent, ability, "modifier_item_assault_buff_aura_lua", {})
		end
		if not parent:HasModifier("modifier_item_assault_debuf_aura_lua") then
			parent:AddNewModifier(parent, ability, "modifier_item_assault_debuf_aura_lua", {})
		end
	end,
	GetAttributes = function()
		return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
	end,
	DeclareFunctions = function()
		return {
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
			MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
		}
	end,
	GetModifierAttackSpeedBonus_Constant = function(self)
		return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	end,
	GetModifierPhysicalArmorBonus = function(self)
		return self:GetAbility():GetSpecialValueFor("bonus_armor")
	end,
	IsHidden = function(self)
		return true
	end
})

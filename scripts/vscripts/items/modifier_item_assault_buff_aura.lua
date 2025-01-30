modifier_item_assault_buff_aura_lua = class({
	OnCreated = function(self) self:StartIntervalThink(1) end,
	OnIntervalThink = function(self)
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_item_assault_lua") then
			self:Destroy()
		end
	end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
	IsAura = function() return true end,
	GetAuraRadius = function(self) return self:GetAbility():GetSpecialValueFor("aura_radius") end,
	GetAuraSearchTeam = function(self) return DOTA_UNIT_TARGET_TEAM_FRIENDLY end,
	GetAuraSearchType = function(self)
		local ability = self:GetAbility()
		if ability:GetSpecialValueFor("aura_ally_building") == 1 then
			return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_BUILDING
		end
		return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
	end,
	GetModifierAura = function() return "modifier_item_assault_buff_lua" end,
	IsHidden = function() return true end
})

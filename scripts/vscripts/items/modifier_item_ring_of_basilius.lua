modifier_item_ring_of_basilius_lua = class({
	DeclareFunctions = function() return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	} end,
	GetModifierPreAttack_BonusDamage = function() return 6 end,
	GetModifierPhysicalArmorBonus = function() return 1 end,
	IsAura = function() return true end,
	GetAuraRadius = function(self)
		local ability = self:GetAbility()
		if ability:GetLevel() == 1 then
			return 900
		else
			return 1
		end
	end,
	GetAuraSearchFlags = function() return DOTA_UNIT_TARGET_FLAG_NONE end,
	GetAuraSearchTeam = function() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end,
	GetAuraSearchType = function() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP end,
	GetModifierAura = function() return "modifier_item_ring_of_basilius_aura_lua" end,
	IsHidden = function() return true end
})

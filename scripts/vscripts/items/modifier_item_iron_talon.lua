modifier_item_iron_talon_lua = class({
	GetAttributes = function() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
	IsHidden = function() return true end,
	DeclareFunctions = function() return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL
	} end,
	GetModifierPhysicalArmorBonus = function() return 2 end,
	GetModifierProcAttack_BonusDamage_Physical = function(self, event)
		if not IsServer() or event.attacker ~= self:GetParent() then return end
		local attacker = event.attacker
		local target = event.target
		local damage = event.damage
		if not target:IsCreep() then return end
		if attacker:IsRangedAttacker() then
			return damage * 12 / 100
		else
			return damage * 32 / 100
		end
	end
})

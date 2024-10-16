modifier_item_bloodthorn_lua = class({
	IsHidden = function() return true end,
	GetAttibutes = function() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
	DeclareFunctions = function() return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
	} end,
	GetModifierBonusStats_Intellect = function() return 25 end,
	GetModifierAttackSpeedBonus_Constant = function() return 30 end,
	GetModifierPreAttack_BonusDamage = function() return 60 end,
	GetModifierConstantManaRegen = function(self) return self:GetParent():GetIntellect(false) * 3 / 50 + 0.015 end, -- 150% mana regen
	GetModifierPreAttack_CriticalStrike = function(self, event)
		local target = event.target
		if target:IsBuilding() then return 0 end
		if target:HasModifier("modifier_item_bloodthorn_debuff_lua") then
			return 175
		end
		if RandomInt(1, 100) <= 20 then
			return 175
		end
	end
})

modifier_undying_zombie_deathstrike_active_lua = class({
	DeclareFunctions = function()
		return {
			MODIFIER_PROPERTY_MOVESPEED_LIMIT,
			MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
		}
	end,
	GetModifierMoveSpeed_Limit = function() return 522 end,
	GetModifierMoveSpeedBonus_Percentage = function() return 50 end,
	GetModifierAttackSpeedBonus_Constant = function() return 50 end
})


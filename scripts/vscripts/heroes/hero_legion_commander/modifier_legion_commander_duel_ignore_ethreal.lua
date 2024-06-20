modifier_legion_commander_duel_ignore_ethreal_lua = class({
	CheckState = function() 
		return {
			[ MODIFIER_STATE_DISARMED ] = false,
			[ MODIFIER_STATE_ATTACK_IMMUNE ] = false
		}
	end,
	GetPriority = function() return MODIFIER_PRIORITY_HIGH end,
	IsHidden = function() return true end
})

modifier_activate_fire_remnant_buff_lua = class({
	GetEffectName = function() return "particles/units/heroes/hero_ember_spirit/ember_spirit_remnant_dash.vpcf" end,
	CheckState = function()
		return {
			[ MODIFIER_STATE_INVULNERABLE ] = true,
			[ MODIFIER_STATE_NO_UNIT_COLLISION ] = true,
			[ MODIFIER_STATE_DISARMED ] = true,
			[ MODIFIER_STATE_ROOTED ] = true
		}
	end
})

modifier_fire_remnant_dummy_buff_lua = class({
	GetStatusEffectName = function() return "particles/units/heroes/hero_ember_spirit/ember_spirit_fire_remnant.vpcf" end,
	CheckState = function()
		return {
			[ MODIFIER_STATE_INVULNERABLE ] = true,
			[ MODIFIER_STATE_NO_HEALTH_BAR ] = true,
			[ MODIFIER_STATE_NO_UNIT_COLLISION ] = true,
			[ MODIFIER_STATE_NOT_ON_MINIMAP ] = true,
			[ MODIFIER_STATE_UNSELECTABLE ] = true,
			[ MODIFIER_STATE_DISARMED ] = true,
			[ MODIFIER_STATE_SILENCED ] = true
		}
	end,
	DeclareFunctions = function() return { MODIFIER_PROPERTY_VISUAL_Z_DELTA } end,
	GetVisualZDelta = function() return -300 end
})

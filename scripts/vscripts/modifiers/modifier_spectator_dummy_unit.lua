modifier_spectator_dummy_unit_lua = class({
	CheckState = function() return {
		[ MODIFIER_STATE_ROOTED ] = true,
		[ MODIFIER_STATE_INVISIBLE ] = true,
		[ MODIFIER_STATE_INVULNERABLE ] = true,
		[ MODIFIER_STATE_UNSELECTABLE ] = true,
		[ MODIFIER_STATE_NOT_ON_MINIMAP ] = true,
		[ MODIFIER_STATE_NO_HEALTH_BAR ] = true,
		[ MODIFIER_STATE_FLYING ] = true,
		[ MODIFIER_STATE_NO_UNIT_COLLISION ] = true
	} end
})

modifier_tempest_spawn_hide_from_map_lua = class({})

function modifier_tempest_spawn_hide_from_map_lua:CheckState()
	return {
		[MODIFIER_STATE_BLIND] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
end

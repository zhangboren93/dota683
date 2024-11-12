modifier_fire_remnant_counter_cooldown_lua = class({
	GetAttributes = function()
		return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
	end
})

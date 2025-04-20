modifier_ground_courier_movement_cap_lua = class({
	IsHidden = function(self) return true end,
	DeclareFunctions = function(self) return { MODIFIER_PROPERTY_MOVESPEED_LIMIT } end,
	GetModifierMoveSpeed_Limit = function(self) return 350 end
})

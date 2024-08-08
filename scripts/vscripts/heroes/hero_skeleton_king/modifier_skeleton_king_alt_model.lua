modifier_skeleton_king_alt_model_lua = class({
	IsHidden = function() return true end,
	DeclareFunctions = function() return { MODIFIER_PROPERTY_MODEL_SCALE } end,
	GetModifierModelScale = function() return 80 end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT end
})

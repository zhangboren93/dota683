modifier_diffusal_purge_slow_datadriven = class({
	IsPurgable = function() return true end,
	GetEffectName = function() return "particles/items_fx/diffusal_slow.vpcf" end,
	GetEffectAttachType = function() return PATTACH_ABSORIGIN end,
	DeclareFunctions = function() return { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE } end,
	GetModifierMoveSpeedBonus_Percentage = function() return -80 end
})

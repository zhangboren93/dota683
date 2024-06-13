modifier_ice_vortex_slow_lua = class({
	OnCreated = function(self) self:StartIntervalThink(0.5) end,
	DeclareFunctions = function() return { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE } end,
	GetModifierMoveSpeedBonus_Percentage = function(self) return self:GetAbility():GetSpecialValueFor("movement_speed_pct") end,
	IsHidden = function() return true end,
	OnIntervalThink = function(self) if not self:GetParent():HasModifier("modifier_ice_vortex") then self:Destroy()	end	end
})

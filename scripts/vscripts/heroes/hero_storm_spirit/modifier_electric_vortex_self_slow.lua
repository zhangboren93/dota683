modifier_electric_vortex_self_slow_lua = class({})

function modifier_electric_vortex_self_slow_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end

function modifier_electric_vortex_self_slow_lua:GetModifierMoveSpeedBonus_Percentage()
	return -50
end

function modifier_electric_vortex_self_slow_lua:IsDebuff()
	return true
end

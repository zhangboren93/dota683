modifier_requiem_slow_lua = class({})
function modifier_requiem_slow_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
	}
end

function modifier_requiem_slow_lua:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("requiem_reduction_ms")
end

function modifier_requiem_slow_lua:GetModifierDamageOutgoing_Percentage()
	return self:GetAbility():GetSpecialValueFor("requiem_reduction_damage")
end

function modifier_requiem_slow_lua:IsDebuff()
	return true
end

function modifier_requiem_slow_lua:GetDuration()
	return self:GetAbility():GetSpecialValueFor("slow_duration") 
end

function modifier_requiem_slow_lua:IsPurgable()
	return true
end

modifier_brewmaster_thunder_clap_creep_lua = class({})
function modifier_brewmaster_thunder_clap_creep_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_brewmaster_thunder_clap_creep_lua:GetModifierMoveSpeedBonus_Percentage()
	return -1 * self:GetAbility():GetSpecialValueFor("movement_slow")
end

function modifier_brewmaster_thunder_clap_creep_lua:GetModifierAttackSpeedBonus_Constant()
	return -1 * self:GetAbility():GetSpecialValueFor("attack_speed_slow")
end

function modifier_brewmaster_thunder_clap_creep_lua:GetStatusEffectName()
	return "particles/status_fx/status_effect_brewmaster_thunder_clap.vpcf"
end
